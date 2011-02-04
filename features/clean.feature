Feature: clean up html from web

  Scenario: CDATA
    Given a titled page exists with url: "http://test.sidrasue.com/112b.html"
    When I go to the page's page
      And I follow "HTML" within ".title"
    Then I should see "A Single Love"
    But I should not see "email Vera"

  Scenario: quotes
    Given a page exists with title: "Quotes", url: "http://test.sidrasue.com/quotes.html"
    When I go to the page's page
      And I follow "HTML" within ".title"
    Then I should see /"Retrieved from the web"/
    But my page named "Quotes" should not contain "&quot;"

  Scenario: pasted html file gets cleaned
    Given a titled page exists with url: "http://test.sidrasue.com/test.html"
    When I am on the page's page
     And I follow "Edit Raw HTML"
    When I fill in "pasted" with "<span class='first'>The</span> beginning<br><br>new paragraph"
      And I press "Update Raw HTML"
      And I follow "TXT"
     Then I should see "The beginning"
       And I should not see "<br>"

