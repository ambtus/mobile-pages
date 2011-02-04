Feature: tests that don't fit neatly into another feature

  Scenario: create a page from a single url with author and notes
    Given a genre exists with name: "mygenre"
    Given an author exists with name: "myauthor"
      And I am on the homepage
      And I fill in "page_url" with "http://test.sidrasue.com/test.html"
     And I fill in "page_title" with "Simple test"
     And I fill in "page_notes" with "some notes"
     And I select "mygenre" from "Genre"
     And I select "myauthor" from "Author"
     And I press "Store"
   Then I should see "Page created" within "#flash_notice"
     And I should see "Simple test" within ".title"
     And I should see "mygenre" within ".genres"
     And I should see "some notes" within ".notes"
     And I should see "myauthor" within ".authors"
   When I follow "HTML"
     Then I should see "Retrieved from the web" within ".content"
   When I am on the page with title "Simple test"
     And I follow "Original" within ".title"
   Then I should be visiting "http://test.sidrasue.com/test.html"

  Scenario: create a page from a list of urls with author and notes
    Given a genre exists with name: "mygenre"
    Given an author exists with name: "myauthor"
      And I am on the homepage
    When I follow "Store Multiple"
      And I fill in "page_urls" with
        """
        http://test.sidrasue.com/parts/1.html
        http://test.sidrasue.com/parts/2.html
        """
     And I fill in "page_title" with "Multiple pages from urls"
     And I fill in "page_notes" with "some notes"
     And I select "mygenre" from "Genre"
     And I select "myauthor" from "Author"
     And I press "Store"
   Then I should see "Multiple pages from urls"
     And I should see "mygenre" within ".genres"
     And I should see "some notes" within ".notes"
     And I should see "myauthor" within ".authors"
     And I should see "Part 1" within "#position_1"
     And I should see "Part 2" within "#position_2"
   When I follow "HTML"
     Then I should see "Part 1"
     And I should see "stuff for part 1"
     And I should see "Part 2"
     And I should see "stuff for part 2"

  Scenario: filter on mix of author, genre, and state
    Given the following pages
      | title                            | add_author_string        | add_genre_string  | favorite | last_read  |
      | The Mysterious Affair at Styles  | agatha christie          | mystery           | true     | 2009-01-01 |
      | Nancy Drew                       | Carolyn Keene            | mystery, children | false    | 2009-02-01 |
      | The Boxcar Children              | Gertrude Chandler Warner | mystery, children | true     |            |
      | Murder on the Orient Express     | agatha christie          | mystery           | false    |            |
      | Another Mystery                  | agatha christie          | mystery           | false    | 2009-01-02 |
      | Yet Another Mystery              | agatha christie          | mystery           | false    | 2009-01-03 |
      | Still More Mysteries             | agatha christie          | mystery, short stories | true| 2009-01-04 |
    When I am on the homepage
      And I select "agatha christie" from "Author"
      And I select "mystery" from "Genre"
      And I press "Find"
    Then I should see "The Mysterious Affair at Styles" within "#position_1"
      And I should see "Murder on the Orient Express" within "#position_2"
      And I should see "Another Mystery" within "#position_3"
      And I should see "Yet Another Mystery" within "#position_4"
      And I should see "Still More Mysteries" within "#position_5"
      And I should not have a "#position_6" field
      And I should not see "Nancy Drew"
      And I should not see "The Boxcar Children"
    When I am on the homepage
      And I select "children" from "Genre"
      And I choose "unread_yes"
      And I press "Find"
    Then I should see "The Boxcar Children"
      And I should not see "Nancy Drew"
      And I should not see "The Mysterious Affair at Styles"
      And I should not see "Murder on the Orient Express"
    When I am on the homepage
    When I choose "unread_yes"
      And I select "agatha christie" from "Author"
      And I press "Find"
    Then I should see "Murder on the Orient Express"
      And I should not see "The Mysterious Affair at Styles"
      And I should not see "Nancy Drew"
      And I should not see "The Boxcar Children"
    When I am on the homepage
      And I select "children" from "Genre"
      And I choose "favorite_yes"
      And I press "Find"
    Then I should see "The Boxcar Children"
      And I should not see "Nancy Drew"
      And I should not see "The Mysterious Affair at Styles"
      And I should not see "Murder on the Orient Express"
    When I am on the homepage
    When I choose "favorite_yes"
      And I select "agatha christie" from "Author"
      And I press "Find"
    Then I should see "The Mysterious Affair at Styles"
      And I should not see "Murder on the Orient Express"
      And I should not see "Nancy Drew"
      And I should not see "The Boxcar Children"
    When I am on the homepage
    When I choose "unread_no"
      And I press "Find"
    Then I should not see "Murder on the Orient Express"
      And I should see "The Mysterious Affair at Styles"
      And I should see "Nancy Drew"
      And I should not see "The Boxcar Children"
    When I am on the homepage
    When I choose "unread_no"
      And I select "agatha christie" from "Author"
      And I press "Find"
    Then I should not see "Murder on the Orient Express"
      And I should see "The Mysterious Affair at Styles"
      And I should not see "Nancy Drew"
      And I should not see "The Boxcar Children"

  Scenario: notes but no content on multi-page view
    Given a page exists with title: "Multi", base_url: "http://test.sidrasue.com/parts/*.html", url_substitutions: "1 2"
   When I am on the page's page
   Then I should see "Part 1" within "#position_1"
     And I should see "Part 2" within "#position_2"
     And I should not see "stuff for part 1"
     And I should not see "stuff for part 2"
     And I should not see "Original" within ".title"
     But I should see "Original" within "#position_1"
     And I should see "Original" within "#position_2"
   When I follow "HTML" within "#position_1"
   Then I should see "stuff for part 1"
     And I should not see "stuff for part 2"
   When I am on the page's page
   And I follow "Part 1"
   When I follow "Notes"
     And I fill in "page_notes" with "This is a note"
     And I press "Update"
   When I am on the page's page
   Then I should see "This is a note" within "#position_1"
     And I should not see "stuff for part 1"
     And I follow "Part 1" within "#position_1"
   Then I should see "This is a note"
     And I should not see "stuff for part 1"

  Scenario: add a part updates the parent's read_after but add a parent doesn't
    Given a page exists with title: "page 1", url: "http://test.sidrasue.com/parts/1.html", read_after: "2020-01-01"
      And a page exists with title: "page 2", url: "http://test.sidrasue.com/parts/2.html", read_after: "2020-01-02"
    When I am on the homepage
    Then I should see "page 1" within "#position_1"
      And I should see "page 2" within "#position_2"
    When I follow "page 2" within "#position_2"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    When I am on the homepage
    Then I should see "page 1" within "#position_1"
      And I should see "New Parent" within "#position_2"
      And I should not see "page 2"
    When I follow "New Parent" within "#position_2"
      And I follow "Manage Parts"
      And I fill in "url_list" with
        """
        http://test.sidrasue.com/parts/3.html
        http://test.sidrasue.com/parts/4.html
        """
      And I press "Update"
    When I am on the homepage
    Then I should see "New Parent" within "#position_1"
      And I should see "page 1" within "#position_2"

  Scenario: non-matching last reads
    Given a titled page exists with urls: "http://test.sidrasue.com/parts/1.html\nhttp://test.sidrasue.com/parts/2.html", last_read: "2009-01-01"
    When I am on the page's page
      And I follow "Part 2" within "#position_2"
      And I follow "Rate"
      And I press "2"
   When I am on the page's page
# FIXME - year will change every year
   Then I should see "2011-" within ".last_read"
     And I should see "unread" within "#position_1"
     And I should not see "2011-" within "#position_2"
     And I should not see "unread" within "#position_2"

  Scenario: text, trim and text should reflect trim
    Given a titled page exists with url: "http://test.sidrasue.com/p.html"
    When I am on the page's page
      And I follow "TXT" within ".title"
    Then I should see "top para"
      And I should see "content"
      And I should see "bottom para"
    When I am on the page's page
      And I follow "Scrub"
      And I choose "top para" within ".top"
      And I choose "bottom para" within ".bottom"
      And I press "Scrub"
    When I follow "TXT" within ".title"
    Then I should not see "top para"
      And I should not see "bottom para"
      And I should see "content"
