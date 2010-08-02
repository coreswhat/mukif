
module WillPaginate

  # custom link renderer
  class LinkRenderer

    class PaginationItem
      attr_accessor :text, :page, :link

      def initialize(text, page = nil)
        self.text = text
        self.page = page
      end
      
      def link?
        self.page != nil
      end
      
      def out(collection, template, params)
        self.page == 1 ? params.delete(:page) : params[:page] = self.page
        unless link?
          self.text
        else
          url = template.url(collection.controller, collection.action, params)
          template.link_to(self.text, url, :anchor => collection.html_anchor)
        end
      end
    end

    SEPARATOR = PaginationItem.new(' | ')
    GAP       = PaginationItem.new(' |&nbsp;&nbsp;...&nbsp;&nbsp;| ')
        
    def prepare(collection, options, template)
      @collection = collection
      @options = options
      @template = template
      
      @params = @template.params.dup.symbolize_keys!   
      @params.delete(:page)
      @params.delete_if {|k, v| v.blank? } # just cosmetic      
    end
        
    # return the html links inside a div (just links if options[:container] is false)
    def to_html
      setup unless @items
      html = ''
      @items.each {|i| html << i.out(@collection, @template, @params) }
      if @options[:container] 
        html = @template.content_tag(:div, html, :class => @options[:class])
      end      
      html
    end    
    
    private

      def setup()
        # l = link only, lt = link or text (text if current page, link otherwise)
        return if @collection.per_page >= @collection.total_entries
        @items = []
        current_page = @collection.current_page
        num_pages = (@collection.total_entries / @collection.per_page.to_f).ceil
        rest = @collection.total_entries % @collection.per_page
        if num_pages <= 11
          # lt | lt | lt | lt | lt | lt 
          make_items(1, num_pages, rest)
        elsif num_pages >= 11 && (current_page < 3 || current_page > num_pages  - 2)
          # lt | lt | l | ... | l | l | l | ... | l | lt | lt
          make_items(1, 3)
          @items << GAP
          middle_page = num_pages / 2
          make_items(middle_page - 1, middle_page + 1)
          @items << GAP
          make_items(num_pages - 2, num_pages, rest)
        else
          if current_page <= 6
            # lt | lt | lt | lt | lt | lt | l | ... | l | l | l
            make_items(1, 7)
            @items << GAP
            make_items(num_pages - 2, num_pages, rest)
          elsif current_page > 6 && current_page < num_pages - 5
            # l | l | l | ... | l | lt | l | ... | l | l | l
            make_items(1, 3)
            @items << GAP
            make_items(current_page - 1, current_page + 1)
            @items << GAP
            make_items(num_pages - 2, num_pages, rest)
          else
            # l | l | l |... | l | lt | lt | lt | lt | lt | lt
            make_items(1, 3)
            @items << GAP
            make_items(num_pages - 6, num_pages, rest)
          end
        end
      end

      def make_items(initial_page, final_page, rest = 0)
        initial_page -= 1
        for i in initial_page...final_page do
          from = (@collection.per_page * i) + 1
          if i == (final_page - 1) && rest > 0  # if last page is parcial
            to = (from + rest) - 1
          else
            to = @collection.per_page * (i + 1)
          end
          text = "#{sprintf('%.2d', from)} - #{sprintf('%.2d', to)}" # %.2d so '1' turns '01'
          page = (i != @collection.current_page - 1) ? (i + 1) : nil # nil if current page
          @items << PaginationItem.new(text, page)
          @items << SEPARATOR unless i == final_page - 1
        end
      end    
  end
end
