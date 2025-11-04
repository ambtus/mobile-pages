Feature: ff.net specific stuff
         local because I never figured out how to fetch from ff.net

Scenario: fanfiction.net can't be fetched
  Given I am on the create single page
    And I fill in "page_title" with "Counting"
    And I fill in "page_url" with "https://www.fanfiction.net/s/5853866/1/Counting"
    And I store the page without refetching
  Then I should see "paste raw html manually" within "#flash_alert"
  And my page with title: "Counting" should have url: "https://www.fanfiction.net/s/5853866/1"
    But the contents should NOT include "Skip. Skip."

Scenario: fanfiction mobile url for book
  Given I am on the mini page
  When I fill in "page_url" with "https://m.fanfiction.net/s/5853866/1/Counting"
    And I store the page without refetching
  Then I should see "paste raw html manually" within "#flash_alert"
    And I should have 1 page
    And my page with title: "xyzzy" should have url: "https://www.fanfiction.net/s/5853866/1"

Scenario: fanfiction mobile url for chapter
  Given I am on the mini page
  When I fill in "page_url" with "https://m.fanfiction.net/s/5853866/2/Counting"
    And I store the page without refetching
  Then I should have 1 page
  And my page with title: "xyzzy" should have url: "https://www.fanfiction.net/s/5853866/2"

Scenario: check 1 before fanfiction.net can't be refetched
  Given skipping exists
  When I am on the first page's page
  Then the contents should include "Skip. Skip."

Scenario: check 2 before fanfiction.net can't be refetched
  Given skipping exists
  When I am on the first page's page
  Then "Original" should link to "https://www.fanfiction.net/s/5853866/1"

Scenario: check 3 before fanfiction.net can't be refetched
  Given skipping exists
  When I change its raw html to "system down"
  Then the contents should include "system down"
    And the contents should NOT include "Skip. Skip."

Scenario: check before fanfiction.net can't be refetched
  Given skipping exists
  When I change its raw html to "system down"
  Then the contents should include "system down"
    And the contents should NOT include "Skip. Skip."

