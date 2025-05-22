Feature: more ao3 fetch stuff

Scenario: refetch Single
  Given "harry potter" is a "Fandom"
    And Where am I exists
    And I am on the page with title "Where am I?"
    And I change its raw html to "oops"
    And I follow "Notes"
    And I fill in "page_notes" with "changed notes"
    And I press "Update"
    And I follow "Refetch"
    And I press "Refetch"
  Then I should see "Refetched" within "#flash_notice"
    And I should see "Where am I?" within ".title"
    And I should NOT see "1."
    And I should see "by Sidra" within ".notes"
    And I should NOT see "changed notes" within ".notes"
    And I should NOT see "WIP" within ".size"
    And the contents should include "Amy woke slowly"
    But the contents should NOT include "oops"

Scenario: refetching top level fic shouldn't change chapter titles if i've modified them
  Given Time Was exists
  When I am on the page with title "Hogwarts"
    And I change the title to "Hogwarts (abandoned)"
    And I follow "Time Was, Time Is"
    And I follow "Refetch"
    And I press "Refetch"
  Then I should see "Refetched" within "#flash_notice"
    And I should see "Hogwarts (abandoned)" within "#position_2"

Scenario: getting book by adding parent and then refetching
  Given Where am I exists
  When I am on the page's page
    And I add a parent with title "Parent"
    And I follow "Refetch"
    And I press "Refetch"
  Then I should see "Refetched" within "#flash_notice"
    And I should see "Time Was, Time Is (Book)" within ".title"
    And I should see "WIP" within ".size"
    And I should see "Where am I?" within "#position_1"
    And I should see "Hogwarts" within "#position_2"

Scenario: fetching a series from before series had urls
  Given Misfits existed
  When I am on the page with title "Misfit Series"
    And I follow "Refetch"
    And I fill in "url" with "https://archiveofourown.org/series/334075"
    And I press "Refetch"
  Then I should see "Refetched" within "#flash_notice"
    And I should see "Misfits (Series)" within ".title"
    And I should see "Three Misfits in New York" within "#position_1"
    And I should see "A Misfit Working Holiday In New York" within "#position_2"
    And I should have 7 pages

Scenario: storing a series when I already have one of its singles
  Given "harry potter" is a "Fandom"
    And Skipping Stones exists
  When I am on the mini page
    And I fill in "page_url" with "https://archiveofourown.org/series/46"
    And I press "Store"
  Then I should see "Counting Drabbles (Series)" within ".title"
    And I should see "harry potter" within ".fandoms"
    And I should see "Skipping Stones" within "#position_1"
    And I should see "by Sidra; Harry Potter/Unknown;" within "#position_1"
    And I should see "The Flower" within "#position_2"
    And I should have 3 pages
    And "Skipping Stones" should be a "Single"

Scenario: adding a url to a series
  Given "harry potter" is a "Fandom"
    And Counting Drabbles exists without a URL
  When I am on the page's page
    And I follow "Refetch"
    And I fill in "url" with "https://archiveofourown.org/series/46"
    And I press "Refetch"
  Then I should have 3 pages
    And "Skipping Stones" should be a "Single"
    And "Counting Drabbles" should be a "Series"

Scenario: creating a series when I already have its books
  Given Misfits existed
    And I am on the homepage
    And I follow "Misfit Series"
    And I press "Uncollect"
  When I fill in "page_url" with "https://archiveofourown.org/series/334075"
    And I press "Store"
  Then I should see "Page created"
    And I should see "Misfits (Series)" within ".title"
    And I should see "Other Fandom" within ".fandoms"
    And I should see "Three Misfits in New York" within "#position_1"
    And I should see "A Misfit Working Holiday In New York" within "#position_2"
    And I should have 7 pages

Scenario: refetching a one-page Single into a Book from page
  Given "harry potter" is a "Fandom"
    And "Sidra" is an "Author"
    And Where am I existed and was read
  When I am on the page with title "Time Was, Time Is"
    And I follow "Refetch"
    And I press "Refetch"
  Then I should see "Refetched" within "#flash_notice"
    And I should see "Time Was, Time Is (Book)" within ".title"
    And I should see "1. Where am I?"
    And I should see "2. Hogwarts"
    And I should NOT see "Using time-travel" within ".parts"
    But I should see "Using time-travel" within ".notes"
    And I should NOT see "written for nanowrimo" within ".parts"
    But I should see "written for nanowrimo" within ".notes"
    And I should see "giving up on nanowrimo" within ".parts"

Scenario: refetching a one-page Single into a Book from new
  Given "harry potter" is a "Fandom"
    And "Sidra" is an "Author"
    And Where am I existed and was read
  When I am on the mini page
    And I fill in "page_url" with "https://archiveofourown.org/works/692"
    And I press "Refetch"
  Then I should see "Time Was, Time Is (Book)" within ".title"

Scenario: refetch a single shouldn't make it a chapter
  Given I Drive Myself Crazy exists
  When I am on the page's page
    And I follow "Refetch"
    And I press "Refetch"
  Then I should see "I Drive Myself Crazy (Single)"
    And I should have 1 page

Scenario: refetching reading makes parent reading
  Given "harry potter" is a "Fandom"
    And "Sidra" is an "Author"
    And Where am I existed and was read
    And I download its epub
  When I am on the mini page
    And I fill in "page_url" with "https://archiveofourown.org/works/692"
    And I press "Refetch"
  Then I should see "Time Was, Time Is (Book)" within ".title"
    And "Reading" should be checked

Scenario: refetch from ao3 when it used to be somewhere else
  Given skipping exists
    And I am on the page's page
    And I follow "Refetch"
    And I fill in "url" with "http://archiveofourown.org/works/688"
    And I press "Refetch"
  Then I should see "Refetched" within "#flash_notice"
    And I should see "by Sidra"
    And I should NOT see "ambtus"
    And I should see "Skipping Stones (Single)" within ".title"
    And I should see "thanks to lauriegilbert"
    And the contents should include "Skip. Skip."

Scenario: fetch a work from a collection
  Given I am on the mini page
  When I fill in "page_url" with "https://archiveofourown.org/collections/Heliocentrism/works/21684820"
    And I press "Store"
  Then my page named "A Conversation Overheard by a Captive Faking Unconsciousness" should have url: "https://archiveofourown.org/works/21684820"

Scenario: refetch a single in a series to a book
  Given Misfits first chapter of second work exists
  When I am on the page with title "A Misfit Working Holiday In New York"
    And I follow "Refetch"
    And I press "Refetch"
  Then I should see "Parent: Misfit Series (Series)"
    And I should see "A Misfit Working Holiday In New York (Book)"
    And I should see "(4 parts)"

Scenario: fetch a group of works (e.g. a users fandom collection)
  Given I am on the mini page
    And I fill in "page_url" with "https://archiveofourown.org/users/WriteThroughTheNight/works?fandom_id=258526"
  When I press "Store"
  Then I should have 2 works
    And my page named "Rest In Peace" should have url: "https://archiveofourown.org/works/1358119"
    And my page named "Fancy Seeing You Here" should have url: "https://archiveofourown.org/works/1151707"
    And I should see "2 pages created."

Scenario: fetch a group of works (e.g. a search)
  Given I am on the mini page
    And I fill in "page_url" with "https://archiveofourown.org/works?commit=Sort+and+Filter&user_id=Sidra&include_work_search%5Bfreeform_ids%5D%5B%5D=663"
  When I press "Store"
  Then I should have 4 works
    And I should see "4 pages created."
    And all wordcounts should be 100

Scenario: ignore already created works in search
  Given Time Was exists
  When I am on the mini page
    And I fill in "page_url" with "https://archiveofourown.org/works?commit=Sort+and+Filter&include_work_search%5Bfreeform_ids%5D%5B%5D=2485&user_id=Sidra"
  When I press "Store"
  Then I should see "0 pages created."
