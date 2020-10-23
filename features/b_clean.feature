Feature: clean up html from web

  Scenario: CDATA
    Given I have no pages
    And a page exists with url: "http://test.sidrasue.com/112b.html"
    When I am on the page's page
      And I view the content
    Then I should see "A Single Love"
    But I should NOT see "email Vera"

  Scenario: quotes
    Given a page exists with title: "Quotes" AND url: "http://test.sidrasue.com/quotes.html"
    When I am on the page with title "Quotes"
      And I view the content
    Then I should see "Retrieved from the web"
    But my page named "Quotes" should NOT contain "&quot;"

  Scenario: pasted html file gets cleaned
    Given I have no pages
    And a page exists with url: "http://test.sidrasue.com/test.html"
    When I am on the page's page
     And I follow "Edit Raw HTML"
    When I fill in "pasted" with
      """
      <span class='first'>The</span> beginning
      <script type="text/javascript">
      emailE=('tarrotcat' + '@' + 'aol.com')
      document.write('<a href="mailto:' + emailE + '">' + 'email Vera' +'</a>')
      </script>
      """
     And I press "Update Raw HTML"
      And I view the content
     Then I should see "The beginning"
       And I should NOT see "email Vera"

   Scenario: fanfiction Share button gets cleaned
     Given I have no pages
     And a page exists with url: "http://www.fanfiction.net/s/5853866/1/Counting"
     When I am on the page's page
      And I view the content
     Then I should see "Skip. Skip."
      But I should NOT see "Share"
