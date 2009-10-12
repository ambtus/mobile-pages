Feature: Basic Store
  What: enter a title and a url
  Why: combat link rot
  Result: view the document

Scenario: no genres
  Given I am on the homepage
    And I have no pages
    And I have no filters
  When I fill in "page_url" with "http://sidrasue.com/tests/test.html"
    And I fill in "page_title" with "Title"
    And I press "Store"
  Then I should see "Please select genre"
  When I fill in "genres" with "my genre"
    And I press "Add genres"
  Then I should see "my genre" in ".genres"

Scenario: no genre selected
  Given I am on the homepage
    And I have no pages
    And the following genre
      | name |
      | first |
  When I fill in "page_url" with "http://sidrasue.com/tests/test.html"
    And I fill in "page_title" with "Title"
    And I press "Store"
  Then I should see "Please select genre"
  When I select "first"
    And I press "Update genres"
  Then I should see "first" in ".genres"


Scenario Outline: title and url
  Given I have no pages
    And the following genres
      | name |
      | first genre |
      | second genre |
      | third genre |
  When I am on the homepage
    And I fill in "page_url" with "<url>"
    And I fill in "page_title" with "<title>"
    And I select "<genre>" 
    And I press "Store"
  Then I should see "Page created" in "#flash_notice"
    And I should see "<title>" in ".title"
    And I should see "<result>" in ".content"
    And I should see "<genre>" in ".genres"

  Examples:
  | url                                       | title            | result                 | genre |
  | http://sidrasue.com/tests/test.html       | Simple Test      | Retrieved from the web | first genre |
  | http://sidrasue.com/tests/basic/test.html | Basic Auth Test  | password example       | second genre |
  | http://sidrasue.com/tests/digest/test.html| Auth Digest Test | digest example         | third genre |
  | http://sidrasue.com/tests/utf8.html       | utf8 Test        | “Hello…”               | first genre |
  | http://sidrasue.com/tests/1252.html       | winlatin1 Test   | “Hello…”               | second genre |
  | http://sidrasue.com/tests/nbsp.html       | space Test       | Retrieved from the web | third genre |
  | http://sidrasue.com/tests/entities.html   | entities         | antsy—boggart          | second genre |
  | http://sidrasue.com/tests/mso.html        | <st1:place>      | in on Clark            | first genre |
