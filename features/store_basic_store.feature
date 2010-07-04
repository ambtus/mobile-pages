Feature: Basic Store
  What: enter a title and a url
  Why: combat link rot
  Result: view the document

Scenario: no genres
  Given I am on the homepage
    And I have no pages
    And I have no filters
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I fill in "page_title" with "New Title"
    And I press "Store"
  Then I should see "Please select genre"
  When I fill in "genres" with "my genre"
    And I press "Add Genres"
  Then I should see "my genre" within ".genres"

Scenario: no genre selected
  Given a genre exists with name: "first"
    And I am on the homepage
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I fill in "page_title" with "New Title"
    And I press "Store"
  Then I should see "Please select genre"
  When I select "first" from "page_genre_ids_"
    And I press "Update Genres"
  Then I should see "first" within ".genres"

Scenario Outline: genres and authors
  Given I have no pages
    And the following genres
      | name |
      | first genre |
      | second genre |
      | third genre |
    And the following authors
      | name |
      | first author |
      | second author |
      | third author |
  When I am on the homepage
    And I fill in "page_url" with "<url>"
    And I fill in "page_title" with "<title>"
    And I select "<genre>" from "Genre"
    And I select "<author>" from "Author"
    And I press "Store"
  Then I should see "Page created" within "#flash_notice"
    And I should see "<title>" within ".title"
    And I should see "<result>" within ".content"
    And I should see "<genre>" within ".genres"
    And I should see "<author>" within ".authors"

  Examples:
  | url                                      | title            | result                 | genre        | author        |
  | http://test.sidrasue.com/test.html       | Simple Test      | Retrieved from the web | first genre  |               |
  | http://test.sidrasue.com/basic/test.html | Basic Auth Test  | password example       | second genre |               |
  | http://test.sidrasue.com/digest/test.html| Auth Digest Test | digest example         | third genre  |               |
  | http://test.sidrasue.com/utf8.html       | utf8 Test        | “Hello…”               | first genre  | first author  |
  | http://test.sidrasue.com/1252.html       | winlatin1 Test   | “Hello…”               | second genre | second author |
  | http://test.sidrasue.com/nbsp.html       | space Test       | Retrieved from the web | third genre  | third author  |
  | http://test.sidrasue.com/mso.html        | <st1:place>      | in on Clark            | first genre  |               |
  | http://test.sidrasue.com/entities.html   | entities         | antsy—boggart          | second genre | first author  |
