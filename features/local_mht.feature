Feature: MHT fics

Scenario: Early versions with nbsp;
  Given part 504 exists
  When I read it online
  Then it should have 14 horizontal rules
    And I should NOT see "503"
    But I should see "The door had been left"
    And I should NOT see "505"
    But I should see "“Congratulations.”"

Scenario: Later versions with nbsp; and mso garbage
  Given part 604 exists
  When I read it online
  Then it should have 5 horizontal rules
    And I should NOT see "603"
    But I should see "The sun was just rising."
    And I should see "“Anosukinom?”"
    And I should NOT see "605"
    But I should see "what might come next?"

Scenario: Latest versions with mso-spacerun
  Given part 889 exists
  When I read it online
  Then it should have 6 horizontal rules
    And I should NOT see "888"
    But I should see "“Have you put your new clothes away?”"
    And I should NOT see "890"
    But I should see "Ahiha burst into tears."

Scenario: early version with an authors note
  Given part 9 exists
  When I read it online
  Then it should have 3 horizontal rules
    And I should NOT see "part eight"
# But I should see "Note: You won't need to retain the names" # comes before the header
    But I should see "After speaking with Kudorin"
    And I should NOT see "part ten"
    But I should see "“I think that I will.”"

Scenario: mid versions with an authors note
  Given part 606 exists
  When I read it online
  Then it should have 8 horizontal rules
    And I should NOT see "605"
    But I should see "From ITL 78: Before Remin’s eyes"
    But I should see "The back of Xio Voe’s neck prickled."
    And I should NOT see "607"
    But I should see "pulse around the edges of the doors."


Scenario: last version with an authors note
  Given part 831 exists
  When I read it online
  Then it should have 6 horizontal rules
    And I should NOT see "830"
    But I should see "I’ve been posting up some new short stories here and there"
    But I should see "Late that evening"
    And I should NOT see "832"
    But I should see "Taking it, he grinned. “Thanks.”"
