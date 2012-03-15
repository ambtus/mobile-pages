# encoding: utf-8

Feature: dealing with various encodings in fetched documents

Scenario Outline: encodings
  Given I have no pages
  When I am on the homepage
    And I fill in "page_url" with "<url>"
    And I fill in "page_title" with "<title>"
    And I press "Store"
  When I go to the page with title "<title>"
  Then I should see "<title>" within ".title"
  When I follow "HTML"
  Then I should see "<result>" within ".content"
  When I go to the page with title "<title>"
    And "Original" should link to "<url>" within ".title"

  Examples:
  | url                                      | title            | result                 |
  | http://test.sidrasue.com/test.html       | Simple Test      | Retrieved from the web |
  | http://test.sidrasue.com/basic/test.html | Basic Auth Test  | password example       |
  | http://test.sidrasue.com/digest/test.html| Auth Digest Test | digest example         |
  | http://test.sidrasue.com/utf8.html       | utf8 Test        | “Hello…”               |
  | http://test.sidrasue.com/1252.html       | winlatin1 Test   | “Hello…”               |
  | http://test.sidrasue.com/nbsp.html       | space Test       | Retrieved from the web |
  | http://test.sidrasue.com/mso.html        | <st1:place>      | in on Clark            |
  | http://test.sidrasue.com/entities.html   | entities         | antsy—boggart          |


  # webrat is not displaying the entity
  Scenario: clean html with stray linefeed
    Given a page exists with title: "Linefeed", url: "http://test.sidrasue.com/112a.html"
    Then my page named "Linefeed" should contain "fiancé"
    And my page named "Linefeed" should not contain "&#13;"

  Scenario: utf8
    Given a titled page exists with url: "http://test.sidrasue.com/sbutf8.html"
    When I am on the page's page
      And I follow "HTML"
    Then I should see "“H"

  Scenario: utf8 in parts
    Given a titled page exists with urls: "http://test.sidrasue.com/sbutf8.html"
    When I am on the page's page
      And I follow "HTML"
    Then I should see "“H"

  Scenario: latin1
    Given a titled page exists with url: "http://test.sidrasue.com/1252.html"
    When I am on the page's page
      And I follow "HTML"
    Then I should see "“H"

