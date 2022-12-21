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

