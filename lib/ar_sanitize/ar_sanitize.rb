
module ARSanitize
  def self.included(base)
    base.extend(ClassMethods)   
    base.send(:ar_sanitize) # sets up default of stripping tags for all fields
  end

  module ClassMethods
    def ar_sanitize(options = {})
      before_validation :escape_fields
      write_inheritable_attribute(:ar_sanitize_options, {:except => (options[:except] || [])})      
      class_inheritable_reader :ar_sanitize_options      
      include ARSanitize::InstanceMethods
    end
  end
  
  module InstanceMethods
    def escape_fields
      # fix a bug with Rails internal AR::Base models that get loaded before
      # the plugin, like CGI::Sessions::ActiveRecordStore::Session
      return if ar_sanitize_options.nil?
      
      self.class.columns.each do |column|
        next unless (column.type == :string || column.type == :text)
        
        field = column.name.to_sym
        value = self[field]

        next if value.nil? || !value.is_a?(String)
        
        if ar_sanitize_options[:except].include?(field)
          next
        else
          self[field] = Rack::Utils.escape_html(value).strip
        end
      end      
    end
  end
end

ActiveRecord::Base.send(:include, ARSanitize)


