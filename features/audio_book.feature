Feature: preparation for reading

  Scenario: audiobook link
    Given a page exists with title: "Alice"
    When I am on the page's page
      And I follow "Sectioned"
    Then the download directory should exist for page titled "Alice"
    Then the download html file should exist for page titled "Alice"
    Then the download epub file should not exist for page titled "Alice"

  Scenario: audiobook sections
    Given a titled page exists with url: "http://test.sidrasue.com/long.html"
    When I am on the page's page
      And I follow "Sectioned"
      Then I should see "Lorem ipsum dolor"
      And I should see "READ SLOWLY"
      And I should see "Section 1"
      And I should see "Section 2"

  Scenario: part sections
    When I am on the homepage
      And I follow "Store Multiple"
      And I fill in "page_urls" with
        """
        http://test.sidrasue.com/parts/1.html
        http://test.sidrasue.com/parts/2.html
        """
     And I fill in "page_title" with "Multiple pages from urls"
     And I press "Store"
   When I go to the page with title "Multiple pages from urls"
   Then I should see "Sectioned" within "#position_1"

  Scenario: section editing first section
    Given a titled page exists with url: "http://test.sidrasue.com/long.html"
    When I am on the page's page
      And I follow "Sectioned"
    Then I should not see "New Content"
      And I follow "Section 1"
      Then I should see "Edit Section 1 for page: page 1"
      And I should see "Lorem ipsum dolor sit amet"
      And I should not see "L0rem ipsum dolor sit amet"
      And I should not see "L9rem ipsum dolor sit amet"
    When I fill in "edited" with "<p>New Content</p>"
      And I press "Preview Section"
      And I should see "Lorem ipsum dolor sit amet" within "#original"
      And I should see "New Content" within "#edited"
      And I should not see "Lorem ipsum dolor sit amet" within "#edited"
    When I press "Confirm Section Edit"
      Then I should see "New Content"
      And I should not see "Lorem ipsum dolor sit amet"

  Scenario: section editing mid section
    Given a titled page exists with url: "http://test.sidrasue.com/long.html"
    When I am on the page's page
      And I follow "Sectioned"
    Then I should not see "New Content"
      And I follow "Section 5"
      Then I should see "Edit Section 5 for page: page 1"
      And I should not see "Lorem ipsum dolor sit amet"
      And I should see "L0rem ipsum dolor sit amet"
      And I should not see "L9rem ipsum dolor sit amet"
    When I fill in "edited" with "<p>New Content</p>"
      And I press "Preview Section"
      And I should see "L0rem ipsum dolor sit amet" within "#original"
      And I should see "New Content" within "#edited"
      And I should not see "L0rem ipsum dolor sit amet" within "#edited"
    When I press "Confirm Section Edit"
      Then I should see "New Content"
      And I should not see "L0rem ipsum dolor sit amet"

  Scenario: section editing last section
    Given a titled page exists with url: "http://test.sidrasue.com/long.html"
    When I am on the page's page
      And I follow "Sectioned"
    Then I should not see "New Content"
      And I follow "Section 27"
      Then I should see "Edit Section 27 for page: page 1"
      And I should not see "Lorem ipsum dolor sit amet"
      And I should not see "L0rem ipsum dolor sit amet"
      And I should see "L9rem ipsum dolor sit amet"
    When I fill in "edited" with "<p>New Content</p>"
      And I press "Preview Section"
      And I should see "L9rem ipsum dolor sit amet" within "#original"
      And I should see "New Content" within "#edited"
      And I should not see "L9rem ipsum dolor sit amet" within "#edited"
    When I press "Confirm Section Edit"
      Then I should see "New Content"
      And I should not see "L9rem ipsum dolor sit amet"

  Scenario: hide the page from the reading list
    Given the following pages
      | title  | last_read  | favorite |
      | first  | 2014-01-01 | 2 |
      | second | 2014-02-01 | 2 |
      | third  | 2014-03-01 | 2 |
    When I am on the homepage
    Then I should see "first" within "#position_1"
    And I should not see "favorite"
    And I should not see "audio"
    When I follow "first" within "#position_1"
    And I follow "Sectioned"
    And I press "Audiobook created"
    When I am on the page with title "first"
    Then I should see "audio" within ".hiddens"
    And I should see "favorite" within ".favorite"
    When I am on the homepage
    Then I should not see "first" within "#position_1"
    When I follow "second" within "#position_1"
    And I follow "Sectioned"
    And I press "Audiobook created"
      And I am on the homepage
    Then I should not see "second"
    When I select "audio" from "Hidden"
      And I press "Find"
    Then I should see "first" within "#position_2"
    And I should see "second" within "#position_1"
