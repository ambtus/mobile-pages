Feature: tags with more than one name

Scenario: editing name from edit tag page updates its pages
  Given a page exists with tropes: "jane"
  When I am on the edit tag page for "jane"
    And I fill in "tag_name" with "jane (june)"
    And I press "Update"
    And I am on the page's page
  Then I should see "jane (june)" within ".tags"

Scenario: adding an AKA to a tag adds both names to index page
  Given "jane" is a tag
  When I am on the edit tag page for "jane"
    And I fill in "tag_name" with "jane (june)"
    And I press "Update"
    And I am on the homepage
  Then I should be able to select "jane" from "Trope"
    And I should be able to select "june" from "Trope"
    But I should NOT be able to select "jane (june)" from "Trope"

Scenario: editing the name from the page's edit tag page
  Given a page exists
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "lewis carroll (charles dodgson)"
    And I press "Add Trope Tags"
    And I am on the homepage
  Then I should be able to select "lewis carrol" from "Trope"
    And I should be able to select "charles dodgson" from "Trope"
    But I should NOT be able to select "lewis carroll (charles dodgson)" from "Trope"

Scenario: adding a tag with aka from the page's edit tag page shows both
  Given a page exists
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "lewis carroll (charles dodgson)"
    And I press "Add Trope Tags"
  Then I should see "lewis carroll (charles dodgson)" within ".tags"

Scenario: creating a page with the original from the homepage shows both on page
  Given "lewis carroll (charles dodgson)" is a tag
  When I am on the homepage
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I select "lewis carroll" from "Trope"
    And I press "Store"
  Then I should see "lewis carroll (charles dodgson)" within ".tags"

Scenario: creating a page with the aka from the homepage shows both on page
  Given "lewis carroll (charles dodgson)" is a tag
  When I am on the homepage
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I select "charles dodgson" from "Trope"
    And I press "Store"
  Then I should see "lewis carroll (charles dodgson)" within ".tags"

Scenario: merge two tags from original point of view
  Given a page exists with tropes: "jane" AND title: "Page 1"
    And a page exists with tropes: "aka" AND title: "Page 2"
  When I am on the edit tag page for "aka"
    And I select "jane" from "merge"
    And I press "Merge"
    And I am on the page with title "Page 1"
  Then I should see "jane (aka)" within ".tags"

Scenario: merge two tags from aka point of view
  Given a page exists with tropes: "jane" AND title: "Page 1"
    And a page exists with tropes: "aka" AND title: "Page 2"
  When I am on the edit tag page for "aka"
    And I select "jane" from "merge"
    And I press "Merge"
    And I am on the page with title "Page 2"
  Then I should see "jane (aka)" within ".tags"
