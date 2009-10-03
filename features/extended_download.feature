Feature: extended download

  Scenario: make multi (more than two) line breaks visible
    Given I have no pages
      And I am on the homepage
      And I fill in "page_url" with "http://sidrasue.com/tests/breaks.html"
      And I fill in "page_title" with "multi line breaks test"
      And I press "Store"
      And I follow "Download" in ".title"
      And My document should contain "__________"
