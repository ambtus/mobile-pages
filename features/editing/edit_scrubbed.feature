Feature: trim cruft off pages

Scenario: remove bottom when one automatically removed surrounding div
  Given a page exists with url: "http://localhost:8080/tests/divs.html"
  When I am on the first page's page
    And I follow "Scrub"
    And I click on "3rd" within ".bottom"
    And I press "Scrub" within ".top"
  Then the contents should include "1st"
    And the contents should include "2nd"
    But the contents should NOT include "3rd"

Scenario: remove top when one automatically removed surrounding blockquote
  Given a page exists with url: "http://localhost:8080/tests/blockquote.html"
  When I am on the first page's page
    And I follow "Scrub"
    And I click on "1st" within ".top"
    And I press "Scrub" within ".bottom"
  Then the contents should include "2nd"
    And the contents should include "3rd"
    But the contents should NOT include "1st"

Scenario Outline: strip beginning and end
  Given a page exists with url: "<url>"
  When I am on the first page's page
    And I follow "Scrub"
    And I click on "<unwanted1>" within ".top"
    And I click on "<unwanted2>" within ".bottom"
    And I press "Scrub" within ".top"
  Then the contents should include "<wanted>"
    And the contents should NOT include "<unwanted1>"
    And the contents should NOT include "<unwanted2>"

Examples:
| url                                        | wanted       | unwanted1       | unwanted2   |
| http://localhost:8080/tests/p.html            | content      | top para        | bottom para |
| http://localhost:8080/tests/table.html        | content      | top para        | Row_1_Cell_1|
| http://localhost:8080/tests/br.html           | all on       | top line        | bottom line |
| http://localhost:8080/tests/entities.html     | As the stags | Content Removed | All fiction |
| http://localhost:8080/tests/img.html          | content      | top para        | bottom par  |
| http://localhost:8080/tests/tablecontent.html | I remembered | Jump            | Content removed    |
| http://localhost:8080/tests/href.html         | content      | top link        | bottom link |
| http://localhost:8080/tests/styled.html       | horizontal   | sentence        | end         |

Scenario: trim when many headers and short fic
  Given a page exists with url: "http://localhost:8080/tests/headers.html"
  When I am on the first page's page
    And I follow "Scrub"
    And I click on "third header" within ".top"
    And I press "Scrub" within ".bottom"
  Then the contents should include "actual content"
    And the contents should NOT include "header"

Scenario: recover from trimming too much
  Given a page exists with url: "http://localhost:8080/tests/headers.html"
  When I am on the first page's page
    And I follow "Scrub"
    And I click on "third header" within ".top"
    And I press "Scrub" within ".bottom"
    And I press "Rebuild from Raw HTML"
  Then the contents should include "header"
    And the contents should include "actual content"

Scenario: check before trimming parent
  Given a page exists with base_url: "http://localhost:8080/tests/parts/*.html" AND url_substitutions: "1 2"
  Then the contents should include "cruft"

Scenario: trim a child removes parent's (composite) html
  Given a page exists with base_url: "http://localhost:8080/tests/parts/*.html" AND url_substitutions: "1 2"
  When I am on the first page's page
  And I follow "Scrub"
    And I follow "Scrub Part 1"
    And I click on "top cruft" within ".top"
    And I click on "bottom cruft" within ".bottom"
    And I press "Scrub" within ".bottom"
  Then the temporary html file should NOT exist

Scenario: trim a child removes parent's (composite) html
  Given a page exists with base_url: "http://localhost:8080/tests/parts/*.html" AND url_substitutions: "1 2"
  When I am on the first page's page
  And I follow "Scrub"
    And I follow "Scrub Part 1"
    And I click on "top cruft" within ".top"
    And I click on "bottom cruft" within ".bottom"
    And I press "Scrub" within ".bottom"
  Then the contents should NOT include "cruft"
    But the contents should include "stuff for part 1"

Scenario: rebuild all children from raw
  Given a page exists with base_url: "http://localhost:8080/tests/parts/*.html" AND url_substitutions: "1 2"
  When I am on the first page's page
    And I follow "Scrub"
    And I follow "Scrub Part 1"
    And I click on "top cruft" within ".top"
    And I click on "bottom cruft" within ".bottom"
    And I press "Scrub" within ".bottom"
    And I press "Rebuild from Raw HTML"
  Then the contents should include "cruft"

Scenario: check before trim a sub-part
  Given a page exists with urls: "http://localhost:8080/tests/parts/1.html"
  When I am on the first page's page
    And I add a parent with title "Parent"
  Then the contents should include "cruft"

Scenario: scrubbing grandchild remove's grandparent's (composite) html
  Given a page exists with urls: "http://localhost:8080/tests/parts/1.html"
  When I am on the first page's page
    And I add a parent with title "Parent"
    And I am on the page with title "Part 1"
    And I follow "Scrub"
    And I click on "top cruft" within ".top"
    And I click on "bottom cruft" within ".bottom"
    And I press "Scrub" within ".top"
  Then the temporary html file should NOT exist

Scenario: scrubbing grandchild shows scrubbed content in grandparent
  Given a page exists with title: "GrandParent" AND type: 'Series'
  Given a page exists with urls: "http://localhost:8080/tests/parts/1.html" AND title: "Parent"
  When I am on the page with title "Parent"
    And I add a parent with title "Grandparent"
    And I am on the page with title "Part 1"
    And I follow "Scrub"
    And I click on "top cruft" within ".top"
    And I click on "bottom cruft" within ".bottom"
    And I press "Scrub" within ".top"
  Then the contents should include "stuff for part 1"
    But the contents should NOT include "top cruft"
    And the contents should NOT include "bottom cruft"

Scenario: show number of nodes
  Given a page exists with url: "http://localhost:8080/tests/div.html"
  When I am on the first page's page
    And I follow "Scrub"
  Then I should see "4 nodes"

Scenario: show number of nodes
  Given a page exists with url: "http://localhost:8080/tests/div.html"
  When I am on the first page's page
    And I follow "Scrub"
    And I click on "last div" within ".bottom"
    And I press "Scrub" within ".bottom"
    And I follow "Scrub"
  Then I should see "3 nodes"
