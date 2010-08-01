Feature: download pdf version

  Scenario: download pdf file
    Given a page exists with url: "http://test.sidrasue.com/styled.html", title: "Styled"
      And the page "Styled" has no pdfs
    When I am on the homepage
    Then I should not see "pdf(40)" within ".title"
    When I follow "new pdf" within ".title"
    Then "40" should be selected in "Font Size"
    When I press "Create pdf"
    Then I should see "Large files may take a while to process" within "#flash_notice"
    Then I should not see "pdf(40)" within ".title"
    When I wait 1 second
      And I am on the page's page
    Then I should see "pdf(40)" within ".title"
    When I follow "pdf(40)" within ".title"
    Then I should be visiting "Styled"'s 40 pdf page
    When I am on the pages page
      And I follow "new pdf"
      Then "40" should be selected in "Font Size"
      And I select "20" from "Font Size"
      And I press "Create pdf"
    When I wait 1 second
      And I am on the page's page
    Then I should see "pdf(20)" within ".title"
    When I follow "pdf(20)" within ".title"
    Then I should be visiting "Styled"'s 20 pdf page
    Given I am on the page's page
    Then I should see "pdf(40)" within ".title"
      And I should see "pdf(20)" within ".title"
    When I follow "rm pdfs"
    Then I should see "Styled-20"
      And I should see "Styled-40"
    When I press "Remove all pdfs"
    Then I should not see "pdf(40)" within ".title"
      And I should not see "rm pdfs" 

  Scenario: backround pdf creation
    Given a page exists with title: "epic", base_url: "http://test.sidrasue.com/long*.html", url_substitutions: "1 2 3 4"
      And the page "epic" has no pdfs
    When I am on the page's page
      And I follow "new pdf" within ".title"
    When I press "Create pdf"
    Then I should see "Large files may take a while to process" within "#flash_notice"
    Given I am on the page's page
    Then I should not see "pdf(40)" within ".title"
    Given I wait 3 seconds
      And I am on the page's page
    Then I should see "pdf(40)" within ".title"
