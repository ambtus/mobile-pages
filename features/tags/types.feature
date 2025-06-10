Feature: many types of tag

Scenario: no tags
  Given I am on the tags page
  Then I should see "0 Fandoms"
    And I should see "0 Authors"
    And I should see "0 Pros"
    And I should see "0 Cons"
    And I should see "0 Hiddens"
    And I should see "0 Readers"
    And I should see "0 Infos"
    And I should see "0 Collections"

Scenario: fandom tags
  Given a page exists with fandoms: "bad"
    And a page exists with fandoms: "good"
    And a page exists with fandoms: "great"
    And a page exists with fandoms: "good"
    And a page exists with fandoms: "great"
    And a page exists with fandoms: "great"
  When I am on the tags page
    And I follow "3 Fandoms"
  Then I should see "great" before "good"
    And I should see "good" before "bad"

 
