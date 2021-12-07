Feature: filter/find by url

  Scenario: Find page by url
    Given the following pages
      | title                                  | url                                |
      | A Christmas Carol by Charles Dickens   | http://test.sidrasue.com/cc.html   |
      | The Call of the Wild by Jack London    | http://test.sidrasue.com/cotw.html |
      | The Mysterious Affair at Styles        | http://test.sidrasue.com/maas.html |
    When I am on the homepage
      And I fill in "page_url" with "maas"
      And I press "Find"
    Then I should see "The Mysterious Affair at Styles" within "#position_1"
    When I am on the homepage
      And I fill in "page_url" with "cc"
      And I press "Find"
    Then I should see "A Christmas Carol" within "#position_1"
    When I am on the homepage
      And I fill in "page_url" with "cotw"
      And I press "Find"
    Then I should see "The Call of the Wild" within "#position_1"

    When I am on the homepage
      And I fill in "page_url" with "test.sidrasue.com"
      And I press "Find"
    Then I should see "The Mysterious Affair at Styles" within "#position_3"
      And I should see "The Call of the Wild" within "#position_2"
      And I should see "A Christmas Carol" within "#position_1"

    When I follow "The Mysterious Affair at Styles"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Mysteries"
      And I press "Update"
    When I am on the homepage
      And I fill in "page_url" with "maas"
      And I press "Find"
    Then I should see "The Mysterious Affair at Styles of Mysteries" within "#position_1"

    When I am on the homepage
      And I fill in "page_url" with "http://test.sidrasue.com/cc.html"
      And I press "Find"
      Then I should see "A Christmas Carol by Charles Dickens (Single)" within ".title"

    When I am on the homepage
      And I fill in "page_url" with "http://test.sidrasue.com/maas.html"
      And I press "Find"
      Then I should see "The Mysterious Affair at Styles (Chapter)" within ".title"
