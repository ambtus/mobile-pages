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
      And I should see "by Sidra"
      And I should see "Using time-travel"
      And I should not see "Using time-travel" within "#position_1"
      And I should see "giving up on nanowrimo" within "#position_2"

  Scenario: refetch from ao3
    Given a titled page exists
      And I am on the page's page
      And I follow "Refetch" within ".title"
    When I fill in "url" with "http://archiveofourown.org/works/692"
      And I press "Refetch"
    Then I should see "by Sidra"
      And I should see "Using time-travel"
      And I should see "1. Where am I?"
      And I should see "2. Hogwarts"
      And I should see "Time Was, Time Is"

  Scenario: deliberately fetch only one chapter
    Given a genre exists with name: "harry potter"
      And I am on the homepage
    When I fill in "page_url" with "http://archiveofourown.org/works/692/chapters/803"
      And I select "harry potter" from "genre"
      And I press "Store"
    Then I should see "Time Was, Time Is"
      And I should not see "1. Where am I?"
      And I should not see "2. Hogwarts"
      And I should see "by Sidra"
      And I should see "Using time-travel"
      And I should not see "giving up on nanowrimo"

  Scenario: fetch more chapters from ao3
    Given a titled page exists with urls: "http://archiveofourown.org/works/692/chapters/803"
    When I am on the page's page
    When I follow "Refetch" within ".title"
    Then the "url" field should contain "http://archiveofourown.org/works/692"
    When I press "Refetch"
    Then I should see "by Sidra"
      And I should see "Using time-travel"
      And I should see "1. Where am I?"
      And I should see "2. Hogwarts"
      And I should see "Time Was, Time Is"
