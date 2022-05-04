Feature: ff.net specific stuff
         local because I never figured out how to fetch from ff.net

Scenario: fanfiction meta
  Given counting exists
    And I am on the page with title "Counting"
  Then I should see "Counting (Single)" within ".title"
    # And I should see "ambtus" # TODO after add grabbing author from fanfiction
    # And I should see "2 connected drabbles" # TODO after add grabbing description from fanfiction

Scenario: fanfiction.net can't be fetched
  Given I am on the create page
    And I fill in "page_title" with "Counting"
    And I fill in "page_url" with "https://www.fanfiction.net/s/5853866/1/Counting"
    And I press "Store"
  Then "Original" should link to "https://www.fanfiction.net/s/5853866/1/Counting"
    And the contents should include "edit raw html manually"
    But the contents should NOT include "Skip. Skip."

Scenario: check before fanfiction.net can't be refetched
  Given counting exists
  When I am on the page with title "Counting"
  Then the contents should include "Skip. Skip."

Scenario: check before fanfiction.net can't be refetched
  Given counting exists
  When I am on the page with title "Counting"
    Then "Original" should link to "https://www.fanfiction.net/s/5853866/1/Counting"

Scenario: check before fanfiction.net can't be refetched
  Given counting exists
  When I change its raw html to "system down"
  Then the contents should include "system down"

Scenario: check before fanfiction.net can't be refetched
  Given counting exists
  When I change its raw html to "system down"
    And I follow "Refetch"
    And I press "Refetch"
  Then I should see "can't refetch from fanfiction.net"
    And I should NOT see "Fetched" within "#flash_notice"
    But I should NOT see "Base"
    And the contents should include "system down"
    But the contents should NOT include "Skip. Skip."
    And the contents should NOT include "edit raw html manually"

Scenario: fanfiction Share button gets cleaned
  Given counting exists
  When I am on the page with title "Counting"
  Then the contents should include "Skip. Skip."
    But the contents should NOT include "Share"

Scenario: fanfiction underline spans don't get cleaned
  Given underline spans exists
  When I am on the page with title "Part 6"
  Then the contents should NOT include "But I so I ,"
    But the contents should include "But I wasn't so I didn't,"
