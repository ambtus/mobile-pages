Feature: change type from web

Scenario: check before change type
  Given a page exists
  When I am on the page's page
  Then I should see "Page 1 (Single)"

Scenario: change from single to book
  Given a page exists
  When I am on the page's page
    And I press "Increase Type"
  Then I should see "Page 1 (Book)"

Scenario: change from single to chapter
  Given a page exists
    And the single has a parent
  When I am on the page's page
    And I press "Decrease Type"
  Then I should see "Page 1 (Chapter)"

Scenario: change from series to book changes the parts to chapters
  Given Counting Drabbles exists
  When I am on the page's page
    And I press "Decrease Type"
  Then I should see "Counting Drabbles (Book)" within ".title"
  And "Skipping Stones" should be a "Chapter"

Scenario: change from chapter to single changes the parent to series
  Given Counting Drabbles exists
  When I am on the page's page
    And I press "Decrease Type"
    And I follow "Skipping Stones"
    And I press "Increase Type"
  Then I should see "Skipping Stones (Single)" within ".title"
  And I should see "Counting Drabbles (Series)" within ".parent"

Scenario: change from book to series
  Given Time Was exists
  When I am on the page's page
    And I press "Increase Type"
  Then I should see "Time Was, Time Is (Series)"

Scenario: change from book to series doesn't change the parts
  Given Time Was exists
  When I am on the page's page
    And I press "Increase Type"
    And I follow "Where am I?"
  Then I should see "Where am I? (Chapter)"

Scenario: increase a chapter
  Given Time Was exists
  When I am on the page's page
    And I follow "Where am I?"
    And I press "Increase Type"
  Then I should see "Where am I? (Single)"

Scenario: increase a chapter increases the parent to series
  Given Time Was exists
  When I am on the page's page
    And I follow "Where am I?"
    And I press "Increase Type"
    And I follow "Time Was, Time Is"
  Then I should see "Time Was, Time Is (Series)"
    And "Where am I?" should be a "Single"

Scenario: change from series to book changes the parts to chapters
  Given Time Was exists
  When I am on the page's page
    And I follow "Where am I?"
    And I press "Increase Type"
    And I follow "Time Was, Time Is"
    And I press "Decrease Type"
  Then I should see "Time Was, Time Is (Book)"
    And "Where am I?" should be a "Chapter"

Scenario: increase a single part
  Given Counting Drabbles exists
  When I am on the page's page
    And I follow "Skipping Stones"
    And I press "Increase Type"
  Then I should see "Skipping Stones (Book)"

Scenario: increase a single part doesn't change the parent
  Given Counting Drabbles exists
  When I am on the page's page
    And I follow "Skipping Stones"
    And I press "Increase Type"
    And I follow "Counting Drabbles"
  Then I should see "Counting Drabbles (Series)"

Scenario: decrease a single part
  Given Counting Drabbles exists
  When I am on the page's page
    And I follow "Skipping Stones"
    And I press "Decrease Type"
  Then I should see "Skipping Stones (Chapter)"

Scenario: decrease a single part doesn't change the parent
  Given Counting Drabbles exists
  When I am on the page's page
    And I follow "Skipping Stones"
    And I press "Decrease Type"
    And I follow "Counting Drabbles"
  Then I should see "Counting Drabbles (Series)"

Scenario: cannot go below Chapter
  Given Time Was exists
  When I am on the page's page
    And I follow "Where am I?"
  Then I should NOT see "Decrease Type"

Scenario: cannot go above Series
  Given a series exists
  When I am on the page's page
  Then I should NOT see "Increase Type"
