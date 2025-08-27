Feature: stuff to do with titles

Scenario: put title in the url box by mistake
  Given I am on the mini page
  When I fill in "page_url" with "Title"
    And I press "Store"
  Then I should see "Url is invalid"
    And I should have 0 pages

Scenario: don't enter title in the title box
  Given I am on the create single page
  When I press "Store"
  Then I should have 0 pages
    And I should see "Both URL and Title can't be blank"

Scenario: clear out title
  Given I am on the create single page
  When I fill in "page_title" with ""
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Store"
  Then I should NOT see "Title can't be blank"
    And I should see "temp" within ".title"
    And I should have 1 page

Scenario: change title
  Given a page exists with url: "http://test.sidrasue.com/test.html"
  When I am on the first page's page
    And I follow "Title"
    And I fill in "title" with "New Title"
    And I press "Update"
  Then I should see "New Title" within ".title"
