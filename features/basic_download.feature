Feature: basic download
  What: create a text version suitable for download to BookZ on the iPhone
  Why: so i can read pages offline
  Result: link to text page

  Scenario: download a text version
    Given I am on the homepage
      And I have no pages
      And I fill in "page_url" with "http://www.rawbw.com/~alice/styled.html"
      And I fill in "page_title" with "Styled text test"
      And I press "Store"
    When I follow "Download" in ".title"
    Then My document should contain "# This is a header #"
      And My document should contain "*Bold*"
      And My document should contain "_Italic_"
      And My document should contain "==strike-through=="
      And My document should contain "1^st"
      And My document should contain "2(nd)"
      And My document should contain "________________"
      And My document should not contain "div>"
      And My document should not contain "p>"
      And My document should contain "…"
      And My document should contain "*This is a another header*"
      And My document should contain "*One Two, Three*"
      And My document should contain "_One, Two? Three_"

  Scenario: download stripping links and images
    Given I am on the homepage
      And I have no pages
      And I fill in "page_url" with "http://www.rawbw.com/~alice/href.html"
      And I fill in "page_title" with "link test"
      And I press "Store"
    When I follow "Download" in ".title"
    Then My document should contain "[top link]"
      And My document should contain "[middle link]"
      And My document should contain "[bottom link]"
      And My document should contain "[image with alt]"
      And My document should not contain "img"
      And My document should not contain "\[\]"

  Scenario: download stripping of javascript and comments
    Given I am on the homepage
      And I have no pages
      And I fill in "page_url" with "http://www.rawbw.com/~alice/entities.html"
      And I fill in "page_title" with "Javascript test"
      And I press "Store"
    When I follow "Download" in ".title"
    Then My document should not contain "script language="
      And My document should not contain "FILE ARCHIVED"
      And My document should not contain "This script will not work without javascript enabled."
      And My document should not contain "noscript"
      And My document should contain "Chris was antsy"

  Scenario: download stripping of tables
    Given I am on the homepage
      And I have no pages
      And I fill in "page_url" with "http://www.rawbw.com/~alice/tablecontent.html"
      And I fill in "page_title" with "table test"
      And I press "Store"
    When I follow "Download" in ".title"
    Then My document should not contain "<table"
      And My document should not contain "<td"
      And My document should not contain "<tr>"
      And My document should not contain "<big>"
      And My document should contain "Irony"
      And My document should contain "I remembered waking up"

  Scenario: download stripping of lists
    Given I am on the homepage
      And I have no pages
      And I fill in "page_url" with "http://www.rawbw.com/~alice/list.html"
      And I fill in "page_title" with "list test"
      And I press "Store"
    When I follow "Download" in ".title"
    Then My document should not contain "<ul"
      And My document should not contain "<ol>"
      And My document should not contain "<li>"
      And My document should not contain "<d"
      And My document should contain "* unordered"
      And My document should contain "term:"

  Scenario: download livejournal page content only
    Given I am on the homepage
      And I have no pages
      And I fill in "page_url" with "http://sid.livejournal.com/119818.html"
      And I fill in "page_title" with "livejournal test"
      And I press "Store"
    When I follow "Download" in ".title"
    Then My document should not contain "input type="
      And My document should not contain "form method="
      And My document should not contain "select name="
      And My document should not contain "img src="
      And My document should not contain "blockquote"
      And My document should not contain "Reply"
      And My document should contain "is mesmerizing"

  Scenario: download fanfiction page content only
    Given I am on the homepage
      And I have no pages
      And I fill in "page_url" with "http://www.fanfiction.net/s/638499/1/"
      And I fill in "page_title" with "Study Group"
      And I press "Store"
    When I follow "Download" in ".title"
    Then My document should not contain "Rated: "
      And My document should contain "This is rabbit’s fault"

  Scenario: download archive of our own page content only
    Given I am on the homepage
      And I have no pages
      And I fill in "page_url" with "http://archiveofourown.org/works/3412"
      And I fill in "page_title" with "Ezra Meets"
      And I press "Store"
    When I follow "Download" in ".title"
    Then My document should not contain "Add Comment"
      And My document should contain "Summary"
      And My document should contain "Mister Larabee"

  Scenario: download crappy Microsoft Office "html"
    Given I am on the homepage
      And I have no pages
      And I fill in "page_url" with "http://www.rawbw.com/~alice/mso.html"
      And I fill in "page_title" with "Microsoft"
      And I press "Store"
    When I follow "Download" in ".title"
    Then My document should not contain "<em"
      And My document should contain "he _had_ to"
