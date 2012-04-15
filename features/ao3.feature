Feature: ao3 specific stuff

  Scenario: grab title
    Given a genre exists with name: "popslash"
      And I am on the homepage
    When I fill in "page_url" with "http://archiveofourown.org/works/68481"
      And I select "popslash" from "genre"
      And I press "Store"
    Then I should not see "Title can't be blank"
      And I should see "I Drive Myself Crazy"
