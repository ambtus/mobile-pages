Feature: add some tags

Scenario: A Single can have fandom and author tags
  Given a Single exists
  When I tag "Single" with fandom and author
  Then the download tag string for "Single" should include fandom and author

Scenario: A Book can have fandom and author tags
  Given a short book exists
  When I tag "Book" with fandom and author
  Then the download tag string for "Book" should include fandom and author

Scenario: A Chapter cannot have it’s own fandom and author tags
  Given a short book exists
  Then I can NOT tag "Chapter 1" with fandom and author

Scenario: A Chapter inherits fandom and author tags from parent, but only when downloaded
  Given a short book exists
  When I tag "Book" with fandom and author
  Then the download tag string for "Chapter 1" should include fandom and author
    But the tag_cache for "Chapter 1" should NOT include fandom and author

Scenario: A Series cannot have it’s own fandom and author tags
  Given a series exists
  Then I can NOT tag "Series" with fandom and author

Scenario: A Series inherits fandom and author download tags from child
  Given a series exists
  When I tag "Book1" with fandom and author
  Then the download tag string for "Series" should include fandom and author

Scenario: A Series inherits fandom and author index tags from child
  Given a series exists
  When I tag "Book1" with fandom and author
  Then the index tags for "Series" should include fandom and author

Scenario: A Series inherits fandom and author show tags from child
  Given a series exists
  When I tag "Book1" with fandom and author
  Then the show tags for "Series" should include fandom and author
