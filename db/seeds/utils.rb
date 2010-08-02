

def create_default_role(id, name, description, css_class, tickets = nil)
  r = Role.new :id => id, :description => description, :css_class => css_class, :tickets => tickets
  r.name = name # attribute name is protected and must be assigned separately
  r.save!
end

def create_role(name, description, css_class, tickets = nil)
  r = Role.new :description => description, :css_class => css_class, :tickets => tickets
  r.name = name # attribute name is protected and must be assigned separately
  r.save!
end

def create_user(id, username, role_name, style, country = nil)
  style = Style.first
  u = User.new(:id => id,
               :username => username,
               :password => username,
               :password_confirmation => username,
               :style => style,
               :country => country,
               :email => "#{username}@mail.com",
               :save_sent => false,
               :display_leeching => false,
               :display_seeding => false,
               :display_snatches => false,
               :display_uploads => false,
               :display_last_request_at => false)
  u.role = Role.find_by_name(role_name) # attribute role_id is protected and must be assigned separately
  u.save!
end
