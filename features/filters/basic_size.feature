Feature: basic filters on size
  What: be able filter on a size
  Why: sometimes I am in the mood for something long or short
  Result: be offered the next page of a specific size

  Scenario: filter on a genre
    Given the following pages
      | title  | url                                   |
      | Medium | http://test.sidrasue.com/medium.html  | 
      | Short  | http://test.sidrasue.com/short.html   | 
      | Long   | http://test.sidrasue.com/long.html    | 
      | Long2  | http://test.sidrasue.com/long2.html   | 
    When I am on the homepage
    Then I should see "Medium" in ".title"
    When I select "short"
      And I press "Filter"
    Then I should see "Short" in ".title"
    When I select "long"
      And I press "Filter"
    Then I should see "Long" in ".title"
    When I press "Read Later"
    Then I should see "Long2" in ".title"


