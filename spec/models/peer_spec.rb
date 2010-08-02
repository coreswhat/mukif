
# spec helper
  require File.join(File.dirname(__FILE__), '..', 'spec_helper')

# concerns
  Dir.glob(File.join(File.dirname(__FILE__), 'peer_spec', '*')).each {|f| require f }

describe '- models' do 
  
  describe 'Peer' do
  
    context '- main class:' do
    
    end
  end
end