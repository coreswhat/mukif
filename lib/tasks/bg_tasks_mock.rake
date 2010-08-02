
# run
  # $ padrino rake bg_tasks_mock:exec -e development

namespace :bg_tasks_mock do

  desc 'Simulate background tasks execution with a simple continuous loop.'
  task :exec do
    
    # logger 
      logger = Logger.new(STDOUT)
      ActiveRecord::Base.logger = logger

    loop do
      puts
      puts ":-) bg_tasks_mock awake at #{Time.now}"
    
      BgTasks::Dispatcher.exec logger
      
      puts ':-) bg_tasks_mock going asleep'
      puts
      sleep 20
    end
  end
end    
    
