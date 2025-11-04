Feature: give it a title

Scenario: title error notice
  Given I am on the mini page
  When I fill in "page_url" with "Title"
    And I store the page
  Then I should have 0 pages
    And I should see "Url is invalid" within "#flash_alert"

Scenario: change title works
  Given a page exists with url: "http://test.sidrasue.com/test.html"
  When I am on the first page's page
    And I follow "Title"
    And I fill in "title" with "New Title"
    And I press "Update"
  Then I should see "New Title" within ".title"
