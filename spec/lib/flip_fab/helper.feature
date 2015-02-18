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
