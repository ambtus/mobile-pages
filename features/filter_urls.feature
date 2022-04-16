Feature: filter/find by url

Scenario: multiple urls match
  Given the following pages
    | title                                  | url                                |
    | A Christmas Carol by Charles Dickens   | http://test.sidrasue.com/cc.html   |
    | The Call of the Wild by Jack London    | http://test.sidrasue.com/cotw.html |
    | The Mysterious Affair at Styles        | http://test.sidrasue.com/maas.html |
  When I am on the filter page
    And I fill in "page_url" with "test.sidrasue.com"
    And I press "Find"
  Then I should see "A Christmas Carol" within "#position_1"
    And I should see "The Call of the Wild" within "#position_2"
    And I should see "The Mysterious Affair at Styles" within "#position_3"

Scenario: one page found
  Given a page exists with title: "The Mysterious Affair at Styles" AND url: "http://test.sidrasue.com/maas.html"
  When I am on the filter page
    And I fill in "page_url" with "http://test.sidrasue.com/maas.html"
    And I press "Find"
  Then I should see "One page found" within "#flash_notice"
    And I should see "The Mysterious Affair at Styles (Single)" within ".title"

Scenario: one part found
  Given a page exists with base_url: "http://test.sidrasue.com/*.html" AND url_substitutions: "cc cotw maas"
  When I am on the filter page
    And I fill in "page_url" with "http://test.sidrasue.com/maas.html"
    And I press "Find"
  Then I should see "One page found" within "#flash_notice"
    And I should see "Part 3 (Chapter)" within ".title"

Scenario: check find page by original url
  Given Open the Door exists
  When I am on the filter page
    And I fill in "page_url" with "https://archiveofourown.org/works/310586"
    And I press "Find"
  Then I should see "One page found" within "#flash_notice"
    And I should see "Open the Door (Book)" within ".title"

Scenario: Find page with http
  Given Open the Door exists
  When I am on the filter page
    And I fill in "page_url" with "http://archiveofourown.org/works/310586"
    And I press "Find"
  Then I should see "One page found" within "#flash_notice"
    And I should see "Open the Door (Book)" within ".title"

Scenario: Find page with trailing slash
  Given Open the Door exists
  When I am on the filter page
    And I fill in "page_url" with "https://archiveofourown.org/works/310586/"
    And I press "Find"
  Then I should see "One page found" within "#flash_notice"
    And I should see "Open the Door (Book)" within ".title"

Scenario: Find page with http and trailing slash
  Given Open the Door exists
  When I am on the filter page
    And I fill in "page_url" with "http://archiveofourown.org/works/310586/"
    And I press "Find"
  Then I should see "One page found" within "#flash_notice"
    And I should see "Open the Door (Book)" within ".title"

Scenario: find by url shows parts
  Given Time Was exists
    And I am on the filter page
  When I fill in "page_url" with "https://archiveofourown.org/works/692/"
    And I press "Find"
  Then I should see "1. Where am I?" within "#position_1"
    And I should see "2. Hogwarts" within "#position_2"
