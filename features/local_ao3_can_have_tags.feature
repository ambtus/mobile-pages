Feature: can_have_tags? inferred tags feature

Scenario: A Book can have fandom and author tags but a Chapter cannot have it’s own fandom and author tags and inherits fandom and author tags from parent
  Given tags exist
  When Time Was exists
  Then the download tag string for "Time Was, Time Is" should include fandom and author
    And the show tags for "Time Was, Time Is" should include fandom and author
    And the index tags for "Time Was, Time Is" should include fandom and author
    But I can NOT tag "Hogwarts" with fandom and author
    And the download tag string for "Hogwarts" should include fandom and author
    And the show tags for "Hogwarts" should include fandom and author
    And the index tags for "Hogwarts" should include fandom and author

Scenario: A Chapter inherits author tags from parent but only when alone
  Given tags exist
  When Time Was exists
  When I am on the page with title "Time Was, Time Is"
  Then I should see "Sidra" within ".authors"
    And I should see "Harry Potter" within ".fandoms"
    But I should NOT see "Sidra" within "#position_1"
    And I should NOT see "Harry Potter" within "#position_1"

Scenario: A Series cannot have it’s own fandom and author tags
  Given Counting Drabbles exists
  Then I can NOT tag "Counting Drabbles" with fandom and author

Scenario: A Series inherits fandom and author tags from child
  Given tags exist
  When Counting Drabbles exists
  Then the download tag string for "Counting Drabbles" should include fandom and author
    And the show tags for "Counting Drabbles" should include fandom and author
    And the index tags for "Counting Drabbles" should include fandom and author



Scenario: A Book can have fandom and author in notes but a Chapter does not have it’s own fandom and author in notes
  Given Time Was exists
  When I am on the page's page
  Then I should see "by Sidra" within ".notes"
    And I should see "Harry Potter" before "Using time-travel" within ".notes"
    And I should see "Other Fandom" within ".fandoms"
    But I should NOT see "Sidra" within "#position_1"
    And I should NOT see "Harry Potter" within "#position_1"

Scenario: A Chapter without fandom and author tags when alone
  Given Time Was exists
  When I am on the page with title "Hogwarts"
  Then I should see "Other Fandom" within ".fandoms"
    But I should NOT see "Sidra"
    And I should NOT see "Harry Potter"

Scenario: A Series without fandom and author tags from child
  Given Counting Drabbles exists
  When I am on the page's page
  Then I should see "Other Fandom" within ".fandoms"
    And I should NOT see "Sidra" within ".notes"
    And I should NOT see "Harry Potter" within ".notes"
    But I should see "by Sidra; Harry Potter; Harry Potter/Unknown" within "#position_1"
