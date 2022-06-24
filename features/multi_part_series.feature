Feature: third level hierarchy

Scenario: create Series from Singles & Books
  Given I have Books with titles "First" and "Third"
    And I have a Single with title "Second" and url "http://test.sidrasue.com/parts/3.html"
  When I am on the "Store Multiple" page
  When I fill in "page_urls" with
    """
    ##First
    ##Second
    ##Third
    """
    And I fill in "page_title" with "Trilogy"
    And I press "Store"
  Then I should see "Trilogy (Series)" within ".title"
    And I should see "First" within "#position_1"
    And I should see "2 parts" within "#position_1"
    And I should see "Second" within "#position_2"
    And "Original" should link to "http://test.sidrasue.com/parts/3.html"
    And I should NOT see "parts" within "#position_2"
    And I should see "Third" within "#position_3"
    And I should see "3 parts" within "#position_3"

Scenario: create collection by adding parent to parent to parent
  Given a page exists
  When I am on the page's page
    And I add a parent with title "Parent"
    And I add a parent with title "Grandparent"
    And I add a parent with title "Great-Grandparent"
    And I read "Great-Grandparent" online
  Then the page should have title "Great-Grandparent"
    And I should see "Great-Grandparent" within "h1"
    And I should see "1. Grandparent" within "h2"
    And I should see "1. Parent" within "h3"
    And I should see "Page 1" within "h4"

Scenario: create by adding parents to a single and a book
  Given a page exists with title: "Parent" AND urls: "http://test.sidrasue.com/parts/2.html,http://test.sidrasue.com/parts/3.html"
    And a page exists with title: "Single" AND url: "http://test.sidrasue.com/parts/1.html"
  When I am on the page with title "Parent"
    And I add a parent with title "Grandparent"
    And I am on the page with title "Single"
    And I add a parent with title "Grandparent"
    And I am on the page with title "Grandparent"
  Then I should see "Grandparent (Series)" within ".title"
    And I should see "Parent" within "#position_1"
    And I should see "2 parts" within "#position_1"
    And I should see "Single" within "#position_2"
    And "Original" should link to "http://test.sidrasue.com/parts/1.html"
    And I should NOT see "parts" within "#position_2"

Scenario: create book by adding parts
  Given a page exists
    And three singles exist
  When I am on the page's page
    And I refetch the following
      """
      ##Parent1
      ##Parent2
      ##Parent3
      """
    And I follow "Parent2" within "#position_2"
    And I refetch the following
      """
      http://test.sidrasue.com/parts/3.html
      http://test.sidrasue.com/parts/4.html
      """
  Then I should see "Parent2 (Book)" within ".title"
    And I should see "Part 1" within "#position_1"
    And I should see "Part 2" within "#position_2"

Scenario: create series by adding subparts to book
  Given a page exists
    And three singles exist
  When I am on the page's page
    And I refetch the following
      """
      ##Parent1
      ##Parent2
      ##Parent3
      """
    And I follow "Parent2" within "#position_2"
    And I refetch the following
      """
      http://test.sidrasue.com/parts/3.html
      http://test.sidrasue.com/parts/4.html
      """
    And I am on the page's page
  Then I should see "Page 1 (Series)" within ".title"
    And I should see "Parent1" within "#position_1"
    And I should NOT see "parts" within "#position_1"
    And I should see "Parent2" within "#position_2"
    And I should see "2 parts" within "#position_2"
    And I should see "Parent3" within "#position_3"
    And I should NOT see "parts" within "#position_3"

Scenario: rating a single unread child sets parent AND grandparent to read
  Given a page exists with title: "Parent" AND urls: "http://test.sidrasue.com/parts/1.html" AND last_read: "2009-01-01"
  When I am on the page with title "Parent"
    And I add a parent with title "Grandparent"
    And I am on the page with title "Parent"
    And I follow "Add Part"
    And I fill in "add_url" with "http://test.sidrasue.com/parts/2.html"
    And I press "Add"
    And I am on the page with title "Part 2"
    And I follow "Rate"
    And I click on "3"
    And I press "Rate"
    And I am on the page with title "Grandparent"
  Then I should NOT see "unread"
    But I should see "2009-01-01"
