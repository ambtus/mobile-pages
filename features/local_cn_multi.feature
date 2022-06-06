Feature: clairesnook multi-part fics

Scenario: series of singles
  Given "Teen Wolf" is a "Fandom"
    And "Claire Watson" is an "Author"
    And The Prepared Mind exists
  When I am on the page's page
  Then I should see "The Prepared Mind (Series)"
    And I should see "Teen Wolf" within ".fandoms"
    And I should see "Claire Watson" within ".authors"
    And I should see "This series evolved during the 2020-2021 Trope Bingo challenge. It begins during the S2 finale of Teen Wolf and goes AU from there." within ".notes"
    And I should see "1. Dice in the Mirror Rate"
    And I should see "2. Crazy Little Thing Rate"


Scenario: book of chapters
  Given "Teen Wolf" is a "Fandom"
    And "Claire Watson" is an "Author"
    And Earthbound Misfit exists
  When I am on the page's page
  Then I should see "Earthbound Misfit (Book)"
    And I should see "Teen Wolf" within ".fandoms"
    And I should see "Claire Watson" within ".authors"
    And I should see "Time Travel" within ".pros"
    And I should see "When Stiles agreed to be drowned" within ".notes"
    And I should see "full notes"
    And I should see "62,796 words (2 parts)"
    And I should see "1. Chapter one to chapter seven Rate"
    And I should see "2. Chapter eight to chapter fourteen Rate"
