Feature: filter by unread (all, any, none, parts, either=default)

Scenario: check before filter (default)
  Given pages with all possible unreads exist
  When I am on the homepage
  Then I should see "not read single"
    And I should see "not read book"
    And I should see "not read series"
    And I should see "partially read book"
    And I should see "partially read series"
    And I should see "yes read single"
    And I should see "yes read book"
    And I should see "yes read series"

Scenario: any (unread or unread parts)
  Given pages with all possible unreads exist
  When I am on the homepage
    And I choose "unread_any"
    And I press "Find"
  Then I should see "not read single"
    And I should see "not read book"
    And I should see "not read series"
    And I should see "partially read book"
    And I should see "partially read series"
    But I should NOT see "yes read single"
    And I should NOT see "yes read book"
    And I should NOT see "yes read series"

Scenario: none (only fully-read)
  Given pages with all possible unreads exist
  When I am on the homepage
    And I choose "unread_none"
    And I press "Find"
  Then I should NOT see "not read single"
    And I should NOT see "not read book"
    And I should NOT see "not read series"
    And I should NOT see "partially read book"
    And I should NOT see "partially read series"
    But I should see "yes read single"
    And I should see "yes read book"
    And I should see "yes read series"

Scenario: all (filter out read and unread parts)
  Given pages with all possible unreads exist
  When I am on the homepage
    And I choose "unread_all"
    And I press "Find"
  Then I should see "not read single"
    And I should see "not read book"
    And I should see "not read series"
    But I should NOT see "partially read book"
    And I should NOT see "partially read series"
    And I should NOT see "yes read single"
    And I should NOT see "yes read book"
    And I should NOT see "yes read series"

Scenario: parts (filter out read and fully-unread)
  Given pages with all possible unreads exist
  When I am on the homepage
    And I choose "unread_parts"
    And I press "Find"
  Then I should NOT see "not read single"
    And I should NOT see "not read book"
    And I should NOT see "not read series"
    But I should see "partially read book"
    And I should see "partially read series"
    And I should NOT see "yes read single"
    And I should NOT see "yes read book"
    And I should NOT see "yes read series"
