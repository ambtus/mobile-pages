Feature: split a tag into two tags

Scenario: split a tag
  Given "harry/snape" is a "Fandom"
  When I am on the edit tag page for "harry/snape"
    And I fill in "first_tag_name" with "Harry"
    And I fill in "second_tag_name" with "Severus"
    And I press "Split"
    And I am on the filter page
  Then I should be able to select "Harry" from "fandom"
    And I should be able to select "Severus" from "fandom"
    But I should NOT be able to select "harry/snape" from "fandom"
    And I should have 2 tags

Scenario: works with split tags get both
  Given a page exists with fandoms: "harry/snape"
  When I am on the edit tag page for "harry/snape"
    And I fill in "first_tag_name" with "Harry"
    And I fill in "second_tag_name" with "Severus"
    And I press "Split"
    And I am on the first page's page
  Then I should NOT see "harry/snape"
    But I should see "Harry Severus" within ".fandoms"
  When I follow "Harry"
    Then "1 page" should link to "/pages?find=Harry"

Scenario: works with split tags can be found by first
  Given 2 pages exist
    And a page exists with fandoms: "harry/snape"
  When I am on the edit tag page for "harry/snape"
    And I fill in "first_tag_name" with "Harry"
    And I fill in "second_tag_name" with "Severus"
    And I press "Split"
    And I am on the filter page
    And I select "Harry" from "fandom"
    And I press "Find"
  Then I should see "Page 1" within "#position_1"

Scenario: works with split tags can be found by second
  Given 2 pages exist
    And a page exists with fandoms: "harry/snape"
  When I am on the edit tag page for "harry/snape"
    And I fill in "first_tag_name" with "Harry"
    And I fill in "second_tag_name" with "Severus"
    And I press "Split"
    And I am on the filter page
    And I select "Severus" from "fandom"
    And I press "Find"
  Then I should see "Page 1" within "#position_1"

Scenario: splitting tags shows in epub
  Given a page exists with pros: "harry/snape, john/rodney"
  When I am on the edit tag page for "harry/snape"
    And I fill in "first_tag_name" with "Harry"
    And I fill in "second_tag_name" with "Severus"
    And I press "Split"
  Then the download epub command should include tags: "Harry, john/rodney, Severus"

Scenario: can put the name of another tag in as first name
  Given 2 pages exist
    And a page exists with fandoms: "harry" AND title: "first"
    And a page exists with fandoms: "harry/snape" AND title: "both"
  When I am on the edit tag page for "harry/snape"
    And I fill in "first_tag_name" with "Harry"
    And I fill in "second_tag_name" with "Severus"
    And I press "Split"
    And I am on the filter page
    When I select "harry" from "fandom"
    And I press "Find"
  Then I should see "first" within "#position_1"
    And I should see "harry" within "#position_1"
    But I should NOT see "Severus" within "#position_1"
    And I should see "both" within "#position_2"
    And I should see "harry" within "#position_2"
    And I should see "Severus" within "#position_2"
    But I should NOT see "Harry"
    And I should NOT see "harry/snape"

Scenario: can put the name of another tag in as second name
  Given 2 pages exist
    And a page exists with fandoms: "severus" AND title: "first"
    And a page exists with fandoms: "harry/snape" AND title: "both"
  When I am on the edit tag page for "harry/snape"
    And I fill in "first_tag_name" with "Harry"
    And I fill in "second_tag_name" with "Severus"
    And I press "Split"
    And I am on the filter page
    When I select "severus" from "fandom"
    And I press "Find"
  Then I should see "first" within "#position_1"
    And I should see "both" within "#position_2"
    And I should see "severus"
    But I should NOT see "Severus"
    And I should NOT see "snape"

Scenario: can put the name of other tags in as both names
  Given a page exists with fandoms: "harry" AND title: "first"
    And a page exists with fandoms: "severus" AND title: "second"
    And a page exists with fandoms: "harry/snape" AND title: "both"
  When I am on the edit tag page for "harry/snape"
    And I fill in "first_tag_name" with "Severus"
    And I fill in "second_tag_name" with "Harry"
    And I press "Split"
    And I am on the page with title "both"
  Then I should see "harry severus" within ".fandoms"
    And I should NOT see "harry/snape"
    And I should NOT see "Severus"
    And I should NOT see "Harry"

Scenario: can't put the same name in both
  Given "harry/snape" is a "Fandom"
  When I am on the edit tag page for "harry/snape"
    And I fill in "first_tag_name" with "harry"
    And I fill in "second_tag_name" with "harry"
    And I press "Split"
  Then I should see "names must be different"
    And I should have 1 tag
