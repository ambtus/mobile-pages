Feature: decrease a page's soon value

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
    And I choose "Soonest"
    And I press "Store"
    And I am on the soonest page
  Then I should see "Looks great" within ".pages"

Scenario: change to soon after create
  Given I am on the create page
  When I fill in "page_title" with "Looks good"
    And I press "Store"
    And I choose "Soon"
    And I press "Change"
    And I am on the soon page
  Then I should see "Looks good" within ".pages"

