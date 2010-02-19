Feature: basic download
  What: create a text version suitable for download to BookZ on the iPhone
  Why: so i can read pages offline
  Result: link to text page

  Scenario: download a text version of styled html
    Given a titled page exists with url: "http://test.sidrasue.com/styled.html"
    When I am on the page's page
      And I follow "Download" in ".title"
    Then I should see "# This is a header #"
      And I should see "## This is a second level header ##"
      And I should see "*Bold*"
      And I should see "_Italic_"
      And I should see "==strike-through=="
      And I should see "1^st"
      And I should see "2(nd)"
      And I should see "&"
      And I should not see "&amp;"
      And I should see "________________"
      And I should not see "div>"
      And I should not see "p>"
      And I should not see "small>"
      And I should see "(something little)"
      And I should see "…"
      And I should see "–"
      And I should see "’"
      And I should not see ";"
      And I should see "*This is another header*"
      And I should see "*One Two, Three*"
      And I should see "_One, Two? Three_"
      And I should see "_One-TwoThree_"
      And I should see "façade"

  Scenario: download stripping links and images
    Given a titled page exists with url: "http://test.sidrasue.com/href.html"
    When I am on the page's page
      And I follow "Download" in ".title"
    Then I should see "[top link]"
      And I should see "[middle link]"
      And I should see "[bottom link]"
      And I should see "[image with alt]"
      And I should not see "img"
      And I should not see "\[\]"
      And I should not see "href"

  Scenario: download stripping of javascript and comments
    Given a titled page exists with url: "http://test.sidrasue.com/entities.html"
    When I am on the page's page
      And I follow "Download" in ".title"
    Then I should not see "script language="
      And I should not see "FILE ARCHIVED"
      And I should not see "This script will not work without javascript enabled."
      And I should not see "noscript"
      And I should see "Chris was antsy"

  Scenario: download stripping of tables
    Given a titled page exists with url: "http://test.sidrasue.com/tablecontent.html"
    When I am on the page's page
      And I follow "Download" in ".title"
    Then I should not see "<table"
      And I should not see "<td"
      And I should not see "<tr>"
      And I should not see "<big>"
      And I should see "Irony"
      And I should see "I remembered waking up"

  Scenario: download stripping of lists
    Given a titled page exists with url: "http://test.sidrasue.com/list.html"
    When I am on the page's page
      And I follow "Download" in ".title"
    Then I should not see "<ul"
      And I should not see "<ol>"
      And I should not see "<li>"
      And I should not see "<d"
      And I should see "* unordered"
      And I should see "term:"

  Scenario: download crappy Microsoft Office "html"
    Given a titled page exists with url: "http://test.sidrasue.com/mso.html"
    When I am on the page's page
      And I follow "Download" in ".title"
    Then I should not see "<"
      And I should see "he _had_ to"
      And I should not see "\n\n\n\n"
      And I should not see "<o:p>"

  Scenario: download more crappy Microsoft Office "html"
    Given a titled page exists with url: "http://test.sidrasue.com/mso2.html"
    When I am on the page's page
      And I follow "Download" in ".title"
    Then I should not see "<wbr>"
      And I should see "so-I-am-God"
      And I should not see "<strong"
      And I should see "*My boyfriend"
      And I should not see "<o:p>"

  Scenario: download weird empty divs
    Given a titled page exists with url: "http://test.sidrasue.com/ejournal_div.html"
    When I am on the page's page
      And I follow "Download" in ".title"
    Then I should not see "\n\n\n\n"
      And I should see "Rodney muttered imprecations"

  Scenario: stripping linefeeds
    Given a titled page exists with url: "http://test.sidrasue.com/linefeeds.html"
    When I am on the page's page
      And I follow "Download" in ".title"
     Then I should not see "thirdfourth"
     Then I should not see "fifthsixth"

  Scenario: divs with attributes
    Given a titled page exists with url: "http://test.sidrasue.com/div.html"
    When I am on the page's page
      And I follow "Download" in ".title"
    Then I should see "first div"
      And I should see "second div"
      And I should not see "<"

  Scenario: download livejournal page content only
    Given a titled page exists with url: "http://sid.livejournal.com/119818.html"
    When I am on the page's page
      And I follow "Download" in ".title"
    Then I should not see "input type="
      And I should not see "form method="
      And I should not see "select name="
      And I should not see "img src="
      And I should not see "blockquote"
      And I should not see "Reply"
      And I should see "is mesmerizing"

  Scenario: download wraithbait page content only
    Given a titled page exists with url: "http://www.wraithbait.com/viewstory.php?sid=15331"
    When I am on the page's page
      And I follow "Download" in ".title"
    Then I should not see "recent stories"
      And I should not see "Stargate SG-1 and Stargate: Atlantis,"
      And I should see "Summary:"
      And I should see "Story Notes:"
      And I should see "I swear to God, Mer, I know what I'm doing!"

  Scenario: download wraithbait story content only
    Given a titled page exists with url: "http://www.wraithbait.com/viewstory.php?action=printable&textsize=0&sid=15133&chapter=all"
    When I am on the page's page
      And I follow "Download" in ".title"
    Then I should see "Summary:"
      And I should see "Story Notes:"
      And I should see "There was a time of day in Atlantis"


  Scenario: download fanfiction page content only
    Given a titled page exists with url: "http://www.fanfiction.net/s/638499/1/"
    When I am on the page's page
      And I follow "Download" in ".title"
    Then I should see "This is rabbit’s fault"
      And I should see "Stuck in the Muddle"
    But I should not see "Rated: "
      And I should not see "Review this Story"

  Scenario: download archive of our own page content only
    Given a titled page exists with url: "http://test.archiveofourown.org/works/3412"
    When I am on the page's page
      And I follow "Download" in ".title"
    Then I should see "Work Header"
      And I should see "Summary"
      And I should see "Work Text"
      And I should see "Mister Larabee"
      And I should see "pilot episode!"
    But I should not see "Add Comment"

  Scenario: download google groops content only
    Given a titled page exists with url: "http://test.sidrasue.com/google.html"
    When I am on the page's page
      And I follow "Download" in ".title"
    Then I should see "Author: Ster Julie"
      And I should not see "This is a Usenet group"

