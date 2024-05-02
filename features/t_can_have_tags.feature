Feature: can_have_tags? created tags feature

Scenario: A Single can have fandom and author tags
  Given a Single exists
  When I can tag "Single" with fandom and author
  Then the download tag string for "Single" should include fandom and author

Scenario: A Book can have fandom and author tags
  Given a Book exists
  When I can tag "Book" with fandom and author
  Then the download tag string for "Book" should include fandom and author

Scenario: A Chapter cannot have it’s own fandom and author tags
  Given a Book exists
  Then I can NOT tag "Chapter 1" with fandom and author

Scenario: A Chapter inherits fandom and author tags from parent, but only when downloaded
  Given a Book exists
  When I can tag "Book" with fandom and author
  Then the download tag string for "Chapter 1" should include fandom and author
    But the tag_cache for "Chapter 1" should NOT include fandom and author

Scenario: A Series cannot have it’s own fandom and author tags
  Given a series exists
  Then I can NOT tag "Series" with fandom and author

Scenario: A Series inherits fandom and author tags from child
  Given a series exists
  When I can tag "Book1" with fandom and author
  Then the download tag string for "Series" should include fandom and author
    And the show tags for "Series" should include fandom and author
    And the index tags for "Series" should include fandom and author

Scenario: cannot move tags up from book to series
  Given a page exists with urls: "http://test.sidrasue.com/parts/1.html,http://test.sidrasue.com/parts/2.html" AND authors: "Sidra" AND fandoms: "Harry Potter" AND cons: "def987"
  When I am on the page's page
    And I add a parent with title "Parent"
  Then the show tags for "Parent" should include fandom and author
    And the index tags for "Parent" should include fandom and author
    And the download tag string for "Parent" should include fandom and author
  But the tags for "Parent" should NOT include fandom and author
