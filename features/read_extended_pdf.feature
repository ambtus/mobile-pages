Feature: download pdf version

  Scenario: download pdf file
    Given a page exists with url: "http://test.sidrasue.com/styled.html", title: "Styled"
      And the page "Styled" has no pdfs
    When I am on the homepage
    Then I should not see "pdf(50)" within ".title"
    When I follow "new pdf" within ".title"
    Then "50" should be selected in "Font Size"
    When I press "Create pdf"
    Then I should see "pdf(50)" within ".title"
    When I follow "pdf(50)" within ".title"
    Then I should be visiting "Styled"'s 50 pdf page
    When I am on the pages page
      And I follow "new pdf"
      Then "50" should be selected in "Font Size"
      And I select "20" from "Font Size"
      And I press "Create pdf"
    Then I should see "pdf(50)" within ".title"
      And I should see "pdf(20)" within ".title"
    When I follow "pdf(20)" within ".title"
    Then I should be visiting "Styled"'s 20 pdf page
