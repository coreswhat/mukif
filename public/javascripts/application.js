
/* document ready loading */
  
  $(document).ready(function(){
    
    /* set focus on the first text input field */
    
      $('input:text:visible:enabled:first').focus();
    
    /* set spinner */
    
      if ($('#spinner').length > 0) {      
        replace_html('spinner', '<img class="spinner" src="/images/spinner.gif" />')
  
        $('#spinner').center();  
    
        $(window).bind('resize', function() {
          $('#spinner').center({transition:300});
        });
    
        $(window).bind('scroll', function() {
          $('#spinner').center({transition:300});
        });
      }
            
    /* set ajax bindings */
      
      /* bookmark links */
      
        $('a.bookmark_link').live('ajax:loading', function() {
          show_spinner();
        });
         
        $('a.bookmark_link').live('ajax:success', function() {
          hide_spinner();
        }); 
      
      /* quote links */
      
        $('a.quote_link').each(function() {
          $(this).removeClass('hide');
        })
          
        $('span.quote_link_no_script').each(function() {
          $(this).addClass('hide');
        })  
      
        $('a.quote_link').live('ajax:loading', function() {
          show_spinner();
        });
        
        $('a.quote_link').live('ajax:success', function() {
          hide_spinner();
        });
        
    /* set behavior bindings */
      
      /* links blur */
  
        $('a').click(function() {
          $(this).blur();
        });
     
    /* specific views */
     
      /* 'torrents/mapped_files' */
       
        if ($('#show_hide_mapped_files').length > 0) {
          $('#show_hide_mapped_files').click(function(e) {
            show_hide_element('torrent_mapped_files');
            e.preventDefault();
          });
        }
         
      /* 'messages/index' */
       
        if ($('#messenger_script_links').length > 0) {
          show_hide_element('messenger_script_links');
           
          $('#messenger_script_links').find('#check_all').click(function() {
            set_check_boxes('messages_form', true)
          });
           
          $('#messenger_script_links').find('#uncheck_all').click(function() {
            set_check_boxes('messages_form', false)
          });      
        }
  });

/* functions */

  /* find element by id */
  
    function find_element_by_id(element_id) {      
      return $('#' + element_id)[0];
    }
    
  /* focus on element */
  
    function set_focus(element_id) {      
      $('#' + element_id).focus();
    }

  /* replace element html */
  
    function replace_html(element_id, html) {
      $('#' + element_id).html(html)         
    }  

  /* show or hide element */

    function show_hide_element(element_id) {
      e = $('#' + element_id);
      if (e.hasClass('hide')) {
        e.removeClass('hide');
      } else {
        e.addClass('hide');
      }
    }

  /* set all check boxes within element */

    function set_check_boxes(element_id, status) {
      $('#' + element_id).find('input:checkbox').each(function() {
        $(this).attr('checked', status);
      })
    }

  /* centers an element in the screen */
  
    jQuery.fn.center = function () {
      this.css('position', 'absolute');
      this.css('top', ( $(window).height() - this.outerHeight() ) / 2 + $(window).scrollTop() + 'px');
      this.css('left', ( $(window).width() - this.outerWidth() ) / 2 + $(window).scrollLeft() + 'px');
      return this;
    }

  /* show hide spinner */

    function show_spinner() {
      $('#spinner').removeClass('hide');
    }
  
    function hide_spinner() {
      $('#spinner').addClass('hide');
    }