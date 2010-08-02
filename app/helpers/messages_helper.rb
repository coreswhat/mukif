
Mukif.helpers do
   
  # controller
   
    def redirect_to_folder
      redirect url(:messages, 
                   :index, 
                   :folder => (session[:messenger_folder] || Message::INBOX), 
                   :page => session[:messenger_page])
    end
    
    def set_default_message_folder
      params[:folder] = Message::INBOX if params[:folder].blank?
    end      

    def toggle_new_message_alert(folder, page)
      if current_user.has_new_message? && folder == Message::INBOX && page == 1
        current_user.toggle! :has_new_message
      end
    end
end