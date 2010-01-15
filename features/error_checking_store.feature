Feature: error checking during store

  Scenario: fill title in url box by mistake is not okay
    Given I am on the homepage
    When I fill in "page_url" with "Title of the Fic"
      And I press "Store"
    Then I should see "Title can't be blank"

  Scenario: switch title for url by mistake is not okay
    Given I am on the homepage
    When I fill in "page_url" with "Title of the Fic"
      And I fill in "page_title" with "http://test.sidrasue.com/test.html"
      And I press "Store"
    Then I should see "Url is invalid"

  Scenario: url can't be resolved shouldn't throw error
    Given the following genre
      | name |
      | my genre |
    When I am on the homepage
      And I fill in "page_title" with "bad url"
      And I fill in "page_url" with "http://w.sidrasue.com/tests/test.html"
      And I select "my genre"
      And I press "Store"
    Then I should see "couldn't resolve host name" in ".content"
      And I should see "couldn't resolve host name" in "#flash_error"

  Scenario: pasted is not html is okay
    Given the following page
      | title |
      | blank pasted no url |
    When I am on the homepage
      And I follow "Read"
    When I follow "Edit Raw HTML"
      And I fill in "pasted" with "plain text"
      And I press "Update Raw HTML"
    Then I should see "Raw HTML updated" in "#flash_notice"
      And I should see "plain text" in ".content"

  Scenario: pasted blank is okay
    Given the following page
      | title |
      | blank pasted no url |
    When I am on the homepage
      And I follow "Read"
    When I follow "Edit Raw HTML"
      And I fill in "pasted" with ""
      And I press "Update Raw HTML"
    Then I should see "Raw HTML updated" in "#flash_notice"
      And I should see "" in ".content"

  Scenario: holder page for parts is okay
    Given I am on the homepage
    When I fill in "page_title" with "Only entered Title"
      And I press "Store"
    Then I should see "Page created" in "#flash_notice"

  Scenario: url with surrounding whitespace okay
    Given I am on the homepage
    When I fill in "page_title" with "bad url"
      And I fill in "page_url" with " http://test.sidrasue.com/test.html"
      And I press "Store"
    Then I should see "Page created" in "#flash_notice"

  Scenario: 404 shouldn't 500, but should display error
    Given the following genre
      | name |
      | my genre |
    When I am on the homepage
      And I fill in "page_title" with "bad url"
      And I fill in "page_url" with "http://test.sidrasue.com/style.html"
      And I select "my genre"
      And I press "Store"
    Then I should see "error retrieving content" in ".content"
      And I should see "error retrieving content" in "#flash_error"
