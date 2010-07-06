Feature: filter on multiple criteria

  Scenario: filter on mix of author, genre, and state
    Given the following pages
      | title                            | add_author_string        | add_genre_string  | favorite | last_read  | 
      | The Mysterious Affair at Styles  | Agatha Christie          | mystery           | true     | 2009-01-01 | 
      | Murder on the Orient Express     | Agatha Christie          | mystery           | false    | 2010-01-01 | 
      | Ten Little Indians               | Agatha Christie          | mystery           | false    |            | 
      | The Boxcar Children              | Gertrude Chandler Warner | mystery, children | true     | 2007-01-01 | 
      | Surprise Island                  | Gertrude Chandler Warner | mystery, children | false    |            | 
    When I am on the homepage
      And I choose "sort_by_last_read"
      And I press "Find"
    Then I should see "The Boxcar Children" within "#position_1"
      And I should see "The Mysterious Affair at Styles" within "#position_2"
      And I should see "Murder on the Orient Express" within "#position_3"
      And I should not see "Ten Little Indians"
      And I should not see "Surprise Island"
