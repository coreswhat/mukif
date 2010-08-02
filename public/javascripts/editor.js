
/* document ready loading */

  $(document).ready(function() {
    
    if ($('#editor').length > 0) {
          
      $('#editor_panel').removeClass('hide'); 
      
      /* text format */
        
        $('#editor_panel').find('#bold').click(function() {
          surround_value(find_editor_text_area(), '[b]', '[/b]');
        });
        
        $('#editor_panel').find('#italic').click(function() {
          surround_value(find_editor_text_area(), '[i]', '[/i]');
        });
        
        $('#editor_panel').find('#underline').click(function() {
          surround_value(find_editor_text_area(), '[u]', '[/u]');
        });
        
        $('#editor_panel').find('#strike').click(function() {
          surround_value(find_editor_text_area(), '[s]', '[/s]');
        });
      
      /* text align */
      
        $('#editor_panel').find('#left').click(function() {
          surround_value(find_editor_text_area(), '[left]', '[/left]');
        });
        
        $('#editor_panel').find('#center').click(function() {
          surround_value(find_editor_text_area(), '[center]', '[/center]');
        });
        
        $('#editor_panel').find('#right').click(function() {
          surround_value(find_editor_text_area(), '[right]', '[/right]');
        });
        
      /* text color */
      
        $('#editor_panel').find('#color').change(function() {
          surround_value(find_editor_text_area(), '[color=' + $(this).val() + ']', '[/color]');
          $(this).val('color');
        });
      
      /* text size */
      
        $('#editor_panel').find('#size').change(function() {
          surround_value(find_editor_text_area(), '[size=' + $(this).val() + ']', '[/size]');
          $(this).val('size');
        });
        
      /* special */  
      
        $('#editor_panel').find('#image').click(function() {
          surround_value(find_editor_text_area(), '[img]', '[/img]');
        });    
        
        $('#editor_panel').find('#hyperlink').click(function() {
          surround_value(find_editor_text_area(), '[url=http://]', '[/url]');
        });
        
        $('#editor_panel').find('#quote').click(function() {
          surround_value(find_editor_text_area(), '[quote=?]', '[/quote]');
        });
        
        $('#editor_panel').find('#youtube').click(function() {
          surround_value(find_editor_text_area(), '[youtube]v=', '[/youtube]');
        });
      
      /* emoticons */  
      
        $('#editor_panel').find('#em_smile').click(function() {
          insert_value(find_editor_text_area(), ' [em]smile[/em] ');
        });
        
        $('#editor_panel').find('#em_wink').click(function() {
          insert_value(find_editor_text_area(), ' [em]wink[/em] ');
        });
        
        $('#editor_panel').find('#em_grin').click(function() {
          insert_value(find_editor_text_area(), ' [em]grin[/em] ');
        });
        
        $('#editor_panel').find('#em_cool').click(function() {
          insert_value(find_editor_text_area(), ' [em]cool[/em] ');
        });
        
        $('#editor_panel').find('#em_kiss').click(function() {
          insert_value(find_editor_text_area(), ' [em]kiss[/em] ');
        });
        
        $('#editor_panel').find('#em_upset').click(function() {
          insert_value(find_editor_text_area(), ' [em]upset[/em] ');
        });
        
        $('#editor_panel').find('#em_none').click(function() {
          insert_value(find_editor_text_area(), ' [em]none[/em] ');
        });
        
        $('#editor_panel').find('#em_angry').click(function() {
          insert_value(find_editor_text_area(), ' [em]angry[/em] ');
        });
        
        $('#editor_panel').find('#em_sad').click(function() {
          insert_value(find_editor_text_area(), ' [em]sad[/em] ');
        });
        
        $('#editor_panel').find('#em_cry').click(function() {
          insert_value(find_editor_text_area(), ' [em]cry[/em] ');
        });      
    }  
  });

/* functions  */
  
  function find_editor_text_area() {
    return $('#editor').find('textarea').filter(':visible:first')[0];
  }

  function surround_value(e, text1, text2) {
    if (typeof(e.caretPos) != 'undefined' && e.createTextRange) {
      var caret_pos = e.caretPos;
      caret_pos.text = caret_pos.text.charAt(caret_pos.text.length - 1) == ' ' ? text1 + caret_pos.text + text2 + ' ' : text1 + caret_pos.text + text2;
      caret_pos.select();
    } else if (typeof(e.selectionStart) != 'undefined') {
      var begin = e.value.substr(0, e.selectionStart);
      var selection = e.value.substr(e.selectionStart, e.selectionEnd - e.selectionStart);
      var end = e.value.substr(e.selectionEnd);
      var new_cursor_pos = e.selectionStart;
      var scroll_pos = e.scrollTop;
      e.value = begin + text1 + selection + text2 + end;
      if (e.setSelectionRange) {
        if (selection.length == 0)
          e.setSelectionRange(new_cursor_pos + text1.length, new_cursor_pos + text1.length);
        else
          e.setSelectionRange(new_cursor_pos, new_cursor_pos + text1.length + selection.length + text2.length);
        e.focus();
      }
      e.scrollTop = scroll_pos;
    } else {
      e.value += text1 + text2;
      e.focus(e.value.length - 1);
    }
  }
  
  function insert_value(e, text) {
    if (typeof(e.caretPos) != 'undefined' && e.createTextRange) {
      var caret_pos = e.caretPos;
      caret_pos.text = text;
      caret_pos.select();
    } else if (typeof(e.selectionStart) != 'undefined') {
      var begin = e.value.substr(0, e.selectionStart);
      var selection = e.value.substr(e.selectionStart, e.selectionEnd - e.selectionStart);
      var end = e.value.substr(e.selectionEnd);
      var newCursorPos = e.selectionStart;
      var scrollPos = e.scrollTop;
      e.value = begin + text + end;
      if (e.setSelectionRange) {
        if (selection.length == 0)
          e.setSelectionRange(newCursorPos + text.length, newCursorPos + text.length);
        else
          e.setSelectionRange(newCursorPos, newCursorPos + text);
        e.focus();
      }
      e.scrollTop = scrollPos;
    } else {
      e.value += text;
      e.focus(e.value.length - 1);
    }
  }