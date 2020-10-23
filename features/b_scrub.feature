Feature: trim cruft off pages

 Scenario: remove bottom when one automatically removed surrounding div
  Given I have no pages
  And a page exists with url: "http://test.sidrasue.com/divs.html"
  When I am on the page's page
    And I follow "Scrub"
  When I choose "3rd" within ".bottom"
  And I press "Scrub" within ".top"
  And I view the content
  Then I should see "1st"
    And I should see "2nd"
  But I should NOT see "3rd"

 Scenario: remove top when one automatically removed surrounding blockquote
  Given I have no pages
  And a page exists with url: "http://test.sidrasue.com/blockquote.html"
  When I am on the page's page
    And I follow "Scrub"
  When I choose "1st" within ".top"
    And I press "Scrub" within ".bottom"
  And I view the content
  Then I should see "2nd"
    And I should see "3rd"
  But I should NOT see "1st"

 Scenario Outline: strip beginning and end
  Given I have no pages
  And a page exists with url: "<url>"
  When I am on the page's page
    And I follow "Scrub"
  When I choose "<unwanted1>" within ".top"
    And I choose "<unwanted2>" within ".bottom"
    And I press "Scrub" within ".top"
  And I view the content
  Then I should see "<wanted>"
    And I should NOT see "<unwanted1>"
    And I should NOT see "<unwanted2>"

  Examples:
  | url                                        | wanted       | unwanted1       | unwanted2   |
  | http://test.sidrasue.com/p.html            | content      | top para        | bottom para |
  | http://test.sidrasue.com/table.html        | content      | top para        | Row_1_Cell_1|
  | http://test.sidrasue.com/br.html           | all on       | top line        | bottom line |
  | http://test.sidrasue.com/entities.html     | As the stags | Content Removed | All fiction |
  | http://test.sidrasue.com/img.html          | content      | top para        | bottom par  |
  | http://test.sidrasue.com/tablecontent.html | I remembered | Jump            | Content     |
  | http://test.sidrasue.com/href.html         | content      | top link        | bottom link |
  | http://test.sidrasue.com/styled.html       | horizontal   | sentence        | end         |

  Scenario: trim when many headers and short fic
            also recover from trimming too much
    Given I have no pages
    And a page exists with url: "http://test.sidrasue.com/headers.html"
    When I am on the page's page
      And I follow "Scrub"
      And I choose "third header" within ".top"
      And I press "Scrub" within ".bottom"
    And I view the content
    Then I should see "actual content"
      And I should NOT see "header"
    When I am on the page's page
    When I press "Rebuild from Raw HTML"
    And I view the content
    Then I should see "header"

  Scenario: trim a parent page
       also rebuild all children from raw
    Given I have no pages
    And a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1 2"
    And I am on the page's page
    When I view the content
    Then I should see "cruft"
      And the download directory should exist
    And I am on the page's page
    And I follow "Scrub" within ".edits"
      And I follow "Scrub Part 1"
      And I choose "top cruft" within ".top"
      And I choose "bottom cruft" within ".bottom"
      And I press "Scrub" within ".bottom"
    Then the download html file should NOT exist
    And I am on the page's page
      And I view the content
    Then I should NOT see "cruft"
      And I should see "stuff for part 1"
    And I am on the page's page
    When I press "Rebuild from Raw HTML"
    Then the download html file should NOT exist
      And I view the content
    Then I should see "cruft"
      And the download directory should exist

  Scenario: trim a sub-part
    Given a page exists
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "url_list" with
        """
        ##First Part
        http://test.sidrasue.com/parts/1.html###SubPart
        """
      And I press "Update"
      And I view the content
    Then I should see "cruft"
      And the download directory should exist
    When I am on the page's page
      And I follow "Scrub"
      And I follow "Scrub First Part"
      And I follow "Scrub SubPart"
      And I choose "top cruft" within ".top"
      And I choose "bottom cruft" within ".bottom"
      And I press "Scrub" within ".top"
    Then the download html file should NOT exist
    When I am on the page's page
      And I view the content
    Then I should see "First Part"
      And I should see "SubPart"
      And I should see "stuff for part 1"
    But I should NOT see "top cruft"
    And I should NOT see "bottom cruft"

  Scenario: show number of nodes
  Given I have no pages
  And a page exists with url: "http://test.sidrasue.com/div.html"
  When I am on the page's page
    And I follow "Scrub"
  Then I should see "4 nodes"
  When I choose "last div" within ".bottom"
  And I press "Scrub" within ".bottom"
    And I follow "Scrub"
  Then I should see "3 nodes"
