Feature: filter on multiple criteria

  Scenario: filter on mix of author, genre, and state
    Given I have no pages
    And the following pages
      | title                            | url                                   | last_read | add_author_string              | add_genre_string            |
      | The Mysterious Affair at Styles  | http://www.rawbw.com/~alice/maas.html | 2009-01-01 | agatha christie                | mystery           |
      | Alice's Adventures In Wonderland | http://www.rawbw.com/~alice/aa.html   | 2009-02-01 | lewis carroll, charles dodgson | fantasy, children |
      | Grimm's Fairy Tales              | http://www.rawbw.com/~alice/gft.html  |  | grimm                          | children, short stories     |
    When I am on the homepage
      And I select "agatha christie"
      And I select "mystery"
      And I press "Filter"
    Then I should see "The Mysterious Affair at Styles" in ".title"
    When I select "lewis carroll"
      And I press "Filter"
    Then I should not see "Alice's Adventures In Wonderland"
    And I should see "No page"
    And I should see "pages filtered by lewis carroll, mystery"
    When I am on the homepage
      And I select "lewis carroll"
      And I select "children"
      And I press "Filter"
    Then I should see "Alice's Adventures In Wonderland"
      And I should see "pages filtered by lewis carroll, children"
    When I select "unread"
      And I press "Filter"
    Then I should not see "Alice's Adventures In Wonderland"
      And I should see "No page"
      And I should see "pages filtered by unread, lewis carroll, children"
    When I select "grimm"
      And I press "Filter"
    Then I should see "Grimm's Fairy Tales"
    And I should see "pages filtered by unread, grimm, children"
