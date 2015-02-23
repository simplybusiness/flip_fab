Feature: Feature flipping in the context of a request, session, etc.

  Scenario Outline: A feature can be flipped and remains flipped in the provided context
    Given there is a feature with a default state of '<default_state>'
      And there are two contexts
     Then the feature is '<default_state>' in the first context, '<default_state>' in the second context
     When I 'enable' the feature in the first context
     Then the feature is 'enabled' in the first context, '<default_state>' in the second context
     When I 'disable' the feature in the first context
     Then the feature is 'disabled' in the first context, '<default_state>' in the second context

    Examples:
      | default_state |
      |       enabled |
      |      disabled |

  Scenario Outline: A feature's state can be set in the URL parameters and remains in that state for that user
    Given there is a feature with a default state of '<default_state>' with cookie persistence
     When I override the state in the URL parameters with '<overridden_state>'
     Then the feature is '<overridden_state>' for the user
     When I 'enable' the feature for the user
     Then the feature is '<overridden_state>' for the user
     When I 'disable' the feature for the user
     Then the feature is '<overridden_state>' for the user

    Examples:
      | default_state | overridden_state |
      |       enabled |          enabled |
      |      disabled |         disabled |
      |       enabled |         disabled |
      |      disabled |          enabled |
