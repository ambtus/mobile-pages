Feature: ao3 specific stuff

  Scenario: grab single page
    Given a genre exists with name: "popslash"
      And an author exists with name: "Sidra"
      And I am on the homepage
    When I fill in "page_url" with "http://archiveofourown.org/works/68481"
      And I select "popslash" from "genre"
      And I press "Store"
    Then I should not see "Title can't be blank"
      And I should see "I Drive Myself Crazy" within ".title"
      And I should see "please no crossovers" within ".notes"
      And I should not see "Popslash" within ".notes"
      And I should see "AJ/JC" within ".notes"
      And I should see "Make the Yuletide Gay" within ".notes"
      And I should see "Sidra" within ".authors"
      And I should not see "by Sidra" within ".notes"

  Scenario: grab chaptered page
    Given a genre exists with name: "harry potter"
      And I am on the homepage
    When I fill in "page_url" with "http://archiveofourown.org/works/692"
      And I select "harry potter" from "genre"
      And I press "Store"
    Then I should see "Time Was, Time Is"
      And I should see "by Sidra" within ".notes"
      And I should see "Using time-travel" within ".notes"
      And I should see "abandoned, Mary Sue" within ".notes"
      And I should see "Where am I?"
      And I should see "written for nanowrimo" within "#position_1"
      And I should see "giving up on nanowrimo" within "#position_2"
      And I should not see "1" within "#position_1"
      And I should not see "2" within "#position_2"
    When I follow "Hogwarts"
      Then I should not see "by Sidra" within ".notes"
      And I should not see "Using time-travel" within ".notes"
      And I should not see "abandoned" within ".notes"

  Scenario: refetch from ao3 when it used to be somewhere else
    Given a page exists with title: "Counting", url: "https://www.fanfiction.net/s/5853866/1/Counting"
      And I am on the page's page
      # Then I should see "ambtus" # after add grabbing author from fanfiction
      And I should not see "lauriegilbert"
      When I follow "HTML"
      Then I should see "Skip."
    When I am on the page's page
      And I follow "Refetch" within ".title"
    When I fill in "url" with "http://archiveofourown.org/works/688"
      And I press "Refetch"
    Then I should see "by Sidra"
      And I should not see "ambtus"
      And I should see "Skipping Stones"
      And I should see "thanks to lauriegilbert"
      When I follow "HTML"
      Then I should see "Skip."

  Scenario: deliberately fetch only one chapter
    Given a genre exists with name: "harry potter"
      And I am on the homepage
    When I fill in "page_url" with "http://archiveofourown.org/works/692/chapters/803"
      And I select "harry potter" from "genre"
      And I press "Store"
    Then I should see "Where am I?" within ".title"
      And I should see "by Sidra"
      And I should see "Using time-travel"
      And I should not see "Hogwarts"
      And I should not see "giving up on nanowrimo"
      And I should not see "1" within ".title"

  Scenario: fetch more chapters from ao3
    Given a titled page exists with urls: "http://archiveofourown.org/works/692/chapters/803"
    When I am on the page's page
    When I follow "Refetch" within ".title"
    Then the "url" field should contain "http://archiveofourown.org/works/692"
    When I press "Refetch"
    Then I should see "Time Was, Time Is" within ".title"
      And I should see "Using time-travel"
      And I should see "Where am I?" within "#position_1"
      And I should see "Hogwarts" within "#position_2"
      And I should not see "Chapter"
      And I should not see "1" within "#position_1"
      And I should not see "2" within "#position_2"
