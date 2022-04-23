Feature: merging tags #TODO remove redundant tests

Scenario: merge two authors
  Given a page exists with authors: "jane" AND title: "Page 1"
    And a page exists with authors: "aka" AND title: "Page 2"
  When I am on the edit tag page for "aka"
    And I select "jane" from "merge"
    And I press "Merge"
  Then I should see "jane (aka)"

Scenario: merge two authors from original point of view
  Given a page exists with authors: "jane" AND title: "Page 1"
    And a page exists with authors: "aka" AND title: "Page 2"
  When I am on the edit tag page for "aka"
    And I select "jane" from "merge"
    And I press "Merge"
    And I am on the page with title "Page 1"
  Then I should see "jane" within ".authors"

Scenario: merge two authors from aka point of view
  Given a page exists with authors: "jane" AND title: "Page 1"
    And a page exists with authors: "aka" AND title: "Page 2"
  When I am on the edit tag page for "aka"
    And I select "jane" from "merge"
    And I press "Merge"
    And I am on the page with title "Page 2"
  Then I should see "jane" within ".authors"

Scenario: merge three author names
  Given a page exists with authors: "jane (june)" AND title: "Page 1"
    And a page exists with authors: "aka" AND title: "Page 2"
  When I am on the edit tag page for "aka"
    And I select "jane" from "merge"
    And I press "Merge"
  Then I should see "jane (aka, june)"

Scenario: merge three author names
  Given a page exists with authors: "jane (june)" AND title: "Page 1"
    And a page exists with authors: "aka" AND title: "Page 2"
  When I am on the edit tag page for "aka"
    And I select "jane" from "merge"
    And I press "Merge"
    And I am on the page with title "Page 2"
  Then I should see "jane" within ".authors"

Scenario: merge four author names
  Given a page exists with authors: "jane (june)" AND title: "Page 1"
    And a page exists with authors: "judy (aka)" AND title: "Page 2"
  When I am on the edit tag page for "judy (aka)"
    And I select "jane" from "merge"
    And I press "Merge"
  Then I should see "jane (aka, judy, june)"

Scenario: merge four author names
  Given a page exists with authors: "jane (june)" AND title: "Page 1"
    And a page exists with authors: "judy (aka)" AND title: "Page 2"
  When I am on the edit tag page for "judy (aka)"
    And I select "jane" from "merge"
    And I press "Merge"
    And I am on the page with title "Page 2"
  Then I should see "jane" within ".authors"

Scenario: merge two cons
  Given "abc123" is a "Con"
    And a page exists with cons: "xyz987"
  When I am on the edit tag page for "xyz987"
    And I select "abc123" from "merge"
    And I press "Merge"
  Then I should see "abc123 (xyz987)"

Scenario: merge two cons
  Given "abc123" is a "Con"
    And a page exists with cons: "xyz987"
  When I am on the edit tag page for "xyz987"
    And I select "abc123" from "merge"
    And I press "Merge"
    And I am on the page's page
  Then I should see "abc123" within ".cons"

Scenario: merge two fandoms
  Given "abc123" is a "Fandom"
    And a page exists with fandoms: "xyz987"
  When I am on the edit tag page for "xyz987"
    And I select "abc123" from "merge"
    And I press "Merge"
  Then I should see "abc123 (xyz987)"
    And I should have 1 tag

Scenario: merge two fandoms
  Given "abc123" is a "Fandom"
    And a page exists with fandoms: "xyz987"
  When I am on the edit tag page for "xyz987"
    And I select "abc123" from "merge"
    And I press "Merge"
    And I am on the page's page
  Then I should see "abc123" within ".fandoms"
    And I should have 1 tag

Scenario: merge two hiddens
  Given "abc123" is a "Hidden"
    And a page exists with hiddens: "xyz987"
  When I am on the edit tag page for "xyz987"
    And I select "abc123" from "merge"
    And I press "Merge"
  Then I should see "abc123 (xyz987)"

Scenario: merge two hiddens
  Given "abc123" is a "Hidden"
    And a page exists with hiddens: "xyz987"
  When I am on the edit tag page for "xyz987"
    And I select "abc123" from "merge"
    And I press "Merge"
    And I am on the page's page
  Then I should see "abc123" within ".hiddens"
    And the page should be hidden

Scenario: merge two infos
  Given "abc123" is an "Info"
    And a page exists with infos: "xyz987"
  When I am on the edit tag page for "xyz987"
    And I select "abc123" from "merge"
    And I press "Merge"
  Then I should see "abc123 (xyz987)"

Scenario: merge two infos
  Given "abc123" is an "Info"
    And a page exists with infos: "xyz987"
  When I am on the edit tag page for "xyz987"
    And I select "abc123" from "merge"
    And I press "Merge"
    And I am on the page's page
  Then I should see "abc123" within ".infos"

Scenario: merge two pros
  Given "abc123" is a "Pro"
    And a page exists with pros: "xyz987"
  When I am on the edit tag page for "xyz987"
    And I select "abc123" from "merge"
    And I press "Merge"
    And I am on the page's page
  Then I should see "abc123" within ".pros"

Scenario: don’t allow merge if not the same type
  Given "abc123" is a "Pro"
    And "xyz987" is a "Con"
  When I am on the edit tag page for "xyz987"
  Then I should NOT see "abc123"
    And I should NOT see "Merge"

Scenario: don’t allow merge if not the same type
  Given "abc123" is a "Pro"
    And a page exists with infos: "xyz987"
  When I am on the edit tag page for "xyz987"
    Then I should NOT see "abc123"
    And I should NOT see "Merge"

Scenario: don’t allow merge if not the same type
  Given "abc123" is a "Con"
    And "xyz987" is a "Pro"
  When I am on the edit tag page for "xyz987"
  Then I should NOT see "abc123"
    And I should NOT see "Merge"

Scenario: don’t allow merge if not the same type
  Given "abc123" is a "Pro"
    And "xyz987" is a "Hidden"
  When I am on the edit tag page for "xyz987"
  Then I should NOT see "abc123"
    And I should NOT see "Merge"

Scenario: don’t allow merge if not the same type
  Given "not fandom" is a "Pro"
    And "bad name" is a "Fandom"
  When I am on the edit tag page for "bad name"
  Then I should NOT see "not fandom"
    And I should NOT see "Merge"

