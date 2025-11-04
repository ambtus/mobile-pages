Feature: split a long work into chapters

Scenario: split a single into a work with two chapters
  Given adapting exists
  When I am on the first page's page
    And I follow "Split"
    And I click on "Itachi &amp; Kisame"
    And I press "Children"
  Then I should have 3 pages
    And I should see "1. Shisui & Kakashi"
    And I should see "2. Itachi & Kisame"
    And I should NOT see "Split"

Scenario: check before split (5 chapters * 2 words = 10 words)
  Given fidelitas exists
  When I am on the first page's page
  Then I should see "10,681 words" within ".size"

Scenario: split a single into a work with multiple chapters
  Given fidelitas exists
  When I am on the first page's page
    And I follow "Split"
    And I click on "Chapter 2"
    And I press "Children"
    And I follow "Chapter 2"
    And I follow "Split"
    And I click on "Chapter 3"
    And I press "Sibling"
    And I follow "Chapter 3"
    And I follow "Split"
    And I click on "Chapter 4"
    And I press "Sibling"
    And I follow "Chapter 4"
    And I follow "Split"
    And I click on "Chapter 5"
    And I press "Sibling"
    And I follow "Fidelitas Vinculum"
    And I press "Update from Parts"
  Then I should have 6 pages
    And I should see "10,671 words" within ".size"
    And I should see "Chapter 1" within "#position_1"
    And I should see "3,619 words" within "#position_1"
    And I should see "Chapter 2" within "#position_2"
    And I should see "2,075 words" within "#position_2"
    And I should see "Chapter 3" within "#position_3"
    And I should see "1,648 words" within "#position_3"
    And I should see "Chapter 4" within "#position_4"
    And I should see "1,415 words" within "#position_4"
    And I should see "Chapter 5" within "#position_5"
    And I should see "1,914 words" within "#position_5"

Scenario: split a chapter into multiple sub-chapters
  Given fire exists
  When I am on the first page's page
    And I follow "Chapter 1"
    And I follow "Split"
    And I click on "Prologue"
    And I press "Children"
    And I follow "Prologue"
    And I follow "Split"
    And I click on "Chapter 1"
    And I press "Sibling"
    And I follow "Chapter 1" within ".parent"
  Then I should see "1. Author’s note" within "#position_1"
    And I should see "2. Prologue" within "#position_2"
    And I should see "3. Chapter 1" within "#position_3"
    And I should see "Chapter 1" within ".title"
    And I should see "in case of fire, break glass" within ".parent"
    And I should see "Chapter 2" within ".part"
    And I should have 6 pages

Scenario: split a chapter into multiple siblings
  Given fire exists
  When I am on the first page's page
    And I follow "Chapter 1"
    And I follow "Split"
    And I click on "Prologue"
    And I press "Sibling"
    And I follow "Chapter 2"
    And I press "Increase Position"
    And I follow "in case of fire" within ".parent"
  Then I should have 4 pages
    And I should see "1. Author’s note" within "#position_1"
    And I should see "2. Prologue" within "#position_2"
    And I should see "3. Chapter 2" within "#position_3"

