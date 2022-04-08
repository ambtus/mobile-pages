Feature: pages with hidden tags are filtered out by default. During search, anything with a hidden is not found unless it is chosen from hiddens.

Scenario: hidden by default (no not-hiddens)
  Given the following pages
    | title                            | fandoms                 | hiddens       |
    | The Mysterious Affair at Styles  | mystery                 | hide          |
    | Alice in Wonderland              | children                | hide, go away |
  When I am on the homepage
  Then I should see "No pages found"
    And I should NOT see "The Mysterious Affair at Styles"
    And I should NOT see "Alice in Wonderland"

Scenario: hidden by default (show not-hiddens)
  Given the following pages
    | title                            | fandoms                 | hiddens       |
    | The Mysterious Affair at Styles  | mystery                 | hide          |
    | Alice in Wonderland              | children                | hide, go away |
    | The Boxcar Children              | mystery, children       |               |
  When I am on the homepage
  Then I should NOT see "No pages found"
    And I should see "The Boxcar Children"
    But I should NOT see "The Mysterious Affair at Styles"
    And I should NOT see "Alice in Wonderland"

Scenario: find by hidden
  Given the following pages
    | title                            | hiddens       |
    | The Mysterious Affair at Styles  | hide          |
    | Alice in Wonderland              | hide, go away |
    | The Boxcar Children              |               |
  When I am on the homepage
    And I select "go away" from "Hidden"
    And I press "Find"
  Then I should see "Alice in Wonderland"
    But I should NOT see "The Mysterious Affair at Styles"
    And I should NOT see "The Boxcar Children"

Scenario: check before change (index)
  Given a page exists with hiddens: "will be visible"
  When I am on the homepage
  Then I should see "No pages found"
    And I select "will be visible" from "hidden"

Scenario: check before change (show)
  Given a page exists with hiddens: "will be visible"
  When I am on the page's page
  Then I should see "will be visible" within ".hiddens"

Scenario: change hidden to trope tag (index)
  Given a page exists with hiddens: "will be visible"
  When I am on the edit tag page for "will be visible"
    And I select "Trope" from "change"
    And I press "Change"
    And I am on the homepage
  Then I should NOT see "No pages found"
    And I should see "Page 1"
    And I select "will be visible" from "tag"

Scenario: change hidden to trope tag (show)
  Given a page exists with hiddens: "will be visible"
  When I am on the edit tag page for "will be visible"
    And I select "Trope" from "change"
    And I press "Change"
    And I am on the homepage
  Then I should see "will be visible" within ".tags"

Scenario: check before change (index)
  Given a page exists with tropes: "to be hidden"
  When I am on the homepage
  Then I should NOT see "No pages found"
    And I should see "Page 1"
    And I select "to be hidden" from "tag"

Scenario: check before change (show)
  Given a page exists with tropes: "to be hidden"
  When I am on the page's page
  Then I should see "to be hidden" within ".tags"

Scenario: change tope to hidden tag (index)
  Given a page exists with tropes: "to be hidden"
  When I am on the edit tag page for "to be hidden"
    And I select "Hidden" from "change"
    And I press "Change"
    And I am on the homepage
  Then I should see "No pages found"
    And I select "to be hidden" from "hidden"

Scenario: change trope to hidden tag (show)
  Given a page exists with tropes: "to be hidden"
  When I am on the edit tag page for "to be hidden"
    And I select "Hidden" from "change"
    And I press "Change"
    And I am on the page's page
  Then I should see "to be hidden" within ".hiddens"

Scenario: check before find by url
  Given the following pages
    | title                  | url                                | hiddens |
    | A Christmas Carol      | http://test.sidrasue.com/cc.html   | hide me |
    | The Call of the Wild   | http://test.sidrasue.com/cotw.html |         |
  When I am on the homepage
  Then I should see "The Call of the Wild"
    But I should NOT see "A Christmas Carol"

Scenario: find by url should find hidden
  Given the following pages
    | title                  | url                                | hiddens |
    | A Christmas Carol      | http://test.sidrasue.com/cc.html   | hide me |
    | The Call of the Wild   | http://test.sidrasue.com/cotw.html |         |
  When I am on the homepage
    And I fill in "page_url" with "http://test.sidrasue.com/cc.html"
    And I press "Find"
  Then I should see "A Christmas Carol" within ".title"

Scenario: find by url should NOT find hidden if it's part of the filter
  Given the following pages
    | title                  | url                                | hiddens |
    | A Christmas Carol      | http://test.sidrasue.com/cc.html   | hide me |
    | The Call of the Wild   | http://test.sidrasue.com/cotw.html |         |
  When I am on the homepage
    And I fill in "page_url" with "test.sidrasue.com"
    And I press "Find"
  Then I should see "The Call of the Wild"
    But I should NOT see "A Christmas Carol"

Scenario: change part to hidden
  Given a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1 2 3" AND tropes: "show me" AND add_author_string: "my author"
  When I am on the page with title "Part 2"
    And I edit its tags
    And I fill in "tags" with "hide me"
    And I press "Add Hidden Tags"
    And I am on the homepage
    And I fill in "page_url" with "http://test.sidrasue.com/parts"
    And I press "Find"
  Then I should see "Part 1"
    And I should see "Part 3"
    But I should NOT see "Part 2"
