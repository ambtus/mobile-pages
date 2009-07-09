Feature: extended parent for existing pages

  Scenario: new parent for an existing page should have last read date
    Given I have no pages
      And the following page
      | title | url | last_read |
      | Single | http://www.rawbw.com/~alice/test.html" | 2008-01-01 |
    When I am on the homepage
    Then I should see "2008-01-01" in ".last_read"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    Then I should see "New Parent" in ".title"
      And I should see "Single" in "#position_1"
      And I should see "2008-01-01" in ".last_read"

  Scenario: new parent for an existing page should have read after date
    Given I have no pages
      And the following pages
      | title | url | read_after |
      | Single | http://www.rawbw.com/~alice/test.html" | 2008-01-01 |
      | Another | http://www.rawbw.com/~alice/entities.html" | 2008-02-01 |
    When I am on the homepage
    Then I should see "Single" in ".title"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    When I am on the homepage
    Then I should see "New Parent" in ".title"

  Scenario: new parent for an existing page should have genre
    Given I have no pages
      And the following page
      | title | url | add_genre_string |
      | Single | http://www.rawbw.com/~alice/test.html" | my genre |
    When I am on the homepage
    When I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    When I am on the homepage
    Then I should see "New Parent" in ".title"
    And I should see "my genre" in ".genres"

  Scenario: new parent for an existing page should have author
    Given I have no pages
      And the following page
      | title | url | add_author_string |
      | Single | http://www.rawbw.com/~alice/test.html" | my author |
    When I am on the homepage
    When I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    When I am on the homepage
    Then I should see "New Parent" in ".title"
    And I should see "my author" in ".authors"
