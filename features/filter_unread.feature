Feature: filter by unread (unread, unread parts, read)

Scenario: check before filter (default) pt1
  Given pages with all possible unreads exist
  When I am on the filter page
    And I press "Find"
  Then I should see "not read single"
    And I should see "not read book"
    And I should see "not read series"
    And I should see "partially read book"
    And I should see "partially read series"

Scenario: check before filter (default) pt2
  Given pages with all possible unreads exist
  When I am on the filter page
    And I press "Find"
    And I press "Next"
  Then I should see "yes read single"
    And I should see "yes read book"
    And I should see "yes read series"

Scenario: read (only fully-read)
  Given pages with all possible unreads exist
  When I am on the filter page
    And I choose "unread_Read"
    And I press "Find"
  Then I should NOT see "not read single"
    And I should NOT see "not read book"
    And I should NOT see "not read series"
    And I should NOT see "partially read book"
    And I should NOT see "partially read series"
    But I should see "yes read single"
    And I should see "yes read book"
    And I should see "yes read series"

Scenario: unread (filter out read and unread parts)
  Given pages with all possible unreads exist
  When I am on the filter page
    And I choose "unread_Unread"
    And I press "Find"
  Then I should see "not read single"
    And I should see "not read book"
    And I should see "not read series"
    But I should NOT see "partially read book"
    And I should NOT see "partially read series"
    And I should NOT see "yes read single"
    And I should NOT see "yes read book"
    And I should NOT see "yes read series"

Scenario: unread parts (filter out read and fully-unread)
  Given pages with all possible unreads exist
  When I am on the filter page
    And I choose "unread_Parts"
    And I press "Find"
  Then I should NOT see "not read single"
    And I should NOT see "not read book"
    And I should NOT see "not read series"
    But I should see "partially read book"
    And I should see "partially read series"
    And I should NOT see "yes read single"
    And I should NOT see "yes read book"
    And I should NOT see "yes read series"
