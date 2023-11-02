Feature: filter/find

Scenario: Find by fandom and author
  Given the following pages
    | title                 | authors | fandoms                |
    | The Mysterious Affair | agatha christie   | mystery                |
    | Nancy Drew            | Carolyn Keene     | mystery, children      |
    | Not a Mystery         | agatha christie   | horror                 |
    | Still More Mysteries  | agatha christie   | mystery, short stories |
  When I am on the filter page
    And I select "agatha christie" from "Author"
    And I select "mystery" from "fandom"
    And I press "Find"
  Then I should see "The Mysterious Affair"
    And I should see "Still More Mysteries"
    But I should NOT see "Nancy Drew"
    And I should NOT see "Not a Mystery"

Scenario: find by fandom and pro
  Given the following pages
    | title                  | fandoms    | pros     |
    | Lord of the Rings      | fantasy    | adult    |
    | The Hobbit             | fantasy    | children |
    | Nancy Drew             | mystery    | children |
  When I am on the filter page
    And I select "fantasy" from "fandom"
    And I select "children" from "pro"
    And I press "Find"
  Then I should NOT see "Lord of the Rings"
    And I should NOT see "Nancy Drew"
    But I should see "The Hobbit" within "#position_1"

Scenario: find by fandom and info
  Given the following pages
    | title                  | fandoms          | infos    |
    | Mirror of Maybe        | snarry           | abc123   |
    | A Nick in Time         | snarry           | lmn345   |
    | A Single Love          | Harry/Tom        | lmn345   |
 When I am on the filter page
    And I select "snarry" from "fandom"
    And I select "lmn345" from "info"
    And I press "Find"
  Then I should see "A Nick in Time"
    But I should NOT see "Mirror of Maybe"
    And I should NOT see "A Single Love"

Scenario: find by fandom and hidden
  Given the following pages
    | title                            | fandoms                 | hiddens       |
    | The Mysterious Affair at Styles  | mystery                 | hide          |
    | Alice in Wonderland              | children                | hide, go away |
    | The Boxcar Children              | mystery, children       |               |
  When I am on the filter page
    And I select "mystery" from "Fandom"
    And I select "hide" from "Hidden"
    And I press "Find"
  Then I should see "The Mysterious Affair at Styles"
    But I should NOT see "Alice in Wonderland"
    And I should NOT see "The Boxcar Children"

Scenario: Find by unread and fandom
   Given the following pages
      | title               | fandoms  | stars | last_read  |
      | Nancy Drew          | children | 2     | 2009-02-01 |
      | The Boxcar Children | children |       |            |
      | To Read Mystery     | mystery  |       |            |
  When I am on the filter page
    And I select "children" from "fandom"
    And I click on "unread_Unread"
    And I press "Find"
  Then I should see "The Boxcar Children"
    But I should NOT see "To Read Mystery"
    And I should NOT see "Nancy Drew"

Scenario: Find by unread and pro
   Given the following pages
      | title                | pros   | stars| last_read  |
      | The Mysterious Affair| abc123 | 4    | 2009-01-01 |
      | The Boxcar Children  | lmn345 | 3    | 2009-02-01 |
      | To Read Mystery      | abc123 |      |            |
      | Orient Express       | abc123 | 2    | 2009-03-01 |
      | Surprise Island      | lmn345 |      |            |
  When I am on the filter page
    And I select "abc123" from "Pro"
    And I click on "unread_Unread"
    And I press "Find"
  Then I should see "To Read Mystery"
    But I should NOT see "The Mysterious Affair"
    And I should NOT see "The Boxcar Children"
    And I should NOT see "Orient Express"
    And I should NOT see "Surprise Island"

Scenario: Find by read and author
   Given the following pages
      | title                | authors                  | stars| last_read  |
      | The Mysterious Affair| agatha christie          | 4    | 2009-01-01 |
      | The Boxcar Children  | Gertrude Chandler Warner | 3    | 2009-02-01 |
      | To Read Mystery      | agatha christie          |      |            |
      | Orient Express       | agatha christie          | 2    | 2009-03-01 |
      | Surprise Island      | Gertrude Chandler Warner |      |            |
  When I am on the filter page
    And I select "agatha christie" from "Author"
    And I click on "unread_Read"
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
  When I am on the filter page
    And I select "children" from "info"
    And I click on "stars_Better"
    And I press "Find"
  Then I should see "The Boxcar Children"
    But I should NOT see "Nancy Drew"
    And I should NOT see "The Mysterious Affair"

Scenario: Find by stars and author
   Given the following pages
      | title                | authors           | stars | last_read  |
      | The Mysterious Affair| agatha christie   | 4     | 2009-01-01 |
      | Nancy Drew           | Carolyn Keene     | 2     | 2009-02-01 |
      | Orient Express       | agatha christie   | 2     | 2009-03-01 |
  When I am on the filter page
  When I click on "stars_Worse"
    And I select "agatha christie" from "Author"
    And I press "Find"
  Then I should see "Orient Express"
    But I should NOT see "The Mysterious Affair"
    And I should NOT see "Nancy Drew"

Scenario: interesting (3h, 4i, 5) but not hateful (3h)
  Given pages with all combinations of pros and cons exist
  When I am on the filter page
    And I select "interesting" from "pro"
    And I select "hateful" from "con"
    And I click on "selected_cons_exclude"
    And I press "Find"
  Then I should see "page4i"
    And I should see "page5"
    But the page should NOT contain css "#position_3"

Scenario: loving (3l, 4l, 5) but not boring (3l)
  Given pages with all combinations of pros and cons exist
  When I am on the filter page
    And I select "loving" from "pro"
    And I select "boring" from "con"
    And I click on "selected_cons_exclude"
    And I press "Find"
  Then I should see "page4l"
    And I should see "page5"
    But the page should NOT contain css "#position_3"

Scenario: mystery but not children
  Given the following pages
    | title                            | pros      | cons     |
    | The Mysterious Affair at Styles  | mystery   |          |
    | Alice in Wonderland              |           | children |
    | The Boxcar Children              | mystery   | children |
  When I am on the filter page
    And I select "mystery" from "pro"
    And I select "children" from "con"
    And I click on "selected_cons_exclude"
    And I press "Find"
  Then I should NOT see "The Boxcar Children"
    And I should NOT see "Alice in Wonderland"
    But I should see "The Mysterious Affair at Styles"

Scenario: no cons any pros
  Given pages with all combinations of pros and cons exist
  When I am on the filter page
    And I click on "show_pros_all"
    And I click on "show_cons_none"
    And I press "Find"
  Then I should see "page5"
    And I should see "page4i"
    And I should see "page4l"
    But I should NOT see "page3h"
    And I should NOT see "page3l"
    But I should NOT see "page3d"
    And I should NOT see "page2"
    And I should NOT see "page1"
    And the page should NOT contain css "#position_4"

Scenario: check before hiddens and pros
  Given a page exists with hiddens: "abc123" AND pros: "cba321" AND title: "Page1"
  When I am on the filter page
    And I select "cba321" from "pro"
    And I click on "show_hiddens_none"
    And I press "Find"
  Then the page should NOT contain css "#position_1"
    And I should see "No pages found"

Scenario: hiddens and pros
  Given a page exists with hiddens: "abc123" AND pros: "cba321" AND title: "Page1"
    And a page exists with hiddens: "abc123" AND pros: "xyz789" AND title: "Page2"
  When I am on the filter page
    And I click on "show_hiddens_all"
    And I select "cba321" from "pro"
    And I press "Find"
  Then I should see "Page1"
    But I should NOT see "Page2"

Scenario: hiddens and pros
  Given a page exists with hiddens: "abc123" AND pros: "cba321" AND title: "Page1"
    And a page exists with hiddens: "abc123" AND pros: "xyz789" AND title: "Page2"
  When I am on the filter page
    And I click on "show_pros_all"
    And I click on "show_hiddens_all"
    And I press "Find"
  Then I should see "Page1"
    And I should see "Page2"

Scenario: pro and hidden but not reader
  Given pages with all combinations of pros and cons and readers and hiddens exist
  When I am on the filter page
    And I select "interesting" from "pro"
    And I click on "show_readers_none"
    And I press "Find"
  Then I should see "pagep"
    And I should see "pagehp"
    But the page should NOT contain css "#position_3"
    And I should NOT see "pagepr"

Scenario: reader but not con
  Given pages with all combinations of pros and cons and readers and hiddens exist
  When I am on the filter page
    And I click on "show_readers_all"
    And I click on "show_cons_none"
    And I press "Find"
  Then I should see "pager"
    And I should see "pagepr"
    But the page should NOT contain css "#position_3"
    And I should NOT see "pagecr"

Scenario: all pros and readers
  Given pages with all combinations of pros and cons and readers and hiddens exist
  When I am on the filter page
    And I click on "show_pros_all"
    And I click on "show_readers_all"
    And I click on "show_cons_none"
    And I click on "show_hiddens_none"
    And I press "Find"
  Then I should see "pagepr"
    And the page should NOT contain css "#position_2"

