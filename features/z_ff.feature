Feature: ff.net specific stuff

   Scenario: fanfiction.net can't be fetched
     Given I have no pages
    Given a tag exists with name: "mytag" AND type: "Fandom"
     When I am on the homepage
     And I select "mytag" from "fandom"
    And I fill in "page_title" with "Counting"
    And I fill in "page_url" with "https://www.fanfiction.net/s/5853866/1/Counting"
    And I press "Store"
    Then "Original" should link to "https://www.fanfiction.net/s/5853866/1/Counting"
    When I view the content
    Then I should see "edit raw html manually"
    Then I should NOT see "Skip. Skip."

   Scenario: fanfiction.net can't be refetched
     Given I have no pages
     And counting exists
    When I am on the page with title "Counting"
      And I view the content
     Then I should see "Skip. Skip."
    When I am on the page with title "Counting"
      Then "Original" should link to "https://www.fanfiction.net/s/5853866/1/Counting"
      And I follow "Edit Raw HTML"
      And I fill in "pasted" with "system down"
      And I press "Update Raw HTML"
    When I view the content
    Then I should see "system down" within ".content"
    When I am on the page with title "Counting"
    When I follow "Refetch"
    Then the "url" field should contain "https://www.fanfiction.net/s/5853866/1/Counting"
    When I press "Refetch"
    Then I should see "can't refetch from fanfiction.net"
    But I should NOT see "Base"
    When I view the content
    Then I should see "system down" within ".content"
     And I should NOT see "Skip. Skip."
     And I should NOT see "edit raw html manually"

   Scenario: fanfiction Share button gets cleaned
     Given I have no pages
     And counting exists
    When I am on the page with title "Counting"
      And I view the content
     Then I should see "Skip. Skip."
      But I should NOT see "Share"

   Scenario: fanfiction underline spans don't get cleaned
     Given I have no pages
     And part6 exists
    When I am on the page with title "Part 6"
      And I view the content
      Then I should NOT see "But I so I ,"
     But I should see "But I wasn't so I didn't,"

  Scenario: refetch from ao3 when it used to be somewhere else
    Given I have no pages
     And counting exists
      And I am on the page with title "Counting"
      Then I should see "Counting (Single)" within ".title"
      # Then I should see "ambtus" # TODO after add grabbing author from fanfiction
      # And I should see "2 connected drabbles" # TODO after add grabbing description from fanfiction
      When I view the content
      Then I should see "Skip."
    When I am on the page with title "Counting"
      And I follow "Refetch" within ".edits"
    When I fill in "url" with "http://archiveofourown.org/works/688"
      And I press "Refetch"
    Then I should see "by Sidra"
      And I should NOT see "ambtus"
      And I should see "Skipping Stones (Single)" within ".title"
      And I should see "thanks to lauriegilbert"
      When I view the content
      Then I should see "Skip."
