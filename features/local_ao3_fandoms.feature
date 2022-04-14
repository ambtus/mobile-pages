Feature: ao3 testing that can use local files
         so I don't have to constantly be fetching from
         (would need to be updated if ao3 changes it's format)

Scenario: Other Fandom if fandom doesn't exists
  Given Skipping Stones exists
  When I am on the page's page
  Then I should see "Other Fandom" within ".fandoms"
    And I should see "Harry Potter" before "Harry Potter/Unknown" within ".notes"

Scenario: Other Fandom prevents fandom matching
  Given Skipping Stones exists
    And "Harry Potter" is a "Fandom"
  When I am on the page's page
    And I press "Rebuild Meta"
  Then I should see "Other Fandom" within ".fandoms"
    And I should see "Harry Potter" before "Harry Potter/Unknown" within ".notes"

Scenario: toggling Other Fandom allows fandom matching
  Given Skipping Stones exists
    And "Harry Potter" is a "Fandom"
  When I am on the page's page
    And I press "Toggle Other Fandom"
  Then I should see "Harry Potter" within ".fandoms"
    And I should NOT see "Harry Potter" before "Harry Potter/Unknown" within ".notes"

Scenario: some fandoms match
  Given "Harry Potter" is a "Fandom"
    And Alan Rickman exists
  When I am on the page's page
  Then I should see "Harry Potter" within ".fandoms"
    And I should see "Die Hard, Robin Hood" within ".notes"
    But I should NOT see "Harry Potter" within ".notes"

Scenario: check before don't over-match
  Given Yer a Wizard exists
    And I am on the page's page
  Then I should see "Other Fandom" within ".fandoms"
    And I should see "Forgotten Realms, Legend of Drizzt Series, Starlight and Shadows Series" within ".notes"

Scenario: don't over-match "of" in fandoms
  Given "Person of Interest" is a "Fandom"
    And Yer a Wizard exists
    And I am on the page's page
  Then I should NOT see "Person of Interest" within ".fandoms"
    And I should see "Forgotten Realms, Legend of Drizzt Series, Starlight and Shadows Series" within ".notes"

Scenario: do match Drizzt (as aka)
  Given "Forgotten Realms (Drizzt)" is a "Fandom"
    And Yer a Wizard exists
    And I am on the page's page
  Then I should see "Forgotten Realms (Drizzt)" within ".fandoms"
    And I should see "Starlight and Shadows Series" within ".notes"
    But I should NOT see "Legend of Drizzt Series" within ".notes"

Scenario: do match Drizzt (as first)
  Given "Drizzt (Forgotten Realms)" is a "Fandom"
    And Yer a Wizard exists
    And I am on the page's page
  Then I should see "Drizzt (Forgotten Realms)" within ".fandoms"
    And I should see "Starlight and Shadows Series" within ".notes"
    But I should NOT see "Legend of Drizzt Series" within ".notes"

 Scenario: series should get their fandoms from the works
  Given "harry potter" is a "Fandom"
    And Counting Drabbles exists
  When I am on the page's page
  Then I should see "harry potter" within ".fandoms"

