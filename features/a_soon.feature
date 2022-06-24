Feature: change a page's soon value

Scenario: default by default
  Given a page exists
  When I am on the page's page
  Then "Default" should be checked

Scenario: change to reading when download epub
  Given a page exists
  When I am on the page's page
    And I download its epub
    And I am on the page's page
  Then "Reading" should be checked

Scenario: change to soonest during create
  Given I am on the create page
  When I fill in "page_title" with "Looks great"
    And I click on "Soonest"
    And I press "Store"
    And I am on the soonest page
  Then I should see "Looks great" within ".pages"

Scenario: change to soon after create
  Given I am on the create page
  When I fill in "page_title" with "Looks good"
    And I press "Store"
    And I click on "Soon"
    And I press "Change"
    And I am on the soon page
  Then I should see "Looks good" within ".pages"

Scenario: change to default when rating
  Given a page exists
    And I download its epub
  When I rate it 5 stars
    And I am on the page's page
  Then "Default" should be checked

Scenario: change to later during create
  Given I am on the create page
  When I fill in "page_title" with "Looks okay"
    And I click on "Someday"
    And I press "Store"
    And I am on the page's page
  Then "Someday" should be checked

Scenario: change to eventually after create
  Given I am on the create page
  When I fill in "page_title" with "Looks bad"
    And I press "Store"
    And I click on "Eventually"
    And I press "Change"
  Then "Eventually" should be checked


