Feature: Feature flipping at an application level

  Scenario Outline: Features can be declared as enabled or disabled and remain as such
    When I define a feature that is '<enabled_or_disabled>'
    Then the feature is '<enabled_or_disabled>'

    Examples:
      | enabled_or_disabled |
      |             enabled |
      |            disabled |
