Feature: author stuff

  Scenario: add a new author with aka to a page
    Given a page exists
      And I am on the page's page
    When I want to edit the authors
      And I fill in "authors" with "lewis carroll (charles dodgson)"
      And I press "Add Authors"
    Then I should see "lewis carroll (charles dodgson)" within ".authors"
    When I am on the homepage
      And I should be able to select "lewis carroll" from "Author"

  Scenario: add an existing author with aka to a page
    Given a page exists
      And an author exists with name: "lewis carroll (charles dodgson)"
    When I am on the page's page
    Then I should NOT see "lewis carroll" within ".authors"
    When I want to edit the authors
      And I select "lewis carroll" from "page_author_ids_"
      And I press "Update Authors"
    When I am on the page's page
      Then I should see "lewis carroll (charles dodgson)" within ".authors"

  Scenario: add an aka to the author name
    Given an author exists with name: "jane"
    When I am on the edit author page for "jane"
    And I fill in "author_name" with "jane (aka)"
    And I press "Update"
    When I am on the homepage
    Then I should be able to select "jane" from "author"
    But I should NOT be able to select "jane (aka)" from "author"
    Given a page exists
    When I am on the page's page
      And I want to edit the authors
    When I select "jane (aka)" from "page_author_ids_"
      And I press "Update Authors"
    Then I should see "jane (aka)" within ".authors"

  Scenario: merge two authors
    Given I have no pages
    And a page exists with add_author_string: "jane" AND title: "Page 2"
      And a page exists with add_author_string: "aka"
    When I am on the edit author page for "aka"
      And I select "jane" from "merge"
      And I press "Merge"
    When I am on the page's page
    Then I should see "jane (aka)" within ".authors"
    When I am on the page with title "Page 2"
    Then I should see "jane (aka)" within ".authors"
