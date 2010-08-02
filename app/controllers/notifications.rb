
Mukif.controllers :notifications do
  
  before { logged_in_required }
  
  get :index, :map => '/notification' do
    @notification_args = case session[:notification]
      when :torrent_inactivated 
        { :title => t('c.torrents.inactivate.notification_title'), :body  => t('c.torrents.inactivate.notification_body') }
      when :report_sent 
        { :title => t('c.reports.create.notification_title'), :body  => t('c.reports.create.notification_body') }
      else
        redirect settings.uri_root
    end
    session[:notification] = nil
    render 'notifications/index'   
  end
end 