Feature: no longer fetch from ao3

Scenario: create empty series
  Given I am on the mini page
    And I fill in "page_url" with "https://archiveofourown.org/series/46"
    And I store the page without refetching
  Then my page with title: 'xyzzy' should have url: "https://archiveofourown.org/series/46"
    And I should have 1 page
    And I should see "xyzzy (Series)"

Scenario: create empty book
  Given I am on the mini page
    And I fill in "page_url" with "https://archiveofourown.org/works/688"
    And I store the page without refetching
  Then my page with title: 'xyzzy' should have url: "https://archiveofourown.org/works/688"
    And I should have 1 page
    And I should see "xyzzy (Book)"

Scenario: create empty single
  Given I am on the mini page
    And I fill in "page_url" with "https://archiveofourown.org/works/688"
    And I store the page without refetching
    And I press "Decrease Type"
  Then I should have 1 page
    And I should see "xyzzy (Single)"

Scenario: create empty single
  Given I am on the mini page
    And I fill in "page_url" with "https://archiveofourown.org/works/692/chapters/803"
    And I store the page without refetching
  Then I should have 1 page
    And my page with title: 'xyzzy' should have url: "https://archiveofourown.org/works/692/chapters/803"
    And I should see "paste raw html"

