Feature: reading

Scenario: reading page
  Given pages with all possible soons exist
  When I am on the reading page
  Then I should see "now reading" within ".pages"
    And the page should NOT contain css "#position_2"
    And I should see "(and 0 hidden)"

Scenario: reading page after new download
  Given pages with all possible soons exist
    And I download the epub for "read next"
  When I am on the reading page
  Then I should see "now reading" within ".pages"
    And I should see "read next" within ".pages"
    And the page should NOT contain css "#position_3"
    And I should see "(and 0 hidden)"

Scenario: reading page after download hidden
  Given a page exists with hiddens: "will be visible"
    And I download its epub
    And pages with all possible soons exist
  When I am on the reading page
  Then I should see "now reading" within ".pages"
    And the page should NOT contain css "#position_2"
    And I should see "(and 1 hidden)"

Scenario: reading page after download hidden
  Given a page exists with hiddens: "will be visible"
    And I download its epub
    And pages with all possible soons exist
  When I am on the reading page
  And I follow "(and 1 hidden)"
  Then I should see "will be visible" within ".pages"
    And the page should NOT contain css "#position_2"
    And I should see "1 pages"

Scenario: reading page after download hidden
  Given a page exists with hiddens: "will be visible"
    And I download its epub
    And pages with all possible soons exist
  When I am on the reading page
    And I follow "(and 1 hidden)"
    And I follow "1 pages"
  Then I should see "now reading" within ".pages"
    And the page should NOT contain css "#position_2"
    And I should see "(and 1 hidden)"

Scenario: reading next
  Given six downloaded and six hidden pages exist
  When I am on the reading page
    And I press "Next"
  Then I should see "reading" within ".pages"
    And the page should NOT contain css "#position_2"
    And I should see "(and 6 hidden)"

Scenario: reading next
  Given six downloaded and six hidden pages exist
  When I am on the reading page
    And I press "Next"
    And I follow "(and 6 hidden)"
    And I press "Next"
  Then I should see "hidden" within ".pages"
    And the page should NOT contain css "#position_2"

Scenario: reading last
  Given eleven downloaded pages exist
  When I am on the reading page
    And I press "Last"
  Then I should have button "Previous"
    But I should NOT have button "Next"

Scenario: reading last
  Given eleven downloaded pages exist
  When I am on the reading page
    And I press "Last"
    And I press "First"
  Then I should have button "Next"
    But I should NOT have button "Previous"

Scenario: reading last
  Given eleven downloaded pages exist
  When I am on the reading page
    And I press "Next"
  Then I should have button "Next"
    And I should have button "Previous"
    And I should have button "Last"
    And I should have button "First"
