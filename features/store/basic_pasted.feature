Feature: basic pasted
  What: after storing a page can paste html
  Why: sometimes the page is protected in such a way as making access via curl difficult
  Result: acts just as if the html was retrieved.

  Scenario: store using a pasted html file
    Given a titled page exists with url: "http://test.sidrasue.com/test.html"
    When I am on the page's page
     And I follow "Edit Raw HTML"
    When I fill in "pasted" with "<p>This is a test</p>"
      And I press "Update Raw HTML"
    Then I should see "Raw HTML updated" in "#flash_notice"
      And I should see "This is a test"
      And I should not see "Retrieved from the web"

  Scenario: pasted html file needing pre-processing
    Given a titled page exists with url: "http://test.sidrasue.com/test.html"
    When I am on the page's page
     And I follow "Edit Raw HTML"
    When I fill in "pasted" with "<span class='first'>The</span> beginning<br><br>new paragraph"
      And I press "Update Raw HTML"
      And I follow "Download"
     Then I should see "The beginning"
       And I should not see "<br>"
