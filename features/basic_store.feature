Feature: Basic Store
  What: enter a title and a url
  Why: combat link rot
  Result: view the document

Scenario Outline: title and url
  Given I am on the homepage
  When I fill in "page_url" with "<url>"
    And I fill in "page_title" with "<title>"
    And I press "Store"
  Then I should see "Page created" in "#flash_notice"
    And I should see "<title>" in ".title"
    And I should see "<result>" in ".content"

  Examples:
  | url                                        | title            | result                 |
  | http://sidrasue.com/tests/test.html      | Simple Test      | Retrieved from the web |
  | http://sidrasue.com/tests/basic/test.html| Basic Auth Test  | password example       |
  | http://sidrasue.com/tests/digest/test.html| Auth Digest Test  | digest example       |
  | http://sidrasue.com/tests/utf8.html      | utf8 Test        | “Hello…”               |
  | http://sidrasue.com/tests/1252.html      | winlatin1 Test   | “Hello…”               |
  | http://sidrasue.com/tests/nbsp.html      | space Test       | Retrieved from the web |
  | http://sidrasue.com/tests/entities.html  | entities         | antsy—boggart          |
  | http://sidrasue.com/tests/mso.html       | <st1:place>      | in on Clark            |
