
Mukif.controllers :adm do
  
  before { logged_in_required }
  before { admin_required }
        
  # env
  
    get :env do
      if defined?(PhusionPassenger)
        @show_passenger_restart_link = Padrino.env != :production || settings.c[:adm][:passenger_restart_production]
      end
      @show_sensitive = Padrino.env != :production || settings.c[:adm][:display_all_env_info_production]
      @env_properties = env_properties 
      render 'adm/env'
    end  
    
  # tracker
  
    get :tracker do
      @tracker_properties = tracker_properties
      render 'adm/tracker'
    end      

  # menu
  
    get :switch_menu do
      if session[:adm_menu]
        session[:adm_menu] = nil
        redirect settings.uri_root
      else
        session[:adm_menu] = true
        redirect url(:adm, :env)
      end
    end

  # domain menu
  
    get :switch_domain_menu do
      if session[:adm_domain_menu]
        session[:adm_domain_menu] = nil
        redirect url(:adm, :env)
      else
        session[:adm_domain_menu] = true
        redirect url(:types, :index)
      end
    end  
    
  # restart under passenger
  
    put :passenger_restart do
      access_denied if Padrino.env == :production && !settings.c[:adm][:passenger_restart_production]
      %x{touch #{File.join(Padrino.root, 'tmp', 'restart.txt')}}
      redirect url(:adm, :env)
    end  
end










