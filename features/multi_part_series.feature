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
    And I press "Increase Type"
    And I refetch the following
      """
      ##Parent1
      ##Parent2
      ##Parent3
      """
    And I follow "Parent2" within "#position_2"
    And I press "Increase Type"
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
    And I press "Increase Type"
    And I refetch the following
      """
      ##Parent1
      ##Parent2
      ##Parent3
      """
    And I follow "Parent2" within "#position_2"
    And I press "Increase Type"
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

Scenario: cannot add a parent to a series
  Given a series exists
  When I am on the page's page
    Then I should NOT see "Add Parent"
