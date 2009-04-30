Feature: basic download
  What: create a text version suitable for download to BookZ on the iPhone
  Why: so i can read pages offline
  Result: link to text page

  Scenario: download a text version
    Given I am on the homepage
      And I fill in "page_url" with "http://www.rawbw.com/~alice/styled.html"
      And I fill in "page_title" with "Styled text test"
      And I press "Store"
    When I follow "Styled text test" in ".title"
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
