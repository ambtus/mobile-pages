Feature: download from wp

Scenario: grab a single from cn
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

Scenario: grab a single from km
  Given "Sentinel" is a "Fandom"
    And "Keira Marcos" is an "Author"
    And I am on the mini page
  When I fill in "page_url" with "https://keiramarcos.com/2009/03/the-awakening-part-one-five/"
    And I press "Store"
  Then I should see "The Awakening (Single)" within ".title"
    And I should see "Sentinel" within ".fandoms"
    And I should see "Keira Marcos" within ".authors"
    And I should see "Blair/Jim" within ".notes"
    And I should see "Detective Jim Ellison doesn’t want a Guide." within ".notes"
    But I should NOT see "by Keira Marcos" within ".notes"
