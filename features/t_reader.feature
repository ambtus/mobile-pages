Feature: reader stuff

Scenario: add reader to a page
  Given a page exists
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "opalsong, golb"
    And I press "Add Reader Tags"
  Then I should see "opalsong" within ".readers"
    And I should see "golb" within ".readers"

Scenario: create readers by adding them to a page
  Given a page exists
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "opalsong, golb"
    And I press "Add Reader Tags"
    And I am on the filter page
  Then I should be able to select "opalsong" from "Reader"
    And I should be able to select "golb" from "Reader"

Scenario: add an existing reader to a page
  Given a page exists
    And "opalsong" is a "Reader"
  When I am on the page's page
    And I edit its tags
    And I select "opalsong" from "page_reader_ids_"
    And I press "Update Tags"
  Then I should see "opalsong" within ".readers"

Scenario: add another reader to a page
  Given a page exists with readers: "opalson"
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "golb"
    And I press "Add Reader Tags"
  Then I should see "golb opalson" within ".readers"

Scenario: add another reader to a page
  Given a page exists with readers: "opalson"
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "golb"
    And I press "Add Reader Tags"
    And I am on the filter page
  Then I should be able to select "golb" from "Reader"

Scenario: new parent for an existing page should NOT have the same reader
  Given a page exists with readers: "sidra"
  When I am on the page's page
    And I add a parent with title "New Parent"
  Then I should NOT see "sidra" within ".readers"
    And I should see "Page 1" within ".parts"
    But I should see "sidra" within ".parts"

Scenario: list and edit the readers
  Given "opalsong" is a "Reader"
    And "golb" is an "Reader"
  When I am on the tags page
  Then I should see "opalsong"
    And I should see "golb"
  When I follow "opalsong"
    Then I should see "Edit tag: opalsong"

Scenario: edit the reader name
  Given a page exists with readers: "opalsong"
  When I am on the edit tag page for "opalsong"
    And I fill in "tag_name" with "Ekele"
    And I press "Update"
    And I am on the page's page
  Then I should see "Ekele" within ".readers"
    But I should NOT see "opalsong" within ".readers"

Scenario: edit the reader name
  Given a page exists with readers: "opalsong"
  When I am on the edit tag page for "opalsong"
    And I fill in "tag_name" with "Ekele"
    And I press "Update"
    And I am on the filter page
  Then I should be able to select "Ekele" from "Reader"
    But I should NOT be able to select "opalsong" from "Reader"

Scenario: delete a reader
  Given a page exists with readers: "opalsong"
  When I am on the edit tag page for "opalsong"
    And I follow "Destroy"
    And I press "Yes"
  Then I should have no readers

Scenario: delete a reader
  Given a page exists with readers: "opalsong"
  When I am on the edit tag page for "opalsong"
    And I follow "Destroy"
    And I press "Yes"
    And I am on the page's page
  Then I should NOT see "opalsong" within ".readers"
    But I should see "read by opalsong" within ".my_notes"
