After do |scenario|
  puts scenario.status
  Cucumber.wants_to_quit = scenario.failed?
end
