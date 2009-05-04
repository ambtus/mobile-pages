Feature: Basic Scrub
  What: select surrounding nodes to discard
  Why: remove the cruft surrounding the content
  Result: see only the content

 Scenario Outline: nodes
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
  | url                                      | nodes | wanted    | unwanted1      | unwanted2     |
  | "http://www.rawbw.com/~alice/div.html"   | "0 1" | "content" | "first div"    | "second div"  |
  | "http://www.rawbw.com/~alice/p.html"     | "0 2" | "content" | "top para"     | "bottom para" |
  | "http://www.rawbw.com/~alice/img.html"   | "1 2" | "content" | "bottom img"   | "bottom para" |
  | "http://www.rawbw.com/~alice/table.html" | "1 3" | "content" | "middle table" | "bottom para" |
  | "http://www.rawbw.com/~alice/href.html"  | "0 3" | "content" | "top link"     | "bottom link" |
  | "http://www.rawbw.com/~alice/br.html"    | "0 2" | "all on" | "top line"     | "bottom line" |
