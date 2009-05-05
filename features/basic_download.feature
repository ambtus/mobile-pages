Feature: basic download
  What: create a text version suitable for download to BookZ on the iPhone
  Why: so i can read pages offline
  Result: link to text page

  Scenario: download a text version
    Given I am on the homepage
      And I fill in "page_url" with "http://www.rawbw.com/~alice/styled.html"
      And I fill in "page_title" with "Styled text test"
      And I press "Store"
    When I follow "Download" in ".title"
    Then My document should contain "#This is a header#"
      And My document should contain "*Bold*"
      And My document should contain "_Italic_"
      And My document should contain "==strike-through=="
      And My document should contain "1^st"
      And My document should contain "2(nd)"
      And My document should contain "________________"
      And My document should not contain "div>"
      And My document should not contain "p>"
      And My document should contain "…"

  Scenario: download stripping links
    Given I am on the homepage
      And I fill in "page_url" with "http://www.rawbw.com/~alice/href.html"
      And I fill in "page_title" with "link test"
      And I press "Store"
    When I follow "Download" in ".title"
    Then My document should contain "link_to: top link"
    Then My document should contain "link_to: middle link"
    Then My document should contain "link_to: bottom link"
    
  Scenario: download stripping of javascript and comments
    Given I am on the homepage
      And I fill in "page_url" with "http://www.rawbw.com/~alice/entities.html"
      And I fill in "page_title" with "Javascript test"
      And I press "Store"
    When I follow "Download" in ".title"
    Then My document should not contain "script language="
      And My document should not contain "FILE ARCHIVED"
      And My document should contain "Chris was antsy"

  Scenario: download stripping of tables
    Given I am on the homepage
      And I fill in "page_url" with "http://www.rawbw.com/~alice/tablecontent.html"
      And I fill in "page_title" with "table test"
      And I press "Store"
    When I follow "Download" in ".title"
    Then My document should not contain "<table"
      And My document should not contain "<td"
      And My document should not contain "<tr>"
      And My document should contain "Irony"
      And My document should contain "I remembered waking up"
