
# spec helper
  require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe '- bittorrent' do 
  
  describe 'Bittorrent' do
    
    describe 'TorrentFile' do  
      include Bittorrent::TorrentFile
  
      before(:each) do    
        t, i = '', ''
        t << 'd'
        t << '..8:announce18:http://tracker_url'
        t << '..10:created by2:UT'
        t << '..13:creation datei999e'
        t << '..8:encoding5:UTF-8'
        t << '..4:info'
        i << '....d'
        i << '......5:filesl'
        i << '........d'
        i << '..........6:lengthi555e'
        i << '..........4:pathl'
        i << '............8:test_dir'
        i << '............9:test_file'
        i << '..........e'
        i << '........e'
        i << '........d'
        i << '..........6:lengthi666e'
        i << '..........4:pathl'
        i << '............8:test_dir'
        i << '............13:test_file_two'
        i << '..........e'
        i << '........e'      
        i << '......e'
        i << '......4:name12:torrent_name'
        i << '......12:piece lengthi777e'
        i << '......6:pieces18:PIECES_BINARY_DATA'
        i << '......7:privatei1e'
        i << '....e'
        t << i
        t << 'e'      
        @torrent_file = t.gsub('.', '')
        @info_entry   = i.gsub('.', '')
      end
      
      it 'should parse a torrent file' do
        h = parse_torrent_file @torrent_file     
        h['announce'].should == 'http://tracker_url'
        h['created by'].should == 'UT' 
        h['creation date'].should == 999
        h['encoding'].should == 'UTF-8'
        h['info']['name'].should == 'torrent_name'
        h['info']['piece length'].should == 777
        h['info']['pieces'].should == 'PIECES_BINARY_DATA'
        h['info']['private'].should == 1
        h['info']['files'].should == [ { 'length' => 555, 'path' => ['test_dir', 'test_file'] },
                                       { 'length' => 666, 'path' => ['test_dir', 'test_file_two'] } ]
      end 
      
      it 'should raise error if torrent file malformed' do
        @torrent_file.gsub!('torrent_name', 'nonono')
        lambda { parse_torrent_file @torrent_file }.should raise_error(InvalidTorrentError)
      end   
          
      it 'should bencode the torrent file info entry' do
        parsed_torrent_file = parse_torrent_file @torrent_file 
        b = bencode_info_entry parsed_torrent_file['info']
        b.should == @info_entry
      end   

      it 'should check if torrent file required entries are present' do
        h = parse_torrent_file @torrent_file
        
        d = h.dup      
        d['info']['name'] = nil
        lambda { check_meta_info d }.should raise_error(InvalidTorrentError)
        
        d = h.dup      
        d['info']['piece length'] = nil
        lambda { check_meta_info d }.should raise_error(InvalidTorrentError)
        
        d = h.dup      
        d['info']['pieces'] = nil
        lambda { check_meta_info d }.should raise_error(InvalidTorrentError)
        
        d = h.dup      
        d['info']['files'][0]['length'] = nil
        lambda { check_meta_info d }.should raise_error(InvalidTorrentError)
  
        d = h.dup      
        d['info']['files'][0]['path'] = nil
        lambda { check_meta_info d }.should raise_error(InvalidTorrentError)
      end
    end
  end
end  
  

