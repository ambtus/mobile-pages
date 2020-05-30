Feature: upload pre-made epub files

  Scenario: don’t upload epub files
    Given I am on the homepage
    Then I should NOT see "upload an ePub"
