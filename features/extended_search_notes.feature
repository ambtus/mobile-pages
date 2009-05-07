Feature: extended search on notes

  Scenario Outline: Find page by notes
    Given the following pages
      | title                                              | url                                   | notes                   |
      | A Christmas Carol by Charles Dickens               | http://www.rawbw.com/~alice/cc.html   | ghosts (not mysterious) |
      | The Call of the Wild by Jack London                | http://www.rawbw.com/~alice/cotw.html | dogs (no christmas)     |
      | The Mysterious Affair at Styles by Agatha Christie | http://www.rawbw.com/~alice/maas.html | poirot (wild!)          |
      And I am on the homepage
     When I fill in "search" with "<search>"
      And I press "Search"
     Then I should see "<title>" in ".title"

    Examples:
      | search     | title                            |
      | christmas  | A Christmas Carol                |
      | wild       | The Call of the Wild             |
      | mysterious | The Mysterious Affair at Styles  |
      | ghosts     | A Christmas Carol                |
      | dogs       | The Call of the Wild             |
      | poirot     | The Mysterious Affair at Styles  |
