
Mukif.controllers :messages do
  
  before { logged_in_required }
  
  get :index, :map => 'messages/:folder' do
    set_default_message_folder
    set_default_page

    folder, page = params[:folder], params[:page].to_i

    raise ArgumentError unless Message.valid_folder? folder

    @messages = Message.paginate_user_messages current_user,
                                               :page => page,
                                               :folder => folder,
                                               :per_page => settings.c[:page_size][:messages]
    @messages.setup_pagination :messages, :index if @messages
                                                   
    toggle_new_message_alert folder, page
    
    session[:messenger_folder], session[:messenger_page] = folder, page  
    render 'messages/index'
  end  

  # show  

    get :show, :with => :id do
      @message = Message.find params[:id]
      @message.ensure_ownership current_user
      @message.set_as_read!
      render 'messages/show'
    end  

  # new  

    get :new do
      @message = Message.new_for_view current_user,
                                      :to => params[:to],
                                      :message_id => params[:message_id],
                                      :reply => params[:reply] == '1',
                                      :forward => params[:forward] == '1'
      render 'messages/new'
    end
    
    post :create do
      unless cancelled?
        @message = Message.new_for_delivery current_user,
                                            params[:message],
                                            :to => params[:to],
                                            :replied_id => params[:replied_id]        
        if @message.deliver
          flash[:notice] = t('c.messages.create.success')
          redirect_to_folder
        else
          render 'messages/new'
        end
      else
        redirect_to_folder
      end
    end     

  # move  

    put :move do
      destination_folder = params[:destination_folder]
      raise ArgumentError unless Message.valid_folder? destination_folder
      unless cancelled?
        unless params[:id].blank? # user was reading a message and decided to move it
          Message.find(params[:id]).move_to_folder!(destination_folder, current_user)
          logger.debug ':-) message moved'
          flash[:notice] = t('c.messages.move.moved_single')
        end
      end
      unless params[:selected_messages].blank? # user was browsing the messages and decided to move some
        messages = Message.find params[:selected_messages]
        messages.each {|m| m.move_to_folder!(destination_folder, current_user) }
        logger.debug ':-) messages moved'
        flash[:notice] = t('c.messages.move.moved_list')
      end
      redirect_to_folder
    end     
end

  






