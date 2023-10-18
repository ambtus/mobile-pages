Feature: audiobook

Scenario: add audiobook url
  Given a page exists
  When I am on the page's page
    And I follow "AudioURL"
    And I fill in "audio_url" with "http://imac.local/~alice/audiobooks/Fanfic/DCU/Unpaid%20Internship.mp3"
    And I press 'Update'
  Then "Listen" should link to "http://imac.local/~alice/audiobooks/Fanfic/DCU/Unpaid%20Internship.mp3"

Scenario: audiobook sections
  Given a page exists with url: "http://test.sidrasue.com/long.html"
  When I view the text for reading aloud
  Then I should see "Lorem ipsum dolor"
    And I should see "SLOW DOWN"
    And I should see "1"
    And I should see "2"

Scenario: part sections
  Given I am on the "Store Multiple" page
    And I fill in "page_urls" with
      """
      http://test.sidrasue.com/parts/1.html
      http://test.sidrasue.com/parts/2.html
      """
    And I fill in "page_title" with "Multiple pages from urls"
    And I press "Store"
    And I am on the page with title "Multiple pages from urls"
  Then I should see "Text" within "#position_1"

Scenario: check before audiobook created
  Given a page exists with last_read: "2014-01-01"
  When I am on the page's page
  Then I should see "2014" within ".last_read"
    And I should NOT see "audio"

Scenario: audiobook created updates last read and adds audio and reader tags
  Given a page exists with last_read: "2014-01-01"
    And I view the text for reading aloud
    And I press "Audiobook created"
    And I am on the page's page
  Then I should see "audio" within ".infos"
    And I should see "Sidra" within ".readers"
    And last read should be today
    And I should NOT see "2014" within ".last_read"

Scenario: audiobook created when i've hidden the audio tag
  Given a page exists with last_read: "2014-01-01"
    And "audio" is a "Hidden"
    And I view the text for reading aloud
    And I press "Audiobook created"
    And I am on the page's page
  Then I should see "audio" within ".hiddens"
    And I should see "Sidra" within ".readers"
    And last read should be today
    And I should NOT see "2014" within ".last_read"

