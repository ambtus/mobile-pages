Feature: adding parents and children and siblings

  Scenario: create a new parent for an existing page
    Given a page exists with url: "http://test.sidrasue.com/test.html"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Parent"
      And I press "Update"
    Then I should see "Parent" within ".title"
      And I should see "Page 1" within "#position_1"
    When I follow "Page 1" within "#position_1"
    Then I follow "Parent" within ".parent"

   Scenario: add parent to read part
    Given a page exists with last_read: "2009-01-01"
      And I am on the page's page
   Then I should NOT see "unread" within ".last_read"
   When I follow "Manage Parts"
     And I fill in "add_parent" with "Parent"
     And I press "Update"
   When I am on the homepage
   Then I should see "Parent" within "#position_1"
   Then I should NOT see "unread" within "#position_1"

   Scenario: add parent to unread part
    Given a page exists
      And I am on the page's page
   Then I should see "unread" within ".last_read"
   When I follow "Manage Parts"
     And I fill in "add_parent" with "Parent"
     And I press "Update"
   When I am on the homepage
   Then I should see "Parent" within "#position_1"
   Then I should see "unread" within "#position_1"

  Scenario: can't add a page to an ambiguous parent
    Given I have no pages
    Given a page exists with title: "Ambiguous1"
      And a page exists with title: "Ambiguous2"
      And a page exists with title: "Single"
    When I am on the page with title "Single"
      Then I should see "Single" within ".title"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "Ambiguous"
      And I press "Update"
    Then I should see "More than one page with that title"
      And I should NOT see "Ambiguous" within ".title"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "Ambiguous1"
      And I press "Update"
    Then I should NOT see "Parent with that title has content"
      And I should see "Page added to this parent"

  Scenario: can't add a part to a page with content
    Given a page exists with title: "Styled" AND url: "http://test.sidrasue.com/styled.html"
      And a page exists with title: "Single"
    When I am on the page with title "Single"
      Then I should see "Single" within ".title"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "Styled"
      And I press "Update"
    Then I should see "Parent with that title has content"
      And I should NOT see "Styled" within ".title"

  Scenario: add an existing page to an existing page with parts
    Given I have no pages
    Given a page exists with title: "Single" AND url: "http://test.sidrasue.com/parts/3.html"
    And a page exists with title: "Multi" AND base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1 2"
    When I am on the homepage
    Then I should see "Single"
    And I should see "Multi"
    When I follow "Single"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Multi"
      And I press "Update"
    Then I should see "Page added to this parent"
      And I should see "Part 1"
      And I should see "Part 2"
      And I should see "Single"
    When I am on the homepage
    Then I should see "Multi" within ".title"
    And I should see "Part 1 | Part 2 | Single"
    When I view the content
    Then I should see "stuff for part 1"
      And I should see "stuff for part 2"
      And I should see "stuff for part 3"

  Scenario: add a part to a page with content
    Given a page exists with url: "http://test.sidrasue.com/test.html"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "url_list" with
        """
        http://test.sidrasue.com/test.html
        http://test.sidrasue.com/styled.html
        """
      And I press "Update"
    Then I should see "Page 1" within ".parent"
    When I am on the homepage
      And I follow "Page 1" within "#position_1"
    Then I should see "Part 1" within "#position_1"
      And I should see "Part 2" within "#position_2"

  Scenario: add a new part to an existing page with parts
    Given a page exists with urls: "http://test.sidrasue.com/parts/1.html"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "url_list" with
        """
        http://test.sidrasue.com/parts/1.html
        http://test.sidrasue.com/parts/2.html
        """
      And I press "Update"
    Then I should see "Part 2"
      And I should see "Part 1"
    When I view the content
    Then I should see "stuff for part 1"
      And I should see "stuff for part 2"

  Scenario: remove a part from an existing page with parts
    Given a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1 2 3"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "url_list" with
        """
        http://test.sidrasue.com/parts/1.html
        http://test.sidrasue.com/parts/3.html
        """
      And I press "Update"
      And I should NOT see "Part 3"
      And I view the content
    Then I should see "stuff for part 1"
      But I should NOT see "stuff for part 2"
      And I should see "stuff for part 3"

       Scenario: add a part updates the parent's read_after but add a parent doesn't
    Given a page exists with url: "http://test.sidrasue.com/parts/1.html" AND read_after: "2050-01-01"
      And a page exists with title: "Page 2" AND url: "http://test.sidrasue.com/parts/2.html" AND read_after: "2050-01-02"
    When I am on the homepage
    Then I should see "Page 1" within "#position_1"
      And I should see "Page 2" within "#position_2"
    When I follow "Page 2" within "#position_2"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    When I am on the homepage
    Then I should see "Page 1" within "#position_1"
    When I follow "New Parent" within "#position_2"
      And I follow "Manage Parts"
      And I fill in "url_list" with
        """
        http://test.sidrasue.com/parts/3.html
        http://test.sidrasue.com/parts/4.html
        """
      And I press "Update"
    When I am on the homepage
    Then I should see "New Parent" within "#position_1"
      And I should see "Page 1" within "#position_2"

        Scenario: non-matching last reads
    Given a page exists with urls: "http://test.sidrasue.com/parts/1.html,http://test.sidrasue.com/parts/2.html" AND last_read: "2009-01-01"
    When I am on the page's page
      And I follow "Part 2" within "#position_2"
      And I follow "Rate"
      And I choose "boring"
      And I choose "very sweet"
    And I press "Rate"
   When I am on the page's page
   Then last read should be today
     And I should see "unread" within "#position_1"
     And I should NOT see "2014-" within "#position_2"
     And I should NOT see "unread" within "#position_2"

   Scenario: add unread part to read parent
    Given a page exists with title: "Multi" AND urls: "http://test.sidrasue.com/parts/1.html"
      And I am on the homepage
   Then I should see "Multi" within "#position_1"
   Then I should see "unread" within "#position_1"
   When I follow "Rate"
      And I choose "very interesting"
      And I choose "sweet enough"
    And I press "Rate"
   Then I should NOT see "unread" within "#position_1"
   When I follow "Multi"
     And I follow "Manage Parts"
     And I fill in "url_list" with
       """
       http://test.sidrasue.com/parts/1.html
       http://test.sidrasue.com/parts/2.html
       """
     And I press "Update"
   When I am on the homepage
   Then I should see "Multi" within "#position_1"
     And I should NOT see "unread" within "#position_1"
   When I follow "Multi" within "#position_1"
     And I follow "Part 1" within "#position_1"
   Then I should NOT see "unread" within ".last_read"
   When I am on the homepage
   When I follow "Multi"
     And I follow "Part 2" within "#position_2"
   Then I should see "unread" within ".last_read"

  Scenario: refetch original html for parts
    Given a page exists with urls: "http://test.sidrasue.com/parts/1.html"
    When I am on the page's page
    When I follow "Refetch" within ".edits"
    Then the "url_list" field should contain "http://test.sidrasue.com/parts/1.html"
    When I fill in "url_list" with
      """
      http://test.sidrasue.com/parts/2.html
      http://test.sidrasue.com/parts/1.html
      """
      And I press "Refetch"
    When I view the content
    Then I should see "stuff for part 2"
    And I should see "stuff for part 1"

