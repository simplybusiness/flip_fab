Feature: Persisting the feature state in a cookie

  Background:
    Given the host is 'www.simplybusiness.co.uk'
      And the feature name is 'example_feature'
      And the time is '2015-01-22 15:26:31 +0000'
      And the state of the feature is 'enabled'

  Scenario: The cookie should apply to the root path (/)
    When I persist the feature state in a cookie
    Then the cookie has the path '/'

  Scenario Outline: The cookie should be named using the name of the gem and name of feature, concatenated with a dot
    Given the feature name is '<feature name>'
     When I persist the feature state in a cookie
     Then the cookie has the name '<cookie name>'

    Examples:
      | feature name           | cookie name                     |
      | cool_new_feature       | flip_fab.cool_new_feature       |
      | other_cool_new_feature | flip_fab.other_cool_new_feature |

  Scenario: The cookie should expire after 1 year
    When I persist the feature state in a cookie
    Then the cookie expires at 'Fri, 22 Jan 2016 15:26:31 GMT'

  Scenario Outline: The cookie's value should be the state of the feature
   Given the state of the feature is '<feature state>'
    When I persist the feature state in a cookie
    Then the cookie value is '<feature state>'

   Examples:
     | feature state |
     | enabled       |
     | disabled      |
