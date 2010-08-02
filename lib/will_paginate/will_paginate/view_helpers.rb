
require File.join(File.dirname(__FILE__), 'core_ext.rb')

module WillPaginate

  module ViewHelpers
    @@pagination_options = {
      :class          => 'pagination',
      :previous_label => '&laquo; Previous',
      :next_label     => 'Next &raquo;',
      :inner_window   => 4, # links around the current page
      :outer_window   => 1, # links around beginning and end
      :separator      => ' ', # single space is friendly to spiders and non-graphic browsers
      :param_name     => :page,
      :params         => nil,
      :renderer       => 'WillPaginate::LinkRenderer',
      :page_links     => true,
      :container      => true
    }
    mattr_reader :pagination_options

    def will_paginate(collection = nil, options = {})
      options, collection = collection, nil if collection.is_a? Hash
      unless collection or !controller
        collection_name = "@#{controller.controller_name}"
        collection = instance_variable_get(collection_name)
        raise ArgumentError, "The #{collection_name} variable appears to be empty. Did you " +
          "forget to pass the collection object for will_paginate?" unless collection
      end
      # early exit if there is nothing to render
      return nil unless WillPaginate::ViewHelpers.total_pages_for_collection(collection) > 1
      
      options = options.symbolize_keys.reverse_merge WillPaginate::ViewHelpers.pagination_options
      if options[:prev_label]
        WillPaginate::Deprecation::warn(":prev_label view parameter is now :previous_label; the old name has been deprecated", caller)
        options[:previous_label] = options.delete(:prev_label)
      end
      
      # get the renderer instance
      renderer = case options[:renderer]
      when String
        options[:renderer].to_s.constantize.new
      when Class
        options[:renderer].new
      else
        options[:renderer]
      end
      # render HTML for pagination
      renderer.prepare collection, options, self
      renderer.to_html
    end
    
    def self.total_pages_for_collection(collection) #:nodoc:
      if collection.respond_to?('page_count') and !collection.respond_to?('total_pages')
        WillPaginate::Deprecation.warn %{
          You are using a paginated collection of class #{collection.class.name}
          which conforms to the old API of WillPaginate::Collection by using
          `page_count`, while the current method name is `total_pages`. Please
          upgrade yours or 3rd-party code that provides the paginated collection}, caller
        class << collection
          def total_pages; page_count; end
        end
      end
      collection.total_pages
    end    
  end    
end
