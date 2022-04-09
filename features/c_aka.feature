Feature: authors with more than one name

Scenario: editing name from edit author page updates its pages
  Given a page exists with add_author_string: "jane"
  When I am on the edit author page for "jane"
    And I fill in "author_name" with "jane (june)"
    And I press "Update"
    And I am on the page's page
  Then I should see "jane (june)" within ".authors"

Scenario: adding an AKA to an author adds both authors to index page
  Given "jane" is an author
  When I am on the edit author page for "jane"
    And I fill in "author_name" with "jane (june)"
    And I press "Update"
    And I am on the homepage
  Then I should be able to select "jane" from "Author"
    And I should be able to select "june" from "Author"
    But I should NOT be able to select "jane (june)" from "Author"

Scenario: editing the name from the page's edit author page
  Given a page exists
  When I am on the page's page
    And I edit the authors
    And I fill in "authors" with "lewis carroll (charles dodgson)"
    And I press "Add Authors"
    And I am on the homepage
  Then I should be able to select "lewis carrol" from "author"
    And I should be able to select "charles dodgson" from "author"
    But I should NOT be able to select "lewis carroll (charles dodgson)" from "author"

Scenario: adding an author with aka from the page's edit author page shows both
  Given a page exists
  When I am on the page's page
    And I edit the authors
    And I fill in "authors" with "lewis carroll (charles dodgson)"
    And I press "Add Authors"
  Then I should see "lewis carroll (charles dodgson)" within ".authors"

Scenario: creating a page with the original from the homepage shows both on page
  Given "lewis carroll (charles dodgson)" is an author
  When I am on the homepage
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I select "lewis carroll" from "Author"
    And I press "Store"
  Then I should see "lewis carroll (charles dodgson)" within ".authors"

Scenario: creating a page with the aka from the homepage shows both on page
  Given "lewis carroll (charles dodgson)" is an author
  When I am on the homepage
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I select "charles dodgson" from "Author"
    And I press "Store"
  Then I should see "lewis carroll (charles dodgson)" within ".authors"

Scenario: merge two authors from original point of view
  Given a page exists with add_author_string: "jane" AND title: "Page 1"
    And a page exists with add_author_string: "aka" AND title: "Page 2"
  When I am on the edit author page for "aka"
    And I select "jane" from "merge"
    And I press "Merge"
    And I am on the page with title "Page 1"
  Then I should see "jane (aka)" within ".authors"

Scenario: merge two authors from aka point of view
  Given a page exists with add_author_string: "jane" AND title: "Page 1"
    And a page exists with add_author_string: "aka" AND title: "Page 2"
  When I am on the edit author page for "aka"
    And I select "jane" from "merge"
    And I press "Merge"
    And I am on the page with title "Page 2"
  Then I should see "jane (aka)" within ".authors"
