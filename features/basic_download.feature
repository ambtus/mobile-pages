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
    Then I should see "#This is a header#"
      And I should see "*Bold*"
      And I should see "_Italic_"
      And I should see "--strike-through--"
      And I should see "1^st 2(nd)"
      And I should see "-----"
