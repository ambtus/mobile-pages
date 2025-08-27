Feature: clean up html from web

Scenario: CDATA
  Given a page exists with url: "http://test.sidrasue.com/112b.html"
  When I am on the first page's page
  Then the contents should include "A Single Love"
    But the contents should NOT include "email Vera"

Scenario: quotes
  Given a page exists with title: "Quotes" AND url: "http://test.sidrasue.com/quotes.html"
  When I am on the page with title "Quotes"
  Then the contents should include "Retrieved from the web"
    But the contents should NOT include "&quot;"

Scenario: pasted html file gets cleaned
  Given a page exists with url: "http://test.sidrasue.com/test.html"
  When I change its raw html to
      """
      <span class='first'>The</span> beginning
      <script type="text/javascript">
      emailE=('tarrotcat' + '@' + 'aol.com')
      document.write('<a href="mailto:' + emailE + '">' + 'email Vera' +'</a>')
      </script>
      """
  Then the contents should include "The beginning"
    But the contents should NOT include "email Vera"

