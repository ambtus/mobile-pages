Feature: filter on multiple criteria

  Scenario: filter on mix of author, genre, and state
    Given the following pages
      | title                            | add_author_string        | add_genre_string  | favorite | last_read  | 
      | The Mysterious Affair at Styles  | agatha christie          | mystery           | true     | 2009-01-01 | 
      | Nancy Drew                       | Carolyn Keene            | mystery, children | false    | 2009-02-01 | 
      | The Boxcar Children              | Gertrude Chandler Warner | mystery, children | true     |            | 
      | Murder on the Orient Express     | agatha christie          | mystery           | false    |            | 
    When I am on the homepage
      And I select "agatha christie"
      And I select "mystery"
      And I press "Find"
    Then I should see "The Mysterious Affair at Styles"
      And I should see "Murder on the Orient Express"
      And I should not see "Nancy Drew"
      And I should not see "The Boxcar Children"
    When I am on the homepage
      And I select "children"
      And I select "unread"
      And I press "Find"
    Then I should see "The Boxcar Children"
      And I should not see "Nancy Drew"
      And I should not see "The Mysterious Affair at Styles"
      And I should not see "Murder on the Orient Express"
    When I am on the homepage
    When I select "unread"
      And I select "agatha christie"
      And I press "Find"
    Then I should see "Murder on the Orient Express"
      And I should not see "The Mysterious Affair at Styles"
      And I should not see "Nancy Drew"
      And I should not see "The Boxcar Children"
    When I am on the homepage
      And I select "children"
      And I select "favorite"
      And I press "Find"
    Then I should see "The Boxcar Children"
      And I should not see "Nancy Drew"
      And I should not see "The Mysterious Affair at Styles"
      And I should not see "Murder on the Orient Express"
    When I am on the homepage
    When I select "favorite"
      And I select "agatha christie"
      And I press "Find"
    Then I should see "The Mysterious Affair at Styles"
      And I should not see "Murder on the Orient Express"
      And I should not see "Nancy Drew"
      And I should not see "The Boxcar Children"
    When I am on the homepage
    When I select "reread"
      And I press "Find"
    Then I should not see "Murder on the Orient Express"
      And I should see "The Mysterious Affair at Styles"
      And I should see "Nancy Drew"
      And I should not see "The Boxcar Children"
    When I am on the homepage
    When I select "reread"
      And I select "agatha christie"
      And I press "Find"
    Then I should not see "Murder on the Orient Express"
      And I should see "The Mysterious Affair at Styles"
      And I should not see "Nancy Drew"
      And I should not see "The Boxcar Children"
