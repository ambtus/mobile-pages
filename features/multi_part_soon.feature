Feature: soon status for parts and parents

Scenario: parts and parents can be different
  Given a series exists
  When I am on the page with title "Book1"
    And I follow "ePub"
  Then "Book1" should be "Reading" soon
    But "Series" should be "Default" soon

Scenario: parts should show, but not necessarily share, their parent's soon
  Given a series exists
    And I download its epub
  When I am on the page with title "Book1"
  Then "Book1" should be "Default" soon
    And "Series" should be "Reading" soon
    And "Default" should be checked
    But I should see "Reading" within ".parent"

Scenario: parts should show, but not necessarily share, their grand parent's soon
  Given a series exists
    And I download its epub
  When I am on the page with title "Prologue"
  Then "Default" should be checked
    But I should see "Reading" within ".parent"
