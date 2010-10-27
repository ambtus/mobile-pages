Feature: trim cruft off pages

 Scenario: remove surrounding div
  Given a titled page exists with url: "http://test.sidrasue.com/divs.html"
  When I am on the page's page
    And I follow "Scrub"
  When I press "Remove surrounding Div"
  Then I should see "Surrounding div removed"
  When I check "bottom2"
  And I press "Scrub"
  Then I should see "1st"
    And I should see "2nd"
  But I should not see "3rd"

 Scenario: remove surrounding blockquote
  Given a titled page exists with url: "http://test.sidrasue.com/blockquote.html"
  When I am on the page's page
    And I follow "Scrub"
  When I press "Remove surrounding Div"
  Then I should see "Surrounding div removed"
  When I check "0"
    And I check "bottom2"
  And I press "Scrub"
  Then I should not see "1st"
    And I should not see "3rd"
  But I should see "2nd"

 Scenario Outline: strip beginning and end
  Given a genre exists with name: "genre"
   When I am on the homepage
    And I fill in "page_url" with "<url>"
    And I fill in "page_title" with "New Title"
    And I select "genre" from "Genre"
    And I press "Store"
    And I follow "Scrub"
  When I check boxes "<nodes>"
    And I press "Scrub"
  Then I should see "<wanted>"
    And I should not see "<unwanted1>"
    And I should not see "<unwanted2>"

  Examples:
  | url                                        | nodes       | wanted       | unwanted1       | unwanted2   |
  | http://test.sidrasue.com/p.html            | 0 bottom2   | content      | top para        | bottom para |
  | http://test.sidrasue.com/table.html        | 0 bottom2   | content      | top para        | Row_1_Cell_1|
  | http://test.sidrasue.com/br.html           | 0 bottom2   | all on       | top line        | bottom line |
  | http://test.sidrasue.com/entities.html     | 0 bottom2   | Chris was    | Content Removed | Next        |
  | http://test.sidrasue.com/img.html          | 1 bottom3   | content      | top para        | bottom par  |
  | http://test.sidrasue.com/tablecontent.html | 4 bottom6   | I remembered | Jump            | Content     |
  | http://test.sidrasue.com/href.html         | 1 bottom3   | content      | top link        | bottom link |
  | http://test.sidrasue.com/styled.html       | 3 bottom11  | horizontal   | sentence        | end         |

 Scenario Outline: strip top or bottom only
  Given a genre exists with name: "genre"
   When I am on the homepage
    And I fill in "page_url" with "<url>"
    And I fill in "page_title" with "New Title"
    And I select "genre" from "Genre"
    And I press "Store"
    And I follow "Scrub"
  When I check "<nodes>"
    And I press "Scrub"
  Then I should see "<wanted1>"
    And I should see "<wanted2>"
    And I should not see "<unwanted>"

  Examples:
  | url                                        | nodes   | wanted1 | wanted2         | unwanted     |
  | http://test.sidrasue.com/tablecontent.html | 1       | Tall    | Send Feedback   | Irony        |
  | http://test.sidrasue.com/tablecontent.html | bottom9 | Irony   | Return to Text  | to Graphics  |

  Scenario: trim when many headers and short fic
    Given a titled page exists with url: "http://test.sidrasue.com/headers.html"
    When I am on the page's page
      And I follow "Scrub"
      And I check boxes "2"
      And I press "Scrub"
      And I follow "Text" within ".title"
    Then I should see "actual content"
      And I should not see "header"

  Scenario: recover from trimming too much
    Given a titled page exists with url: "http://test.sidrasue.com/headers.html"
    When I am on the page's page
      And I follow "Scrub"
      And I check boxes "0 bottom2"
      And I press "Scrub"
    Then I should not see "actual content"
    When I press "Rebuild from Raw HTML"
    Then I should see "actual content"

  Scenario: trim a parent page
    Given a page exists with title: "Parent", base_url: "http://test.sidrasue.com/parts/*.html", url_substitutions: "1 2"
    And I am on the page's page
    When I follow "Read"
    Then I should see "cruft"
    When I follow "Text" within ".title"
    Then I should see "cruft"
    When I am on the page's page
    And I follow "Scrub" within ".title"
      And I follow "Scrub Part 1"
      And I check boxes "0 bottom2"
      And I press "Scrub"
    Then I should not see "cruft"
      And I should see "stuff for part 1"
    When I follow "Parent" within ".parent"
      And I follow "Text" within ".title"
    Then I should not see "cruft"
      And I should see "stuff for part 1"
      And I should see "stuff for part 2"

  Scenario: trim a sub-part
    Given a titled page exists with urls: "##First Part\nhttp://test.sidrasue.com/parts/1.html###SubPart"
    When I am on the page's page
      And I follow "Scrub"
      And I follow "Scrub First Part"
      And I follow "Scrub SubPart"
      And I check boxes "0 bottom2"
      And I press "Scrub"
    When I am on the homepage
      And I follow "Text" within "#position_1"
    Then I should see "First Part #"
      And I should see "## SubPart ##"
      And I should see "stuff for part 1"
    But I should not see "top cruft"
    And I should not see "bottom cruft"
