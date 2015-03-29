Feature: hiddens are just like genres, but they are hidden by default. The hidden collection is null during search, and anything with a hidden is not found. If something is chosen from hiddens, then it is found.

  Scenario: hidden selected
    Given a hidden exists with name: "nonfiction"
    Given a genre exists with name: "something"
      And I am on the homepage
      And I select "nonfiction" from "Hidden"
      And I select "something" from "genre"
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should not see "Please select genre"
      And I should see "nonfiction" within ".hiddens"

  Scenario: strip hidden whitespace
    Given a titled page exists
    When I go to the page's page
      And I follow "Hiddens"
      And I fill in "hiddens" with "  nonfiction,  audio  book,save for   later  "
      And I press "Add Hidden Genres"
    Then I should see "audio book, nonfiction, save for later" within ".hiddens"

  Scenario: add a hidden to a page when there are no hiddens
    Given a titled page exists
    When I am on the page's page
      And I follow "Hiddens"
    When I fill in "hiddens" with "nonfiction, audio book"
      And I press "Add Hidden Genres"
    Then I should see "nonfiction" within ".hiddens"
      And I should see "audio book" within ".hiddens"
    When I am on the homepage
    Then I select "nonfiction" from "Hidden"
    Then I select "audio book" from "Hidden"

  Scenario: select a hidden for a page when there are hiddens
    Given a hidden exists with name: "work in progress"
    And a titled page exists
    When I am on the page's page
    When I follow "Hiddens"
      And I select "work in progress" from "page_hidden_ids_"
      And I press "Update Hidden Genres"
    Then I should see "work in progress" within ".hiddens"

  Scenario: add a hidden to a page which has hiddens
    Given a titled page exists with add_hiddens_from_string: "nonfiction"
    When I am on the page's page
    Then I should see "nonfiction" within ".hiddens"
    When I follow "Hiddens"
      And I follow "Add Hidden Genres"
      And I fill in "hiddens" with "audio book, wip"
      And I press "Add Hidden Genres"
    Then I should see "audio book, nonfiction, wip" within ".hiddens"
    When I am on the homepage
    Then I select "nonfiction" from "Hidden"
      And I select "audio book" from "Hidden"
      And I select "wip" from "Hidden"

  Scenario: new parent for an existing page should have hidden
    Given a titled page exists with add_hiddens_from_string: "nonfiction"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    When I am on the page's page
      And I follow "New Parent"
    Then I should see "nonfiction" within ".hiddens"

  Scenario: list the hiddens
    Given a hidden exists with name: "audio book"
    When I am on the hidden's edit page
    And I fill in "hidden_name" with "audiobooked"
    And I press "Update"
    When I am on the homepage
      And I select "audiobooked" from "Hidden"

  Scenario: delete a hidden
    Given a hidden exists with name: "work in progress"
      And a titled page exists with add_hiddens_from_string: "work in progress"
    When I am on the hidden's edit page
    And I follow "Destroy"
    When I press "Yes"
    Then I should have no hiddens
    When I am on the homepage
      Then I should not see "work in progress"

  Scenario: merge two hiddens
    Given a hidden exists with name: "better name"
      And a titled page exists with add_hiddens_from_string: "bad name"
    When I go to the edit hidden page for "bad name"
      And I select "better name" from "merge"
      And I press "Merge"
    Then I should see "better name"
      And I should not see "bad name"
    When I am on the homepage
    And I select "better name" from "Hidden"
      And I press "Find"
    Then I should not see "No pages found"
      And I should see "better name" within ".hiddens"

  Scenario: hidden by default
    Given the following pages
      | title                            | add_hiddens_from_string  |
      | The Mysterious Affair at Styles  | mystery           |
      | Alice in Wonderland              | children          |
      | The Boxcar Children              | mystery, children |
    When I am on the homepage
    Then I should see "No pages found"
      And I should not see "The Mysterious Affair at Styles"
      And I should not see "The Boxcar Children"
      And I should not see "Alice in Wonderland"

  Scenario: hidden by default with genres
    Given the following pages
      | title                            | add_genres_from_string  | add_hiddens_from_string |
      | The Mysterious Affair at Styles  | mystery                 | hide |
      | Alice in Wonderland              | children                | hide, go away |
      | The Boxcar Children              | mystery, children       | |
    When I am on the homepage
    Then I should not see "No pages found"
      And I should see "The Boxcar Children"
      And I should not see "The Mysterious Affair at Styles"
      And I should not see "Alice in Wonderland"

  Scenario: find hidden
    Given the following pages
      | title                            | add_hiddens_from_string  |
      | The Mysterious Affair at Styles  | mystery           |
      | Alice in Wonderland              | children          |
      | The Boxcar Children              | mystery, children |
    When I am on the homepage
      And I select "children" from "Hidden"
      And I press "Find"
    Then I should see "Alice in Wonderland"
      And I should see "The Boxcar Children"
      But I should not see "The Mysterious Affair at Styles"

  Scenario: move to genre
    Given a hidden exists with name: "hidden name"
      And a titled page exists with add_hiddens_from_string: "hidden name"
    When I am on the homepage
    Then I should see "No pages found"
    When I go to the edit hidden page for "hidden name"
      And I press "Move to Genre"
    When I am on the homepage
    Then I should not see "No pages found"
      And I should have no hiddens
      And I select "hidden name" from "genre"
      And I press "Find"
    Then I should not see "No pages found"

