Feature: Basic Scrub
  What: select surrounding nodes to discard
  Why: remove the cruft surrounding the content
  Result: see only the content

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
