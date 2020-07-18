Feature: an ebook with a relationship tag is collected by series (not subjects) for marvin

  Scenario: one relationship, no fandoms => relationship in series
    Given a page exists with relationships: "snarry" AND tags: "AU"
    Then the download epub command should include series: "snarry"
    And the download epub command should include tags: "AU"
    But the download epub command should NOT include tags: "snarry"
    And the download epub command should NOT include series: "AU"
    And the download epub command should include comments: "snarry, AU"

  Scenario: one fandom, one relationship => relationship in series
    Given a page exists with fandoms: "Harry Potter" AND relationships: "snarry"
    Then the download epub command should include series: "snarry"
    And the download epub command should NOT include tags: "Harry Potter"
    And the download epub command should NOT include series: "Harry Potter"
    But the download epub command should NOT include tags: "snarry"
    And the download epub command should include comments: "Harry Potter, snarry"

  Scenario: one fandom, many relationships => fandom in series
    Given a page exists with fandoms: "Harry Potter" AND relationships: "twincest, snarry"
    Then the download epub command should include series: "Harry Potter"
    And the download epub command should NOT include tags: "Harry Potter"
    But the download epub command should NOT include tags: "snarry"
    And the download epub command should NOT include series: "twincest"
    And the download epub command should include comments: "Harry Potter, snarry, twincest"
    But the download epub command should NOT include comments: "crossover"

  Scenario: many fandoms, one relationship => relationship in series
    Given a page exists with fandoms: "harry potter, sga" AND relationships: "harry/snape"
    Then the download epub command should NOT include series: "crossover"
    And the download epub command should NOT include series: "harry potter"
    But the download epub command should include series: "harry/snape"
    And the download epub command should include comments: "harry potter, sga, harry/snape"
    But the download epub command should NOT include comments: "crossover"

  Scenario: many fandoms, many relationships => "crossover" in series
    Given a page exists with fandoms: "harry potter, sga" AND relationships: "harry/snape, john/rodney"
    Then the download epub command should include series: "crossover"
    But the download epub command should NOT include tags: "harry potter"
    And the download epub command should NOT include series: "harry potter"
    And the download epub command should NOT include series: "harry/snape"
    And the download epub command should include comments: "harry potter, sga, harry/snape, john/rodney"
    But the download epub command should NOT include comments: "crossover"
