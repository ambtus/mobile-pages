Feature: split a tag into two tags

  Scenario: split a tag
    Given a tag exists with name: "harry/snape"
    When I am on the homepage
      Then I should be able to select "harry/snape" from "tag"
    When I am on the edit tag page for "harry/snape"
      And I fill in "first_tag_name" with "Harry"
      And I fill in "second_tag_name" with "Severus"
      And I press "Split"
    When I am on the homepage
      Then I should be able to select "Harry" from "tag"
      And I should be able to select "Severus" from "tag"
      But I should NOT be able to select "harry/snape" from "tag"

  Scenario: works with split tags get both
    Given I have no pages
      And I have no tags
      And a page exists with characters: "harry/snape"
    When I am on the homepage
      Then I should see "harry/snape" within "#position_1"
    When I am on the edit tag page for "harry/snape"
      And I fill in "first_tag_name" with "Harry"
      And I fill in "second_tag_name" with "Severus"
      And I press "Split"
    When I am on the homepage
      Then I should see "Harry, Severus" within "#position_1"
    When I am on the page's page
    Then I should NOT see "harry/snape"
    And I should see "Harry Severus" within ".characters"

  Scenario: works with split tags can be found by either
    Given I have no pages
      And I have no tags
      And a page exists with characters: "harry/snape"
    When I am on the homepage
      Then I should see "harry/snape" within "#position_1"
    When I am on the edit tag page for "harry/snape"
      And I fill in "first_tag_name" with "Harry"
      And I fill in "second_tag_name" with "Severus"
      And I press "Split"
    When I am on the homepage
      When I select "Harry" from "character"
      And I press "Find"
      Then I should see "Page 1" within "#position_1"
    When I am on the homepage
      When I select "Severus" from "character"
      And I press "Find"
      Then I should see "Page 1" within "#position_1"

  Scenario: splitting tags shows in epub
    Given I have no pages
      And a page exists with characters: "harry/snape, john/rodney"
    Then the download epub command should include tags: "harry/snape, john/rodney"
     When I am on the edit tag page for "harry/snape"
      And I fill in "first_tag_name" with "Harry"
      And I fill in "second_tag_name" with "Severus"
      And I press "Split"
    Then the download epub command should include tags: "Harry, john/rodney, Severus"

  Scenario: can put the name of another tag in as first name
    Given I have no pages
    And I have no tags
      And a page exists with characters: "harry" AND title: "one"
      And a page exists with characters: "harry/snape" AND title: "both"
    When I am on the edit tag page for "harry/snape"
      And I fill in "first_tag_name" with "Harry"
      And I fill in "second_tag_name" with "Severus"
      And I press "Split"
    When I am on the homepage
      When I select "harry" from "character"
      And I press "Find"
      Then I should see "one" within "#position_1"
     And I should see "both" within "#position_2"
    When I am on the homepage
      When I select "Severus" from "character"
      And I press "Find"
      Then I should see "both" within "#position_1"

  Scenario: can put the name of another tag in as second name
    Given I have no pages
    And I have no tags
      And a page exists with characters: "harry" AND title: "one"
      And a page exists with characters: "harry/snape" AND title: "both"
    When I am on the edit tag page for "harry/snape"
      And I fill in "first_tag_name" with "Severus"
      And I fill in "second_tag_name" with "Harry"
      And I press "Split"
    When I am on the homepage
      When I select "harry" from "character"
      And I press "Find"
      Then I should see "one" within "#position_1"
     And I should see "both" within "#position_2"
    When I am on the homepage
      When I select "Severus" from "character"
      And I press "Find"
      Then I should see "both" within "#position_1"

  Scenario: can put the name of other tags in as both names
    Given I have no pages
    And I have no tags
      And a page exists with characters: "harry" AND title: "one"
      And a page exists with characters: "severus" AND title: "other"
      And a page exists with characters: "harry/snape" AND title: "both"
    When I am on the edit tag page for "harry/snape"
      And I fill in "first_tag_name" with "Severus"
      And I fill in "second_tag_name" with "Harry"
      And I press "Split"
    When I am on the homepage
    Then I should NOT be able to select "harry/snape" from "character"
    When I select "harry" from "character"
      And I press "Find"
    Then I should see "one" within "#position_1"
      And I should see "both" within "#position_2"
      And I should see "harry, severus" within "#position_2"
    And I should NOT see "harry/snape"
    When I am on the homepage
      And I select "severus" from "character"
      And I press "Find"
    Then I should see "other" within "#position_1"
      And I should see "both" within "#position_2"
    When I follow "both"
      Then I should see "harry severus" within ".characters"
      And I should NOT see "harry/snape"

  Scenario: can't put the same name in both
    And a tag exists with name: "harry/snape"
    When I am on the edit tag page for "harry/snape"
      And I press "Split"
    Then I should see "names must be different"
