Feature: downloads parts metadata

Scenario: download part titles should not have unread if all parts unread
  Given a page exists with base_url: "http://test.sidrasue.com/test*.html" AND url_substitutions: "1 2 3"
  When I read it online
  Then I should NOT see "unread"

Scenario: link to parts in downloaded html
  Given a page exists with base_url: "http://test.sidrasue.com/long*.html" AND url_substitutions: "1-2"
  When I read it online
  Then "Page 1" should link to itself
    And "Part 1" should link to itself
    And "Part 2" should link to itself

Scenario: two and three levels (h3 & h4)
  Given I am on the homepage
  When I follow "Store Multiple"
    And I fill in "page_urls" with
      """
      ##Child 1
      http://test.sidrasue.com/parts/3.html##Child 2
      """
    And I fill in "page_title" with "Parent"
    And I press "Store"
    And I follow "Child 1"
    And I refetch the following
      """
      http://test.sidrasue.com/parts/1.html##Boo
      ##Grandchild
      """
    And I follow "Grandchild"
    And I refetch the following
      """
      http://test.sidrasue.com/parts/2.html##Hiss
      """
    And I read "Parent" online
  Then I should see "Child 1" within "h2"
    And I should see "Boo" within "h3"
    And I should see "Hiss" within "h4"

Scenario: download part titles
  Given "rating tag" is a "Pro"
    And "info tag" is an "Info"
    And a page exists with base_url: "http://test.sidrasue.com/long*.html" AND url_substitutions: "1 2 3"
  When I am on the page's page
    And I follow "Part 1"
    And I follow "Rate"
    And I choose "5"
    And I press "Rate"
    And I select "rating tag" from "page_pro_ids_"
    And I select "info tag" from "page_info_ids_"
    And I press "Update Tags"
    And I follow "Part 2"
    And I follow "Rate"
    And I choose "Yes" within ".stars"
    And I press "Rate"
    And I read it online
  Then I should see "Part 1 (rating tag)" within "h2"
    And I should see "Part 2 (unfinished)"
    And I should see "Part 3 (unread)"
    But I should NOT see "info tag"
    And I should NOT see today
    And I should NOT see "5 stars"
    And I should NOT see "10,001 words"

Scenario: part epubs should have all metadata from parent except size (which is different) and info (which is never put on epubs)
  Given a page exists with base_url: "http://test.sidrasue.com/long*.html" AND url_substitutions: "1 2 3" AND fandoms: "harry potter" AND infos: "informational" AND pros: "AU" AND authors: "my author" AND stars: "4"
  Then the download epub command for "Page 1" should include authors: "my author&harry potter"
    And the download epub command for "Part 2" should include authors: "my author&harry potter"

    And the download epub command for "Page 1" should include tags: "AU"
    And the download epub command for "Part 2" should include tags: "AU"

    And the download epub command for "Page 1" should include comments: "AU"
    And the download epub command for "Part 2" should include comments: "AU"

    And the download epub command for "Page 1" should include rating: "8"
    And the download epub command for "Part 2" should include rating: "8"

    And the download epub command for "Page 1" should include tags: "long"
    But the download epub command for "Part 2" should NOT include tags: "long"
    And the download epub command for "Page 1" should NOT include tags: "medium"
    But the download epub command for "Part 2" should include tags: "medium"

    And the download epub command for "Page 1" should NOT include tags: "informational"
    And the download epub command for "Part 2" should NOT include tags: "informational"

    And the download epub command for "Page 1" should include comments: "30,003 words"
    But the download epub command for "Part 2" should include comments: "10,001 words"

