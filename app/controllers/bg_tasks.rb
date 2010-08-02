
Mukif.controllers :bg_tasks do
  
  before { logged_in_required }
  before { admin_required }  
  
  get :index do
    @bg_tasks = fetch_bg_tasks
    @cron_jobs = list_cron_jobs
    @bg_task_logs = BgTaskLog.all :limit => 40
    render 'bg_tasks/index'
  end
  
  # exec
     
    put :exec, :with => :id do
      begin
        t = BgTask.find params[:id]
        t.exec logger, true
        flash[:notice] = "#{t.name} successfully executed"
      rescue => e
        log_error e
        flash[:error] = "#{t.name} failed"
      end
      redirect url(:bg_tasks, :index)
    end
      
  # switch
       
    put :switch, :with => :id do
      t = BgTask.find params[:id]
      t.toggle! :active
      redirect url(:bg_tasks, :index)
    end
      
  # reload
   
    put :reload do
      owner_required      
      reload_bg_tasks
      redirect url(:bg_tasks, :index)
    end

  # edit
  
    get :edit, :with => :id do
      @bg_task = BgTask.find params[:id]
      render 'bg_tasks/edit'
    end
    
    put :update, :with => :id do
      @bg_task = BgTask.find params[:id]
      if @bg_task.update_attributes params[:bg_task]
        redirect url(:bg_tasks, :index)
      else
        render 'bg_tasks/edit'
      end        
    end
    
  # update_crontab
     
    put :update_crontab do
      owner_required
      access_denied unless settings.c[:adm][:crontab_update_enabled]
      %x{bundle exec whenever --set environment=#{Padrino.env} --update-crontab #{settings.c[:app_unix_name]}}
      redirect url(:bg_tasks, :index)
    end
end









