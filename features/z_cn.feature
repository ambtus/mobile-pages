Feature: download from cn

Scenario: grab a single
  Given "Teen Wolf" is a "Fandom"
    And "Claire Watson" is an "Author"
    And I am on the mini page
  When I fill in "page_url" with "http://clairesnook.com/fiction/the-secret-to-survivin/"
    And I press "Store"
  Then I should see "The Secret to Survivin’ (Single)" within ".title"
    And I should see "Teen Wolf" within ".fandoms"
    And I should see "Claire Watson" within ".authors"
    But I should NOT see "by Claire Watson" within ".notes"
    And I should NOT see "n/a" within ".notes"
    And I should see "A/U, Competence" within ".notes"
    And I should see "Derek will never be his mother, but that doesn’t mean he can’t learn to be a better alpha than what he started as." within ".notes"
    And I should see "Trope Bingo #Competence" within ".notes"
