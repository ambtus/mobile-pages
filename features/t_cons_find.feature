Feature: pages with con tags are filtered out when selected
         unless it's being linked to directly, in which case it filtered in

Scenario: link from edit page (no pages)
  Given "abc123" is a "Con"
  When I am on the edit tag page for "abc123"
    And I follow "0 pages with that tag"
  Then the page should have title "Pages tagged with abc123"
    And I should see "No pages found"
    And the page should NOT contain css "#position_1"

Scenario: link from edit page
  Given a page exists with cons: "abc123"
  When I am on the edit tag page for "abc123"
    And I follow "1 page with that tag"
  Then the page should have title "Pages tagged with abc123"
    And I should see "Page 1"

Scenario: link from edit page
  Given a page exists with cons: "abc123"
  When I am on the edit tag page for "abc123"
    And I follow "Destroy"
    And I follow "view affected pages"
  Then I should see "Page 1"

Scenario: link from tag index
  Given a page exists with cons: "abc123"
  When I am on the tags page
    And I follow "pages tagged with abc123"
  Then I should see "Page 1"

Scenario: link from show
  Given a page exists with cons: "abc123"
  When I am on the page's page
    And I follow "abc123"
  Then I should see "Page 1"

Scenario: if there are no more pages
  Given 10 pages with cons: "abc123" exist
  When I am on the page's page
    And I follow "abc123"
    And I press "Next"
  Then I should see "No pages found"
    And the page should NOT contain css "#position_1"

Scenario: limit 10
  Given 21 pages with cons: "abc123" exist
  When I am on the edit tag page for "abc123"
    And I follow "21 pages with that tag"
  Then I should see "Page 1" within "#position_1"
    And I should see "Page 10" within "#position_10"
    And I should NOT see "Page 11"
    And I should NOT see "Page 20"
    And I should NOT see "Page 21"

Scenario: next remembers count
  Given 21 pages with cons: "abc123" exist
  When I am on the edit tag page for "abc123"
    And I follow "21 pages with that tag"
    And I press "Next"
    And I press "Next"
  Then I should see "Page 21" within "#position_1"
    And the page should NOT contain css "#position_2"
    And I should NOT see "Page 1"
    And I should NOT see "Page 20"
