Given /^I am not authenticated$/ do
  visit('/users/sign_out')
end

Given /^I have one\s+user "([^\"]*)" with password "([^\"]*)"$/ do |email, password|
  User.find_or_create_by_email(:email => email,
           :password => password,
           :password_confirmation => password).save!
end

Given /^I am an authenticated user$/ do
  email = 'testing@sidrasue.com'
  password = 'secretpass'

  step %{I have one user "#{email}" with password "#{password}"}
  visit('/users/sign_in')
  step %{I fill in "user_email" with "#{email}"}
  step %{I fill in "user_password" with "#{password}"}
  step %{I press "Sign in"}
  step %{I should see "Signed in successfully"}
end
