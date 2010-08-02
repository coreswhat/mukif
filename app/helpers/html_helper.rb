
Mukif.helpers do
    
  BB_TAGS = [ [ /\[quote\](.+?)\[\/quote\]/i,          '<div class="quote"><div class="quote_text">\1</div></div>' ], 
              [ /\[quote=(.+?)\](.+?)\[\/quote\]/i,    '<div class="quote">\1 wrote:<br/><div class="text">\2</div></div>' ], 
              [ /\[b\](.+?)\[\/b\]/i,                  '<span class="bold">\1</span>' ],
              [ /\[i\](.+?)\[\/i\]/i,                  '<span class="italic">\1</span>' ],
              [ /\[u\](.+?)\[\/u\]/i,                  '<span class="underline">\1</span>' ],
              [ /\[s\](.+?)\[\/s\]/i,                  '<span class="strike">\1</span>' ],
              [ /\[left\](.+?)\[\/left\]/i,            '<div class="left">\1</div>' ],
              [ /\[center\](.+?)\[\/center\]/i,        '<div class="center">\1</div>' ],
              [ /\[right\](.+?)\[\/right\]/i,          '<div class="right">\1</div>' ],
              [ /\[url=(.+?)\](.+?)\[\/url\]/i,        '<a href="\1">\2</a>' ], 
              [ /\[img\](.+?)\[\/img\]/i,              '<img src="\1"/>' ],
              [ /\[youtube\]v=(.+?)\[\/youtube\]/i,    '<object width="425" height="344"><param name="movie" value="http://www.youtube.com/v/\1"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/\1" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="425" height="344"></embed></object>' ],
              [ /\[color=([^;]+?)\](.+?)\[\/color\]/i, '<span style="color: \1;">\2</span>' ],
              [ /\[size=(.+?)\](.+?)\[\/size\]/i,      '<font size="\1">\2</font>' ] ]        

  BB_EMOTICONS = [ [ /\[em\]smile\[\/em\]/i, 'emoticons/smile.gif', ':-)' ],
                   [ /\[em\]wink\[\/em\]/i,  'emoticons/wink.gif',  ';-)' ],
                   [ /\[em\]grin\[\/em\]/i,  'emoticons/grin.gif',  ':-D' ],
                   [ /\[em\]cool\[\/em\]/i,  'emoticons/cool.gif',  '8-)' ],
                   [ /\[em\]kiss\[\/em\]/i,  'emoticons/kiss.gif',  ':-*' ],
                   [ /\[em\]upset\[\/em\]/i, 'emoticons/upset.gif', ':-o' ],
                   [ /\[em\]none\[\/em\]/i,  'emoticons/none.gif',  ':-|' ],
                   [ /\[em\]angry\[\/em\]/i, 'emoticons/angry.gif', '>:-(' ],
                   [ /\[em\]sad\[\/em\]/i,   'emoticons/sad.gif',   ':-(' ],
                   [ /\[em\]cry\[\/em\]/i,   'emoticons/cry.gif',   ':,-(' ] ]

  BB_APP_LINKS = [ [ /\[torrent=(\d+)\](.+?)\[\/torrent\]/i, :torrents, :show ],
                   [ /\[user=(\d+)\](.+?)\[\/user\]/i ,      :users,    :show ],
                   [ /\[wish=(\d+)\](.+?)\[\/wish\]/i,       :wishes,   :show ] ]                
        
  # view
  
    def parse_data_to_html(s)
      if s
        s = s.dup
        parse_line_breaks s
        parse_bbcode s
        parse_emoticons s
        parse_app_links s
      end
    end
    
    def parse_line_breaks(s, dup = false)
      if s
        s = s.dup if dup
        s.gsub! "\r\n", '<br/>'
        s.gsub! "\n", '<br/>'
        s
      end
    end
  
    def parse_bbcode(s, dup = false)
      if s
        s = s.dup if dup
        BB_TAGS.each {|e| s.gsub! e[0], e[1] }
        s
      end
    end
    
    def parse_emoticons(s, dup = false)
      if s
        s = s.dup if dup
        BB_EMOTICONS.each {|e| s.gsub!(e[0], image_tag(e[1], :class => 'emoticon', :alt => e[2])) if s =~ e[0] }
        s
      end
    end
  
    def parse_app_links(s, dup = false)
      if s
        s = s.dup if dup
        BB_APP_LINKS.each {|e| s.gsub!(e[0], content_tag(:a, $2, :href => url(e[1], e[2], :id => $1))) if s =~ e[0] }
        s
      end
    end
end

  
        











