Feature: doesn't actually require an ao3 login, but it does do a remote ao3 fetch

Scenario: do NOT overwrite raw html if Single has been deleted
  Given The Right Path exists
  When I am on the page's page
    And I follow "Refetch"
    And I press "Refetch"
  Then I should see "error retrieving content" within "#flash_alert"
    And the contents should include "Ben Solo is ten years old"

Scenario: do NOT overwrite raw html if Book has been deleted
  Given Brave New World exists
  When I am on the page with title "Brave New World"
     And I follow "Refetch"
     And I press "Refetch"
  Then I should see "error retrieving content" within "#flash_alert"
    And the contents should include "With two sets of eyes on him now, Draco gulped"

Scenario: do NOT overwrite raw html if chapter of Book has been deleted
  Given Brave New World exists
  When I am on the page with title "Chapter 2"
     And I follow "Refetch"
     And I press "Refetch"
  Then I should see "error retrieving content" within "#flash_alert"
    And the contents should include "With two sets of eyes on him now, Draco gulped"

Scenario: do NOT overwrite raw html of parts if Book has been deleted
  Given Brave New World exists
  When I am on the page with title "Brave New World"
     And I follow "Refetch"
     And I press "Refetch Recursive"
  Then I should see "error retrieving content" within "#flash_alert"
    And the notes should include "Harry Potter"

Scenario: do NOT overwrite raw html if book of series has been deleted
  Given Iterum Rex exists
  When I am on the page with title "Brave New World"
     And I follow "Refetch"
     And I press "Refetch"
  Then I should see "error retrieving content" within "#flash_alert"
    And the contents should include "With two sets of eyes on him now, Draco gulped"

Scenario: do NOT overwrite raw html if book of series has been deleted
  Given Iterum Rex exists
  When I am on the page's page
     And I follow "Refetch"
     And I press "Refetch Recursive"
  Then I should see "error retrieving content" within "#flash_alert"
    And the contents should include "With two sets of eyes on him now, Draco gulped"

Scenario: do NOT lose information if series has been deleted before raw html exists
  Given Iterum Rex exists
  When I am on the page with title "Iterum Rex"
    And I press "Rebuild Meta"
  Then I should see "error retrieving content" within "#flash_alert"
    But I should see "Iterum Rex" within ".title"
    And I should see "by TardisIsTheOnlyWayToTravel" within ".notes"
    And I should see "Harry Potter, Arthurian Mythology & Related Fandoms" within ".notes"
    And I should see "Brave New World" within "#position_1"
    But I should NOT see "by TardisIsTheOnlyWayToTravel" within "#position_1"
    And I should NOT see "Harry Potter, Arthurian Mythology & Related Fandoms" within "#position_1"
    But I should see "Draco Malfoy, reluctant Death Eater" within "#position_1"


