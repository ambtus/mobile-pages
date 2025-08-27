Feature: tools to enable onscreen content editing
         can be used to fix a small irritating typo
         especially if it's messing up your attempt at podficcing
         but major editing should be done by editing the scrubbed html in an editor

Scenario: should be able to edit html if it's a Single
  Given a page exists with url: "http://test.sidrasue.com/test.html"
  When I am on the first page's page
  Then I should see "Page 1 (Single)"
    And I should see "Edit Raw HTML"
    And I should see "Edit Scrubbed HTML"

Scenario: should be able to edit html if it's a Chapter
  Given a page exists with urls: "http://test.sidrasue.com/test.html"
  When I am on the page with title "Part 1"
  Then I should see "Page 1 (Book)" within ".parent"
    And I should see "Edit Raw HTML"
    And I should see "Edit Scrubbed HTML"

Scenario: should NOT be able to edit html if it's a Book
  Given a page exists with urls: "http://test.sidrasue.com/test.html"
  When I am on the first page's page
  Then I should see "Page 1 (Book)" within ".title"
    And I should NOT see "Edit Raw HTML"
    And I should NOT see "Edit Scrubbed HTML"

Scenario: check before editing
  Given an editable page exists
  When I view the text for reading aloud
  Then I should see "L0rem ipsum dolor sit amet"
    And I should see "L5rem ipsum dolor sit amet"
    And I should see "L9rem ipsum dolor sit amet"
    And I should see a horizontal rule
    But I should NOT see two horizontal rules
    And I should NOT see "New Content"
    And I should have 10 nodes

Scenario: edit first section
  Given an editable page exists
  When I view the text for reading aloud
    And I follow "0"
  Then I should see "Edit Text 0 for page: Page 1"
    And I should see "L0rem ipsum dolor sit amet"
    And I should NOT see "L5rem ipsum dolor sit amet"
    And I should NOT see "L9rem ipsum dolor sit amet"

Scenario: preview first section edit
  Given an editable page exists
  When I view the text for reading aloud
    And I follow "0"
    And I fill in "edited" with "<p>New Content<p>"
    And I press "Preview Text"
  Then I should see "L0rem ipsum dolor sit amet" within "#original"
    And I should see "New Content" within "#edited"
    And I should NOT see "L0rem ipsum dolor sit amet" within "#edited"

Scenario: confirm first section edit
  Given an editable page exists
  When I view the text for reading aloud
    And I follow "0"
    And I fill in "edited" with "<p>New Content<p>"
    And I press "Preview Text"
    And I press "Confirm Text Edit"
  Then I should see "New Content"
    And I should NOT see "L0rem ipsum dolor sit amet"

Scenario: recover from editing too much of the first section
  Given an editable page exists
  When I view the text for reading aloud
    And I follow "0"
    And I fill in "edited" with "<p>New Content<p>"
    And I press "Preview Text"
    And I press "Confirm Text Edit"
    And I am on the first page's page
    And I press "Rebuild from Raw HTML"
  Then the contents should include "L0rem ipsum dolor sit amet"
    But the contents should NOT include "New Content"

Scenario: check before editing mid section
  Given an editable page exists
  When I view the text for reading aloud
  Then I should see "L5rem ipsum dolor sit amet"
    But I should NOT see "New Content"

Scenario: edit mid section
  Given an editable page exists
  When I view the text for reading aloud
    And I follow "5"
  Then I should see "Edit Text 5 for page: Page 1"
    And I should NOT see "L0rem ipsum dolor sit amet"
    And I should see "L5rem ipsum dolor sit amet"
    And I should NOT see "L9rem ipsum dolor sit amet"

Scenario: preview mid section edit
  Given an editable page exists
  When I view the text for reading aloud
    And I follow "5"
    And I fill in "edited" with "<p>New Content<p>"
    And I press "Preview Text"
  Then I should see "L5rem ipsum dolor sit amet"
    And I should see "New Content" within "#edited"
    And I should NOT see "L5rem ipsum dolor sit amet" within "#edited"

Scenario: confirm mid section edit
  Given an editable page exists
  When I view the text for reading aloud
    And I follow "5"
    And I fill in "edited" with "<p>New Content<p>"
    And I press "Preview Text"
    And I press "Confirm Text Edit"
  Then I should see "New Content"
    And I should NOT see "L5rem ipsum dolor sit amet"
    But I should see "L0rem ipsum dolor sit amet"
    And I should see "L9rem ipsum dolor sit amet"

Scenario: recover from editing too much of the mid section
  Given an editable page exists
  When I view the text for reading aloud
    And I follow "5"
    And I fill in "edited" with "<p>New Content<p>"
    And I press "Preview Text"
    And I press "Confirm Text Edit"
    And I am on the first page's page
    And I press "Rebuild from Raw HTML"
  Then the contents should include "L5rem ipsum dolor sit amet"
    But the contents should NOT include "New Content"

Scenario: check before editing last section
  Given an editable page exists
  When I view the text for reading aloud
  Then I should see "L9rem ipsum dolor sit amet"
    But I should NOT see "New Content"

Scenario: edit last section
  Given an editable page exists
  When I view the text for reading aloud
    And I follow "9"
  Then I should see "Edit Text 9 for page: Page 1"
    And I should NOT see "L0rem ipsum dolor sit amet"
    And I should NOT see "L5rem ipsum dolor sit amet"
    And I should see "L9rem ipsum dolor sit amet"

Scenario: preview last section edit
  Given an editable page exists
  When I view the text for reading aloud
    And I follow "9"
    And I fill in "edited" with "<p>New Content<p>"
    And I press "Preview Text"
  Then I should see "L9rem ipsum dolor sit amet" within "#original"
    And I should see "New Content" within "#edited"
    And I should NOT see "L9rem ipsum dolor sit amet" within "#edited"

Scenario: confirm last section edit
  Given an editable page exists
  When I view the text for reading aloud
    And I follow "9"
    And I fill in "edited" with "<p>New Content<p>"
    And I press "Preview Text"
    And I press "Confirm Text Edit"
  Then I should see "New Content"
    And I should NOT see "L9rem ipsum dolor sit amet"
    But I should see "L0rem ipsum dolor sit amet"
    And I should see "L5rem ipsum dolor sit amet"

Scenario: recover from editing too much of the last section
  Given an editable page exists
  When I view the text for reading aloud
    And I follow "9"
    And I fill in "edited" with "<p>New Content<p>"
    And I press "Preview Text"
    And I press "Confirm Text Edit"
    And I am on the first page's page
    And I press "Rebuild from Raw HTML"
  Then the contents should include "L9rem ipsum dolor sit amet"
    But the contents should NOT include "New Content"

Scenario: split first section
  Given an editable page exists
  When I view the text for reading aloud
    And I follow "1"
    And I fill in "edited" with "<p>L0rem ipsum dolor sit amet.</p><p>Quisque ultricies faucibus odio.</p>"
    And I press "Preview Text"
    And I press "Confirm Text Edit"
  Then I should have 11 nodes

Scenario: change a section to a horizontal rule
  Given an editable page exists
  When I view the text for reading aloud
    And I follow "5"
    And I fill in "edited" with "<hr>"
    And I press "Preview Text"
    And I press "Confirm Text Edit"
    And I read it online
  Then I should see two horizontal rules
    And I should have 10 nodes

Scenario: remove a section
  Given an editable page exists
  When I view the text for reading aloud
    And I follow "9"
    And I fill in "edited" with ""
    And I press "Preview Text"
    And I press "Confirm Text Edit"
  Then I should have 9 nodes
    And the contents should NOT include "L9rem ipsum dolor sit amet"

Scenario: remove a horizontal rule
  Given an editable page exists
  When I view the text for reading aloud
    And I follow "2"
    And I fill in "edited" with ""
    And I press "Preview Text"
    And I press "Confirm Text Edit"
    And I read it online
  Then I should NOT see a horizontal rule
    And I should have 9 nodes
    And I should see "L0rem ipsum dolor sit amet"
    And I should see "L5rem ipsum dolor sit amet"
    And I should see "L9rem ipsum dolor sit amet"

