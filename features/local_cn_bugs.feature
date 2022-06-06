Feature: clairesnook bugs and oddities

Scenario: The Secret to Survivin’ author notes bug and n/a warning
  Given Secret exists
  When I am on the page's page
  Then I should see "Trope Bingo #Competence"
    But I should NOT see ": Trope"
    And I should NOT see "n/a"

Scenario: Crazy Little Thing summary multiline
  Given Crazy exists
  When I am on the page's page
  Then I should see "For Stiles, all roads would eventually"
    And I should see "knocked unconscious and abducted."

Scenario: Something In My Liberty author note multiline pt1
  Given Something exists
  When I am on the page's page
  Then I should see "Trope Bingo #Pregnancy"
    And I should see "full notes"

Scenario: Something In My Liberty author note multiline pt2
  Given Something exists
  When I am on the page's page
    And I follow "full notes"
  Then I should see "not sorry"
    And I should see "as Kamaria."

Scenario: Art scrubbing bug
  Given Art exists
  When I read it online
  Then I should see "The art created for Almost Paradise by Claire Watson. All of these images were created by fashi0n , and are presented here in the order they appear in the story."

Scenario: Black Moon Rising multi fandoms
  Given "Harry Potter" is a "Fandom"
    And Black exists
  When I am on the page's page
  Then I should see "Harry Potter" within ".fandoms"
    And I should see "Little Black Dress" within ".notes"

Scenario: Arm Candy author note
  Given Arm exists
  When I am on the page's page
  Then I should see "Set outside canon and several years in the future." within ".notes"
    And I should NOT see "938" within ".notes"

Scenario: Serendipity title & empty authors note
  Given "Harry Potter" is a "Fandom"
    And "Claire Watson" is an "Author"
    And Serendipity exists
  When I am on the page's page
  Then I should see "Serendipity (Single)"
    And I should NOT see "– EAD 2022"
    And I should NOT see "Chapter one"
    And I should see two horizontal rules
    But I should NOT see three horizontal rules

Scenario: Serendipity initial comment
  Given Serendipity exists
  When I read it online
  Then I should see "This is the first chapter of a story where Harry and Sirius get all the care I wanted them to get in canon"

