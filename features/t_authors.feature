Feature: author stuff

Scenario: add authors to a page
  Given a page exists
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "lewis carroll, charles dodgson"
    And I press "Add Author Tags"
  Then I should see "lewis carroll" within ".authors"
    And I should see "charles dodgson" within ".authors"

Scenario: create authors by adding them to a page
  Given a page exists
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "lewis carroll, charles dodgson"
    And I press "Add Author Tags"
    And I am on the filter page
  Then I should be able to select "charles dodgson" from "Author"
    And I should be able to select "lewis carroll" from "Author"

Scenario: add an existing author to a page
  Given a page exists
    And "lewis carroll" is an "Author"
  When I am on the page's page
    And I edit its tags
    And I select "lewis carroll" from "page_author_ids_"
    And I press "Update Tags"
  Then I should see "lewis carroll" within ".authors"

Scenario: add another author to a page
  Given a page exists with authors: "lewis carroll"
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "charles dodgson"
    And I press "Add Author Tags"
  Then I should see "charles dodgson lewis carroll" within ".authors"

Scenario: add another author to a page
  Given a page exists with authors: "lewis carroll"
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "charles dodgson"
    And I press "Add Author Tags"
    And I am on the filter page
  Then I should be able to select "charles dodgson" from "Author"

Scenario: list the authors
  Given "jane" is an "Author"
    And "bob" is an "Author"
  When I am on the authors page
  Then I should see "jane"
    And I should see "bob"
  When I follow "edit jane"
    Then I should see "Edit tag: jane"

Scenario: edit an author
  Given "jane" is an "Author"
  When I am on the authors page
    And I follow "edit jane"
  Then I should see "Edit tag: jane"

Scenario: edit the author name
  Given a page exists with authors: "jane"
  When I am on the edit tag page for "jane"
    And I fill in "tag_name" with "June"
    And I press "Update"
    And I am on the page's page
  Then I should see "June" within ".authors"
    But I should NOT see "jane" within ".authors"

Scenario: edit the author name
  Given a page exists with authors: "jane"
  When I am on the edit tag page for "jane"
    And I fill in "tag_name" with "June"
    And I press "Update"
    And I am on the filter page
  Then I should be able to select "June" from "Author"
    But I should NOT be able to select "jane" from "Author"

Scenario: delete an author
  Given a page exists with authors: "jane"
  When I am on the edit tag page for "jane"
    And I follow "Destroy"
    And I press "Yes"
  Then I should have no authors

Scenario: delete an author
  Given a page exists with authors: "jane"
  When I am on the edit tag page for "jane"
    And I follow "Destroy"
    And I press "Yes"
    And I am on the page's page
  Then I should NOT see "jane" within ".authors"
    But I should see "by jane" within ".notes"
