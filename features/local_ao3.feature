Feature: ao3 testing that can use local cached files
         so I don't have to constantly be fetching from
         (would need to be updated if ao3 changes it's format)

Scenario: ao3 with and without chapter titles
  Given Open the Door exists
  When I am on the page with title "Open the Door"
  Then I should see "Chapter 1" within "#position_1"
    And I should see "2. Ours" within "#position_2"
    But I should NOT see "1. Chapter 1"
    And the part titles should be stored as "Chapter 1 & Ours"
    And I should NOT see "WIP" within ".omitteds"

Scenario: ao3 2/2 (not WIP)
  Given Open the Door exists
  When I am on the page with title "Open the Door"
  Then I should NOT see "WIP" within ".omitteds"

Scenario: deliberately download chapter 1 shows summary and notes
  Given Where am I exists
  When I am on the homepage
    And I follow "Where am I"
  Then I should see "Where am I? (Single)" within ".title"
    And I should see "Using time-travel"
    And I should see "written for"

Scenario: rebuild meta shouldn't refetch
  Given I Drive Myself Crazy exists
  When I am on the page's page
    And I follow "Edit Raw HTML"
    And I fill in "pasted" with ""
    And I press "Update Raw HTML"
    And I press "Rebuild Meta"
  Then I should see "can’t find title (Single)"
    And I should NOT see "by Sidra" within ".notes"

Scenario: rebuild from raw should also rebuild meta
  Given I Drive Myself Crazy exists
    And "Sidra" is an "Author"
  When I am on the homepage
    And I follow "I Drive Myself Crazy"
    And I follow "Notes"
    And I fill in "page_notes" with "testing notes"
    And I press "Update"
    And I press "Rebuild from Raw HTML"
  Then I should see "Sidra" within ".authors"
    And I should NOT see "by Sidra" within ".notes"
    And I should see "please no crossovers" within ".notes"
    And I should NOT see "testing notes" within ".notes"

Scenario: bad formatting notes
  Given Bad Formatting exists
  When I am on the homepage
  Then I should see "He is theirs The clones have nothing"
    And I should NOT see "theirsThe"

Scenario: bad formatting content
  Given Bad Formatting exists
  When I am on the page's page
    And I view the content
  Then I should see "It doesn’t always work"
    And I should NOT see "doesnâ€™t"

Scenario: quotes in notes download bug
  Given Quoted Notes exists
  When I am on the homepage
    And I follow "ePub"
  Then the download epub file should exist

Scenario: multiple authors - none in Authors
  Given Multi Authors exists
  When I am on the page's page
  Then I should see "by adiduck (book_people), whimsicalimages" within ".notes"
    And I should NOT see "et al" within ".notes"

Scenario: multiple authors - some in Authors
  Given "adiduck (book_people)" is an "Author"
    And Multi Authors exists
  When I am on the page's page
  Then I should see "adiduck (book_people)" within ".authors"
    And I should see "et al: whimsicalimages" within ".notes"

Scenario: multiple authors - reversed in Authors
  Given "book_people (adiduck)" is an "Author"
    And Multi Authors exists
  When I am on the page's page
  Then I should see "book_people (adiduck)" within ".authors"
    And I should see "et al: whimsicalimages" within ".notes"

Scenario: multiple authors - primary in Authors
  Given "adiduck" is an "Author"
    And Multi Authors exists
  When I am on the page's page
  Then I should see "adiduck" within ".authors"
    And I should see "et al: whimsicalimages" within ".notes"
    And I should NOT see "book_people"

Scenario: multiple authors - aka in Authors
  Given "book_people" is an "Author"
    And Multi Authors exists
  When I am on the page's page
  Then I should see "book_people" within ".authors"
    And I should see "et al: whimsicalimages" within ".notes"
    And I should NOT see "adiduck" within ".authors"

Scenario: Other Fandom if fandom doesn't exists
  Given Skipping Stones exists
  When I am on the page's page
  Then I should see "Other Fandom" within ".fandoms"
    And I should see "Harry Potter" before "Harry Potter/Unknown" within ".notes"

Scenario: Other Fandom prevents fandom matching
  Given Skipping Stones exists
    And "Harry Potter" is a "Fandom"
  When I am on the page's page
    And I press "Rebuild Meta"
  Then I should see "Other Fandom" within ".fandoms"
    And I should see "Harry Potter" before "Harry Potter/Unknown" within ".notes"

Scenario: toggling Other Fandom allows fandom matching
  Given Skipping Stones exists
    And "Harry Potter" is a "Fandom"
  When I am on the page's page
    And I press "Toggle Other Fandom"
  Then I should see "Harry Potter" within ".fandoms"
    And I should NOT see "Harry Potter" before "Harry Potter/Unknown" within ".notes"

Scenario: multiple fandoms and author on a Single
  Given Alan Rickman exists
  When I am on the page's page
  Then I should see "Other Fandom" within ".fandoms"
    And I should see "Harry Potter, Die Hard, Robin Hood" within ".notes"
    And I should see "by manicmea" within ".notes"
    But I should NOT see "Rowling" within ".notes"
    And I should NOT see "Movies" within ".notes"
    And I should NOT see "Prince" within ".notes"
    And I should NOT see "1991" within ".notes"

Scenario: some fandoms match
  Given "Harry Potter" is a "Fandom"
    And Alan Rickman exists
  When I am on the page's page
  Then I should see "Harry Potter" within ".fandoms"
    And I should see "Die Hard, Robin Hood" within ".notes"
    But I should NOT see "Harry Potter" within ".notes"

Scenario: check before don't over-match
  Given Yer a Wizard exists
    And I am on the page's page
  Then I should see "Other Fandom" within ".fandoms"
    And I should see "Forgotten Realms, Legend of Drizzt Series, Starlight and Shadows Series" within ".notes"

Scenario: don't over-match "of" in fandoms
  Given "Person of Interest" is a "Fandom"
    And Yer a Wizard exists
    And I am on the page's page
  Then I should NOT see "Person of Interest" within ".fandoms"
    And I should see "Forgotten Realms, Legend of Drizzt Series, Starlight and Shadows Series" within ".notes"

Scenario: do match Drizzt (as aka)
  Given "Forgotten Realms (Drizzt)" is a "Fandom"
    And Yer a Wizard exists
    And I am on the page's page
  Then I should see "Forgotten Realms (Drizzt)" within ".fandoms"
    And I should see "Starlight and Shadows Series" within ".notes"
    But I should NOT see "Legend of Drizzt Series" within ".notes"

Scenario: do match Drizzt (as first)
  Given "Drizzt (Forgotten Realms)" is a "Fandom"
    And Yer a Wizard exists
    And I am on the page's page
  Then I should see "Drizzt (Forgotten Realms)" within ".fandoms"
    And I should see "Starlight and Shadows Series" within ".notes"
    But I should NOT see "Legend of Drizzt Series" within ".notes"

Scenario: works in a series still have authors in notes even if the series doesn't
  Given Counting Drabbles exists
    And I am on the page with title "Skipping Stones"
  Then I should see "Parent: Counting Drabbles (Series)"
    And I should see "Next: The Flower [sequel to Skipping Stones] (Single)"
    And I should see "Skipping Stones (Single)" within ".title"
    And I should see "by Sidra" within ".notes"

Scenario: works in a series still have fandoms in notes even if the series doesn't
  Given Counting Drabbles exists
  When I am on the page with title "Skipping Stones"
  Then I should see "Other Fandom" within ".fandoms"
    And I should see "Harry Potter" before "Harry Potter/Unknown" within ".notes"

Scenario: single of work should have work title, not chapter title
  Given Fuuinjutsu exists
  When I am on the homepage
  Then I should NOT see "Chapter 1"
    But I should see "Fuuinjutsu+Chakra+Bonds+Clones, Should not be mixed by Uzumakis"

Scenario: no author or fandom or relationships shouldn't get empty paragraph
  Given "esama" is an "Author"
    And "Harry Potter" is a "Fandom"
    And Wheel exists
  When I am on the homepage
    Then I should NOT see "; Harry has been thinking"
    But I should see "Harry has been thinking"
    And the notes should NOT include "<p></p><hr width=\"80%\"/> <p>Harry has been thinking"
    But the notes should include "<p>Harry has been thinking"

 Scenario: series should get their fandoms from the works
  Given "harry potter" is a "Fandom"
    And Counting Drabbles exists
  When I am on the page's page
  Then I should see "harry potter" within ".fandoms"

Scenario: meta on second chapter of book
  Given "harry potter" is a "Fandom"
    And Time Was exists
  When I am on the page with title "Hogwarts"
    Then I should see "Hogwarts (Chapter)" within ".title"
    Then I should NOT see "by Sidra" within ".notes"
    And I should NOT see "Using time-travel" within ".notes"
    And I should NOT see "abandoned" within ".notes"
    But the part titles should be stored as "Where am I? & Hogwarts"

Scenario: meta on first book of series
  Given "harry potter" is a "Fandom"
    And Counting Drabbles exists
  When I am on the page with title "Skipping Stones"
    Then I should see "Parent: Counting Drabbles (Series)"
    And I should see "Next: The Flower [sequel to Skipping Stones] (Single)"
    And I should see "Skipping Stones (Single)" within ".title"
    And I should NOT see "WIP" within ".omitteds"

Scenario: fetch one chapter from ao3
  Given "harry potter" is a "Fandom"
    And Where am I exists
    And I am on the page with title "Where am I?"
   Then I should see "Where am I? (Single)" within ".title"
    And I should NOT see "WIP" within ".omitteds"

Scenario: edit one chapter from ao3
  Given "harry potter" is a "Fandom"
    And Where am I exists
  When I am on the page with title "Where am I?"
    And I follow "Notes"
    And I fill in "page_notes" with "changed notes"
    And I press "Update"
    And I follow "Edit Raw HTML"
    And I fill in "pasted" with "oops"
    And I press "Update Raw HTML"
    And I view the content
  Then I should see "oops"
    And I should NOT see "Amy woke slowly"
    And I should see "changed notes"
    And I should NOT see "Sidra"

Scenario: refetch url
  Given "harry potter" is a "Fandom"
    And Where am I exists
    And I am on the page with title "Where am I?"
  When I follow "Refetch"
  Then the "url" field should contain "https://archiveofourown.org/works/692/chapters/803"

Scenario: check before getting book by adding parent and then refetching
  Given Where am I exists
  When I am on the homepage
    And I follow "Where am I"
  Then I should see "Where am I? (Single)" within ".title"
    And I should NOT see "WIP" within ".omitteds"

Scenario: 2nd check before getting book by adding parent and then refetching
  Given Where am I exists
  When I am on the homepage
    And I follow "Where am I"
    And I follow "Manage Parts"
    And I fill in "add_parent" with "Parent"
    And I press "Update"
    And I follow "Refetch"
  Then I should see "archiveofourown.org/works/692/chapters/803" within "#url_list"
    And the "url" field should contain "https://archiveofourown.org/works/692"

Scenario: check before fetching a series from before all the works had urls
  Given Misfits exists
  When I am on the page with title "Misfit Series"
    And I follow "Refetch"
  Then I should see "A Misfit Working Holiday In New York" within "#url_list"

Scenario: check before creating a series when I already have one of its books
  Given Misfits exists
  When I am on the homepage
    And I follow "Misfit Series"
    And I press "Uncollect"
  Then I should have 6 pages

Scenario: check before refetching a one-page Single into a Book
  Given "harry potter" is a "Fandom"
    And "Sidra" is an "Author"
    And Where am I existed and was read
  When I am on the page with title "Time Was, Time Is"
  Then I should see "Time Was, Time Is (Single)" within ".title"
    And I should see "5" within ".stars"
    And I should see "WIP" within ".omitteds"
    And I should see "harry potter" within ".fandoms"
    And I should see "Sidra" within ".authors"
    And I should see "Using time-travel"
    And I should see "written for nanowrimo"
    And I should NOT see "unread"
    And last read should be today

Scenario: check before refetching a one-page Single into a Book
  Given "harry potter" is a "Fandom"
    And "Sidra" is an "Author"
    And Where am I existed and was read
  When I am on the page with title "Time Was, Time Is"
    And I follow "Refetch"
  Then the "url" field should contain "https://archiveofourown.org/works/692"

Scenario: check before refetching a read Series should show it as unread
  Given Counting Drabbles partially exists
  When I am on the page with title "Counting Drabbles"
  Then I should see "100 words" within ".size"
    And I should see "by Sidra" within ".notes"
    And I should see "Harry Potter" within ".notes"
    And I should see "Implied snarry" within ".notes"
    And I should see "thanks to lauriegilbert!" within ".notes"
    And I should see "1. Skipping Stones" within "#position_1"
    And I should see "by Sidra; Harry Potter; Harry Potter/Unknown;" within "#position_1"
    And I should NOT see "The Flower"

Scenario: check before adding an unread chapter to a book makes the book unread
  Given Time Was partially exists
  When I am on the homepage
    And I follow "Time Was, Time Is"
  Then I should see today within ".last_read"
    But I should NOT see "unread parts" within ".last_read"
    And I should see today within "#position_1"
