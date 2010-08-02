
describe '- models' do 
  
  describe 'Report' do
  
    context '- finders:' do
      
      before(:each) do
        clear_database
        load_default_variables
      end
    
      it 'should have open reports after new report is created' do            
        @report = make_report(@user)
        Report.has_open?.should be_true
      end
    end
  end    
end