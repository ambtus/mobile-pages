Feature: download pdf version

  Scenario: download pdf file
    Given a page exists with url: "http://test.sidrasue.com/test.html", title: "Space in/title+ weirdnesses:"
      And the page "Space in/title+ weirdnesses:" has no pdfs
    When I am on the homepage
      And I follow "new pdf" within ".title"
      And I press "Create pdf"
    And I wait 1 second
    When I am on the homepage
    Then I should see "pdf(40)" within ".title"
    When I follow "pdf(40)" within ".title"
    Then I should be visiting "Space in/title+ weirdnesses:"'s 40 pdf page
