Feature: ratings are a type of tag, and can be created and selected like tags

  Scenario: strip rating whitespace and sort
    Given a page exists
    When I am on the page's page
      And I edit its tags
      And I fill in "tags" with "  interesting,  sweet,confusing  "
      And I press "Add Rating Tags"
    Then I should see "confusing, interesting, sweet" within ".ratings"

  Scenario: no tags exist during create
    Given I am on the homepage
      And I have no pages
      And I have no tags
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should see "Page created with Other Fandom"
    When I edit its tags
      And I fill in "tags" with "interesting"
      And I press "Add Rating Tags"
    Then I should see "interesting" within ".ratings"

  Scenario: no tags selected during create
    Given a tag exists with name: "first" AND type: "Rating"
      And I am on the homepage
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should see "Page created with Other Fandom"
    When I edit its tags
      And I select "first" from "page_rating_ids_"
      And I press "Update Tags"
    Then I should see "first" within ".ratings"

  Scenario: rating and fandom selected during create
    Given a tag exists with name: "first" AND type: "Fandom"
      And a tag exists with name: "second" AND type: "Rating"
      And I am on the homepage
      And I select "first" from "fandom"
      And I select "second" from "rating"
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should NOT see "Please select fandom"
      And I should see "first" within ".fandoms"
      And I should see "second" within ".ratings"

  Scenario: rating only selected during create
    Given a tag exists with name: "sweet" AND type: "Rating"
      And I am on the homepage
      And I select "sweet" from "rating"
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should see "Page created with Other Fandom"
      And I should see "sweet" within ".ratings"

  Scenario: add a rating to a page when there are no ratings
    Given a page exists
    When I am on the page's page
      And I edit its tags
    When I fill in "tags" with "sweet, interesting"
      And I press "Add Rating Tags"
    Then I should see "interesting, sweet" within ".ratings"
    When I am on the homepage
    Then I should be able to select "sweet" from "Rating"
    Then I should be able to select "interesting" from "Rating"

  Scenario: select a rating for a page when there are ratings
    Given a tag exists with name: "cute" AND type: "Rating"
    And a page exists
    When I am on the page's page
      And I edit its tags
      And I select "cute" from "page_rating_ids_"
      And I press "Update Tags"
    Then I should see "cute" within ".ratings"

  Scenario: add a rating to a page which already has ratings
    Given I have no pages
    And a page exists with ratings: "funny"
    When I am on the page's page
    Then I should see "funny" within ".ratings"
    When I edit its tags
      And I fill in "tags" with "loved, cute"
      And I press "Add Rating Tags"
    Then I should see "cute, funny, loved" within ".ratings"
    When I am on the homepage
    Then I should be able to select "funny" from "Rating"
      And I should be able to select "cute" from "Rating"
      And I should be able to select "loved" from "Rating"

   Scenario: new parent for an existing page should have the same rating
    Given I have no pages
    And a page exists with ratings: "loved"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    When I am on the page with title "New Parent"
    Then I should see "loved" within ".ratings"
      And I should NOT see "(loved)" within "#position_1"
    When I am on the homepage
      Then I should see "New Parent" within "#position_1"
    And I should see "loved" within ".tags"

 Scenario: list the ratings
    Given a tag exists
    Given a tag exists with name: "funny" AND type: "Rating"
    When I am on the tags page
    Then I should see "Tag 1"
      And I should see "funny"
    When I follow "funny"
      Then I should see "Edit tag: funny"

  Scenario: edit the rating name
    Given I have no tags
    And a tag exists with name: "funny" AND type: "Rating"
    When I am on the homepage
      Then I should be able to select "funny" from "rating"
    When I am on the edit tag page for "funny"
    And I fill in "tag_name" with "cute"
    And I press "Update"
    When I am on the homepage
      And I should be able to select "cute" from "rating"
      But I should NOT be able to select "funny" from "rating"

  Scenario: delete a rating
    Given a page exists with ratings: "interesting"
    When I am on the edit tag page for "interesting"
    And I follow "Destroy"
    When I press "Yes"
    Then I should have no ratings
    When I am on the homepage
      Then I should NOT see "interesting"
      But I should see "Page 1"

  Scenario: merge two tags
    Given I have no pages
    And a tag exists with name: "cute" AND type: "Rating"
      And a page exists with ratings: "funny"
    When I am on the edit tag page for "funny"
      And I select "cute" from "merge"
      And I press "Merge"
    When I am on the page's page
    Then I should NOT see "funny"
    And I should see "cute" within ".ratings"

  Scenario: don’t allow merge if not the same type
    Given a tag exists with name: "not rating"
    Given a tag exists with name: "funny" AND type: "Rating"
    When I am on the edit tag page for "funny"
      Then I should NOT see "not rating"
      And I should NOT see "Merge"

  Scenario: change rating to fandom tag
    Given I have no pages
    And a page exists with ratings: "Harry Potter"
    When I am on the page's page
      Then I should see "Harry Potter" within ".ratings"
    When I am on the edit tag page for "Harry Potter"
      And I select "Fandom" from "change"
      And I press "Change"
    When I am on the page's page
      Then I should see "Harry Potter" within ".fandoms"
      And the page should NOT have any rating tags
    When I am on the homepage
      Then I should be able to select "Harry Potter" from "fandom"
      But I should NOT be able to select "Harry Potter" from "rating"

  Scenario: change trope to rating tag
    Given I have no pages
    And a page exists with tropes: "cute"
    When I am on the page's page
      Then I should see "cute" within ".tags"
    When I am on the edit tag page for "cute"
      And I select "Rating" from "change"
      And I press "Change"
    When I am on the page's page
      Then I should see "cute" within ".ratings"
      And the page should NOT have any not rating tags
    When I am on the homepage
      Then I should be able to select "cute" from "rating"
      But I should NOT be able to select "cute" from "tag"

