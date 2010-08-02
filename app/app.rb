
class Mukif < Padrino::Application
  register Padrino::Mailer
  register Padrino::Helpers
     
  register Authentication
  register Authorization 
  register BgTasks
  register ErrorHandling
  
  register WillPaginate
  
  configure do
        
    # paths
      set :uri_root, '/'
          
    # config
      c = open(Padrino.root('config', 'mukif.yml')) {|f| YAML.load(f)[Padrino.env.to_s] }
      c.recursive_symbolize_keys!
      c.freeze
      
      set :c, c
      
    # authentication  
      set :login_path, '/login'
      set :remember_me_period, c[:login][:remember_me_days].days
                 
    # mailer      
      set :mailer_defaults, :from => c[:app_name]  
      # smtp settings
        smtp_conf = c[:mailer][:smtp]
        set :delivery_method, :smtp => { 
          :address              => smtp_conf[:address],
          :port                 => smtp_conf[:port],
          :user_name            => smtp_conf[:user_name],
          :password             => smtp_conf[:password],
          :authentication       => smtp_conf[:authentication],
          :enable_starttls_auto => smtp_conf[:enable_starttls_auto]
        }
  end
  
  configure :development do
    # set :raise_errors, true
    # set :show_exceptions, true
  end
end

  

















