Feature: text version of pages

# FIXME: some of this is removed in the initial scrub, not in the text reformat
# and should be tested in clean.feature instead of here

  Scenario: text version of styled html
    Given a titled page exists with url: "http://test.sidrasue.com/styled.html"
    When I am on the page's page
      And I follow "TXT" within ".title"
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
      And I should not see "someclass"
      And I should not see "div>"
      And I should not see "p>"
      And I should not see "small>"
      And I should see "(something little)"
      And I should not see ";"
      And I should see "### This is another header ###"
      And I should see "*One Two, Three*"
      And I should see "_One, Two? Three_"
      And I should see "_One-TwoThree_"

  Scenario: text stripping links and images
    Given a titled page exists with url: "http://test.sidrasue.com/href.html"
    When I am on the page's page
      And I follow "TXT" within ".title"
    Then I should see "[top link]"
      And I should see "[middle link]"
      And I should see "[bottom link]"
      And I should see "[image with alt]"
      And I should not see "img"
      And I should not see "\[\]"
      And I should not see "href"

  Scenario: text stripping of javascript and comments
    Given a titled page exists with url: "http://test.sidrasue.com/entities.html"
    When I am on the page's page
      And I follow "TXT" within ".title"
    Then I should not see "script language="
      And I should not see "FILE ARCHIVED"
      And I should not see "This script will not work without javascript enabled."
      And I should not see "noscript"
      And I should see "Chris was antsy"

  Scenario: text stripping of tables
    Given a titled page exists with url: "http://test.sidrasue.com/tablecontent.html"
    When I am on the page's page
      And I follow "TXT" within ".title"
    Then I should not see "<table"
      And I should not see "<td"
      And I should not see "<tr>"
      And I should not see "<big>"
      And I should see "Irony"
      And I should see "I remembered waking up"

  Scenario: text stripping of lists
    Given a titled page exists with url: "http://test.sidrasue.com/list.html"
    When I am on the page's page
      And I follow "TXT" within ".title"
    Then I should not see "<ul"
      And I should not see "<ol>"
      And I should not see "<li>"
      And I should not see "<d"
      And I should see "* unordered"
      And I should see "term:"

  Scenario: text of crappy Microsoft Office "html"
    Given a titled page exists with url: "http://test.sidrasue.com/mso.html"
    When I am on the page's page
      And I follow "TXT" within ".title"
    Then I should not see "<"
      And I should see "he _had_ to"
      And I should not see "\n\n\n\n"
      And I should not see "<o:p>"

  Scenario: more crappy Microsoft Office "html"
    Given a titled page exists with url: "http://test.sidrasue.com/mso2.html"
    When I am on the page's page
      And I follow "TXT" within ".title"
    Then I should not see "<wbr>"
      And I should see "so-I-am-God"
      And I should not see "<strong"
      And I should see "*My boyfriend"
      And I should not see "<o:p>"

  Scenario: text of weird empty divs
    Given a titled page exists with url: "http://test.sidrasue.com/ejournal_div.html"
    When I am on the page's page
      And I follow "TXT" within ".title"
    Then I should not see "\n\n\n\n"
      And I should see "Rodney muttered imprecations"

  Scenario: stripping linefeeds
    Given a titled page exists with url: "http://test.sidrasue.com/linefeeds.html"
    When I am on the page's page
      And I follow "TXT" within ".title"
     Then I should not see "thirdfourth"
     Then I should not see "fifthsixth"

  Scenario: make multi (more than two) line breaks visible as hr
    Given a titled page exists with url: "http://test.sidrasue.com/breaks.html"
    When I am on the page's page
      And I follow "TXT" within ".title"
    Then I should see "__________"

  Scenario: divs with attributes
    Given a titled page exists with url: "http://test.sidrasue.com/div.html"
    When I am on the page's page
      And I follow "TXT" within ".title"
    Then I should see "first div"
      And I should see "second div"
      And I should not see "<"

  Scenario: text for livejournal page content only
    Given a titled page exists with url: "http://sid.livejournal.com/119818.html"
    When I am on the page's page
      And I follow "TXT" within ".title"
    Then I should not see "input type="
      And I should not see "form method="
      And I should not see "select name="
      And I should not see "img src="
      And I should not see "blockquote"
      And I should not see "Reply"
      And I should see "is mesmerizing"

  Scenario: text wraithbait page content only
    Given a titled page exists with url: "http://www.wraithbait.com/viewstory.php?sid=15331"
    When I am on the page's page
      And I follow "TXT" within ".title"
    Then I should not see "recent stories"
      And I should not see "Stargate SG-1 and Stargate: Atlantis,"
      And I should not see "Summary:"
      And I should see "Story Notes:"
      And I should see "I swear to God, Mer, I know what I'm doing!"

  Scenario: text wraithbait story content only
    Given a titled page exists with url: "http://www.wraithbait.com/viewstory.php?sid=15133"
    When I am on the page's page
      And I follow "TXT" within ".title"
    Then I should not see "Summary:"
      And I should see "Story Notes:"
      And I should see "There was a time of day in Atlantis"
      And I should see "a single tear trickled down his pale soft cheek"

  Scenario: text fanfiction page content only
    Given a titled page exists with url: "http://www.fanfiction.net/s/638499/1/"
    When I am on the page's page
      And I follow "TXT" within ".title"
    Then I should see "This is rabbit"
      And I should see "Stuck in the Muddle"
    But I should not see "Rated: "
      And I should not see "Review this Story"

  Scenario: text archive of our own page content only
    Given a titled page exists with url: "http://test.archiveofourown.org/works/692"
    When I am on the page's page
    When I follow "TXT" within ".title"
    Then I should not see "Work Header"
      And I should not see "Work Text"
      And I should not see "Chapter Text"
      And I should not see "View chapter by chapter"
      And I should see "Summary"
      And I should see "Using time-travel"
      And I should see "written for nanowrimo"
      And I should see ": Where am I?"
      And I should see "Amy woke slowly"
      And I should see ": Hogwarts"
      And I should see "giving up"
      And I should see "Amy looked at the pair in disbelief."
      And I should see "I'm not. Am I?"
    But I should not see "Add Comment"

  Scenario: text google groops content only
    Given a titled page exists with url: "http://test.sidrasue.com/google.html"
    When I am on the page's page
      And I follow "TXT" within ".title"
    Then I should see "Author: Ster Julie"
      And I should not see "This is a Usenet group"

  Scenario: can't stand alright
    Given a titled page exists with url: "http://test.sidrasue.com/alright.html"
    When I am on the page's page
      And I follow "TXT" within ".title"
    Then I should see "All right, all right"
      And I should not see "Alright, alright"

  Scenario: question marks in title
    Given a page exists with title: "This title?"
    When I go to the page's page
      And I follow "TXT" within ".title"

  Scenario: slashes in title
    Given a page exists with title: "This title 1/2"
    When I go to the page's page
      And I follow "TXT" within ".title"

  Scenario: periods in title
    Given a page exists with title: "This.title.has.periods"
    When I go to the page's page
      And I follow "TXT" within ".title"

  Scenario: spaces in title
    Given a page exists with title: "This title has spaces"
    When I go to the page's page
      And I follow "TXT" within ".title"

  Scenario: blank named anchor
    Given a titled page exists with url: "http://sidra.livejournal.com/838.html"
    When I go to the page's page
      And I follow "TXT" within ".title"
    Then I should see "Ron crouched"
      And I should not see "<a"

  Scenario: tidy ocassionally re-adds &nbsp;
    Given a titled page exists with url: "http://test.sidrasue.com/tidy.html"
    When I am on the page's page
      And I follow "TXT" within ".title"
    Then I should not see "nbsp"

  Scenario: text for a multi-part doc
    Given the following page
      | title  | base_url                              | url_substitutions |
      | multi  | http://test.sidrasue.com/parts/*.html | 1 2 3   |
    When I am on the homepage
      And I follow "multi"
    When I follow "TXT" within ".title"
    Then I should see "stuff for part 1"
      And I should see "stuff for part 2"
      And I should see "stuff for part 3"
      And I should see "# Part 1 #"
      And I should see "# Part 2 #"
      And I should see "# Part 3 #"

