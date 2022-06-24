Feature: ao3 & ff.net note scrubbing

Scenario: check before ao3
  Given I Drive Myself Crazy exists
  When I am on the page's page
    And I follow "Scrub Notes"
    And I click on "Popslash" within ".top"
    And I click on "Make the Yuletide Gay" within ".bottom"
    And I press "Scrub Notes" within ".bottom"
  Then I should NOT see "by Sidra" within ".notes"
    And I should NOT see "Popslash" within ".notes"
    And I should NOT see "Make the Yuletide Gay" within ".notes"
    But I should see "AJ/JC" within ".notes"
    And I should see "Request: I like AUs or canon - but please no crossovers"

Scenario: rebuild from raw should recover scrubbed notes
  Given I Drive Myself Crazy exists
  When I am on the page's page
    And I follow "Scrub Notes"
    And I click on "Popslash" within ".top"
    And I click on "Make the Yuletide Gay" within ".bottom"
    And I press "Scrub Notes" within ".bottom"
    And I press "Rebuild from Raw HTML"
  Then I should see "by Sidra" within ".notes"
    And I should see "Popslash" within ".notes"
    And I should see "Make the Yuletide Gay" within ".notes"

Scenario: rebuild meta should NOT recover scrubbed notes
  Given I Drive Myself Crazy exists
  When I am on the page's page
    And I follow "Scrub Notes"
    And I click on "Popslash" within ".top"
    And I click on "Make the Yuletide Gay" within ".bottom"
    And I press "Scrub Notes" within ".bottom"
    And I press "Rebuild Meta"
  Then I should NOT see "by Sidra" within ".notes"
    And I should NOT see "Popslash" within ".notes"
    And I should NOT see "Make the Yuletide Gay" within ".notes"
    But I should see "AJ/JC" within ".notes"
    And I should see "Request: I like AUs or canon - but please no crossovers"

Scenario: check before ff.net
  Given ibiki exists
  When I am on the page's page
    And I follow "Scrub Notes"
    And I click on "Naruto" within ".bottom"
    And I press "Scrub Notes" within ".bottom"
  Then I should see "by May Wren" within ".notes"
    But I should NOT see "Naruto" within ".notes"
    And I should NOT see "The Academy's teachers" within ".notes"

Scenario: rebuild from raw should recover scrubbed notes
  Given ibiki exists
  When I am on the page's page
    And I follow "Scrub Notes"
    And I click on "Naruto" within ".bottom"
    And I press "Scrub Notes" within ".bottom"
    And I press "Rebuild from Raw HTML"
  Then I should see "by May Wren" within ".notes"
    And I should see "Naruto" within ".notes"
    And I should see "The Academy's teachers" within ".notes"

Scenario: rebuild meta should NOT recover scrubbed notes
  Given ibiki exists
  When I am on the page's page
    And I follow "Scrub Notes"
    And I click on "Naruto" within ".bottom"
    And I press "Scrub Notes" within ".bottom"
    And I press "Rebuild Meta"
  Then I should see "by May Wren" within ".notes"
    But I should NOT see "Naruto" within ".notes"
    And I should NOT see "The Academy's teachers" within ".notes"
