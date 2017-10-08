Feature: adding parents and children and siblings

  Scenario: create a new parent for an existing page
    Given a page exists with title: "Single", url: "http://test.sidrasue.com/test.html"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Parent"
      And I press "Update"
    Then I should see "Parent" within ".title"
      And I should see "Single" within "#position_1"
    When I follow "Single" within "#position_1"
    Then I follow "Parent" within ".parent"

   Scenario: add parent to read part
    Given a page exists with title: "Part", last_read: "2009-01-01"
      And I am on the page's page
   Then I should not see "unread" within ".last_read"
   When I follow "Manage Parts"
     And I fill in "add_parent" with "Parent"
     And I press "Update"
   When I am on the homepage
   Then I should see "Parent" within "#position_1"
   Then I should not see "unread" within "#position_1"

   Scenario: add parent to unread part
    Given a titled page exists
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
    When I am on the page's page
      Then I should see "Single" within ".title"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "Ambiguous"
      And I press "Update"
    Then I should see "More than one page with that title"
      And I should not see "Ambiguous" within ".title"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "Ambiguous1"
      And I press "Update"
    Then I should not see "Parent with that title has content"
      And I should see "Page added to this parent"

  Scenario: can't add a part to a page with content
    Given a page exists with title: "Styled", url: "http://test.sidrasue.com/styled.html"
      And a page exists with title: "Single"
    When I am on the page's page
      Then I should see "Single" within ".title"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "Styled"
      And I press "Update"
    Then I should see "Parent with that title has content"
      And I should not see "Styled" within ".title"

  Scenario: add an existing page to an existing page with parts
    Given I have no pages
    Given a page exists with title: "Single", url: "http://test.sidrasue.com/parts/3.html"
    And a page exists with title: "Multi", base_url: "http://test.sidrasue.com/parts/*.html", url_substitutions: "1 2"
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
    When I follow "HTML" within ".title"
    Then I should see "stuff for part 1"
      And I should see "stuff for part 2"
      And I should see "stuff for part 3"

  Scenario: add a part to a page with content
    Given a page exists with title: "Single", url: "http://test.sidrasue.com/test.html"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "url_list" with
        """
        http://test.sidrasue.com/test.html
        http://test.sidrasue.com/styled.html
        """
      And I press "Update"
    Then I should see "Single" within ".parent"
    When I am on the homepage
      And I follow "Single" within "#position_1"
    Then I should see "Part 1" within "#position_1"
      And I should see "Part 2" within "#position_2"

  Scenario: add a new part to an existing page with parts
    Given a titled page exists with urls: "http://test.sidrasue.com/parts/1.html"
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
    When I follow "HTML" within ".title"
    Then I should see "stuff for part 1"
      And I should see "stuff for part 2"

  Scenario: remove a part from an existing page with parts
    Given a titled page exists with base_url: "http://test.sidrasue.com/parts/*.html", url_substitutions: "1 2 3"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "url_list" with
        """
        http://test.sidrasue.com/parts/1.html
        http://test.sidrasue.com/parts/3.html
        """
      And I press "Update"
      And I should not see "Part 3"
      And I follow "HTML" within ".title"
    Then I should see "stuff for part 1"
      But I should not see "stuff for part 2"
      And I should see "stuff for part 3"

       Scenario: add a part updates the parent's read_after but add a parent doesn't
    Given a page exists with title: "page 1", url: "http://test.sidrasue.com/parts/1.html", read_after: "2020-01-01"
      And a page exists with title: "page 2", url: "http://test.sidrasue.com/parts/2.html", read_after: "2020-01-02"
    When I am on the homepage
    Then I should see "page 1" within "#position_1"
      And I should see "page 2" within "#position_2"
    When I follow "page 2" within "#position_2"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    When I am on the homepage
    Then I should see "page 1" within "#position_1"
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
      And I should see "page 1" within "#position_2"

        Scenario: non-matching last reads
    Given a titled page exists with urls: "http://test.sidrasue.com/parts/1.html\nhttp://test.sidrasue.com/parts/2.html", last_read: "2009-01-01"
    When I am on the page's page
      And I follow "Part 2" within "#position_2"
      And I follow "Rate"
      And I choose "boring"
      And I choose "very sweet"
    And I press "Rate"
   When I am on the page's page
   Then last read should be today
     And I should see "unread" within "#position_1"
     And I should not see "2014-" within "#position_2"
     And I should not see "unread" within "#position_2"

   Scenario: add unread part to read parent
    Given a page exists with title: "Multi", urls: "http://test.sidrasue.com/parts/1.html"
      And I am on the homepage
   Then I should see "Multi" within "#position_1"
   Then I should see "unread" within ".last_read"
   When I follow "Rate"
      And I choose "very interesting"
      And I choose "sweet enough"
    And I press "Rate"
   Then I should not see "unread" within ".last_read"
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
     And I should not see "unread" within ".last_read"
   When I follow "Multi" within "#position_1"
     And I follow "Part 1" within "#position_1"
   Then I should not see "unread" within ".last_read"
   When I am on the homepage
   When I follow "Multi"
     And I follow "Part 2" within "#position_2"
   Then I should see "unread" within ".last_read"

  Scenario: refetch original html for parts
    Given a titled page exists with urls: "http://test.sidrasue.com/parts/1.html"
    When I am on the page's page
    When I follow "Refetch" within ".title"
    Then the "url_list" field should contain "http://test.sidrasue.com/parts/1.html"
    When I fill in "url_list" with
      """
      http://test.sidrasue.com/parts/2.html
      http://test.sidrasue.com/parts/1.html
      """
      And I press "Refetch"
    When I follow "HTML" within ".title"
    Then I should see "stuff for part 2"
    And I should see "stuff for part 1"
