Feature: change filter button

Scenario: change author direct find
  Given the following pages
    | title                            | authors |
    | The Mysterious Affair at Styles  | agatha christie   |
    | Grimm's Fairy Tales              | grimm             |
    | Alice's Adventures In Wonderland | lewis carroll, charles dodgson |
    | Through the Looking Glass        | lewis carroll |
  When I am on the authors page
    And I follow "lewis carroll pages"
    And I press "Change Filter"
  Then "lewis carroll" should be selected in "Author"

Scenario: change author filter
  Given the following pages
    | title                            | authors |
    | The Mysterious Affair at Styles  | agatha christie   |
    | Grimm's Fairy Tales              | grimm             |
    | Alice's Adventures In Wonderland | lewis carroll, charles dodgson |
    | Through the Looking Glass        | lewis carroll |
  When I am on the filter page
    And I select "charles dodgson" from "Author"
    And I press "Find"
    And I press "Change Filter"
  Then "charles dodgson" should be selected in "Author"

Scenario: change author and info filter
  Given the following pages
    | title                            | authors | infos |
    | The Mysterious Affair at Styles  | agatha christie   | hello |
    | Grimm's Fairy Tales              | grimm             |  |
    | Alice's Adventures In Wonderland | lewis carroll, charles dodgson | hello |
    | Through the Looking Glass        | lewis carroll | |
  When I am on the filter page
    And I select "lewis carrol" from "Author"
    And I select "hello" from "Info"
    And I press "Find"
    And I press "Change Filter"
  Then "lewis carroll" should be selected in "Author"
    And "hello" should be selected in "Info"

Scenario: change author but not info
  Given the following pages
    | title                            | authors | infos |
    | The Mysterious Affair at Styles  | agatha christie   | hello |
    | The Oriental Express  | agatha christie   | |
    | Grimm's Fairy Tales              | grimm             |  |
    | Alice's Adventures In Wonderland | lewis carroll, charles dodgson | hello |
    | Through the Looking Glass        | lewis carroll | |
  When I am on the filter page
    And I select "lewis carrol" from "Author"
    And I select "hello" from "Info"
    And I press "Find"
    And I press "Change Filter"
    And I select "agatha christie"
    And I press "Find"
  Then I should see "The Mysterious Affair at Styles"
    But I should NOT see "Alice's Adventures In Wonderland"
    And I should NOT see "The Oriental Express"

Scenario: remove author should not persist
  Given the following pages
    | title                            | authors | infos |
    | The Mysterious Affair at Styles  | agatha christie   | hello |
    | Grimm's Fairy Tales              | grimm             | hello |
    | Alice's Adventures In Wonderland | lewis carroll, charles dodgson | hello |
    | Through the Looking Glass        | lewis carroll | |
  When I am on the filter page
    And I select "lewis carrol" from "Author"
    And I select "hello" from "Info"
    And I press "Find"
    And I press "Change Filter"
    And I select "" from "Author"
    And I press "Find"
  Then I should see "The Mysterious Affair at Styles"
    And I should see "Alice's Adventures In Wonderland"
    And I should see "Grimm's Fairy Tales"
    But I should NOT see "Through the Looking Glass"
    And the page should NOT contain css "#position_4"

Scenario: change author direct find and tag filter
  Given the following pages
    | title                            | authors |
    | The Mysterious Affair at Styles  | agatha christie   |
    | Grimm's Fairy Tales              | grimm             |
    | Alice's Adventures In Wonderland | lewis carroll, charles dodgson |
    | Through the Looking Glass        | lewis carroll |
  When I am on the authors page
    And I follow "lewis carroll pages"
    And I press "Change Filter"
    And I press "Find"
    And I press "Change Filter"
  Then "lewis carroll" should be selected in "Author"

Scenario: change title and pro filter
  Given the following pages
    | title                            | authors | pros |
    | The Mysterious Affair at Styles  | agatha christie   | hello |
    | Grimm's Fairy Tales              | grimm             |  |
    | Alice's Adventures In Wonderland | lewis carroll, charles dodgson | hello |
    | Through the Looking Glass        | lewis carroll | |
  When I am on the filter page
    And I fill in "page_title" with "the"
    And I select "hello" from "Pro"
    And I press "Find"
    And I press "Change Filter"
  Then "hello" should be selected in "Pro"
    And "the" should be entered in "page_title"

Scenario: change url and title
  Given the following pages
    | title                                  | url                                |
    | A Christmas Carol by Charles Dickens   | http://test.sidrasue.com/cc.html   |
    | The Call of the Wild by Jack London    | http://test.sidrasue.com/cotw.html |
    | The Mysterious Affair at Styles        | http://test.sidrasue.com/maas.html |
  When I am on the filter page
    And I fill in "page_url" with "test.sidrasue.com"
    And I fill in "page_title" with "by"
    And I press "Find"
    And I press "Change Filter"
  Then "by" should be entered in "page_title"
    And "test.sidrasue.com" should be entered in "page_url"

Scenario: change tag cache
  Given tags exist
    And Counting Drabbles exists
  When I am on the filter page
    And I fill in "page_tag_cache" with "Sidra, Popslash"
    And I click on "Series"
    And I press "Find"
    And I press "Change Filter"
  Then "Sidra, Popslash" should be entered in "page_tag_cache"
