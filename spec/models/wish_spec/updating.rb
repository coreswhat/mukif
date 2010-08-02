
describe '- models' do 
  
  describe 'Wish' do

    context '- updating:' do
      
      before(:each) do
        clear_database
        load_default_variables
        load_torrent_variables
        load_wish_variables
      end
      
      # editable_by rules
    
        it 'should be editable only by creator, administrator or moderator if open' do
          @wish.open?.should be_true
          
          @wish.editable_by?(@user_wisher).should be_true
          @wish.editable_by?(@user).should be_false
          @wish.editable_by?(@user_mod).should be_true
          @wish.editable_by?(@user_admin).should be_true
        end
        
        it 'should be editable only by administrator or moderator if not open' do
          @wish.pending = true
    
          @wish.open?.should be_false
          @wish.editable_by?(@user_wisher).should be_false
          @wish.editable_by?(@user).should be_false
          @wish.editable_by?(@user_mod).should be_true
          @wish.editable_by?(@user_admin).should be_true
        end      
    
      # update
    
        it 'should be updated given the valid parameters' do
          e_type    = make_type('e_type')
          e_format  = make_format('e_format')
          e_country = make_country('e_country')
  
          params = { :name => 'e_name',
                     :type_id => e_type.id.to_s,
                     :format_id => e_format.id.to_s,
                     :description => 'e_description',
                     :year => '1234',
                     :country_id => e_country.id.to_s }
  
          @wish.update_with_updater(params, @user_wisher)
          @wish.reload
  
          @wish.name.should == 'e_name'
          @wish.country.should == e_country
          @wish.type.should == e_type
          @wish.format.should == e_format
          @wish.description.should == 'e_description'
          @wish.year.should == 1234
        end
    end    
  end
end