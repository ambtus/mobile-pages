Feature: page bugs

Scenario: test before parent shows tags
  Given a page exists with urls: "http://test.sidrasue.com/parts/1.html,http://test.sidrasue.com/parts/2.html" AND authors: "Sidra" AND fandoms: "Harry Potter" AND cons: "def987"
  When I am on the first page's page
  Then I should see "Sidra"
    And I should see "Harry Potter"
    And I should see "def987"
    And I should see "2 parts"

Scenario: parent shows tags
  Given a page exists with urls: "http://test.sidrasue.com/parts/1.html,http://test.sidrasue.com/parts/2.html" AND authors: "Sidra" AND fandoms: "Harry Potter" AND cons: "def987"
  When I am on the first page's page
    And I add a parent with title "New Parent"
    And I am on the page with title "New Parent"
  Then I should see "Sidra"
    And I should see "Harry Potter"
    And I should see "def987"
    And I should see "1 part"

Scenario: parent doesn't own tags
  Given a page exists with urls: "http://test.sidrasue.com/parts/1.html,http://test.sidrasue.com/parts/2.html" AND authors: "Sidra" AND fandoms: "Harry Potter" AND cons: "def987"
  When I am on the first page's page
    And I add a parent with title "New Parent"
    And I am on the page with title "New Parent"
  Then the show tags for "New Parent" should include fandom and author
    And the index tags for "New Parent" should include fandom and author
    And the download tag string for "New Parent" should include fandom and author
  But the tags for "New Parent" should NOT include fandom and author

Scenario: missing raw html directory
  Given a page exists with url: "http://test.sidrasue.com/test.html"
    And the page's directory is missing
  When I am on the first page's page
  Then I should NOT get a 404
    And I should see "Page 1 (Single)"
