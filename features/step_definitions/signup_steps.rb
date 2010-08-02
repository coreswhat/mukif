
# given

  Given /^that signup is open$/ do
    make_app_param 'signup_open', 'true'
  end

  Given /^that signup is closed$/ do
    make_app_param 'signup_open', 'false'
  end

  Given /^that signup requires invitation$/ do
    make_app_param 'signup_by_invitation_only', 'true'
  end

  Given /^that signup does not require invitation$/ do
    make_app_param 'signup_by_invitation_only', 'false'
  end




