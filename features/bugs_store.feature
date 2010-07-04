Feature: bugs during store

  Scenario: fill title in url box by mistake is not okay
    Given I am on the homepage
    When I fill in "page_url" with "Title of the Fic"
      And I press "Store"
    Then I should see "Title can't be blank"

  Scenario: fill title in url box with Title not okay
    Given I am on the homepage
    When I fill in "page_title" with "Title"
      And I press "Store"
    Then I should see "Title can't be blank or 'Title'"

  Scenario: switch title for url by mistake is not okay
    Given I am on the homepage
    When I fill in "page_url" with "Title of the Fic"
      And I fill in "page_title" with "http://test.sidrasue.com/test.html"
      And I press "Store"
    Then I should see "Url is invalid"

  Scenario: url can't be resolved should throw error
    Given a genre exists with name: "genre"
    When I am on the homepage
      And I select "genre" from "Genre"
      And I fill in "page_title" with "bad url"
      And I fill in "page_url" with "http://w.sidrasue.com/tests/test.html"
      And I press "Store"
    Then I should see "couldn't resolve host name" within "#flash_alert"
      And I should not see "Page created" 

  Scenario: pasted plaintext is okay
    Given a titled page exists
      And I am on the page's page
    When I follow "Edit Raw HTML"
      And I fill in "pasted" with "plain text"
      And I press "Update Raw HTML"
    Then I should see "Raw HTML updated" within "#flash_notice"
      And I should see "plain text" within ".content"

  Scenario: pasted blank is okay
    Given a titled page exists
      And I am on the page's page
    When I follow "Edit Raw HTML"
      And I fill in "pasted" with ""
      And I press "Update Raw HTML"
    Then I should see "Raw HTML updated" within "#flash_notice"
      And I should see "" within ".content"

  Scenario: holder page for parts is okay
    Given I am on the homepage
    When I fill in "page_title" with "Only entered Title"
      And I press "Store"
    Then I should see "Page created" within "#flash_notice"

  Scenario: url with surrounding whitespace okay
    Given a titled page exists with url: " http://test.sidrasue.com/test.html"
    When I am on the page's page
      And I follow "Read"
    Then I should see "Retrieved from the web"

  Scenario: 404 shouldn't 500, but should display error
    Given a genre exists with name: "genre"
    When I am on the homepage
      And I select "genre" from "Genre"
      And I fill in "page_title" with "bad url"
      And I fill in "page_url" with "http://test.sidrasue.com/style.html"
      And I press "Store"
    Then I should see "error retrieving content" within "#flash_alert"
      And I should not see "Page created" 

  Scenario: not filling in notes shouldn't give "Notes"
    Given a genre exists with name: "genre"
    When I am on the homepage
     And I select "genre" from "Genre"
     And I fill in "page_title" with "no notes"
     And I press "Store"
   Then I should not see "Notes" within ".notes"
   
  Scenario: duplicate url
    Given a page exists with title: "Original", url: "http://test.sidrasue.com/test.html", add_genre_string: "mygenre"
    When I am on the homepage
      And I fill in "page_title" with "duplicate"
      And I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I select "mygenre" from "Genre"
      And I press "Store"
    Then I should see "Url has already been taken" within "#flash_alert"
      And I should not see "duplicate" 
