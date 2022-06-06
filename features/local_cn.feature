Feature: clairesnook fics

Scenario: The Resolute Urgency of Now (tab-pane)
  Given "Harry Potter" is a "Fandom"
    And Urgency exists
  When I am on the page's page
  Then I should see "The Resolute Urgency of Now" within ".title"
    And I should see "by Claire Watson" within ".notes"
    And I should see "Harry Potter" within ".fandoms"
    And I should see "Harry wakes up in the cupboard at Privet Drive. Thinking he’s involved in an extremely lucid dream, he sets events in motion that will change everything" within ".notes"
    And I should see "Harry Potter & Sirius Black" within ".notes"
    And I should see "Writing a time-travel story" within ".notes"
    And I should see "full notes" within ".notes"
    And I should see "Time Travel" within ".pros"
    And the contents should start with "When Harry woke,"
    And the contents should end with "time to wake up."

Scenario: The Resolute Urgency of Now (tab-pane) long notes
  Given Urgency exists
  When I am on the page's page
    And I follow "full notes"
  Then I should see "Which is a lot." within ".notes"

Scenario: Time After Time (entry-content no summary)
  Given "Shadowhunters" is a "Fandom"
    And Time exists
  When I am on the page's page
  Then I should see "Time After Time" within ".title"
    And I should see "by Claire Watson" within ".notes"
    And I should see "Shadowhunters" within ".fandoms"
    And I should see "This story explores something that occurred to me after watching This World Inverted (S1E10). This is an imaginary conversation Clary might have had soon after ‘discovering’ that Jace is her brother." within ".notes"
    And I should see "Alec/Magnus, Jace/Clary (offscreen)" within ".notes"
    And I should see "Discussion of theoretical past"
    And the contents should start with "Alec and Magnus had been about"
    And the contents should end with "leaning in for another kiss."

Scenario: I Wish (entry-content summary and authors note)
  Given "Teen Wolf" is a "Fandom"
    And "Claire Watson" is an "Author"
    And Wish exists
  When I am on the page's page
  Then I should see "I Wish" within ".title"
    And I should see "Claire Watson" within ".authors"
    And I should see "Teen Wolf" within ".fandoms"
    And I should see "Things look a little different for Stiles when his familiarity bias is stripped away." within ".notes"
    And I should see "pre Stiles/Derek" within ".notes"
    And I should see "This is set in the" within ".notes"
    And I should see "end of the school year." within ".notes"
    And I should NOT see "None"
    And the contents should start with "It had been an ordinary boring"
    And the contents should end with "no harm done, after all."

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
  Then I should see "Almost Paradise – Art by fashi0n"
    And I should see "by Claire Watson"
    And I should see "The art created for Almost Paradise by Claire Watson. All of these images were created by fashi0n , and are presented here in the order they appear in the story."

Scenario: Black Moon Rising multi fandoms
  Given "Harry Potter" is a "Fandom"
    And Black exists
  When I am on the page's page
  Then I should see "Harry Potter" within ".fandoms"
    And I should see "Little Black Dress" within ".notes"
