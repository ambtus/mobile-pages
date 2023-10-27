Feature: MHT fics

Scenario: Early versions with nbsp;
  Given part 504 exists
  When I read it online

Scenario: Later versions with nbsp; and mso garbage
  Given part 604 exists
  When I read it online

Scenario: Latest versions with mso-spacerun
  Given part 889 exists
  When I read it online
