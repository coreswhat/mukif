
describe '- models' do 
  
  describe 'Torrent' do

    context '- updating:' do
  
      before(:each) do
        clear_database
        load_default_variables
        load_torrent_variables
      end
  
      it 'should be editable only by creator, administrator or moderator' do
        @torrent.editable_by?(@user_uploader).should be_true
        @torrent.editable_by?(@user_mod).should be_true
        @torrent.editable_by?(@user_admin).should be_true
        @torrent.editable_by?(@user).should be_false
      end
  
      it 'should be updated by uploader given the valid parameters' do
        e_type    = make_type('e_type')
        e_format  = make_format('e_format')
        e_source  = make_source('e_source')
        e_country = make_country('e_country')
  
        params = { :name => 'e_name',
                   :type_id => e_type.id.to_s,
                   :format_id => e_format.id.to_s,
                   :source_id => e_source.id.to_s,
                   :country_id => e_country.id.to_s,
                   :description => 'e_description',
                   :year => '1234' }
  
        @torrent.update_with_updater params, @user_uploader      
        @torrent.reload
        
        @torrent.name.should == 'e_name'
        @torrent.type.should == e_type
        @torrent.format.should == e_format
        @torrent.source.should == e_source
        @torrent.country.should == e_country
        @torrent.description.should == 'e_description'
        @torrent.year.should == 1234
      end
      
      it 'should be updated by moderator given the valid parameters' do
        e_type    = make_type('e_type')
        e_format  = make_format('e_format')
        e_source  = make_source('e_source')
        e_country = make_country('e_country')
  
        params = { :name => 'e_name',
                   :type_id => e_type.id.to_s,
                   :format_id => e_format.id.to_s,
                   :source_id => e_source.id.to_s,
                   :country_id => e_country.id.to_s,
                   :description => 'e_description',
                   :year => '1234',
                   :free => '1',
                   :free_until => Time.now.to_s }
  
        @torrent.update_with_updater params, @user_mod, 'whatever reason'      
        @torrent.reload
        
        @torrent.name.should == 'e_name'
        @torrent.type.should == e_type
        @torrent.format.should == e_format
        @torrent.source.should == e_source
        @torrent.country.should == e_country
        @torrent.description.should == 'e_description'
        @torrent.year.should == 1234
        @torrent.free?.should be_true
        @torrent.free_until.instance_of?(Time).should be_true
      end   
    end
  end
end