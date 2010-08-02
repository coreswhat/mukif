
# run
  # $ cucumber features -f pretty
  # $ cucumber features/report.feature -f pretty

# env
  PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)

# app root
  app_root = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))

# required files

  # test env
    require 'capybara/cucumber'
    require 'spec/expectations'
  
  # app
    require File.join(app_root, 'config', 'boot')
  
  # support
  
    # support dir
      support_dir = File.join(app_root, 'spec', 'support')
  
    # support modules
      ['fetchers', 'finders', 'makers', 'misc'].each {|f| require File.join(support_dir, f) }
  
    # test data dir
      TEST_DATA_DIR = File.join(support_dir, 'test_data') unless defined?(TEST_DATA_DIR)

# cucumber

  World(Fetchers, Finders, Makers, Misc)
    
# capybara

  Capybara.app = Mukif.tap {|app| } # handle all padrino apps using: Padrino.application
  
  Capybara.default_driver = :selenium

# echo
  puts
  puts "- env:"
  puts "  + padrino env   = #{Padrino.env}"
  puts "  + locale        = #{I18n.locale}"
  puts "  + app root dir  = #{app_root}"
  puts "  + support dir   = #{support_dir}"
  puts "  + test data dir = #{TEST_DATA_DIR}"
  puts
