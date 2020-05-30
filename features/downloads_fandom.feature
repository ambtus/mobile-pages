Feature: an ebook with a fandom tag is collected by series (not subjects) for marvin

  Scenario: epub download fandom page
    Given a page exists with fandoms: "harry potter" AND tags: "AU"
    Then the download epub command should include series: "harry potter"
    And the download epub command should include tags: "AU"
    But the download epub command should NOT include tags: "harry potter"
    And the download epub command should NOT include series: "AU"
    And the download epub command should include comments: "harry potter, AU"

  Scenario: epub download multi-fandom page
    Given a page exists with fandoms: "harry potter, sga" AND tags: "AU"
    Then the download epub command should include series: "crossover"
    And the download epub command should include tags: "AU"
    But the download epub command should NOT include tags: "harry potter"
    And the download epub command should NOT include series: "harry potter"
    And the download epub command should include comments: "harry potter, sga, AU"
    But the download epub command should NOT include comments: "crossover"
