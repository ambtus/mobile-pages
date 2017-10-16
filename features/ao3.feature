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
      And I should see "1. Where am I?" within "#position_1"
      And I should see "2. Hogwarts" within "#position_2"
    When I follow "2. Hogwarts"
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
      And I should not see "1." within ".title"
      And I should see "by Sidra"
      And I should see "Using time-travel"
      And I should not see "Hogwarts"
      And I should not see "giving up on nanowrimo"

  Scenario: refetch one chapter from ao3
    Given a genre exists with name: "harry potter"
      And I am on the homepage
    When I fill in "page_url" with "http://archiveofourown.org/works/692/chapters/803"
      And I select "harry potter" from "genre"
      And I press "Store"
      And I follow "Notes"
      And I fill in "page_notes" with "changed notes"
      And I press "Update"
    Then I should see "changed notes" within ".notes"
      And I should not see "by Sidra" within ".notes"
    And I follow "Edit Scrubbed HTML"
      And I fill in "pasted" with "oops"
      And I press "Update Scrubbed HTML"
      And I follow "HTML"
    Then I should see "oops"
      And I should not see "Amy woke slowly"
    When I go back
      And I follow "Refetch"
      Then the "url" field should contain "http://archiveofourown.org/works/692/chapters/803"
    When I press "Refetch"
      Then I should see "Where am I?" within ".title"
      And I should not see "1."
      And I should see "by Sidra" within ".notes"
      And I should not see "changed notes" within ".notes"
      When I follow "HTML"
      Then I should not see "oops"
      And I should see "Amy woke slowly"

  Scenario: fetch more chapters from ao3
    Given a genre exists with name: "harry potter"
      And I am on the homepage
    When I fill in "page_url" with "http://archiveofourown.org/works/692/chapters/803"
      And I select "harry potter" from "genre"
      And I press "Store"
    When I follow "Manage Parts"
     And I fill in "add_parent" with "Parent"
     And I press "Update"
     And I follow "Refetch" within ".title"
    Then the "url" field should contain "http://archiveofourown.org/works/692"
    When I press "Refetch"
    Then I should see "Time Was, Time Is" within ".title"
      And I should see "Using time-travel"
      And I should see "2. Hogwarts" within "#position_2"
      And I should see "Where am I?" within "#position_1"
      And I should not see "1. " within "#position_1"
        # This is not a bug. See following feature.
        # It's better to have to refetch a chapter that you want to update the chapter title of
        # Than to have the chapter titles updated even if you don't want them to change
    When I follow "Where am I?"
      And I follow "Refetch"
      And I press "Refetch"
      Then I should see "1. Where am I?"

  Scenario: refetching top level fic shouldn't change chapter titles if i've modified them
     Given a genre exists with name: "harry potter"
      And I am on the homepage
    When I fill in "page_url" with "http://archiveofourown.org/works/692"
      And I select "harry potter" from "genre"
      And I press "Store"
      And I follow "2. Hogwarts"
    When I follow "Manage Parts"
      And I fill in "title" with "Hogwarts (abandoned)"
      And I press "Update"
      And I follow "Time Was, Time Is"
    Then I should see "Hogwarts (abandoned)" within "#position_2"
      And I should not see "2." within "#position_2"
    When I follow "Refetch"
      And I press "Refetch"
    Then I should see "Hogwarts (abandoned)" within "#position_2"
      And I should not see "2." within "#position_2"
