Feature: authors with more than one name

Scenario: editing name from edit author page updates its pages
  Given a page exists with authors: "jane"
  When I am on the edit tag page for "jane"
    And I fill in "tag_name" with "jane (june)"
    And I press "Update"
    And I am on the page's page
  Then I should see "jane (june)" within ".authors"

Scenario: adding an AKA to an author adds both authors to index page
  Given "jane" is an "Author"
  When I am on the edit tag page for "jane"
    And I fill in "tag_name" with "jane (june)"
    And I press "Update"
    And I am on the filter page
  Then I should be able to select "jane" from "Author"
    And I should be able to select "june" from "Author"
    But I should NOT be able to select "jane (june)" from "Author"

Scenario: editing the name from the page's edit author page
  Given a page exists
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "lewis carroll (charles dodgson)"
    And I press "Add Author Tags"
    And I am on the filter page
  Then I should be able to select "lewis carrol" from "author"
    And I should be able to select "charles dodgson" from "author"
    But I should NOT be able to select "lewis carroll (charles dodgson)" from "author"

Scenario: adding an author with aka from the page's edit author page shows both
  Given a page exists
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "lewis carroll (charles dodgson)"
    And I press "Add Author Tags"
  Then I should see "lewis carroll (charles dodgson)" within ".authors"

Scenario: creating a page with the original from the homepage shows both on page
  Given "lewis carroll (charles dodgson)" is an "Author"
  When I am on the create page
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I select "lewis carroll" from "Author"
    And I press "Store"
  Then I should see "lewis carroll (charles dodgson)" within ".authors"

Scenario: creating a page with the aka from the homepage shows both on page
  Given "lewis carroll (charles dodgson)" is an "Author"
  When I am on the create page
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I select "charles dodgson" from "Author"
    And I press "Store"
  Then I should see "lewis carroll (charles dodgson)" within ".authors"

Scenario: merge two authors from original point of view
  Given a page exists with authors: "jane" AND title: "Page 1"
    And a page exists with authors: "aka" AND title: "Page 2"
  When I am on the edit tag page for "aka"
    And I select "jane" from "merge"
    And I press "Merge"
    And I am on the page with title "Page 1"
  Then I should see "jane (aka)" within ".authors"

Scenario: merge two authors from aka point of view
  Given a page exists with authors: "jane" AND title: "Page 1"
    And a page exists with authors: "aka" AND title: "Page 2"
  When I am on the edit tag page for "aka"
    And I select "jane" from "merge"
    And I press "Merge"
    And I am on the page with title "Page 2"
  Then I should see "jane (aka)" within ".authors"

Scenario: two authors can share an AKA
  Given a page exists with authors: "dick (DO NOT REFETCH)" AND title: "dicks' book"
    And a page exists with authors: "jane (DO NOT REFETCH)" AND title: "jane's book"
  When I am on the page with title "jane's book"
  Then I should see "jane (DO NOT REFETCH)" within ".authors"
    But I should NOT see "dick"

Scenario: suppress AKA's in meta string (index)
  Given a page exists with authors: "jane (june)"
  When I am on the homepage
  Then I should see "jane" within "#position_1"
    But I should NOT see "june" within "#position_1"

Scenario: link from edit page bug
  Given a page exists with authors: "jane (june)"
  When I am on the edit tag page for "jane (june)"
    And I follow "1 page with that tag"
  Then I should see "Page 1"

Scenario: link from edit page bug
  Given a page exists with authors: "jane (june)"
  When I am on the edit tag page for "jane (june)"
    And I follow "Destroy"
    And I follow "view affected pages"
  Then I should see "Page 1"
