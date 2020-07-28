Feature: an ebook with a fandom tag is collected by series (not subjects) for marvin

  Scenario: short and has an info tag (not displayed)
    Given a page exists with infos: "tag1"
    And the download epub command should NOT include tags: "tag1"
    And the download epub command should include tags: "short"
    And the download epub command should include tags: "unread"
    And the download epub command should include comments: "short"
    But the download epub command should NOT include comments: "tag1"

