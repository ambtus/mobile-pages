Feature: errors on download

  Scenario: download a text version
    Given I am on the homepage
      And I have no pages
      And I fill in "page_url" with "http://sidrasue.com/tests/test.html"
      And I fill in "page_title" with "This.title.has.periods"
      And I press "Store"
    When I follow "Download" in ".title"
    Then My document should contain "Retrieved from the web"

  Scenario: download with link ref
    Given I am on the homepage
      And I have no pages
      And I fill in "page_url" with "http://sidra.livejournal.com/838.html"
      And I fill in "page_title" with "This page has a cutid"
      And I press "Store"
    When I follow "Download" in ".title"
    Then My document should contain "Ron crouched"
    And My document should not contain "<a"
