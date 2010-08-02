
Mukif.controllers :genders do
  
  before { logged_in_required }
  before { admin_required }

  get :index do
    @genders = Gender.find :all
    render 'genders/index' 
  end
  
  # new
  
    get :new do
      @gender = Gender.new
      render 'genders/new'
    end
    
    post :create do
      @gender = Gender.new params[:gender]  
      if @gender.save
        redirect url(:genders, :index)
      else
        render 'genders/new'
      end
    end
     
  # edit
  
    get :edit, :with => :id do
      @gender = Gender.find params[:id]
      render 'genders/edit' 
    end
    
    put :update, :with => :id do
      @gender = Gender.find params[:id]
      if @gender.update_attributes params[:gender]
        redirect url(:genders, :index)
      else
        render 'genders/edit'
      end
    end
  
  # destroy
          
    delete :destroy, :with => :id do 
      Gender.destroy params[:id]
      redirect url(:genders, :index)
    end   
end



