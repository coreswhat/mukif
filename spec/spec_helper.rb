
# run
  # spec spec -c -f n
  # spec spec/models/user_spec.rb -c -f n
  
# env
  PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)

# app root
  app_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

# required files

  # app
    require File.join(app_root, 'config', 'boot')
  
  # support
    
    # support dir
      support_dir = File.join(app_root, 'spec', 'support')
  
    # support modules
      ['fetchers', 'finders', 'makers', 'misc', 'support_variables'].each {|f| require File.join(support_dir, f) }
  
    # test data dir
      TEST_DATA_DIR = File.join(support_dir, 'test_data') unless defined?(TEST_DATA_DIR)
  
# i18n

  # locale
    I18n.locale = 'en'
  
  # load translations (looks like it is a padrino issue)      
    I18n.load_path += [ File.join(app_root, 'app', 'locale', 'models', 'en.yml') ]
    I18n.load_path += [ File.join(app_root, 'app', 'locale', 'formats', 'en.yml') ]
    I18n.reload!

# rspec config

  Spec::Runner.configure do |conf|
    conf.include Fetchers, Finders, Makers, Misc, SupportVariables
  end

# padrino config

  def app  
    Mukif.tap { |app| } # you can handle all padrino applications using: Padrino.application
  end

# echo
  unless $echoed
    puts
    puts "- spec_helper:"
    puts "  + padrino env   = #{Padrino.env}"
    puts "  + locale        = #{I18n.locale}"
    puts "  + app root dir  = #{app_root}"
    puts "  + support dir   = #{support_dir}"
    puts "  + test data dir = #{TEST_DATA_DIR}"
    puts
    $echoed = true
  end


























#
