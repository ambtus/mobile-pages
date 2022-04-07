Feature: ff.net specific stuff

Scenario: fanfiction meta
  Given counting exists
    And I am on the page with title "Counting"
  Then I should see "Counting (Single)" within ".title"
    # And I should see "ambtus" # TODO after add grabbing author from fanfiction
    # And I should see "2 connected drabbles" # TODO after add grabbing description from fanfiction

Scenario: fanfiction.net can't be fetched
  Given I am on the homepage
    And I fill in "page_title" with "Counting"
    And I fill in "page_url" with "https://www.fanfiction.net/s/5853866/1/Counting"
    And I press "Store"
  Then "Original" should link to "https://www.fanfiction.net/s/5853866/1/Counting"
    And my page named "Counting" should contain "edit raw html manually"
    And my page named "Counting" should NOT contain "Skip. Skip."

Scenario: check before fanfiction.net can't be refetched
  Given counting exists
  When I am on the page with title "Counting"
    And I view the content
  Then I should see "Skip. Skip."

Scenario: check before fanfiction.net can't be refetched
  Given counting exists
  When I am on the page with title "Counting"
    Then "Original" should link to "https://www.fanfiction.net/s/5853866/1/Counting"

Scenario: check before fanfiction.net can't be refetched
  Given counting exists
  When I am on the page with title "Counting"
    And I follow "Edit Raw HTML"
    And I fill in "pasted" with "system down"
    And I press "Update Raw HTML"
    And I view the content
  Then I should see "system down" within ".content"

Scenario: check before fanfiction.net can't be refetched
  Given counting exists
  When I am on the page with title "Counting"
    And I follow "Edit Raw HTML"
    And I fill in "pasted" with "system down"
    And I press "Update Raw HTML"
  When I follow "Refetch"
    And I press "Refetch"
  Then I should see "can't refetch from fanfiction.net"
    And I should NOT see "Fetched" within "#flash_notice"
    But I should NOT see "Base"
    And my page named "Counting" should contain "system down"
    And my page named "Counting" should NOT contain "Skip. Skip."
    And my page named "Counting" should NOT contain "edit raw html manually"

Scenario: fanfiction Share button gets cleaned
  Given counting exists
  When I am on the page with title "Counting"
    And I view the content
  Then I should see "Skip. Skip."
    But I should NOT see "Share"

Scenario: fanfiction underline spans don't get cleaned
  Given part6 exists
  When I am on the page with title "Part 6"
    And I view the content
  Then I should NOT see "But I so I ,"
    But I should see "But I wasn't so I didn't,"

