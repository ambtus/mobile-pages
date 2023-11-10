Feature: wikipedia descriptions of audiobooks

Scenario: death on the nile
  Given Death on the Nile exists
  When I am on the page's page
  Then I should see "Death on the Nile (Single)"

Scenario: death on the nile
  Given Death on the Nile exists
  When I read it online
  Then I should see "1937 novel by Agatha Christie"
    And I should see "so that we can see the truth..."
    But I should NOT see "Adaptations"
    And I should NOT see "From Wikipedia, the free encyclopedia"

Scenario: death in the clouds
  Given Death in the Clouds exists
  When I am on the page's page
  Then I should see "Death in the Clouds (Single)"

Scenario: death in the clouds
  Given Death in the Clouds exists
  When I read it online
  Then I should see "1935 Poirot novel by Agatha Christie"
    And I should see "thought him a barbarian."
    But I should NOT see "Adaptations"
    And I should NOT see "From Wikipedia, the free encyclopedia"

Scenario: dumb witness
  Given Dumb Witness exists
  When I am on the page's page
  Then I should see "Dumb Witness (Single)"

Scenario: dumb witness
  Given Dumb Witness exists
  When I read it online
  Then I should see "Dumb Witness is a detective fiction novel by British writer"
    And I should see "Poirot confessed naively."
    But I should NOT see "Adaptations"
    And I should NOT see "From Wikipedia, the free encyclopedia"

Scenario: mews
  Given Murder in the Mews exists
  When I am on the page's page
  Then I should see "Murder in the Mews (Single)"

Scenario: mews
  Given Murder in the Mews exists
  When I read it online
  Then I should see "1937 story collection by Agatha Christie"
    And I should see "which was later collected in Poirot's Early Cases."
    But I should NOT see "Film, TV or theatrical adaptations"
    And I should NOT see "From Wikipedia, the free encyclopedia"

