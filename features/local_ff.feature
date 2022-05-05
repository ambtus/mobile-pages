Feature: ff.net specific stuff
         local because I never figured out how to fetch from ff.net

Scenario: fanfiction Single meta
  Given skipping exists
    And I am on the page's page
  Then I should see "Skipping Stones (Single)" within ".title"
    But I should NOT see "1. " within ".title"
    And I should see "by ambtus" within ".notes"
    And I should see "Harry Potter" within ".notes"
    And I should see "2 connected drabbles" within ".notes"

Scenario: fanfiction Book meta
  Given counting exists
    And I am on the page's page
  Then I should see "Counting (Book)" within ".title"
    And I should see "by ambtus" within ".notes"
    And I should see "Harry Potter" within ".notes"
    And I should see "2 connected drabbles" within ".notes"
    And I should see "Skipping Stones (unread, 100 words)" within "#position_1"
    And I should see "The Flower (unread, 100 words)" within "#position_2"
    But I should NOT see "ambtus" within ".parts"
    And I should NOT see "Harry Potter" within ".parts"
    And I should NOT see "2 connected drabbles" within ".parts"

Scenario: fanfiction Book meta
  Given counting exists
    And I am on the page's page
  Then I should see ""

Scenario: fanfiction.net can't be fetched
  Given I am on the create page
    And I fill in "page_title" with "Counting"
    And I fill in "page_url" with "https://www.fanfiction.net/s/5853866/1/Counting"
    And I press "Store"
  Then I should see "edit raw html manually" within "#flash_alert"
    And "Original" should link to "https://www.fanfiction.net/s/5853866/1/Counting"
    But the contents should NOT include "Skip. Skip."

Scenario: check 1 before fanfiction.net can't be refetched
  Given skipping exists
  When I am on the page's page
  Then the contents should include "Skip. Skip."

Scenario: check 2 before fanfiction.net can't be refetched
  Given skipping exists
  When I am on the page's page
  Then "Original" should link to "https://www.fanfiction.net/s/5853866/1/Counting"

Scenario: check 3 before fanfiction.net can't be refetched
  Given skipping exists
  When I change its raw html to "system down"
  Then the contents should include "system down"
    And the contents should NOT include "Skip. Skip."

Scenario: check before fanfiction.net can't be refetched
  Given skipping exists
  When I change its raw html to "system down"
    And I follow "Refetch"
    And I press "Refetch"
  Then I should see "can't refetch from fanfiction.net"
    And I should NOT see "Fetched" within "#flash_notice"
    And the contents should include "system down"
    But the contents should NOT include "Skip. Skip."

Scenario: fanfiction Share button gets cleaned
  Given skipping exists
  Then the contents should include "Skip. Skip."
    But the contents should NOT include "Share"

Scenario: fanfiction underline spans don't get cleaned
  Given He Could Be A Zombie exists
  Then the contents should NOT include "But I so I ,"
    But the contents should include "But I wasn't so I didn't,"

