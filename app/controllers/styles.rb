
Mukif.controllers :styles do
  
  before { logged_in_required }
  before { admin_required }

  get :index do
    @styles = Style.find :all
    render 'styles/index' 
  end
  
  # new
  
    get :new do
      @style = Style.new
      render 'styles/new'
    end
    
    post :create do
      @style = Style.new params[:style]  
      if @style.save
        redirect url(:styles, :index)
      else
        render 'styles/new'
      end
    end
     
  # edit
  
    get :edit, :with => :id do
      @style = Style.find params[:id]
      render 'styles/edit' 
    end
    
    put :update, :with => :id do
      @style = Style.find params[:id]
      if @style.update_attributes params[:style]
        redirect url(:styles, :index)
      else
        render 'styles/edit'
      end
    end
  
  # destroy
        
    delete :destroy, :with => :id do    
      s = Style.find params[:id]
      access_denied if s.default?
      Style.transaction do
        User.scoped_by_style_id(s).find(:all).each do |u|
          u.update_attribute :style_id, 1
        end
        s.destroy
      end
      redirect url(:styles, :index)
    end   
end