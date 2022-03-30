Feature: ao3 testing that uses local cached files
  which need to be updated if ao3 changes it's format

  Scenario: ao3 with and without chapter titles
    Given I have no pages
    And Open the Door exists
    When I am on the page with title "Open the Door"
    Then I should see "Chapter 1" within "#position_1"
      And I should see "2. Ours" within "#position_2"
      But I should NOT see "1. Chapter 1"
   And the part titles should be stored as "Chapter 1 & Ours"
     And I should NOT see "WIP" within ".omitteds"

  Scenario: a Book of Chapters doesn’t assume it’s an ao3 Work but does ignore work notes
    Given I have no pages
      And a tag exists with name: "harry potter" AND type: "Fandom"
      And Where am I exists
    When I am on the homepage
      And I follow "Where am I"
      Then I should see "Where am I? (Single)" within ".title"
      And I should see "Using time-travel"
      And I should see "written for"
      And I should NOT see "WIP" within ".omitteds"
    When I follow "Manage Parts"
     And I fill in "add_parent" with "Parent"
     And I press "Update"
    Then I should see "Parent (Book)" within ".title"
    And I follow "Where am I?"
      Then I should see "Where am I? (Chapter)" within ".title"
    When I follow "Parent"
      And I follow "Refetch"
    Then I should see "archiveofourown.org/works/692/chapters/803" within "#url_list"
    When I am on the homepage
      And I fill in "page_url" with "https://archiveofourown.org/works/692"
      And I press "Find"
    Then I should see "Where am I? of Parent" within "#position_1"
    But the page should NOT contain css "#position_2"
    When I follow "Parent" within "#position_1"
      And I press "Rebuild Meta"
      Then I should NOT see "Time Was, Time Is"
      And I should NOT see "Using time-travel"
      But I should see "written for"

  Scenario: creating a non-ao3 work from a set of ao3 Singles
    Given I have no pages
      And Time Was exists
    When I am on the homepage
      And I follow "Time Was, Time Is"
      Then I should see "WIP" within ".omitteds"
      And I press "Uncollect"
    When I am on the homepage
    And I follow "Hogwarts" within "#position_2"
      Then I should see "Hogwarts (Single)" within ".title"
     And I should NOT see "WIP" within ".omitteds"
    When I follow "Manage Parts"
     And I fill in "add_parent" with "Parent"
     And I press "Update"
    Then I should see "Parent (Book)" within ".title"
    When I am on the homepage
    And I follow "Where am I?" within "#position_1"
      Then I should see "Where am I? (Single)" within ".title"
    When I follow "Manage Parts"
     And I fill in "add_parent" with "Parent"
     And I press "Update"
    Then I should see "Parent (Book)" within ".title"
    And I should see "Hogwarts" within "#position_1"
    And I should see "Where am I?" within "#position_2"
    When I follow "Hogwarts" within "#position_1"
      Then I should see "Hogwarts (Chapter)" within ".title"
      And I should see "Next: Where am I? (Chapter)"
    When I follow "Parent"
      And I follow "Refetch"
      And I fill in "url" with ""
      And I fill in "url_list" with
        """
        https://archiveofourown.org/works/692/chapters/803
        https://archiveofourown.org/works/692/chapters/804
        """
    And I press "Refetch"
    Then I should see "Refetched" within "#flash_notice"
    Then I should see "Parent (Book)" within ".title"
    And I should NOT see "Time Was" within ".title"
    When I follow "Where am I?" within "#position_1"
      Then I should see "Where am I? (Chapter)" within ".title"
      And I should see "Next: Hogwarts (Chapter)"

  Scenario: ensure rebuild meta isn’t refetching
    Given I have no pages
      And I have no tags
      And I have no authors
      And a tag exists with name: "popslash" AND type: "Fandom"
       And I Drive Myself Crazy exists
    When I am on the homepage
    Then I should see "please no crossovers" within "#position_1"
      And I should see "AJ/JC" within "#position_1"
      And I should see "Make the Yuletide Gay" within "#position_1"
      And I should see "by: Sidra" within "#position_1"
    When I follow "I Drive Myself Crazy"
      And I follow "Notes"
      And I fill in "page_notes" with "testing notes"
      And I press "Update"
    Then I should see "testing notes" within ".notes"
      And I should NOT see "please no crossovers" within ".notes"
      And I should NOT see "AJ/JC" within ".notes"
      And I should NOT see "Make the Yuletide Gay" within ".notes"
      And I should NOT see "by: Sidra" within ".notes"
    Given an author exists with name: "Sidra"
      And I press "Rebuild Meta"
    Then I should see "Sidra" within ".authors"
      And I should NOT see "by: Sidra" within ".notes"
      And I should see "please no crossovers" within ".notes"
      And I should see "AJ/JC" within ".notes"
      And I should see "Make the Yuletide Gay" within ".notes"
    When I follow "Notes"
      And I fill in "page_notes" with "testing notes"
      And I press "Update"
    Then I should see "testing notes" within ".notes"
      And I should NOT see "AJ/JC" within ".notes"
      And I should NOT see "Make the Yuletide Gay" within ".notes"
    When I follow "Edit Raw HTML"
     And I fill in "pasted" with ""
     And I press "Update Raw HTML"
    When I press "Rebuild Meta"
    Then I should see "can’t find title (Single)"
      And I should NOT see "AJ/JC" within ".notes"
      And I should NOT see "testing notes" within ".notes"

  Scenario: rebuild from raw should rebuild meta
    Given I have no pages
      And I have no tags
      And I have no authors
      And a tag exists with name: "popslash" AND type: "Fandom"
       And I Drive Myself Crazy exists
    When I am on the homepage
    When I follow "I Drive Myself Crazy"
      And I follow "Notes"
      And I fill in "page_notes" with "testing notes"
      And I press "Update"
    Then I should see "testing notes" within ".notes"
    Given an author exists with name: "Sidra"
      And I press "Rebuild from Raw HTML"
    Then I should see "Sidra" within ".authors"
      And I should NOT see "by: Sidra" within ".notes"
      And I should see "please no crossovers" within ".notes"
      And I should NOT see "testing notes" within ".notes"

  Scenario: formatting notes
    Given I have no pages
    And Bad Formatting exists
    When I am on the homepage
      Then I should NOT see "theirsThe"
      But I should see "He is theirs The clones have nothing"
    When I view the content
      Then I should NOT see "doesnâ€™t"
      But I should see "It doesn’t always work"

  Scenario: quotes in notes download bug
    Given I have no pages
    And Quoted Notes exists
    When I am on the homepage
    And I follow "ePub"
    Then the download epub file should exist

  Scenario: multiple authors
  Given I have no pages
    And Multi Authors exists
  When I am on the homepage
    And I follow "edge of providence"
    Then I should see "by: adiduck (book_people), whimsicalimages" within ".notes"
    And I should NOT see "et al" within ".notes"
  Given an author exists with name: "book_people (adiduck)"
    And I press "Rebuild Meta"
    Then I should see "et al: whimsicalimages" within ".notes"
    And I should see "book_people" within ".authors"
  Given I have no authors
  And an author exists with name: "adiduck (book_people)"
      And I press "Rebuild Meta"
    Then I should see "et al: whimsicalimages" within ".notes"
    And I should see "adiduck" within ".authors"

  # The following isn't by design. it's just a limitation of how i store author names
  Given I have no authors
  And an author exists with name: "book_people"
      And I press "Rebuild Meta"
    Then I should see "by: adiduck (book_people), whimsicalimages" within ".notes"
    And I should NOT see "book_people" within ".authors"

  Scenario: toggle Other Fandom
  Given I have no pages
  And I have no tags
    And Skipping Stones exists
  When I am on the homepage
    And I follow "Skipping Stones"
    Then I should see "Other Fandom" within ".fandoms"
    And I should see "Harry Potter" within ".notes"
    But I should NOT see "Rowling" within ".notes"
  Given a tag exists with name: "Harry Potter" AND type: "Fandom"
    And I press "Rebuild Meta"
    Then I should NOT see "Harry Potter" within ".fandoms"
    But I should see "Other Fandom" within ".fandoms"
    And I should see "Harry Potter" within ".notes"
  When I press "Toggle Other Fandom"
    Then I should NOT see "Other Fandom" within ".fandoms"
    And I should NOT see "Harry Potter" within ".fandoms"
  When I press "Rebuild Meta"
    Then I should see "Harry Potter" within ".fandoms"

  Scenario: multiple fandoms and author on a Single
  Given I have no pages
  And I have no fandoms
    And Alan Rickman exists
  When I am on the page with url "https://archiveofourown.org/works/5720104"
    Then I should see "Other Fandom" within ".fandoms"
    And I should see "Harry Potter, Die Hard, Robin Hood" within ".notes"
    And I should see "by: manicmea" within ".notes"
   But I should NOT see "Rowling" within ".notes"
    And I should NOT see "Movies" within ".notes"
    And I should NOT see "Prince" within ".notes"
    And I should NOT see "1991" within ".notes"
  When a tag exists with name: "Harry Potter" AND type: "Fandom"
  And an author exists with name: "manicmea"
  When I press "Toggle Other Fandom"
    And I press "Rebuild Meta"
    Then I should see "Harry Potter" within ".fandoms"
    And I should see "manicmea" within ".authors"
    And I should see "Die Hard, Robin Hood" within ".notes"
    But I should NOT see "manicmea" within ".notes"

  Scenario: don't over-match fandoms
   Given I have no pages
  And I have no fandoms
    And Yer a Wizard exists
    And I am on the page with title "Yer a Wizard, Drizzt"
    Then I should see "Other Fandom" within ".fandoms"
    And I should see "Forgotten Realms, Legend of Drizzt Series, Starlight and Shadows Series" within ".notes"
  When a tag exists with name: "Person of Interest" AND type: "Fandom"
    And I press "Toggle Other Fandom"
    Then I should NOT see "Other Fandom" within ".fandoms"
    And I press "Rebuild Meta"
    Then I should NOT see "Other Fandom" within ".fandoms"
    And I should see "Forgotten Realms, Legend of Drizzt Series, Starlight and Shadows Series" within ".notes"
  When a tag exists with name: "Forgotten Realms/Drizzt" AND type: "Fandom"
    And I press "Rebuild Meta"
    Then I should see "Forgotten Realms/Drizzt" within ".fandoms"
    And I should see "Starlight and Shadows Series" within ".notes"

  Scenario: don't match fandoms if Other Fandoms tag exists
   Given I have no pages
  And I have no fandoms
    And Yer a Wizard exists
    And a tag exists with name: "Person of Interest" AND type: "Fandom"
  When I am on the page with title "Yer a Wizard, Drizzt"
    Then I should see "Forgotten Realms, Legend of Drizzt Series, Starlight and Shadows Series" within ".notes"
    And I should see "Other Fandom" within ".fandoms"
  When a tag exists with name: "Forgotten Realms/Drizzt" AND type: "Fandom"
    And I press "Rebuild Meta"
    Then I should NOT see "Forgotten Realms/Drizzt" within ".fandoms"
    And I should see "Forgotten Realms, Legend of Drizzt Series, Starlight and Shadows Series" within ".notes"

   Scenario: works in a series still have authors if the series doesn't
    Given I have no pages
    And I have no tags
    And Counting Drabbles exists
    And I am on the page with title "Skipping Stones"
      Then I should see "Parent: Counting Drabbles (Series)"
      And I should see "Next: The Flower [sequel to Skipping Stones] (Single)"
      And I should see "Skipping Stones (Single)" within ".title"
      And I should see "by: Sidra" within ".notes"
    When an author exists with name: "Sidra"
    When I press "Rebuild Meta"
      Then I should NOT see "by: Sidra" within ".notes"
      But I should see "Sidra" within ".authors"
    When I follow "Counting Drabbles"
      And I follow "Authors" within ".edits"
      And I select "Sidra" from "page_author_ids_"
      And I press "Update Authors"
      Then I should see "Sidra" within ".authors"
    When I follow "The Flower"
      Then I should see "by: Sidra" within ".notes"
    When I press "Rebuild Meta"
      Then I should NOT see "by: Sidra" within ".notes"
      And I should NOT see "Sidra" within ".authors"

   Scenario: works in a series still have fandoms if the series doesn't
    Given I have no pages
    And I have no tags
    And Counting Drabbles exists
    And I am on the page with title "Skipping Stones"
    Then I should see "Other Fandom" within ".fandoms"
      Then I should see "Harry Potter" before "Harry Potter/Unknown" within ".notes"
    When a tag exists with name: "harry potter" AND type: "Fandom"
    And I press "Toggle Other Fandom"
    When I press "Rebuild Meta"
      Then I should NOT see "Harry Potter" before "Harry Potter/Unknown" within ".notes"
      But I should see "harry potter" within ".fandoms"
    When I follow "Counting Drabbles"
      And I follow "Tags" within ".edits"
      And I select "harry potter" from "page_fandom_ids_"
      And I press "Update Tags"
      Then I should see "harry potter" within ".fandoms"
    When I follow "The Flower"
      Then I should see "Harry Potter" within ".notes"
    When I press "Rebuild Meta"
      Then I should NOT see "Harry Potter" before "Harry Potter/Unknown" within ".notes"
      And I should NOT see "harry potter" within ".fandoms"

  Scenario: single of work should have work title, not chapter title
    Given I have no pages
      And I have no tags
      And Fuuinjutsu exists
      When I am on the homepage
      Then I should NOT see "Chapter 1"
      But I should see "Fuuinjutsu+Chakra+Bonds+Clones, Should not be mixed by Uzumakis"

  Scenario: no author or fandom or relationships shouldn't get empty paragraph
    Given I have no pages
      And an author exists with name: "esama"
    When a tag exists with name: "Harry Potter" AND type: "Fandom"
      And Wheel exists
    When I am on the homepage
      Then I should NOT see "; Harry has been thinking"
      But I should see "Harry has been thinking"

