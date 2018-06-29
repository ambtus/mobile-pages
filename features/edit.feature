Feature: tools to help audiobook creation

  Scenario: section editing first section and recover from editing too much
    Given a titled page exists with url: "http://test.sidrasue.com/long.html"
    When I am on the page's page
      And I follow "Text"
    Then I should not see "New Content"
      And I follow "1"
      Then I should see "Edit Text 1 for page: page 1"
      And I should see "Lorem ipsum dolor sit amet"
      And I should not see "L0rem ipsum dolor sit amet"
      And I should not see "L9rem ipsum dolor sit amet"
    When I fill in "edited" with "New Content"
      And I press "Preview Text"
      And I should see "Lorem ipsum dolor sit amet" within "#original"
      And I should see "New Content" within "#edited"
      And I should not see "Lorem ipsum dolor sit amet" within "#edited"
    When I press "Confirm Text Edit"
      Then I should see "New Content"
      And I should not see "Lorem ipsum dolor sit amet"
    When I am on the page's page
    When I press "Rebuild from Clean HTML"
    And I follow "HTML" within ".title"
    Then I should see "Lorem ipsum dolor sit amet"
      And I should not see "New Content"


  Scenario: section editing mid section
    Given a titled page exists with url: "http://test.sidrasue.com/long.html"
    When I am on the page's page
      And I follow "Text"
    Then I should not see "New Content"
      And I follow "5"
      Then I should see "Edit Text 5 for page: page 1"
      And I should not see "Lorem ipsum dolor sit amet"
      And I should see "Nulla facilisi. Suspendisse non lectus in nisl varius dapibus."
      And I should not see "L9rem ipsum dolor sit amet"
    When I fill in "edited" with "<p>New Content</p>"
      And I press "Preview Text"
      And I should see "Nulla facilisi. Suspendisse non lectus in nisl varius dapibus." within "#original"
      And I should see "New Content" within "#edited"
      And I should not see "Nulla facilisi. Suspendisse non lectus in nisl varius dapibus." within "#edited"
    When I press "Confirm Text Edit"
      Then I should see "New Content"
      And I should not see "Nulla facilisi. Suspendisse non lectus in nisl varius dapibus."

  Scenario: section editing last section
    Given a titled page exists with url: "http://test.sidrasue.com/long.html"
    When I am on the page's page
      And I follow "Text"
    Then I should not see "New Content"
      And I follow "111"
      Then I should see "Edit Text 111 for page: page 1"
      And I should not see "Lorem ipsum dolor sit amet"
      And I should not see "L0rem ipsum dolor sit amet"
      And I should see "L9rem ipsum dolor sit amet"
    When I fill in "edited" with "<p>New Content</p>"
      And I press "Preview Text"
      And I should see "L9rem ipsum dolor sit amet" within "#original"
      And I should see "New Content" within "#edited"
      And I should not see "L9rem ipsum dolor sit amet" within "#edited"
    When I press "Confirm Text Edit"
      Then I should see "New Content"
      And I should not see "L9rem ipsum dolor sit amet"

