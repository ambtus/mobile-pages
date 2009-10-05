Feature: download page with parts

  Scenario: download a multi-part doc
    Given the following page
      | title  | base_url                               | url_substitutions |
      | multi  | http://sidrasue.com/tests/parts/*.html | 1 2 3   |
    When I am on the homepage
    When I follow "Download" in ".title"
    Then my document should contain "stuff for part 1"
      And my document should contain "stuff for part 2"
      And my document should contain "stuff for part 3"
      And my document should contain "# Part 1 #"
      And my document should contain "# Part 2 #"
      And my document should contain "# Part 3 #"
