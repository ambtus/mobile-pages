Feature: errors on download

  Scenario: download a text version
    Given I am on the homepage
      And I have no pages
      And I fill in "page_url" with "http://www.rawbw.com/~alice/test.html"
      And I fill in "page_title" with "This.title.has.periods"
      And I press "Store"
    When I follow "Download" in ".title"
    Then My document should contain "Retrieved from the web"
