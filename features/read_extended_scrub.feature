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
  When I press "Remove surrounding Div"
  Then I should see "Surrounding div removed"
  When I check "bottom2"
  And I press "Scrub"
  Then I should see "1st"
    And I should see "2nd"
  But I should not see "3rd"

 Scenario: remove surrounding blockquote
  Given a titled page exists with url: "http://test.sidrasue.com/blockquote.html"
  When I am on the page's page
    And I follow "Scrub"
  When I press "Remove surrounding Div"
  Then I should see "Surrounding div removed"
  When I check "0"
    And I check "bottom2"
  And I press "Scrub"
  Then I should not see "1st"
    And I should not see "3rd"
  But I should see "2nd"

