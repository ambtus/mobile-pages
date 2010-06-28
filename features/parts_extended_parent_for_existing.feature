Feature: extended parent for existing pages

  Scenario: new parent for an existing page should have last read date
    Given a page exists with title: "Single", last_read: "2008-01-01"
    When I am on the page's page
    Then I should see "2008-01-01" in ".last_read"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    Then I should see "New Parent" in ".title"
      And I should see "Single" in "#position_1"
      And I should see "2008-01-01" in ".last_read"

  Scenario: new parent for an existing page should have read after date
    Given the following pages
      | title   | read_after |
      | Single  | 2008-01-01 |
      | Another | 2008-02-01 |
    When I am on the homepage
    Then I should see "Single" in ".title"
    When I follow "Read"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    When I am on the homepage
    Then I should see "New Parent" in ".title"

  Scenario: new parent for an existing page should have genre
    Given a titled page exists with add_genre_string: "genre"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    When I am on the homepage
    Then I should see "New Parent" in ".title"
    And I should see "genre" in ".genres"

  Scenario: new parent for an existing page should have author
    Given a titled page exists with add_author_string: "author"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    When I am on the homepage
    Then I should see "New Parent" in ".title"
    And I should see "author" in ".authors"
