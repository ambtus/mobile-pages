Feature: Basic Scrub
  What: select surrounding nodes to discard
  Why: remove the cruft surrounding the content
  Result: see only the content

 Scenario Outline: strip beginning and end
  Given I have no pages
    And I am on the homepage
    And I fill in "page_url" with <url>
    And I fill in "page_title" with "Title"
    And I press "Store"
    And I follow "Scrub"
  When I check boxes <nodes>
    And I press "Scrub"
  Then I should see <wanted>
    And I should not see <unwanted1>
    And I should not see <unwanted2>

  Examples:
  | url                                             | nodes | wanted         | unwanted1         | unwanted2     |
  | "http://www.rawbw.com/~alice/p.html"            | "0 2" | "content"      | "top para"        | "bottom para" |
  | "http://www.rawbw.com/~alice/table.html"        | "0 2" | "content"      | "top para"        | "Row_1_Cell_1"|
  | "http://www.rawbw.com/~alice/br.html"           | "0 2" | "all on"       | "top line"        | "bottom line" |
  | "http://www.rawbw.com/~alice/entities.html"     | "0 2" | "Chris was"    | "Content Removed" | "Next"        |
  | "http://www.rawbw.com/~alice/img.html"          | "1 3" | "content"      | "top para"        | "bottom par"  |
  | "http://www.rawbw.com/~alice/tablecontent.html" | "3 5" | "I remembered" | "Jump"            | "Content"     |
  | "http://www.rawbw.com/~alice/href.html"         | "1 3" | "content"      | "top link"        | "bottom link" |

 Scenario Outline: strip top or bottom only
  Given I have no pages
    And I am on the homepage
    And I fill in "page_url" with <url>
    And I fill in "page_title" with "Title"
    And I press "Store"
    And I follow "Scrub"
  When I check <nodes>
    And I press "Scrub"
  Then I should see <wanted1>
    And I should see <wanted2>
    And I should not see <unwanted>

  Examples:
  | url                                             | nodes | wanted1        | wanted2           | unwanted     |
  | "http://www.rawbw.com/~alice/div.html"          | "1"   | "content"      | "last div"        | "second div"  |
  | "http://www.rawbw.com/~alice/container.html"    | "1"   | "content"      | "content2"        | "second div"  |
  | "http://www.rawbw.com/~alice/p.html"            | "2"   | "content"      | "top para"        | "bottom para" |
  | "http://www.rawbw.com/~alice/tablecontent.html" | "5"   | "I remembered" | "Jump"            | "Content"     |
