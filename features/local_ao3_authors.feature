Feature: ao3 testing that can use local files
         so I don't have to constantly be fetching from
         (would need to be updated if ao3 changes it's format)

Scenario: multiple authors - none in Authors
  Given Multi Authors exists
  When I am on the page's page
  Then I should see "by adiduck (book_people), whimsicalimages" within ".notes"
    And I should NOT see "et al" within ".notes"

Scenario: multiple authors - some in Authors
  Given "adiduck (book_people)" is an "Author"
    And Multi Authors exists
  When I am on the page's page
  Then I should see "adiduck" within ".authors"
    And I should see "et al: whimsicalimages" within ".notes"
    And I should NOT see "book_people"

Scenario: multiple authors - reversed in Authors
  Given "book_people (adiduck)" is an "Author"
    And Multi Authors exists
  When I am on the page's page
  Then I should see "book_people" within ".authors"
    And I should see "et al: whimsicalimages" within ".notes"
    And I should NOT see "adiduck"

Scenario: multiple authors - primary in Authors
  Given "adiduck" is an "Author"
    And Multi Authors exists
  When I am on the page's page
  Then I should see "adiduck" within ".authors"
    And I should see "et al: whimsicalimages" within ".notes"
    And I should NOT see "book_people"

Scenario: multiple authors - aka in Authors
  Given "book_people" is an "Author"
    And Multi Authors exists
  When I am on the page's page
  Then I should see "book_people" within ".authors"
    And I should see "et al: whimsicalimages" within ".notes"
    And I should NOT see "adiduck"

