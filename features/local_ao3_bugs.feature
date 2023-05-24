Feature: ao3 testing that can use local files
         so I don't have to constantly be fetching from
         (would need to be updated if ao3 changes it's format)

Scenario: bad formatting notes
  Given Bad Formatting exists
  When I am on the homepage
  Then I should see "He is theirs The clones have nothing"
    And I should NOT see "theirsThe"

Scenario: bad formatting content
  Given Bad Formatting exists
  Then the contents should include "It doesn’t always work"
    And the contents should NOT include "doesnâ€™t"

Scenario: quotes in notes download bug
  Given Quoted Notes exists
  When I am on the homepage
    And I follow "ePub"
  Then the download epub file should exist

Scenario: single of work should have work title, not chapter title
  Given Fuuinjutsu exists
  When I am on the homepage
  Then I should NOT see "Chapter 1"
    But I should see "Fuuinjutsu+Chakra+Bonds+Clones, Should not be mixed by Uzumakis"

Scenario: no author or fandom or relationships shouldn't get empty paragraph
  Given "esama" is an "Author"
    And "Harry Potter" is a "Fandom"
    And Wheel exists
  When I am on the homepage
    Then I should NOT see "; Harry has been thinking"
    But I should see "Harry has been thinking"
    And the notes should NOT include "<p></p><hr width=\"80%\"/> <p>Harry has been thinking"
    But the notes should include "<p>Harry has been thinking and Voldemort gets to be the first to hear the results.</p> <hr width=\"80%\"/>"

Scenario: bug in make_single when Single had been stored as Chapter
  Given broken Drabbles exists
  When I am on the page's page
    And I press "Uncollect"
    And I am on the page with title "Skipping Stones"
  Then I should see "Skipping Stones (Single)"

Scenario: put endnote on work, not last chapter
  Given Cold Water exists
  When I am on the page's page
  Then I should see "my tumblr: " within ".end_notes"
    And I should see "cw: gutting of a squirrel" within "#position_2"
    And I should NOT see "my tumblr: " within "#position_2"
    But I should NOT see "my tumblr: " within "#position_3"

Scenario: missing fandom
  Given "Star Wars (Mandalorian, Rogue One)" is a "Fandom"
    And had a heart exists
  When I am on the page's page
  Then I should see "Star Wars" within ".fandoms"

Scenario: duplicate end notes on chapter as single
  Given Multi Authors exists
  When I am on the page's page
  Then I should see "No, Jango is not in chapter one." within ".end_notes"
    But I should NOT see "No, Jango is not in chapter one." within ".notes"
    And I should NOT see "full notes"

Scenario: adding a parent to a single wrongly makes the parent a book
  Given Skipping Stones exists
    And I am on the page's page
  When I add a parent with title "Counting"
  Then I should see "Counting (Series)" within ".title"

Scenario: adding a parent to a single wrongly makes the page a chapter
  Given Skipping Stones exists
    And I am on the page's page
  When I add a parent with title "Counting"
    And I follow "Skipping Stones"
  Then I should see "Skipping Stones (Single)" within ".title"

Scenario: duplicate end notes on first chapter and book (book)
  Given New Day Dawning exists
  When I am on the page's page
    And I follow "full notes"
  Then I should NOT see "And thus Obito snatches himself a child"

Scenario: duplicate end notes on first chapter and book (chapter)
  Given New Day Dawning exists
  When I am on the page's page
    And I follow "Chapter 1"
  Then I should see "And thus Obito snatches himself a child"

Scenario: kudos link on split parts
  Given adapting exists
  When I am on the page's page
    And I follow "Split"
    And I click on "Itachi &amp; Kisame"
    And I press "Children"
    And I read it online
  Then Leave Kudos or Comments on "Continually Adapting (to Stay Alive)" should link to its comments

Scenario: check before single chapter 1 made into book retains title
  Given that was single exists
  When I am on the page's page
  Then I should see "that was a spring of storms (Single)" within ".title"

Scenario: hr between every paragraph
  Given "Lerya" is an "Author"
    And "Teen Wolf" is a "Fandom"
    And guardian exists
  When I read it online
  Then I should see a horizontal rule
    But I should NOT see two horizontal rules

Scenario: triple hr's
  Given "esama" is an "Author"
    And "Star Wars" is a "Fandom"
    And 55367 exists
  Then it should have 10 horizontal rules

Scenario: quote in title
  Given I asked exists
  When I am on the homepage
    And I follow "ePub"
  Then the download epub file should exist

Scenario: before removal of complementary
  Given "harry potter" is a "Fandom"
    And Time Was existed
  When I am on the page's page
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

Scenario: after removal of complementary
  Given "harry potter" is a "Fandom"
    And Time Was exists
  When I am on the page's page
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
