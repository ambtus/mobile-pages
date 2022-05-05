Feature: fandoms are a type of tag, and can be created and selected like tags

Scenario: 陈情令 | The Untamed (TV)
  Given "Untamed (MoDao ZuShi)" is a "Fandom"
    And a page exists with inferred_fandoms: "陈情令 | The Untamed (TV)"
  When I am on the page's page
  Then I should see "Untamed" within ".fandoms"
    And I should NOT see "陈情令"
    And I should NOT see "TV"

Scenario: Marvel Cinematic Universe
  Given "Avengers (Marvel)" is a "Fandom"
    And a page exists with inferred_fandoms: "Marvel Cinematic Universe"
  When I am on the page's page
  Then I should see "Avengers" within ".fandoms"
    And I should NOT see "Cinematic Universe"

Scenario: 魔道祖师 - 墨香铜臭 | Módào Zǔshī - Mòxiāng Tóngxiù
  Given "Untamed (MoDao ZuShi)" is a "Fandom"
    And a page exists with inferred_fandoms: "魔道祖师 - 墨香铜臭 | Módào Zǔshī - Mòxiāng Tóngxiù"
  When I am on the page's page
  Then I should see "Untamed" within ".fandoms"
    And I should NOT see "魔道祖师"
    And I should NOT see "Mòxiāng"
    And I should NOT see "Módào"

Scenario: 魔道祖师 - 墨香铜臭 | Módào Zǔshī - Mòxiāng Tóngxiù, 陈情令 | The Untamed (TV)
  Given "Untamed (MoDao ZuShi)" is a "Fandom"
    And a page exists with inferred_fandoms: "魔道祖师 - 墨香铜臭 | Módào Zǔshī - Mòxiāng Tóngxiù, 陈情令 | The Untamed (TV)"
  When I am on the page's page
  Then I should see "Untamed" within ".fandoms"
    And I should NOT see "Modao Zshi" within ".notes"

Scenario: Forgotten Realms and The Legend of Drizzt Series - R. A. Salvatore
  Given "Drizzt (Forgotten Realms)" is a "Fandom"
    And a page exists with inferred_fandoms: "Forgotten Realms, The Legend of Drizzt Series - R. A. Salvatore"
  When I am on the page's page
  Then I should see "Drizzt" within ".fandoms"
    And I should NOT see "Legend of Drizzt Series"

Scenario: Spider-Man - All Media Types part 1
  Given a page exists with inferred_fandoms: "Spider-Man - All Media Types"
  When I am on the page's page
  Then I should see "Spider-Man" within ".notes"

Scenario: Spider-Man - All Media Types part 2
  Given "Spider-man" is a "Fandom"
    And a page exists with inferred_fandoms: "Spider-Man - All Media Types"
  When I am on the page's page
  Then I should see "Spider-man" within ".fandoms"
    But I should NOT see "Spider-Man" within ".notes"

Scenario: Deadpool (2016) and Deadpool - All Media Types part 1
  Given a page exists with inferred_fandoms: "Deadpool (2016), Deadpool - All Media Types"
  When I am on the page's page
  Then I should see "Deadpool" within ".notes"
    But I should NOT see "Deadpool, Deadpool"

Scenario: Deadpool (2016) and Deadpool and Spider-Man
  Given a page exists with inferred_fandoms: "Deadpool (2016), Deadpool - All Media Types, Spider-Man - All Media Types"
  When I am on the page's page
  Then I should see "Deadpool, Spider-Man" within ".notes"
    But I should NOT see "Deadpool, Deadpool"

Scenario: Scenario: Deadpool (2016) and Deadpool and Spider-Man
  Given "Marvel (Avengers, Deadpool, Spider-Man)" is a "Fandom"
    And a page exists with inferred_fandoms: "Deadpool (2016), Deadpool - All Media Types, Spider-Man - All Media Types"
  When I am on the page's page
  Then I should see "Marvel" within ".fandoms"
    And the notes should be empty

Scenario: Real Genius (1985)
  Given "Forgotten Realms (Drizzt)" is a "Fandom"
    And a page exists with inferred_fandoms: "Real Genius (1985)"
  When I am on the page's page
  Then I should NOT see "Forgotten Realms" within ".fandoms"
    But I should see "Real Genius" within ".notes"
    And I should NOT see "1985" within ".notes"

Scenario: 天官赐福 - 墨香铜臭 | Tiān Guān Cì Fú - Mòxiāng Tóngxiù and 天官赐福
  Given a page exists with inferred_fandoms: "天官赐福 - 墨香铜臭 | Tiān Guān Cì Fú - Mòxiāng Tóngxiù, 天官赐福"
  When I am on the page's page
  Then I should NOT see "Tian Guan Ci Fu, ????" within ".notes"
    And I should NOT see "Tiān Guān Cì Fú" within ".notes"
    But I should see "Tian Guan Ci Fu" within ".notes"

Scenario: star wars, not star trek
  Given "Star Trek" is a "Fandom"
    And "Battlestar Galactica" is a "Fandom"
    And "Starsky & Hutch" is a "Fandom"
    And "Star Wars" is a "Fandom"
    And a page exists with inferred_fandoms: "Star Wars - All Media Types, Star Wars Prequel Trilogy"
  When I am on the page's page
  Then I should see "Star Wars" within ".fandoms"
    But I should NOT see "Star Trek"
    And I should NOT see "Battlestar"
    And I should NOT see "Starsky"

