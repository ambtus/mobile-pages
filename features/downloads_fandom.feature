Feature: an ebook with a fandom tag is added to a series for marvin

  Scenario: epub download fandom page
    Given a page exists with fandoms: "harry potter"
    Then the download epub command should include series: "harry potter"
    And the download epub command should include comments: "harry potter"

  Scenario: epub download multi-fandom page
    Given a page exists with fandoms: "harry potter, sga"
    Then the download epub command should include series: "crossover"
    But the download epub command should include comments: "harry potter, sga"
