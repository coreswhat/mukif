
# install
  # $ bundle install
  # $ bundle install --without development test deploy

# source

  source :rubygems

# project

  gem 'rake'
  gem 'rack-flash'
  gem 'padrino', '0.9.14'
  
  # database

    gem 'mysql'
    gem 'activerecord', :require => 'active_record'
    
  # support

    gem 'activesupport', :require => 'active_support'

  # background tasks
  
    gem 'whenever'

# development

  group :development do
    gem 'thin'
  end
    
# test

  group :test do    
    gem 'rspec', :require => 'spec'
    gem 'cucumber'
    gem 'capybara'
    gem 'rack-test', :require => 'rack/test'    
  end

# deploy

  group :deploy do
    gem 'sprinkle'    
    gem 'capistrano'
  end
  
    


