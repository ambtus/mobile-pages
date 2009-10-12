Feature: extended download

  Scenario: make multi (more than two) line breaks visible
    Given the following page
      | title | url | 
      | title | http://sidrasue.com/tests/breaks.html | 
    When I am on the homepage
      And I follow "Download" in ".title"
    Then my document should contain "__________"
