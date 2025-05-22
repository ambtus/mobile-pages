Feature: allow find any

Scenario: shown by default
  Given a page exists with readers: "good"
  When I am on the homepage
  Then I should NOT see "No pages found"
    And I should see "Page 1"
    And I should see "good" within "#position_1"

Scenario: filtered in when selected
  Given a page exists with readers: "very good" AND title: "Page 1"
    And a page exists with readers: "slightly good" AND title: "Page 2"
  When I am on the filter page
    And I select "very good" from "Reader"
    And I press "Find"
  Then I should NOT see "Page 2"
    But I should see "Page 1" within "#position_1"

Scenario: filtered in when filtering in all
  Given a page exists with audio_url: "very good" AND title: "Page 1"
    And a page exists with audio_url: "slightly good" AND title: "Page 2"
    And a page exists with title: "Page 3"
  When I am on the filter page
    And I click on "show_audios_all"
    And I press "Find"
  Then I should see "Page 1"
    And I should see "Page 2"
    But I should NOT see "Page 3"

Scenario: filtered out when filtering out all
  Given a page exists with audio_url: "very bad" AND title: "Page 1"
    And a page exists with audio_url: "slightly bad" AND title: "Page 2"
  When I am on the filter page
    And I click on "show_audios_none"
    And I press "Find"
  Then I should see "No pages found"

Scenario: reader selected during create is filterable out
  Given "abc123" is a "Reader"
  When I am on the create page
    And I select "abc123"
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I fill in "page_audio_url" with "http://test.com/test.mp3"
    And I press "Store"
    And I am on the filter page
    And I click on "show_audios_none"
    And I press "Find"
  Then I should see "No pages found"

Scenario: reader selected during create is filterable in
  Given "abc123" is a "Reader"
    And a page exists with title: "Page 3"
  When I am on the create page
    And I select "abc123"
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I fill in "page_audio_url" with "http://test.com/test.mp3"
    And I press "Store"
    And I am on the filter page
    And I click on "show_audios_all"
    And I press "Find"
  Then I should NOT see "No pages found"
    And I should see "abc123"
    But I should NOT see "Page 3"

Scenario: show_audios_all should only show if there is an audio url
  Given a page exists with audio_url: "very bad" AND title: "Page 1"
    And a page exists with audio_url: "slightly bad" AND title: "Page 2"
    And a page exists with title: "Page 3"
  When I am on the filter page
    And I click on "show_audios_all"
    And I press "Find"
  Then I should NOT see "No pages found"
    And I should see "Page 1"
    And I should see "Page 2"
    But I should NOT see "Page 3"

Scenario: show_audios_none should only show if there is not an audio url
  Given a page exists with readers: "very bad" AND title: "Page 1"
    And a page exists with audio_url: "slightly bad" AND title: "Page 2"
    And a page exists with title: "Page 3"
  When I am on the filter page
    And I click on "show_audios_none"
    And I press "Find"
  Then I should NOT see "No pages found"
    And I should see "Page 1"
    And I should see "Page 3"
    But I should NOT see "Page 2"

Scenario: filter on reader should not filter out parts
  Given Counting Drabbles exists
    And part 1 has reader "by Author"
    And part 2 has reader "Sidra"
  When I am on the filter page
    And I select "by Author" from "Reader"
    And I click on "type_all"
    And I press "Find"
  Then I should NOT see "No pages found"
    And I should see "Skipping"
    But I should NOT see "Flower"
    And the page should NOT contain css "#position_2"

