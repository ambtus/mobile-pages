Feature: filter/find

  Scenario: children should not show up on front page by themselves
    Given a page exists with title: "Parent", urls: "http://test.sidrasue.com/parts/1.html\nhttp://test.sidrasue.com/parts/2.html"
    When I am on the homepage
    Then I should see "Parent" within ".title"
    And I should see "Part 1 | Part 2"

  Scenario: filter on mix of author, genre, and state
    Given the following pages
      | title                            | add_author_string        | add_genres_from_string        | favorite | last_read  |
      | The Mysterious Affair at Styles  | agatha christie          | mystery           | 1        | 2009-01-01 |
      | Nancy Drew                       | Carolyn Keene            | mystery, children | 3        | 2009-02-01 |
      | The Boxcar Children              | Gertrude Chandler Warner | mystery, children | 0        |            |
      | Harry Potter                     | rowling                  | mystery, children | 1        | 2010-01-01 |
      | Murder on the Orient Express     | agatha christie          | mystery           | 0        | 2011-01-01 |
      | Another Mystery                  | agatha christie          | mystery           | 2        | 2009-01-02 |
      | To Read Mystery                  | agatha christie          | mystery           | 0        |            |
      | Still More Mysteries             | agatha christie          | mystery, short stories | 3   | 2009-01-04 |
    # Find all by author
    When I am on the homepage
      And I select "agatha christie" from "Author"
      And I select "mystery" from "genre"
      And I press "Find"
    Then I should see "The Mysterious Affair at Styles" within "#position_1"
      And I should see "Murder on the Orient Express" within "#position_2"
      And I should see "Another Mystery" within "#position_3"
      And I should see "To Read Mystery" within "#position_4"
      And I should see "Still More Mysteries" within "#position_5"
      And I should not have a "#position_6" field
      And I should not see "Nancy Drew"
      And I should not see "The Boxcar Children"
    # find unread by genre
    When I am on the homepage
      And I select "children" from "genre"
      And I choose "unread_yes"
      And I press "Find"
    Then I should see "The Boxcar Children"
      And I should not see "Nancy Drew"
      And I should not see "The Mysterious Affair at Styles"
      And I should not see "Murder on the Orient Express"
    # find unread by author
    When I am on the homepage
    When I choose "unread_yes"
      And I select "agatha christie" from "Author"
      And I press "Find"
    Then I should not see "Murder on the Orient Express"
      And I should not see "The Mysterious Affair at Styles"
      And I should not see "The Boxcar Children"
      And I should see "To Read Mystery"
    # find favorite by genre
    When I am on the homepage
      And I select "children" from "genre"
      And I choose "favorite_yes"
      And I press "Find"
    Then I should see "Harry Potter"
      And I should not see "The Boxcar Children"
      And I should not see "Nancy Drew"
      And I should not see "The Mysterious Affair at Styles"
      And I should not see "Murder on the Orient Express"
    # find favorite by author
    When I am on the homepage
    When I choose "favorite_yes"
      And I select "agatha christie" from "Author"
      And I press "Find"
    Then I should see "The Mysterious Affair at Styles"
      And I should see "Murder on the Orient Express"
      And I should not see "Still More Mysteries"
      And I should not see "Another Mystery"
      And I should not see "To Read Mystery"
      And I should not see "Harry Potter"
    # find not unread (i.e. read)
    When I am on the homepage
    When I choose "unread_no"
      And I press "Find"
    Then I should see "Murder on the Orient Express"
      And I should not see "The Boxcar Children"
      But I should see "The Mysterious Affair at Styles"
      And I should not see "To Read Mystery"
      And I should see "Nancy Drew"
    # find not unread by author
    When I am on the homepage
    When I choose "unread_no"
      And I select "agatha christie" from "Author"
      And I press "Find"
    Then I should see "Murder on the Orient Express"
      And I should see "The Mysterious Affair at Styles"
      And I should not see "To Read Mystery"
      And I should not see "Nancy Drew"
    # find favorite by author
    When I am on the homepage
      And I select "agatha christie" from "Author"
      And I choose "favorite_good"
      And I press "Find"
    Then I should see "Another Mystery"
      And I should not see "Nancy Drew"
      And I should not see "The Mysterious Affair at Styles"
      And I should not see "Murder on the Orient Express"

  Scenario: Find page by url
    Given the following pages
      | title                                              | url                                |
      | A Christmas Carol by Charles Dickens               | http://test.sidrasue.com/cc.html   |
      | The Call of the Wild by Jack London                | http://test.sidrasue.com/cotw.html |
      | The Mysterious Affair at Styles by Agatha Christie | http://test.sidrasue.com/maas.html |
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
    Then I should see "The Mysterious Affair at Styles" within "#position_1"
