Feature: extended notes

  Scenario: long notes should be truncated at word boundaries
    After the word starting on or after Page::MININOTE

    Given a titled page exists with notes: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam."
    When I am on the page's page
     Then I should see "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam." within ".notes"
   When I am on the homepage
     Then I should see "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium..." within "#position_1"

  Scenario: a note without a space after 75 characters
    Given a titled page exists with notes: "On Assignment for Dumbledore, in past, Harry sees his lover from a new perspective."
    When I am on the homepage
      Then I should see "On Assignment for Dumbledore, in past, Harry sees his lover from a new perspective."
