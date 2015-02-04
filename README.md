Flip Fab
--------

**Feature flipping... Made FaBuLoUs!**

A gem providing persistent, per-user feature flipping to Rack applications.

This allows you to...

* Define features used to modify the behaviour of an application
* Enable or disable features for a user
* Persist the features defined for a user so that they see a consistent feature set for all applications in a domain

Looked into the following feature flipping gems:

- https://github.com/moredip/rack-flags
- https://github.com/pda/flip
- https://github.com/jnunemaker/flipper

None of them suit our needs as they lack one of...

* Work without a data store (e.g. ActiveRecord, Mongo, Redis)
* Code as configuration

## Defining a feature

```ruby
FlipFab.define_feature(:name_of_feature, :enabled) # default state: :enabled
FlipFab.define_feature(:name_of_other_feature, :disabled) # default state: :disabled
```

* The AB testing gem would define any features it exposes upon initialization

## Enabling/disabling a feature for a user

### Within controller context

```ruby
features[:name_of_feature].enable
features[:name_of_feature].disable
```

* If the feature is not defined, `features[:name_of_feature]` will return `nil` - `features` is just a hash
* The enabled/disabled feature will be stored in the user's cookie
* The AB testing gem would plug in here to enable or disable features when starting a test

### From URL params

`http://localhost:3000?name_of_feature=enabled&name_of_other_feature=disabled`

* The features specified in the URL will take precendence over those specified in the controller
* The enabled/disabled features will be stored in the user's cookie

## Checking if a feature is enabled

```ruby
# Called from within a controller or view
features[:name_of_feature].enabled?
features[:name_of_feature].disabled?
```

Precedence of feature lookup:

1. URL parameter
1. Cookie
1. Default

## Storing features on Rfq

When the Rfq is created, we'll need to save the features set onto the web_rfq so that it will be available to the consultant if the Rfq is amended.

When the consultant is amending an Rfq, the features will need to be extracted from the web Rfq and put in the consultant's cookie to make the features accessible to FlipFab.

If a consultant is starting a new Rfq, we'll need to reset the features to their defaults in case they have features set due to the previous Rfq they were amending.

Caveats:

- Breaks X_Rated AB tests as no more storing ab tests in answer set
- Tests that start after the Rfq is created will not be stored on Rfq (thus will not be available in backoffice)
- No more storing ab tests in web_rfq - removed responsibility of ab test publishing from Rfq
