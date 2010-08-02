
class Torrent < ActiveRecord::Base
  include Bittorrent::TorrentFile

  require 'digest'
  
  # parsing concern

  def parse_and_save(torrent_data, force_private = true)
    if set_meta_info(torrent_data, force_private)
      if save
        log_creation
        return true
      end
    end
    false
  end
  
  def out
    root = BDictionary.new
    root[ANNOUNCE] = BString.new(self.announce_url)
    root[CREATED_BY] = BString.new(self.created_by) if self.created_by
    root[COMMENT] = BString.new(self.comment) if self.comment
    root[CREATION_DATE] = BNumber.new(self.creation_date.to_i) if self.creation_date
    root[INFO] = BRaw.new(self.raw_info.data) # precooked info entry
    root.out
  end

  private

    # Parse torrent file and populate the meta info attributes. Also add errors to model if found.
    # Return false if a parse error occurs or meta info is invalid
    def set_meta_info(torrent_file_data, force_private = true)
      begin
        meta_info = parse_torrent_file(torrent_file_data, logger) # parse and check if meta-info is valid
        logger.debug ':-) torrent file is valid' if logger
      rescue InvalidTorrentError => e
        logger.debug ":-o torrent parsing error: #{e.message}" if logger
        valid? # check if other errors in the model
        add_error :torrent_file, 'invalid'
        return false
      end
      meta_info[INFO][PRIVATE] = PRIVATE_FLAG if force_private
      populate_torrent meta_info
      true
    end

    def populate_torrent(meta_info)
      self.creation_date = Time.at(meta_info[CREATION_DATE]) unless meta_info[CREATION_DATE].blank?
      self.created_by = meta_info[CREATED_BY]
      self.comment = meta_info[COMMENT][0, 100] unless meta_info[COMMENT].blank?
      self.encoding = meta_info[ENCODING]

      info = meta_info[INFO]
      self.piece_length = info[PIECE_LENGTH]
      self.mapped_files = []
      if info[FILES].blank? # single file mode
        self.mapped_files << MappedFile.new(:name => info[NAME], :size => info[LENGTH])
        self.size = info[LENGTH]
        self.files_count = 1
      else
        self.dir_name = info[NAME]
        size = 0
        info[FILES].each do |file|
          file_path = file_name = ''
          file[PATH].each do |path| # path comes splited in a list
            if path == file[PATH].last
              file_name = path # last path item is the filename
            else
              file_path << path << '/'
            end
          end
          self.mapped_files << MappedFile.new(:name => file_name, :size => file[LENGTH], :path => file_path)
          size += file[LENGTH]
        end
        self.size = size
        self.files_count = info[FILES].size
      end

      # the bencoded INFO is kept ready to go, avoiding extra work when regenerating the torrent file
      self.raw_info = RawInfo.new :data => bencode_info_entry(meta_info[INFO])

      # torrent info hash calculation
      self.info_hash = Digest::SHA1.digest(self.raw_info.data)
      
      # set hexencoded info hash      
      self.info_hash_hex = Digest.hexencode(self.info_hash).upcase
    end
end



