Feature: filter/find

Scenario: find by character and trope
  Given the following pages
    | title                  | characters       | tropes   |
    | Mirror of Maybe        | snarry           | au       |
    | A Nick in Time         | snarry           | kidfic   |
    | A Single Love          | Harry/Tom        | kidfic   |
 When I am on the homepage
    And I select "snarry" from "character"
    And I select "kidfic" from "tag"
    And I press "Find"
  Then I should see "A Nick in Time"
    But I should NOT see "Mirror of Maybe"
    And I should NOT see "A Single Love"

Scenario: find by fandom and trope
  Given the following pages
    | title                  | fandoms    | tropes   |
    | Lord of the Rings      | fantasy    | adult    |
    | The Hobbit             | fantasy    | children |
    | Nancy Drew             | mystery    | children |
  When I am on the homepage
    And I select "fantasy" from "fandom"
    And I select "children" from "tag"
    And I press "Find"
  Then I should NOT see "Lord of the Rings"
    And I should NOT see "Nancy Drew"
    But I should see "The Hobbit" within "#position_1"

Scenario: find by fandom and hidden
  Given the following pages
    | title                            | fandoms                 | hiddens       |
    | The Mysterious Affair at Styles  | mystery                 | hide          |
    | Alice in Wonderland              | children                | hide, go away |
    | The Boxcar Children              | mystery, children       |               |
  When I am on the homepage
    And I select "mystery" from "Fandom"
    And I select "hide" from "Hidden"
    And I press "Find"
  Then I should see "The Mysterious Affair at Styles"
    But I should NOT see "Alice in Wonderland"
    And I should NOT see "The Boxcar Children"

Scenario: Find by author and fandom
  Given the following pages
    | title                 | authors | fandoms                |
    | The Mysterious Affair | agatha christie   | mystery                |
    | Nancy Drew            | Carolyn Keene     | mystery, children      |
    | Not a Mystery         | agatha christie   | horror                 |
    | Still More Mysteries  | agatha christie   | mystery, short stories |
  When I am on the homepage
    And I select "agatha christie" from "Author"
    And I select "mystery" from "fandom"
    And I press "Find"
  Then I should see "The Mysterious Affair"
    And I should see "Still More Mysteries"
    But I should NOT see "Nancy Drew"
    And I should NOT see "Not a Mystery"

Scenario: Find by unread and fandom
   Given the following pages
      | title               | fandoms  | stars | last_read  |
      | Nancy Drew          | children | 2     | 2009-02-01 |
      | The Boxcar Children | children |       |            |
      | To Read Mystery     | mystery  |       |            |
  When I am on the homepage
    And I select "children" from "fandom"
    And I choose "unread_all"
    And I press "Find"
  Then I should see "The Boxcar Children"
    But I should NOT see "To Read Mystery"
    And I should NOT see "Nancy Drew"

Scenario: Find by unread and author
   Given the following pages
      | title                | authors        | stars| last_read  |
      | The Mysterious Affair| agatha christie          | 4    | 2009-01-01 |
      | The Boxcar Children  | Gertrude Chandler Warner | 3    | 2009-02-01 |
      | To Read Mystery      | agatha christie          |      |            |
      | Orient Express       | agatha christie          | 2    | 2009-03-01 |
      | Surprise Island      | Gertrude Chandler Warner |      |            |
  When I am on the homepage
    And I select "agatha christie" from "Author"
    And I choose "unread_all"
    And I press "Find"
  Then I should see "To Read Mystery"
    But I should NOT see "The Mysterious Affair"
    And I should NOT see "The Boxcar Children"
    And I should NOT see "Orient Express"
    And I should NOT see "Surprise Island"

Scenario: Find by read and author
   Given the following pages
      | title                | authors        | stars| last_read  |
      | The Mysterious Affair| agatha christie          | 4    | 2009-01-01 |
      | The Boxcar Children  | Gertrude Chandler Warner | 3    | 2009-02-01 |
      | To Read Mystery      | agatha christie          |      |            |
      | Orient Express       | agatha christie          | 2    | 2009-03-01 |
      | Surprise Island      | Gertrude Chandler Warner |      |            |
  When I am on the homepage
    And I select "agatha christie" from "Author"
    And I choose "unread_none"
    And I press "Find"
  Then I should see "The Mysterious Affair"
    And I should see "Orient Express"
    But I should NOT see "To Read Mystery"
    And I should NOT see "Surprise Island"
    And I should NOT see "The Boxcar Children"

Scenario: Find by stars and info
   Given the following pages
      | title                | infos    | stars | last_read  |
      | The Mysterious Affair| mystery  | 4     | 2009-01-01 |
      | Nancy Drew           | children | 2     | 2009-02-01 |
      | The Boxcar Children  | children | 4     | 2009-03-01 |
  When I am on the homepage
    And I select "children" from "info"
    And I choose "stars_better"
    And I press "Find"
  Then I should see "The Boxcar Children"
    But I should NOT see "Nancy Drew"
    And I should NOT see "The Mysterious Affair"

Scenario: Find by stars and author
   Given the following pages
      | title                | authors | stars | last_read  |
      | The Mysterious Affair| agatha christie   | 4     | 2009-01-01 |
      | Nancy Drew           | Carolyn Keene     | 2     | 2009-02-01 |
      | Orient Express       | agatha christie   | 2     | 2009-03-01 |
  When I am on the homepage
  When I choose "stars_worse"
    And I select "agatha christie" from "Author"
    And I press "Find"
  Then I should see "Orient Express"
    But I should NOT see "The Mysterious Affair"
    And I should NOT see "Nancy Drew"

Scenario: interesting (3h, 4i, 5) but not hateful (3h)
  Given pages with ratings and omitteds exist
  When I am on the homepage
    And I select "interesting" from "rating"
    And I select "hateful" from "omitted"
    And I press "Find"
  Then I should see "page4i"
    And I should see "page5"
    But the page should NOT contain css "#position_3"

Scenario: loving (3l, 4l, 5) but not boring (3l)
  Given pages with ratings and omitteds exist
  When I am on the homepage
    And I select "loving" from "rating"
    And I select "boring" from "omitted"
    And I press "Find"
  Then I should see "page4l"
    And I should see "page5"
    But the page should NOT contain css "#position_3"

Scenario: mystery but not children
  Given the following pages
    | title                            | tropes    | omitteds |
    | The Mysterious Affair at Styles  | mystery   |          |
    | Alice in Wonderland              |           | children |
    | The Boxcar Children              | mystery   | children |
  When I am on the homepage
    And I select "mystery" from "tag"
    And I select "children" from "omitted"
    And I press "Find"
  Then I should NOT see "The Boxcar Children"
    And I should NOT see "Alice in Wonderland"
    But I should see "The Mysterious Affair at Styles"

