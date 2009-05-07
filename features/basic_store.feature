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
  | http://www.rawbw.com/~alice/test.html      | Simple Test      | Retrieved from the web |
  | http://www.rawbw.com/~alice/basic/test.html| Basic Auth Test  | password example       |
  | http://www.rawbw.com/~alice/digest/test.html| Auth Digest Test  | digest example       |
  | http://www.rawbw.com/~alice/utf8.html      | utf8 Test        | “Hello…”               |
  | http://www.rawbw.com/~alice/1252.html      | winlatin1 Test   | “Hello…”               |
  | http://www.rawbw.com/~alice/nbsp.html      | space Test       | Retrieved from the web |
  | http://www.rawbw.com/~alice/entities.html  | entities         | antsy—boggart          |
  | http://www.rawbw.com/~alice/mso.html       | <st1:place>      | in on Clark            |
