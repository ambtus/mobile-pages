Feature: lj specific stuff

Scenario: download livejournal adult content
  Given a page exists with url: "http://sidra.livejournal.com/3265.html"
  Then the contents should NOT include "Adult Content"
    And the contents should include "alien"
