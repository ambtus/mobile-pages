Feature: search on url

  Scenario: Find page by url 
    Given the following pages
      | title                                              | url                                |
      | A Christmas Carol by Charles Dickens               | http://test.sidrasue.com/cc.html   | 
      | The Call of the Wild by Jack London                | http://test.sidrasue.com/cotw.html | 
      | The Mysterious Affair at Styles by Agatha Christie | http://test.sidrasue.com/maas.html | 
    When I am on the homepage
      And I fill in "page_url" with "maas"
      And I press "Find"
    Then I should see "The Mysterious Affair at Styles" in "#position_1"
    When I am on the homepage
      And I fill in "page_url" with "cc"
      And I press "Find"
    Then I should see "A Christmas Carol" in "#position_1"
    When I am on the homepage
      And I fill in "page_url" with "cotw"
      And I press "Find"
    Then I should see "The Call of the Wild" in "#position_1"
    When I am on the homepage
      And I fill in "page_url" with "test.sidrasue.com"
      And I press "Find"
    Then I should see "The Mysterious Affair at Styles" in "#position_3"
      And I should see "The Call of the Wild" in "#position_2"
      And I should see "A Christmas Carol" in "#position_1"
