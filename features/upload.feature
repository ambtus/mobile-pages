Feature: upload pre-made epub files

  Scenario: upload epub file and extract title and not existing author
    Given a genre exists with name: "popslash"
      And I am on the homepage
    When I attach the file "features/testfiles/book.epub" to "page_file"
      And I select "popslash" from "genre"
      And I press "Store"
    Then I should not see "Title can't be blank"
      And I should see "I Drive Myself: Crazy" within ".title"
      And I should see "by Sidra" within ".notes"
      And I should see "Uploaded short" within ".size"

  Scenario: upload epub file and extract title and existing author
    Given a genre exists with name: "popslash"
      And an author exists with name: "Sidra"
      And I am on the homepage
    When I attach the file "features/testfiles/book.epub" to "page_file"
      And I select "popslash" from "genre"
      And I press "Store"
    Then I should not see "Title can't be blank"
      And I should see "I Drive Myself: Crazy" within ".title"
      And I should see "Sidra" within ".authors"

  Scenario: upload epub file with entered notes and not existing author
    Given a genre exists with name: "popslash"
      And I am on the homepage
    When I attach the file "features/testfiles/book.epub" to "page_file"
      And I fill in "page_notes" with "my note"
      And I select "popslash" from "genre"
      And I press "Store"
    Then I should not see "Title can't be blank"
      And I should see "I Drive Myself: Crazy" within ".title"
      And I should see "by Sidra" within ".notes"
      And I should see "my note" within ".notes"

  Scenario: upload epub file with entered notes and existing author
    Given a genre exists with name: "popslash"
      And an author exists with name: "Sidra"
      And I am on the homepage
    When I attach the file "features/testfiles/book.epub" to "page_file"
      And I fill in "page_notes" with "my note"
      And I select "popslash" from "genre"
      And I press "Store"
    Then I should not see "Title can't be blank"
      And I should see "I Drive Myself: Crazy" within ".title"
      And I should see "Sidra" within ".authors"
      And I should see "my note" within ".notes"

