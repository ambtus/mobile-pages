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

Scenario: book of chapters with long notes
  Given "Shadowhunters" is a "Fandom"
    And Almost Paradise exists
  When I am on the page's page
  Then I should see "Almost Paradise (Book)"
    And I should see "by Claire Watson"
    And I should see "Shadowhunters" within ".fandoms"
    And I should see "Alec/Magnus, Isabelle/Simon, Maryse/Luke"
    And I should see "full notes"
    And I should see "1. Chapter one to four Rate"
    And I should see "2. Art by fashi0n Rate"
    And the notes should include "https://i0.wp.com/clairesnook.com/wp-content/uploads/2020/07/image1.jpeg"

Scenario: book of chapters with long notes
  Given Almost Paradise exists
  When I am on the page's page
    And I follow "full notes"
  Then I should see "Clary Fray may have been stripped"
    And I should see "memories back."
    And I should see "Almost Paradise is a collaborative"
    And I should see "themed fanfiction stories."
    And I should see "Hate Crimes/Hate Speech, Discussion of Evil Plans involving Incest"
    But I should NOT see "Author Notes"

Scenario: manipulating chapter/single to get the title you want without losing notes
  Given Shadowwings exists
  When I am on the page's page
    And I follow "Shadowwings"
    And I press "Decrease Type"
    And I press "Rebuild Meta"
  Then I should see "Genesis (Chapter)"
    And I should see "For as long as Alec could remember, he had been fascinated by wings."
    And I should see "Canon child neglect, canon violence"
