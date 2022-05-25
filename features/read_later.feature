Feature: increase a page's soon value

Scenario: change to default when rating
  Given a page exists
    And I download its epub
  When I rate it 5 stars
    And I am on the page's page
  Then "Default" should be checked

Scenario: change to later during create
  Given I am on the create page
  When I fill in "page_title" with "Looks okay"
    And I choose "Later"
    And I press "Store"
    And I am on the page's page
  Then "Later" should be checked

Scenario: change to eventually after create
  Given I am on the create page
  When I fill in "page_title" with "Looks bad"
    And I press "Store"
    And I choose "Eventually"
    And I press "Change"
  Then "Eventually" should be checked


