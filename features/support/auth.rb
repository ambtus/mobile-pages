Before do
  visit '/login'
  fill_in 'Name', :with => 'tester'
  fill_in 'Password', :with => 'secret'
  click_button "Log in"
end
