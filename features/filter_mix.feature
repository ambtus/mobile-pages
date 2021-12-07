Feature: filter/find

  Scenario: filter on mix of author, tag, and state
    Given the following pages
      | title                            | add_author_string        | tropes            | stars    | last_read  |
      | The Mysterious Affair at Styles  | agatha christie          | mystery           | 4        | 2009-01-01 |
      | Nancy Drew                       | Carolyn Keene            | mystery, children | 2        | 2009-02-01 |
      | The Boxcar Children              | Gertrude Chandler Warner | mystery, children |          |            |
      | Harry Potter                     | rowling                  | mystery, children | 4        | 2010-01-01 |
      | Murder on the Orient Express     | agatha christie          | mystery           | 5        | 2011-01-01 |
      | Another Mystery                  | agatha christie          | mystery           | 3        | 2009-01-02 |
      | To Read Mystery                  | agatha christie          | mystery           |          |            |
      | Still More Mysteries             | agatha christie          | mystery, short stories | 2   | 2009-01-04 |
    # Find all by author
    When I am on the homepage
      And I select "agatha christie" from "Author"
      And I select "mystery" from "tag"
      And I press "Find"
    Then I should see "The Mysterious Affair at Styles"
      And I should see "Murder on the Orient Express"
      And I should see "Another Mystery"
      And I should see "To Read Mystery"
      And I should see "Still More Mysteries"
      And I should NOT see "Nancy Drew"
      And I should NOT see "The Boxcar Children"
    # find unread by tag
    When I am on the homepage
      And I select "children" from "tag"
      And I choose "unread_yes"
      And I press "Find"
    Then I should see "The Boxcar Children"
      And I should NOT see "Nancy Drew"
      And I should NOT see "Harry Potter"
      And I should NOT see "To Read Mystery"

    # find unread by author
    When I am on the homepage
    When I choose "unread_yes"
      And I select "agatha christie" from "Author"
      And I press "Find"
    Then I should NOT see "Murder on the Orient Express"
      And I should NOT see "The Mysterious Affair at Styles"
      And I should NOT see "The Boxcar Children"
      And I should see "To Read Mystery"
    # find favorite by tag
    When I am on the homepage
      And I select "children" from "tag"
      And I choose "stars_better"
      And I press "Find"
    Then I should see "Harry Potter"
      And I should NOT see "The Boxcar Children"
      And I should NOT see "Nancy Drew"
      And I should NOT see "The Mysterious Affair at Styles"
      And I should NOT see "Murder on the Orient Express"
    # find favorite by author
    When I am on the homepage
    When I choose "stars_better"
      And I select "agatha christie" from "Author"
      And I press "Find"
    Then I should see "The Mysterious Affair at Styles"
      And I should see "Murder on the Orient Express"
      And I should NOT see "Still More Mysteries"
      And I should NOT see "Another Mystery"
      And I should NOT see "To Read Mystery"
      And I should NOT see "Harry Potter"
    # find not unread (i.e. read)
    When I am on the homepage
    When I choose "unread_no"
      And I press "Find"
    Then I should see "Murder on the Orient Express"
      And I should NOT see "The Boxcar Children"
      But I should see "The Mysterious Affair at Styles"
      And I should NOT see "To Read Mystery"
      And I should see "Nancy Drew"
    # find not unread by author
    When I am on the homepage
    When I choose "unread_no"
      And I select "agatha christie" from "Author"
      And I press "Find"
    Then I should see "Murder on the Orient Express"
      And I should see "The Mysterious Affair at Styles"
      And I should NOT see "To Read Mystery"
      And I should NOT see "Nancy Drew"
    # find favorite by author
    When I am on the homepage
      And I select "agatha christie" from "Author"
      And I choose "stars_3"
      And I press "Find"
    Then I should see "Another Mystery"
      And I should NOT see "Nancy Drew"
      And I should NOT see "The Mysterious Affair at Styles"
      And I should NOT see "Murder on the Orient Express"

