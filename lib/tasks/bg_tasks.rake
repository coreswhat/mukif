
# run:
#   $ padrino rake bg_tasks:exec -e development

namespace :bg_tasks do

  desc 'Execute the background tasks, ideally should be invoked by a cron job.'
  task :exec do
    BgTasks::Dispatcher.exec
  end
end    
    

