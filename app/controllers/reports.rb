
Mukif.controllers :reports do
  
  before { logged_in_required }

  get :index do
    admin_mod_required
    @reports = Report.all
    render 'reports/index'
  end

  # new
  
    get :new, :map => '/report/:type/:id' do
      ensure_report_type_valid
      render 'reports/new'
    end
    
    post :create, :map => '/report/:type/:id' do
      ensure_report_type_valid       
      unless params[:reason].blank?
        @target = find_report_target 
        Report.kreate! @target, current_user, params[:reason], report_target_url
        session[:notification] = :report_sent
        redirect url(:notifications, :index)
      else
        flash.now[:error] = t('c.reports.create.reason_required')
        render 'reports/new'
      end
    end

  # destroy
     
    delete :destroy, :with => :id do
      admin_mod_required
      Report.destroy params[:id]
      redirect url(:reports, :index)
    end

  # grab / release
     
    put :grab, :with => :id do
      admin_mod_required
      Report.find(params[:id]).assign_to! current_user
      redirect url(:reports, :index)
    end 
   
    put :release, :with => :id do
      admin_mod_required
      Report.find(params[:id]).unassign!
      redirect url(:reports, :index)
    end
end







