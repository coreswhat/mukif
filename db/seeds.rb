
require Padrino.root('db/seeds/utils.rb')

require Padrino.root('db/seeds/app_default_data.rb')
require Padrino.root('db/seeds/app_data.rb')

if Padrino.env == :development
  require Padrino.root('db/seeds/dummy_data.rb')
end 
