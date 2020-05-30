Feature: tools to enable onscreen content editing

  Scenario: TODO tag after editing
    Given a page exists with url: "http://test.sidrasue.com/short.html"

  Scenario: section editing first section and recover from editing too much
    Given a page exists with url: "http://test.sidrasue.com/long.html"
    When I am on the page's page
      And I want to edit the text
    Then I should NOT see "New Content"
      And I follow "1"
      Then I should see "Edit Text 1 for page: Page 1"
      And I should see "Lorem ipsum dolor sit amet"
      And I should NOT see "L0rem ipsum dolor sit amet"
      And I should NOT see "L9rem ipsum dolor sit amet"
    When I fill in "edited" with "New Content"
      And I press "Preview Text"
      And I should see "Lorem ipsum dolor sit amet" within "#original"
      And I should see "New Content" within "#edited"
      And I should NOT see "Lorem ipsum dolor sit amet" within "#edited"
    When I press "Confirm Text Edit"
      Then I should see "New Content"
      And I should NOT see "Lorem ipsum dolor sit amet"
    When I am on the page's page
    When I press "Rebuild from Scrubbed HTML"
    And I view the content
    Then I should see "Lorem ipsum dolor sit amet"
      And I should NOT see "New Content"


  Scenario: section editing mid section
    Given a page exists with url: "http://test.sidrasue.com/long.html"
    When I am on the page's page
      And I want to edit the text
    Then I should NOT see "New Content"
      And I follow "5"
      Then I should see "Edit Text 5 for page: Page 1"
      And I should NOT see "Lorem ipsum dolor sit amet"
      And I should see "Nulla facilisi. Suspendisse non lectus in nisl varius dapibus."
      And I should NOT see "L9rem ipsum dolor sit amet"
    When I fill in "edited" with "<p>New Content</p>"
      And I press "Preview Text"
      And I should see "Nulla facilisi. Suspendisse non lectus in nisl varius dapibus." within "#original"
      And I should see "New Content" within "#edited"
      And I should NOT see "Nulla facilisi. Suspendisse non lectus in nisl varius dapibus." within "#edited"
    When I press "Confirm Text Edit"
      Then I should see "New Content"
      And I should NOT see "Nulla facilisi. Suspendisse non lectus in nisl varius dapibus."

  Scenario: section editing last section
    Given a page exists with url: "http://test.sidrasue.com/long.html"
    When I am on the page's page
      And I want to edit the text
    Then I should NOT see "New Content"
      And I follow "111"
      Then I should see "Edit Text 111 for page: Page 1"
      And I should NOT see "Lorem ipsum dolor sit amet"
      And I should NOT see "L0rem ipsum dolor sit amet"
      And I should see "L9rem ipsum dolor sit amet"
    When I fill in "edited" with "<p>New Content</p>"
      And I press "Preview Text"
      And I should see "L9rem ipsum dolor sit amet" within "#original"
      And I should see "New Content" within "#edited"
      And I should NOT see "L9rem ipsum dolor sit amet" within "#edited"
    When I press "Confirm Text Edit"
      Then I should see "New Content"
      And I should NOT see "L9rem ipsum dolor sit amet"

