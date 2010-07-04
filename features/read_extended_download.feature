Feature: extended download

  Scenario: make multi (more than two) line breaks visible
    Given a titled page exists with url: "http://test.sidrasue.com/breaks.html"
    When I am on the homepage
      And I follow "Text" within ".title"
    Then I should see "__________"

  Scenario: download pml file
    Given a titled page exists with url: "http://test.sidrasue.com/test.html"
    When I am on the homepage
      And I follow "PML" within ".title"
#    Then I should see "\v"

  Scenario: hide pdb link if non-existent
    Given a titled page exists with url: "http://test.sidrasue.com/test.html"
    When I am on the homepage
      Then I should not see "eReader"
