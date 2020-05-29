Feature: author stuff

  Scenario: add a new author to a page
    Given a page exists
      And I am on the page's page
    When I want to edit the authors
      And I fill in "authors" with "lewis carroll, charles dodgson"
      And I press "Add Authors"
    Then I should see "lewis carroll" within ".authors"
      And I should see "charles dodgson" within ".authors"
    When I am on the homepage
      And I should be able to select "charles dodgson" from "Author"
      And I should be able to select "lewis carroll" from "Author"

  Scenario: add an existing author to a page
    Given a page exists
      And an author exists with name: "lewis carroll"
    When I am on the page's page
    Then I should not see "lewis carroll" within ".authors"
    When I want to edit the authors
      And I select "lewis carroll" from "page_author_ids_"
      And I press "Update Authors"
    Then I should see "lewis carroll" within ".authors"

  Scenario: add another author to a page
    Given a page exists with add_author_string: "lewis carroll"
    When I am on the page's page
    Then I should see "lewis carroll" within ".authors"
    When I want to edit the authors
      And I fill in "authors" with "charles dodgson"
      And I press "Add Authors"
    Then I should see "charles dodgson & lewis carroll" within ".authors"
    When I am on the homepage
    Then I should be able to select "charles dodgson" from "Author"

  Scenario: new parent for an existing page should have the same author
    Given a page exists with add_author_string: "newbie"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    Then I should see "newbie" within ".authors"
    And I should see "Page 1" within ".parts"
    But I should not see "newbie" within ".parts"

  Scenario: list the authors
    Given an author exists with name: "jane"
      And an author exists with name: "bob"
    When I am on the authors page
    Then I should see "jane"
      And I should see "bob"
    When I follow "jane"
      Then I should see "Edit author: jane"

  Scenario: delete an author
    Given a page exists with add_author_string: "jane"
    When I am on the edit author page for "jane"
    And I follow "Destroy"
    When I press "Yes"
    Then I should have no authors
    When I am on the page's page
      Then I should not see "jane" within ".authors"
      But I should see "by jane" within ".notes"

  Scenario: edit the author name
    Given a page exists with add_author_string: "jane"
    When I am on the edit author page for "jane"
    And I fill in "author_name" with "June"
    And I press "Update"
    When I am on the page's page
      Then I should see "June" within ".authors"

  @wip
  Scenario: add an AKA
    Given a page exists with add_author_string: "jane"
    When I am on the edit author page for "jane"
    And I fill in "author_name" with "jane (june)"
    And I press "Update"
    When I am on the page's page
      Then I should see "jane (june)" within ".authors"
    When I am on the homepage
    Then I should be able to select "jane" from "Author"
    And I should be able to select "june" from "Author"

