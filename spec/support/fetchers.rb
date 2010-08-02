
module Fetchers
  
  # client
  
    def fetch_client(code)
      Client.find_by_code(code) || make_client(code)
    end

  # country

    def fetch_country(description = nil)
      Country.find_by_description(description) || make_country(description)
    end
    
  # format  
  
    def fetch_format(description = nil)
      Format.find_by_description(description) || make_format(description)
    end
    
  # gender
  
    def fetch_gender(description = nil)
      Gender.find_by_description(description) || make_gender(description)
    end
  
  # role
  
    def fetch_role(name = nil)
      name ||= Role::USER
      Role.find_by_name(name) || make_role(name)
    end
  
  # source
    
    def fetch_source(description = nil)
      Source.find_by_description(description) || make_source(description)
    end
  
  # style
  
    def fetch_style(description = nil)
      Style.find_by_description(description) || make_style(description)
    end
  
  # type
  
    def fetch_type(description = nil)
      Type.find_by_description(description) || make_type(description)
    end
end  
  
  
    