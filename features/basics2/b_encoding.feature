# encoding: utf-8
Feature: dealing with various encodings in fetched documents

Scenario Outline: encodings
  Given I am on the create single page
  When I fill in "page_url" with "<url>"
    And I fill in "page_title" with "<title>"
    And I store the page
  Then the contents should include "<result>"

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


Scenario: stray linefeed
  Given a page exists with url: "http://test.sidrasue.com/112a.html"
  When I am on the first page's page
  Then the contents should include "fiancé"
    And the contents should include "What was Xio Voe really like?"
    But the contents should NOT include "&#13;"

Scenario: utf8
  Given a page exists with url: "http://test.sidrasue.com/sbutf8.html"
  When I am on the first page's page
  Then the contents should include "“H"

Scenario: latin1
  Given a page exists with url: "http://test.sidrasue.com/1252.html"
  When I am on the first page's page
  Then the contents should include "“H"

