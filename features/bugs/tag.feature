Feature: tag bugs

Scenario: link from edit page bug
  Given a page exists with authors: "jane (june)"
  When I am on the edit tag page for "jane (june)"
    And I follow "Destroy"
    And I follow "view affected pages"
  Then I should see "Page 1"

Scenario: link from tag index bug
  Given a page exists with authors: "jane (june)"
  When I am on the authors page
    And I follow "jane page"
  Then I should see "Page 1"

Scenario: link from show bug
  Given a page exists with authors: "jane (june)"
  When I am on the first page's page
    And I follow "jane"
    And I follow "1 page"
  Then I should see "Page 1"

Scenario: link from edit page bug
  Given a page exists with authors: "jane (june)"
  When I am on the edit tag page for "jane (june)"
    And I follow "1 page with that tag"
  Then I should see "Page 1"

