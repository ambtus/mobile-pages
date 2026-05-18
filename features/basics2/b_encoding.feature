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
| http://localhost:8080/tests/test.html       | Simple Test      | Retrieved from the web |
| http://localhost:8080/tests/basic/test.html | Basic Auth Test  | password example       |
| http://localhost:8080/tests/digest/test.html| Auth Digest Test | digest example         |
| http://localhost:8080/tests/utf8.html       | utf8 Test        | “Hello…”               |
| http://localhost:8080/tests/1252.html       | winlatin1 Test   | “Hello…”               |
| http://localhost:8080/tests/nbsp.html       | space Test       | Retrieved from the web |
| http://localhost:8080/tests/mso.html        | <st1:place>      | in on Clark            |
| http://localhost:8080/tests/entities.html   | entities         | antsy—boggart          |


Scenario: stray linefeed
  Given a page exists with url: "http://localhost:8080/tests/112a.html"
  When I am on the first page's page
  Then the contents should include "fiancé"
    And the contents should include "What was Xio Voe really like?"
    But the contents should NOT include "&#13;"

Scenario: utf8
  Given a page exists with url: "http://localhost:8080/tests/sbutf8.html"
  When I am on the first page's page
  Then the contents should include "“H"

Scenario: latin1
  Given a page exists with url: "http://localhost:8080/tests/1252.html"
  When I am on the first page's page
  Then the contents should include "“H"

