Feature: error checking during store

  Scenario: fill title in url box by mistake is not okay
    Given I am on the homepage
    When I fill in "page_url" with "Title of the Fic"
      And I press "Store"
    Then I should see "Title can't be blank"

  Scenario: switch title for url by mistake is not okay
    Given I am on the homepage
    When I fill in "page_url" with "Title of the Fic"
      And I fill in "page_title" with "http://www.rawbw.com/~alice/test.html"
      And I press "Store"
    Then I should see "Url is invalid"

  Scenario: url can't be resolved shouldn't throw error
    Given I am on the homepage
    When I fill in "page_title" with "bad url"
      And I fill in "page_url" with "http://wwww.rawbw.com/~alice/test.html"
      And I press "Store"
    Then I should see "Couldn't resolve host name" in ".content"

  Scenario: pasted is not html is okay
    Given I am on the homepage
    And I have no pages
    When I fill in "page_title" with "invalid html"
      And I press "Store"
      And I follow "Edit Raw HTML"
    When I fill in "pasted" with "plain text"
      And I press "Update Raw HTML"
    Then I should see "Raw HTML updated" in "#flash_notice"
      And I should see "plain text"

  Scenario: pasted blank is okay
    Given I am on the homepage
    And I have no pages
    When I fill in "page_title" with "blank pasted no url"
      And I press "Store"
      And I follow "Edit Raw HTML"
      And I fill in "pasted" with ""
      And I press "Update Raw HTML"
    Then I should see "Raw HTML updated" in "#flash_notice"
      And I should see "" in ".content"

  Scenario: holder page for parts is okay
    Given I am on the homepage
    When I fill in "page_title" with "Only entered Title"
      And I press "Store"
    Then I should see "Page created" in "#flash_notice"
