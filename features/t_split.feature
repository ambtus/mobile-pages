Feature: split a tag into two tags

Scenario: split a tag
  Given "harry/snape" is a tag
  When I am on the edit tag page for "harry/snape"
    And I fill in "first_tag_name" with "Harry"
    And I fill in "second_tag_name" with "Severus"
    And I press "Split"
    And I am on the homepage
  Then I should be able to select "Harry" from "tag"
    And I should be able to select "Severus" from "tag"
    But I should NOT be able to select "harry/snape" from "tag"
    And I should have 2 tags

Scenario: works with split tags get both
  Given a page exists with characters: "harry/snape"
  When I am on the edit tag page for "harry/snape"
    And I fill in "first_tag_name" with "Harry"
    And I fill in "second_tag_name" with "Severus"
    And I press "Split"
    And I am on the page's page
  Then I should NOT see "harry/snape"
    But I should see "Harry Severus" within ".characters"
    And "Harry" should link to "/pages?character=Harry"

Scenario: works with split tags can be found by first
  Given 2 pages exist
    And a page exists with characters: "harry/snape"
  When I am on the edit tag page for "harry/snape"
    And I fill in "first_tag_name" with "Harry"
    And I fill in "second_tag_name" with "Severus"
    And I press "Split"
    And I am on the homepage
    And I select "Harry" from "character"
    And I press "Find"
  Then I should see "Page 1" within "#position_1"

Scenario: works with split tags can be found by second
  Given 2 pages exist
    And a page exists with characters: "harry/snape"
  When I am on the edit tag page for "harry/snape"
    And I fill in "first_tag_name" with "Harry"
    And I fill in "second_tag_name" with "Severus"
    And I press "Split"
    And I am on the homepage
    And I select "Severus" from "character"
    And I press "Find"
    Then I should see "Page 1" within "#position_1"

Scenario: splitting tags shows in epub
  Given a page exists with characters: "harry/snape, john/rodney"
  When I am on the edit tag page for "harry/snape"
    And I fill in "first_tag_name" with "Harry"
    And I fill in "second_tag_name" with "Severus"
    And I press "Split"
  Then the download epub command should include tags: "Harry, john/rodney, Severus"

Scenario: can put the name of another tag in as first name
  Given 2 pages exist
    And a page exists with characters: "harry" AND title: "first"
    And a page exists with characters: "harry/snape" AND title: "both"
  When I am on the edit tag page for "harry/snape"
    And I fill in "first_tag_name" with "Harry"
    And I fill in "second_tag_name" with "Severus"
    And I press "Split"
    And I am on the homepage
    When I select "harry" from "character"
    And I press "Find"
  Then I should see "first" within "#position_1"
    And I should see "both" within "#position_2"
    And I should see "harry"
    But I should NOT see "Harry"

Scenario: can put the name of another tag in as second name
  Given 2 pages exist
    And a page exists with characters: "severus" AND title: "first"
    And a page exists with characters: "harry/snape" AND title: "both"
  When I am on the edit tag page for "harry/snape"
    And I fill in "first_tag_name" with "Harry"
    And I fill in "second_tag_name" with "Severus"
    And I press "Split"
    And I am on the homepage
    When I select "severus" from "character"
    And I press "Find"
  Then I should see "first" within "#position_1"
    And I should see "both" within "#position_2"
    And I should see "severus"
    But I should NOT see "Severus"
    And I should NOT see "snape"

Scenario: can put the name of other tags in as both names
  Given a page exists with characters: "harry" AND title: "first"
    And a page exists with characters: "severus" AND title: "second"
    And a page exists with characters: "harry/snape" AND title: "both"
  When I am on the edit tag page for "harry/snape"
    And I fill in "first_tag_name" with "Severus"
    And I fill in "second_tag_name" with "Harry"
    And I press "Split"
  When I am on the page with title "both"
    Then I should see "harry severus" within ".characters"
    And I should NOT see "harry/snape"
    And I should NOT see "Severus"
    And I should NOT see "Harry"

Scenario: can't put the same name in both
  Given "harry/snape" is a tag
  When I am on the edit tag page for "harry/snape"
    And I fill in "first_tag_name" with "harry"
    And I fill in "second_tag_name" with "harry"
    And I press "Split"
  Then I should see "names must be different"
    And I should have 1 tag
