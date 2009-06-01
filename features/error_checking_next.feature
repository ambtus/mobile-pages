Feature: next bugs

  Scenario: create and read a page from base url plus pattern
    Given I have no pages
      And the following page
      | title         | url                                    |
      | Single Text   | http://www.rawbw.com/~alice/test.html  |
      | First Part |  http://www.rawbw.com/~alice/parts/1.html |
      And I am on the homepage
    Then I should see "Single Text" in ".title"
     When I press "Next"
    Then I should see "First Part" in ".title"
    When I follow "Manage Parts"
     And I fill in "add_parent" with "New Parent"
     And I press "Update"
    Then I should see "New Parent" in ".title"
     When I press "Next"
    Then I should see "Single Text" in ".title"
     When I press "Next"
    Then I should see "New Parent" in ".title"
