Feature: Extended Scrub

 Scenario: jump to end
  Given a titled page exists
  When I am on the page's page
    And I follow "Scrub"
  Then I follow "Jump to end"

 Scenario: remove surrounding div
  Given a titled page exists with url: "http://test.sidrasue.com/divs.html"
  When I am on the page's page
    And I follow "Scrub"
  When I press "Remove surrounding div"
  Then I should see "Surrounding div removed"
  When I check boxes "2"
  And I press "Scrub"
  Then I should not see "3"

 Scenario: remove surrounding blockquote
  Given a titled page exists with url: "http://test.sidrasue.com/blockquote.html"
  When I am on the page's page
    And I follow "Scrub"
  When I press "Remove surrounding div"
  Then I should see "Surrounding div removed"
  When I check boxes "2"
  And I press "Scrub"
  Then I should not see "3"

