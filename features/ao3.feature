Feature: ao3 specific stuff

  Scenario: grab stuff
    Given a genre exists with name: "popslash"
      And an author exists with name: "Sidra"
      And I am on the homepage
    When I fill in "page_url" with "http://archiveofourown.org/works/68481"
      And I select "popslash" from "genre"
      And I press "Store"
    Then I should not see "Title can't be blank"
      And I should see "I Drive Myself Crazy" within ".title"
      And I should see "please no crossovers" within ".notes"
      And I should see "randomling" within ".notes"
      And I should see "Sidra" within ".authors"

  Scenario: grab chapters
    Given a genre exists with name: "harry potter"
      And I am on the homepage
    When I fill in "page_url" with "http://archiveofourown.org/works/692"
      And I select "harry potter" from "genre"
      And I press "Store"
    Then I should see "Time Was, Time Is"
      And I should see "1. Where am I?"
      And I should see "2. Hogwarts"
      And I should see "by Sidra" within ".notes"
      And I should see "Using time-travel" within ".notes"
      And I should not see "Using time-travel" within "#position_1"
      And I should see "giving up on nanowrimo" within "#position_2"
