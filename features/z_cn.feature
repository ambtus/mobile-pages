Feature: download from wp

Scenario: grab a single
  Given "Harry Potter" is a "Fandom"
    And "Claire Watson" is an "Author"
    And I am on the mini page
  When I fill in "page_url" with "http://clairesnook.com/evil-author-day/serendipity-ead-2022/"
    And I press "Store"
  Then I should see "Serendipity (Single)" within ".title"
    And I should see "Harry Potter" within ".fandoms"
    And I should see "Claire Watson" within ".authors"
    And I should see "Fix-it" within ".pros"
    And I should see "Harry Potter & Sirius Black" within ".notes"
    And I should see "Harry Potter notices things." within ".notes"
    And I should see "Canon Divergent" within ".notes"
    But I should NOT see "by Claire Watson" within ".notes"
    And I should NOT see "Fix-it" within ".notes"

