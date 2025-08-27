Feature: clairesnook single fics

Scenario: The Resolute Urgency of Now (tab-pane)
  Given "Harry Potter" is a "Fandom"
    And Urgency exists
  When I am on the first page's page
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
  When I am on the first page's page
    And I follow "full notes"
  Then I should see "Which is a lot." within ".notes"

Scenario: Time After Time (entry-content no summary)
  Given "Shadowhunters" is a "Fandom"
    And Time exists
  When I am on the first page's page
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
  When I am on the first page's page
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

