
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

config_path = File.join(File.dirname(__FILE__), 'config')

if File.exist?(File.join(config_path, 'mukif.yml'))
  require File.join(config_path, 'boot')
end

# app custom files task

  # run
  #  $ rake app_custom_files:generate
  
  namespace :app_custom_files do
  
    desc "Create a copy of all the app custom files without the '.example' extension."
    task :generate do
      config_files = ['mukif.yml', 'bg_tasks.yml', 'database.rb', 'schedule.rb', 'auth_keys.rb']
      seeds_files  = ['app_data.rb', 'dummy_data.rb']
      deploy_files = ['backup.rb', 'deploy.rb', 'prepare.rb']
  
      root_path = File.dirname(__FILE__)
  
      config_path = File.join(root_path, 'config')
      config_files.each do |f|
        file = File.join(config_path, f)
        FileUtils.copy_file("#{file}.example", file) unless File.exist?(file)
      end
  
      seeds_path = File.join(root_path, 'db', 'seeds')
      seeds_files.each do |f|
        file = File.join(seeds_path, f)
        FileUtils.copy_file("#{file}.example", file) unless File.exist?(file)
      end
  
      deploy_path = File.join(root_path, 'deploy')
      deploy_files.each do |f|
        file = File.join(deploy_path, f)
        FileUtils.copy_file("#{file}.example", file) unless File.exist?(file)
      end
    end
  end