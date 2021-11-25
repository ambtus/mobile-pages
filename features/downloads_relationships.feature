Feature: an ebook with a relationship tag is added to tags for marvin

  Scenario: one relationship, no fandoms => relationship in tags
    Given I have no pages
    And a page exists with relationships: "snarry" AND tropes: "AU"
    Then the download epub command should include tags: "snarry"
    And the download epub command should include tags: "AU"
    But the download epub command should NOT include series: "snarry"
    And the download epub command should NOT include series: "AU"
    And the download epub command should include comments: "snarry, AU"

  Scenario: one fandom, one relationship => relationship in tags, fandom in authors
    Given I have no pages
    And a page exists with fandoms: "Harry Potter" AND relationships: "snarry"
    Then the download epub command should include tags: "snarry"
    And the download epub command should NOT include tags: "Harry Potter"
    And the download epub command should include authors: "Harry Potter"
    But the download epub command should NOT include authors: "snarry"
    And the download epub command should include comments: "snarry"
    And the download epub command should NOT include comments: "Harry Potter"

  Scenario: one fandom, many relationships => fandom in authors, relationships in tags
    Given I have no pages
    And a page exists with fandoms: "Harry Potter" AND relationships: "twincest, snarry"
    Then the download epub command should include authors: "Harry Potter"
    And the download epub command should NOT include tags: "Harry Potter"
    But the download epub command should include tags: "snarry"
    And the download epub command should include tags: "twincest"
    And the download epub command should include comments: "snarry, twincest"
    But the download epub command should NOT include comments: "Harry Potter"

  Scenario: many fandoms, one relationship => relationship in tags, fandom in authors
    Given I have no pages
    And a page exists with fandoms: "harry potter, sga" AND relationships: "harry/snape"
    And the download epub command should include authors: "harry potter"
    And the download epub command should include authors: "sga"
    But the download epub command should NOT include authors: "harry/snape"
    And the download epub command should include comments: "harry/snape"
    But the download epub command should NOT include comments: "harry potter, sga, "

  Scenario: many fandoms, many relationships => relationship in tags, fandom in authors
    Given I have no pages
    And a page exists with fandoms: "harry potter, sga" AND relationships: "harry/snape, john/rodney"
    And the download epub command should include authors: "harry potter"
    And the download epub command should include authors: "sga"
    And the download epub command should include tags: "harry/snape"
    And the download epub command should include tags: "john/rodney"
    And the download epub command should include comments: "harry/snape, john/rodney"
    But the download epub command should NOT include comments: "harry potter"
