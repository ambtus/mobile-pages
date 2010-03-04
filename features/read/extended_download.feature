Feature: extended download

  Scenario: make multi (more than two) line breaks visible
    Given a titled page exists with url: "http://test.sidrasue.com/breaks.html"
    When I am on the homepage
      And I follow "Text" in ".title"
    Then I should see "__________"

  Scenario: download pml file
    Given a titled page exists with url: "http://test.sidrasue.com/test.html"
    When I am on the homepage
      And I follow "pml" in ".title"
    Then I should see "\v"
