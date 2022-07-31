Feature: change a page's soon value

Scenario: default by default
  Given a page exists
  When I am on the page's page
  Then "Default" should be checked

Scenario: change to reading when download epub
  Given a page exists
  When I download its epub
    And I am on the page's page
  Then "Reading" should be checked

Scenario: change to reading when download partially read parent
  Given a partially read page exists
  When I download its epub
    And I am on the page's page
  Then "Reading" should be checked

Scenario: change to reading when download unread part
  Given a partially read page exists
  When I download the epub for "Unread"
    And I am on the page with title "Unread"
  Then "Reading" should be checked

Scenario: change to reading when download read
  Given a read page exists
  When I download its epub
    And I am on the page's page
  Then "Reading" should be checked

Scenario: change to reading when download read part
  Given a partially read page exists
  When I download the epub for "Read"
    And I am on the page with title "Read"
  Then "Reading" should be checked

Scenario: reading page
  Given a partially read page exists
    And I download the epub for "Read"
    And I download the epub for "Unread"
    And I am on the reading page
  Then the page should contain css "#position_1"
    And the page should contain css "#position_2"

Scenario: change to soonest during create
  Given I am on the create page
  When I fill in "page_title" with "Looks great"
    And I click on "Soonest"
    And I press "Store"
    And I am on the soonest page
  Then I should see "Looks great" within ".pages"

Scenario: change to sooner after create
  Given I am on the create page
  When I fill in "page_title" with "Looks good"
    And I press "Store"
    And I click on "Sooner"
    And I press "Change"
    And I am on the page's page
  Then "Sooner" should be checked

Scenario: change to soon after create
  Given I am on the create page
  When I fill in "page_title" with "Looks good"
    And I press "Store"
    And I click on "Soon"
    And I press "Change"
    And I am on the page's page
  Then "Soon" should be checked

Scenario: change to default when rating
  Given a page exists
    And I download its epub
  When I rate it 5 stars
    And I am on the page's page
  Then "Default" should be checked

Scenario: change to default when re-rating
  Given a read page exists
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


