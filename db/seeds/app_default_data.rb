

# app database params (values can be anything loadable by YAML)

  AppParam.create :name => 'signup_open'              , :yaml => 'true'
  AppParam.create :name => 'signup_by_invitation_only', :yaml => 'true'

# default roles

  create_default_role 1, Role::SYSTEM       , 'System'       , 'user_system'   , ''
  create_default_role 2, Role::OWNER        , 'Owner'        , 'user_owner'    , 'inviter wisher'
  create_default_role 3, Role::ADMINISTRATOR, 'Administrator', 'user_admin'    , 'inviter wisher'
  create_default_role 4, Role::MODERATOR    , 'Moderator'    , 'user_mod'      , 'inviter wisher'
  create_default_role 5, Role::USER         , 'User'         , 'user_user'     , 'wisher'
  create_default_role 6, Role::DEFECTIVE    , 'Defective'    , 'user_defective'

# default style

  s = Style.create :id => 1, :description => 'Default', :stylesheet => 'default.css'

# default country

  c = Country.create :description => 'Earth', :image => 'earth.gif'

# default users

  create_user 1, 'system', Role::SYSTEM, s # system user must have the id 1
  create_user 2, 'owner',  Role::OWNER,  s, c
