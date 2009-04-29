Feature: Basic Suggestion for Next page
  what: be presented with the next page
  why: If I just want to read something
  result: read them in order of creation

  Scenario: Read pages in order
    Given the following pages
      | title                           | url                                   |
      | A Christmas Carol               | http://www.rawbw.com/~alice/cc.html   |
      | The Call of the Wild            | http://www.rawbw.com/~alice/cotw.html |
      | The Mysterious Affair at Styles | http://www.rawbw.com/~alice/maas.html |
     When I am on the homepage
     Then I should see "A Christmas Carol" in ".title"
       And I should not see "Marley was dead: to begin with." in ".content"
     When I follow "Read"
     Then I should see "Marley was dead: to begin with." in ".content"
     When I press "Next"
     Then I should see "The Call of the Wild" in ".title"
       And I should see "Buck did not read the newspapers" in ".content"
     When I am on the homepage
     Then I should see "The Call of the Wild" in ".title"
       And I should not see "Buck did not read the newspapers" in ".content"
     When I press "Next"
     Then I should see "The Mysterious Affair at Styles" in ".title"
       And I should not see "The intense interest aroused in the public" in ".content"
      When I follow "Read"
     Then I should see "The Mysterious Affair at Styles" in ".title"
       And I should see "The intense interest aroused in the public" in ".content"
