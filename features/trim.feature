Feature: trim cruft off pages

 Scenario: remove surrounding div and bottom
  Given a titled page exists with url: "http://test.sidrasue.com/divs.html"
  When I am on the page's page
    And I follow "Scrub"
  When I press "Remove surrounding Div"
  Then I should see "Surrounding div removed"
  When I choose "3rd" within ".bottom"
  And I press "Scrub"
  And I follow "HTML"
  Then I should see "1st"
    And I should see "2nd"
  But I should not see "3rd"

 Scenario: remove surrounding blockquote and top
  Given a titled page exists with url: "http://test.sidrasue.com/blockquote.html"
  When I am on the page's page
    And I follow "Scrub"
  When I press "Remove surrounding Div"
  Then I should see "Surrounding div removed"
  When I choose "1st" within ".top"
    And I press "Scrub"
  And I follow "HTML"
  Then I should see "2nd"
    And I should see "3rd"
  But I should not see "1st"

 Scenario Outline: strip beginning and end
  Given a titled page exists with url: "<url>"
  When I am on the page's page
    And I follow "Scrub"
  When I choose "<unwanted1>" within ".top"
    And I choose "<unwanted2>" within ".bottom"
    And I press "Scrub"
  And I follow "HTML"
  Then I should see "<wanted>"
    And I should not see "<unwanted1>"
    And I should not see "<unwanted2>"

  Examples:
  | url                                        | wanted       | unwanted1       | unwanted2   |
  | http://test.sidrasue.com/p.html            | content      | top para        | bottom para |
  | http://test.sidrasue.com/table.html        | content      | top para        | Row_1_Cell_1|
  | http://test.sidrasue.com/br.html           | all on       | top line        | bottom line |
  | http://test.sidrasue.com/entities.html     | As the stags | Content Removed | hr width    |
  | http://test.sidrasue.com/img.html          | content      | top para        | bottom par  |
  | http://test.sidrasue.com/tablecontent.html | I remembered | Jump            | Content     |
  | http://test.sidrasue.com/href.html         | content      | top link        | bottom link |
  | http://test.sidrasue.com/styled.html       | horizontal   | sentence        | end         |

  Scenario: trim when many headers and short fic
            also recover from trimming too much
    Given a titled page exists with url: "http://test.sidrasue.com/headers.html"
    When I am on the page's page
      And I follow "Scrub"
      And I choose "third header" within ".top"
      And I press "Scrub"
    And I follow "HTML"
    Then I should see "actual content"
      And I should not see "header"
    When I am on the page's page
    When I follow "Scrub"
      And I choose "actual content" within ".top"
      And I press "Scrub"
    And I follow "HTML"
    Then I should not see "actual content"
    When I am on the page's page
    When I press "Rebuild from Raw HTML"
    And I follow "HTML"
    Then I should see "actual content"

  Scenario: trim a parent page
    Given a page exists with title: "Parent", base_url: "http://test.sidrasue.com/parts/*.html", url_substitutions: "1 2"
    And I am on the page's page
    When I follow "HTML"
    Then I should see "cruft"
    And I am on the page's page
    When I follow "TXT" within ".title"
    Then I should see "cruft"
    When I am on the page's page
    And I follow "Scrub" within ".title"
      And I follow "Scrub Part 1"
      And I choose "top cruft" within ".top"
      And I choose "bottom cruft" within ".bottom"
      And I press "Scrub"
    And I follow "HTML"
    Then I should not see "cruft"
      And I should see "stuff for part 1"
    When I am on the page's page
      And I follow "TXT" within ".title"
    Then I should not see "cruft"
      And I should see "stuff for part 1"
      And I should see "stuff for part 2"

  Scenario: trim a sub-part
    Given a titled page exists with urls: "##First Part\nhttp://test.sidrasue.com/parts/1.html###SubPart"
    When I am on the page's page
      And I follow "Scrub"
      And I follow "Scrub First Part"
      And I follow "Scrub SubPart"
      And I choose "top cruft" within ".top"
      And I choose "bottom cruft" within ".bottom"
      And I press "Scrub"
    When I am on the page's page
      And I follow "First Part"
      And I follow "TXT"
    Then I should see "First Part #"
      And I should see "## SubPart ##"
      And I should see "stuff for part 1"
    But I should not see "top cruft"
    And I should not see "bottom cruft"
