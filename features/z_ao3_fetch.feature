Feature: ao3 fetch stuff

Scenario: grab a single
  Given "popslash" is a "Fandom"
    And "Sidra" is an "Author"
    And I am on the mini page
  When I fill in "page_url" with "http://archiveofourown.org/works/68481/"
    And I press "Store"
  Then I should NOT see "Title can't be blank"
    And I should NOT see "Select tags"
    And I should see "I Drive Myself Crazy (Single)" within ".title"
    And I should NOT see "WIP" within ".cons"
    And I should see "popslash" within ".fandoms"
    And I should see "please no crossovers" within ".notes"
    And I should NOT see "Popslash" within ".notes"
    And I should see "AJ/JC" within ".notes"
    And I should see "Make the Yuletide Gay" within ".notes"
    And I should see "Sidra" within ".authors"
    And I should NOT see "by Sidra" within ".notes"
    And my page named "I Drive Myself Crazy" should have url: "https://archiveofourown.org/works/68481"

Scenario: grab a book
  Given "harry potter" is a "Fandom"
    And I am on the create page
  When I fill in "page_url" with "https://archiveofourown.org/works/692/"
    And I select "harry potter"
    And I press "Store"
  Then I should see "Time Was, Time Is (Book)" within ".title"
    And I should see "WIP" within ".cons"
    And I should see "1,581 words" within ".size"
    And I should see "by Sidra" within ".notes"
    And I should see "harry potter" within ".fandoms"
    And I should see "Using time-travel" within ".notes"
    And I should see "abandoned, Mary Sue" within ".notes"
    And I should see "written for nanowrimo" within ".notes"
    And I should see "1. Where am I?" within "#position_1"
    And I should NOT see "written for nanowrimo" within "#position_1"
    And I should see "2. Hogwarts" within "#position_2"
    And I should see "giving up on nanowrimo" within "#position_2"
    And my page named "Time Was, Time Is" should have url: "https://archiveofourown.org/works/692"

 Scenario: grab a series (duplicate from local_ao3_xx)
  Given "Harry Potter" is a "Fandom"
    And "Sidra" is an "Author"
    And I am on the mini page
  When I fill in "page_url" with "http://archiveofourown.org/series/46"
    And I press "Store"
  Then I should see "Counting Drabbles (Series)" within ".title"
    And I should see "200 words" within ".size"
    And I should see "Implied snarry" within ".notes"
    And I should see "thanks to lauriegilbert!" within ".notes"
    And I should see "Harry Potter" within ".fandoms"
    And I should see "Sidra" within ".authors"
    And I should see "1. Skipping Stones" within "#position_1"
    And I should see "2. The Flower [sequel to Skipping Stones]" within "#position_2"
    And the show tags for "Counting Drabbles" should include fandom and author
    And I should see "Harry Potter/Unknown; Drabble; thanks to lauriegilbert for" within "#position_1"
    And I should see "Harry Potter/Unknown; Drabble; Thank you lauriegilbert for" within "#position_2"
    And my page named "Counting Drabbles" should have url: "https://archiveofourown.org/series/46"
    And my page named "Skipping Stones" should have url: "https://archiveofourown.org/works/688"
    And my page named "The Flower [sequel to Skipping Stones]" should have url: "https://archiveofourown.org/works/689"
    And the tags for "Skipping Stones" should include fandom and author
    And the tags for "The Flower [sequel to Skipping Stones]" should include fandom and author
    But the tags for "Counting Drabbles" should NOT include fandom and author

Scenario: deliberately fetch only one chapter
  Given I am on the mini page
    And I fill in "page_url" with "https://archiveofourown.org/works/692/chapters/803"
  When I press "Store"
  Then I should see "Where am I? (Single)" within ".title"
    And I should NOT see "WIP" within ".cons"
    And I should NOT see "1."
    But I should see "by Sidra"
    And I should see "Harry Potter"
    But I should NOT see "Using time-travel"
    And I should NOT see "Hogwarts"
    And I should NOT see "giving up on nanowrimo"
    And my page named "Where am I?" should have url: "https://archiveofourown.org/works/692/chapters/803"

