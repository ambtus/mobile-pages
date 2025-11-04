Feature: create a page with more than just a url

Scenario: create a page from a single url with selected tags
  Given "my fandom" is a "Fandom"
    And "my author" is an "Author"
    And "my pro" is a "Pro"
  When I am on the create single page
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I select "my fandom"
    And I select "my author"
    And I select "my pro"
    And I store the page
  Then I should see "Page created" within "#flash_notice"
    And I should see "my fandom" within ".fandoms"
    And I should see "my author" within ".authors"
    And I should see "my pro" within ".pros"
    And I should see "xyzzy" within ".title"

Scenario: create a page from a single url with title and notes and my notes
  Given I am on the create single page
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I fill in "page_notes" with "some generic notes"
    And I fill in "page_my_notes" with "some personal notes"
    And I fill in "page_title" with "some weird title"
    And I store the page
  Then I should see "Page created" within "#flash_notice"
    And I should see "some weird title" within ".title"
    And I should see "some generic notes" within ".notes"
    And I should see "some personal notes" within ".my_notes"

Scenario: check before create a page with a hidden tag
  Given "abc123" is a "Hidden"
  When I am on the create single page
    And I fill in "page_title" with "Title"
    And I select "abc123"
    And I press "Store"
    And I press "Update Raw HTML"
    And I should see "abc123" within ".hiddens"
    And I should have 1 page

Scenario: create a page with a hidden tag
  Given "abc123" is a "Hidden"
  When I am on the create single page
    And I fill in "page_title" with "Title"
    And I select "abc123"
    And I press "Store"
    And I press "Update Raw HTML"
    And I am on the filter page
    And I click on "show_hiddens_none"
    And I press "Find"
  Then I should see "No pages found"
    But I should have 1 page

