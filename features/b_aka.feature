Feature: author stuff

  Scenario: add a new author with aka to a page
    Given a page exists
      And I am on the page's page
    When I follow "Authors"
      And I fill in "authors" with "lewis carroll (charles dodgson)"
      And I press "Add Authors"
    Then I should see "lewis carroll (charles dodgson)" within ".authors"
    When I am on the homepage
      And I select "lewis carroll" from "Author"

  Scenario: add an existing author with aka to a page
    Given a page exists
      And an author exists with name: "lewis carroll (charles dodgson)"
    When I am on the page's page
    Then I should not see "lewis carroll" within ".authors"
    When I follow "Authors"
      And I select "lewis carroll" from "page_author_ids_"
      And I press "Update Authors"
    When I am on the page's page
      Then I should see "lewis carroll (charles dodgson)" within ".authors"

  @wip
  Scenario: add an aka to the author name
    Given an author exists with name: "jane"
    When I am on the edit author page for "jane"
    And I fill in "author_name" with "jane (aka)"
    And I press "Update"
    When I am on the homepage
      And I select "jane" from "author"
    Given a page exists
    When I am on the page's page
    And I follow "Authors"
      And I select "jane (aka)" from "page_author_ids_"

  @wip
  Scenario: merge two authors
    Given a page exists with add_author_string: "jane" AND title: "Page 2"
      And a page exists with add_author_string: "aka"
    When I am on the edit tag page for "aka"
      And I select "jane" from "merge"
      And I press "Merge"
    When I am on the page's page
    Then I should see "jane (aka)" within ".authors"
    When I am on the page with title "Page 2"
    Then I should see "jane (aka)" within ".authors"
