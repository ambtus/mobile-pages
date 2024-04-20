Feature: change tags after rating

Scenario: don't delete fandom
  Given "abc123" is a "Pro"
    And a page exists with fandoms: "Harry Potter"
  When I rate it 5 stars
    And I select "abc123" from "page_pro_ids_"
    And I submit the form
  Then I should see "abc123" within ".pros"
    And I should see "Harry Potter" within ".fandoms"

Scenario: or author
  Given "abc123" is a "Con"
    And a page exists with authors: "Sidra"
  When I rate it 3 stars
    And I select "abc123" from "page_con_ids_"
    And I submit the form
  Then I should see "abc123" within ".cons"
    And I should see "Sidra" within ".authors"
