Feature: authors with more than one name

Scenario: adding an AKA to an author
  Given "jane" is an "Author"
  When I am on the edit tag page for "jane"
    And I fill in "tag_name" with "jane (june)"
    And I press "Update"
  Then I should see "jane (june)"

Scenario: adding an AKA to an author
  Given "jane" is an "Author"
  When I am on the edit tag page for "jane"
    And I fill in "tag_name" with "jane (june)"
    And I press "Update"
    And I am on the filter page
  Then I should be able to select "jane" from "Author"
    But I should NOT be able to select "june" from "Author"
    And I should NOT be able to select "jane (june)" from "Author"

Scenario: creating the name from the page's edit author page
  Given a page exists
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "lewis carroll (charles dodgson)"
    And I press "Add Author Tags"
    And I am on the authors page
  Then I should see "lewis carroll (charles dodgson)"

Scenario: creating the name from the page's edit author page
  Given a page exists
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "lewis carroll (charles dodgson)"
    And I press "Add Author Tags"
    And I am on the filter page
  Then I should be able to select "lewis carrol" from "author"
    But I should NOT be able to select "charles dodgson" from "author"
    But I should NOT be able to select "lewis carroll (charles dodgson)" from "author"

Scenario: suppress AKA's in meta string (index)
  Given a page exists with authors: "jane (june)"
  When I am on the homepage
  Then I should see "jane" within "#position_1"
    But I should NOT see "june" within "#position_1"

Scenario: two authors can share short names
  Given a page exists with authors: "dick (jane)" AND title: "dicks' book"
    And a page exists with authors: "jane (dick)" AND title: "jane's book"
  When I am on the homepage
  Then I should NOT see "jane" within "#position_1"
    But I should see "dick" within "#position_1"

Scenario: two authors can share akas
  Given a page exists with authors: "dick (aka)" AND title: "dicks' book"
    And a page exists with authors: "jane (aka)" AND title: "jane's book"
  When I am on the homepage
  Then I should NOT see "aka"
    But I should see "dick" within "#position_1"

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

Scenario: link from tag index bug
  Given a page exists with authors: "jane (june)"
  When I am on the authors page
    And I follow "jane pages"
  Then I should see "Page 1"

Scenario: link from show bug
  Given a page exists with authors: "jane (june)"
  When I am on the page's page
    And I follow "jane"
    And I follow "1 page"
  Then I should see "Page 1"
