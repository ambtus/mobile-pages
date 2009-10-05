Feature: basic download
  What: create a text version suitable for download to BookZ on the iPhone
  Why: so i can read pages offline
  Result: link to text page

  Scenario: download a text version of styled html
    Given the following page
      | title  | url |
      | multi  | http://sidrasue.com/tests/styled.html |
    When I am on the homepage
      And I follow "Download" in ".title"
    Then my document should contain "# This is a header #"
      And my document should contain "## This is a second level header ##"
      And my document should contain "*Bold*"
      And my document should contain "_Italic_"
      And my document should contain "==strike-through=="
      And my document should contain "1^st"
      And my document should contain "2(nd)"
      And my document should contain "&"
      And my document should not contain "&amp;"
      And my document should contain "________________"
      And my document should not contain "div>"
      And my document should not contain "p>"
      And my document should not contain "small>"
      And my document should contain "(something little)"
      And my document should contain "…"
      And my document should contain "—"
      And my document should contain "’"
      And my document should not contain ";"
      And my document should contain "*This is another header*"
      And my document should contain "*One Two, Three*"
      And my document should contain "_One, Two? Three_"
      And my document should contain "_One-TwoThree_"
      And my document should contain "<>end<>"
      And my document should contain "façade"

  Scenario: download stripping links and images
    Given the following page
      | title  | url |
      | multi  | http://sidrasue.com/tests/href.html |
    When I am on the homepage
      And I follow "Download" in ".title"
    Then my document should contain "[top link]"
      And my document should contain "[middle link]"
      And my document should contain "[bottom link]"
      And my document should contain "[image with alt]"
      And my document should not contain "img"
      And my document should not contain "\[\]"
      And my document should not contain "href"

  Scenario: download stripping of javascript and comments
    Given the following page
      | title  | url |
      | multi  | http://sidrasue.com/tests/entities.html |
    When I am on the homepage
      And I follow "Download" in ".title"
    Then my document should not contain "script language="
      And my document should not contain "FILE ARCHIVED"
      And my document should not contain "This script will not work without javascript enabled."
      And my document should not contain "noscript"
      And my document should contain "Chris was antsy"

  Scenario: download stripping of tables
    Given the following page
      | title  | url |
      | multi  | http://sidrasue.com/tests/tablecontent.html |
    When I am on the homepage
      And I follow "Download" in ".title"
    Then my document should not contain "<table"
      And my document should not contain "<td"
      And my document should not contain "<tr>"
      And my document should not contain "<big>"
      And my document should contain "Irony"
      And my document should contain "I remembered waking up"

  Scenario: download stripping of lists
    Given the following page
      | title  | url |
      | multi  | http://sidrasue.com/tests/list.html |
    When I am on the homepage
      And I follow "Download" in ".title"
    Then my document should not contain "<ul"
      And my document should not contain "<ol>"
      And my document should not contain "<li>"
      And my document should not contain "<d"
      And my document should contain "* unordered"
      And my document should contain "term:"

  Scenario: download crappy Microsoft Office "html"
    Given the following page
      | title  | url |
      | multi  | http://sidrasue.com/tests/mso.html |
    When I am on the homepage
      And I follow "Download" in ".title"
    Then my document should not contain "<em"
      And my document should contain "he _had_ to"
      And my document should not contain "<wbr>"
      And my document should not contain "<o:p>"
      And my document should contain "so-I-am-God"
      And my document should not contain "\n\n\n\n"
      And my document should contain "*My boyfriend"
      And my document should not contain "<strong"

  Scenario: download weird empty divs
    Given the following page
      | title  | url |
      | multi  | http://sidrasue.com/tests/ejournal_div.html |
    When I am on the homepage
      And I follow "Download" in ".title"
    Then my document should not contain "\n\n\n\n"
      And my document should contain "Rodney muttered imprecations"

  Scenario: download page with and without linefeeds
    Given the following page
      | title  | url |
      | multi  | http://sidrasue.com/tests/linefeeds.html |
    When I am on the homepage
      And I follow "Download" in ".title"
    Then my document should contain "first\n\nsecond\n\nthird\n\nfourth\n\nfifth\n\nsixth\n\nseventh\n\neighth"

  Scenario: divs with attributes
    Given the following page
      | title  | url |
      | multi  | http://sidrasue.com/tests/div.html |
    When I am on the homepage
      And I follow "Download" in ".title"
    Then my document should contain "first div\n\nsecond div\n\ncontent"

  Scenario: download livejournal page content only
    Given the following page
      | title  | url |
      | multi  | http://sid.livejournal.com/119818.html |
    When I am on the homepage
      And I follow "Download" in ".title"
    Then my document should not contain "input type="
      And my document should not contain "form method="
      And my document should not contain "select name="
      And my document should not contain "img src="
      And my document should not contain "blockquote"
      And my document should not contain "Reply"
      And my document should contain "is mesmerizing"

  Scenario: download fanfiction page content only
    Given the following page
      | title  | url |
      | multi  | http://www.fanfiction.net/s/638499/1/ |
    When I am on the homepage
      And I follow "Download" in ".title"
    Then my document should not contain "Rated: "
      And my document should contain "This is rabbit’s fault"

  Scenario: download archive of our own page content only
    Given the following page
      | title  | url |
      | multi  | http://archiveofourown.org/works/3412 |
    When I am on the homepage
      And I follow "Download" in ".title"
    Then my document should not contain "Add Comment"
      And my document should contain "Summary"
      And my document should contain "Mister Larabee"

  Scenario: download google groops content only
    Given the following page
      | title  | url |
      | multi  | http://sidrasue.com/tests/google.html |
    When I am on the homepage
      And I follow "Download" in ".title"
    Then my document should contain "Author: Ster Julie"
      And my document should not contain "This is a Usenet group"

