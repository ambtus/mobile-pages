Feature: tools to enable onscreen content editing

Scenario: should be able to edit html if it's a Single
  Given a page exists with url: "http://test.sidrasue.com/test.html"
  When I am on the page's page
  Then I should see "Page 1 (Single)"
    And I should see "Edit Raw HTML"
    And I should see "Edit Scrubbed HTML"

Scenario: should be able to edit html if it's a Chapter
  Given a page exists with urls: "http://test.sidrasue.com/test.html"
  When I am on the page with title "Part 1"
  Then I should see "Page 1 (Book)" within ".parent"
    And I should see "Edit Raw HTML"
    And I should see "Edit Scrubbed HTML"

Scenario: should NOT be able to edit html if it's a Book
  Given a page exists with urls: "http://test.sidrasue.com/test.html"
  When I am on the page's page
  Then I should see "Page 1 (Book)" within ".title"
    And I should NOT see "Edit Raw HTML"
    And I should NOT see "Edit Scrubbed HTML"

Scenario: check before editing first section
  Given a page exists with url: "http://test.sidrasue.com/long.html"
  When I am on the page's page
    And I want to edit the text
  Then I should see "Lorem ipsum dolor sit amet"
    But I should NOT see "New Content"

Scenario: edit first section
  Given a page exists with url: "http://test.sidrasue.com/long.html"
  When I am on the page's page
    And I want to edit the text
    And I follow "1"
  Then I should see "Edit Text 1 for page: Page 1"
    And I should see "Lorem ipsum dolor sit amet"
    And I should NOT see "L0rem ipsum dolor sit amet"
    And I should NOT see "L9rem ipsum dolor sit amet"

Scenario: preview first section edit
  Given a page exists with url: "http://test.sidrasue.com/long.html"
  When I am on the page's page
    And I want to edit the text
    And I follow "1"
    And I fill in "edited" with "New Content"
    And I press "Preview Text"
  Then I should see "Lorem ipsum dolor sit amet" within "#original"
    And I should see "New Content" within "#edited"
    And I should NOT see "Lorem ipsum dolor sit amet" within "#edited"

Scenario: confirm first section edit
  Given a page exists with url: "http://test.sidrasue.com/long.html"
  When I am on the page's page
    And I want to edit the text
    And I follow "1"
    And I fill in "edited" with "New Content"
    And I press "Preview Text"
    And I press "Confirm Text Edit"
  Then I should see "New Content"
    And I should NOT see "Lorem ipsum dolor sit amet"

Scenario: recover from editing too much of the first section
  Given a page exists with url: "http://test.sidrasue.com/long.html"
  When I am on the page's page
    And I want to edit the text
    And I follow "1"
    And I fill in "edited" with "New Content"
    And I press "Preview Text"
    And I press "Confirm Text Edit"
    And I am on the page's page
    And I press "Rebuild from Raw HTML"
    And I view the content
  Then I should see "Lorem ipsum dolor sit amet"
    And I should NOT see "New Content"

Scenario: check before editing mid section
  Given a page exists with url: "http://test.sidrasue.com/long.html"
  When I am on the page's page
    And I want to edit the text
  Then I should see "Nulla facilisi. Suspendisse non lectus in nisl varius dapibus"
    But I should NOT see "New Content"

Scenario: edit mid section
  Given a page exists with url: "http://test.sidrasue.com/long.html"
  When I am on the page's page
    And I want to edit the text
    And I follow "5"
  Then I should see "Edit Text 5 for page: Page 1"
    And I should NOT see "Lorem ipsum dolor sit amet"
    And I should see "Nulla facilisi. Suspendisse non lectus in nisl varius dapibus"
    And I should NOT see "L9rem ipsum dolor sit amet"

Scenario: preview mid section edit
  Given a page exists with url: "http://test.sidrasue.com/long.html"
  When I am on the page's page
    And I want to edit the text
    And I follow "5"
    And I fill in "edited" with "New Content"
    And I press "Preview Text"
  Then I should see "Nulla facilisi. Suspendisse non lectus in nisl varius dapibus" within "#original"
    And I should see "New Content" within "#edited"
    And I should NOT see "Nulla facilisi. Suspendisse non lectus in nisl varius dapibus" within "#edited"

Scenario: confirm mid section edit
  Given a page exists with url: "http://test.sidrasue.com/long.html"
  When I am on the page's page
    And I want to edit the text
    And I follow "5"
    And I fill in "edited" with "New Content"
    And I press "Preview Text"
    And I press "Confirm Text Edit"
  Then I should see "New Content"
    And I should NOT see "Nulla facilisi. Suspendisse non lectus in nisl varius dapibus"

Scenario: recover from editing too much of the mid section
  Given a page exists with url: "http://test.sidrasue.com/long.html"
  When I am on the page's page
    And I want to edit the text
    And I follow "5"
    And I fill in "edited" with "New Content"
    And I press "Preview Text"
    And I press "Confirm Text Edit"
    And I am on the page's page
    And I press "Rebuild from Raw HTML"
    And I view the content
  Then I should see "Nulla facilisi. Suspendisse non lectus in nisl varius dapibus"
    And I should NOT see "New Content"

Scenario: check before editing last section
  Given a page exists with url: "http://test.sidrasue.com/long.html"
  When I am on the page's page
    And I want to edit the text
  Then I should see "L9rem ipsum dolor sit amet"
    But I should NOT see "New Content"

Scenario: edit last section
  Given a page exists with url: "http://test.sidrasue.com/long.html"
  When I am on the page's page
    And I want to edit the text
    And I follow "111"
  Then I should see "Edit Text 111 for page: Page 1"
    And I should NOT see "Lorem ipsum dolor sit amet"
    And I should NOT see "Nulla facilisi. Suspendisse non lectus in nisl varius dapibus"
    And I should see "L9rem ipsum dolor sit amet"

Scenario: preview last section edit
  Given a page exists with url: "http://test.sidrasue.com/long.html"
  When I am on the page's page
    And I want to edit the text
    And I follow "111"
    And I fill in "edited" with "New Content"
    And I press "Preview Text"
  Then I should see "L9rem ipsum dolor sit amet" within "#original"
    And I should see "New Content" within "#edited"
    And I should NOT see "L9rem ipsum dolor sit amet" within "#edited"

Scenario: confirm last section edit
  Given a page exists with url: "http://test.sidrasue.com/long.html"
  When I am on the page's page
    And I want to edit the text
    And I follow "111"
    And I fill in "edited" with "New Content"
    And I press "Preview Text"
    And I press "Confirm Text Edit"
  Then I should see "New Content"
    And I should NOT see "L9rem ipsum dolor sit amet"

Scenario: recover from editing too much of the last section
  Given a page exists with url: "http://test.sidrasue.com/long.html"
  When I am on the page's page
    And I want to edit the text
    And I follow "111"
    And I fill in "edited" with "New Content"
    And I press "Preview Text"
    And I press "Confirm Text Edit"
    And I am on the page's page
    And I press "Rebuild from Raw HTML"
    And I view the content
  Then I should see "L9rem ipsum dolor sit amet"
    And I should NOT see "New Content"

