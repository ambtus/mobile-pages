Feature: create a page from pasted html
  What: when storing a page can paste html as well as give the reference url
  Why: sometimes the page is protected in such a way as making access via curl difficult
  Result: acts just as if the html was retrieved.

  Scenario: store using an pasted html file
    Given I am on the homepage
      And I fill in "page_url" with "http://www.rawbw.com/~alice/test.html"
      And I fill in "page_title" with "Test pasted html"
    When I fill in "page_pasted" with "<p>This is a test</p>"
      And I press "Store"
    Then I should see "Page created"
      And I should see "This is a test"
      And I should not see "Retrieved from the web"