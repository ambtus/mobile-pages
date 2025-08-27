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
    And a page exists with cons: "xyz987" AND title: "Something"
  When I am on the tags page
    And I follow "2 Cons"
    And I follow "abc123 page"
  Then I should see "Page 1"
    But I should NOT see "Something"

Scenario: link from show
  Given a page exists with cons: "abc123"
  When I am on the first page's page
    And I follow "abc123"
  Then I should see "Page 1"

Scenario: if there are no more pages
  Given 5 pages with cons: "abc123" exist
  When I am on the first page's page
    And I follow "abc123"
    And I press "Next"
  Then I should see "No pages found"
    And the page should NOT contain css "#position_1"

Scenario: limit 5
  Given 11 pages with cons: "abc123" exist
  When I am on the edit tag page for "abc123"
    And I follow "11 pages with that tag"
  Then I should see "Page 1" within "#position_1"
    And I should see "Page 5" within "#position_5"
    And I should NOT see "Page 6"
    And I should NOT see "Page 10"
    And I should NOT see "Page 11"

Scenario: next remembers count
  Given 11 pages with cons: "abc123" exist
  When I am on the edit tag page for "abc123"
    And I follow "11 pages with that tag"
    And I press "Next"
    And I press "Next"
  Then I should see "Page 11" within "#position_1"
    And the page should NOT contain css "#position_2"
    And I should NOT see "Page 5"
    And I should NOT see "Page 10"
