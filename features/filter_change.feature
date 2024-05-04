Feature: change filter button

Scenario: change author direct find
  Given the following pages
    | title                            | authors |
    | The Mysterious Affair at Styles  | agatha christie   |
    | Grimm's Fairy Tales              | grimm             |
    | Alice's Adventures In Wonderland | lewis carroll, charles dodgson |
    | Through the Looking Glass        | lewis carroll |
  When I am on the tags page
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

Scenario: change author direct find and tag filter
  Given the following pages
    | title                            | authors |
    | The Mysterious Affair at Styles  | agatha christie   |
    | Grimm's Fairy Tales              | grimm             |
    | Alice's Adventures In Wonderland | lewis carroll, charles dodgson |
    | Through the Looking Glass        | lewis carroll |
  When I am on the tags page
    And I follow "lewis carroll pages"
    And I press "Change Filter"
    And I press "Find"
    And I press "Change Filter"
  Then "lewis carroll" should be selected in "Author"
