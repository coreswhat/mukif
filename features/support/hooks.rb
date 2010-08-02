
# all

  Before do

    # clear database
      clear_database
    
    # clear sessions
      Capybara.reset_sessions!
    
    # create system user
      Given 'the system user exists' # required to send system messages
          
  end

# rack test driver
  
  Before('@rack_test_driver') do
    Capybara.current_driver = :rack_test
  end
  
  After('@rack_test_driver') do
    Capybara.use_default_driver
  end

