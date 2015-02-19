Flip Fab
--------

**Feature flipping... Made FaBuLoUs!**

A gem providing persistent (via cookie store) feature flipping to Rack applications.

This allows you to...

* Define features that can be used to modify the behaviour of an application
* Persist the features' states in a user's cookie so that they see a consistent feature set for all applications in a domain
* Define your own custom persistence adapters to persist features in your own data store

## Usage

Add the following to your `Gemfile`

```ruby
gem 'flip_fab', git: 'git@github.com:simplybusiness/flip_fab.git'
```

### Rails

The helper will be included in `ActionController::Base` as a view helper method when the gem is loaded.

### Sinatra

Add the following to `Sinatra::Base`

```ruby
require 'flip_fab'
helpers FlipFab::Helper
```

## Defining a feature

For Rails, this could go in `config/initializers/flip_fab.rb`

```ruby
FlipFab.define_feature(:name_of_feature) # default state: :disabled
FlipFab.define_feature(:name_of_other_feature, { default: :enabled }) # default state: :enabled
```

## Enabling/disabling a feature for a user

### Within the context of a controller

```ruby
features[:name_of_feature].enable # Enable the feature for the user
features[:name_of_feature].enabled? # => true
features[:name_of_feature].disable # Disable the feature for the user
features[:name_of_feature].disabled? # => true
```

* If the feature is not defined, `features[:name_of_feature]` will return `nil`
* The enabled/disabled feature will be stored in the user's cookie

### Outside of a controller

Outside of a controller, features cannot be enabled/disabled for individual users.

### From URL params

`http://localhost:3000?name_of_feature=enabled&name_of_other_feature=disabled`

* The features' states specified in the URL will take precendence over those specified in the controller
* The enabled/disabled features will be stored in the user's cookie
* Smoke tests could enable or disable features using this mechanism

## Checking if a feature is enabled

### From within a controller or view

```ruby
# With the feature having been enabled for the user:
features[:name_of_feature].enable # Enable the feature for the user

features[:name_of_feature].enabled? # => true
features[:name_of_feature].disabled? # => false
```

### Outside of a controller/view

```ruby
# With the feature defined like this:
FlipFab.define_feature(:name_of_feature) # default state: :disabled

FlipFab.features[:name_of_feature].enabled? # => false
FlipFab.features[:name_of_feature].disabled? # => true
```

### Precedence of feature lookup

1. URL parameter
1. Cookie
1. Default

## Cookie persistence

Out of the box, the features a user receives can be persisted in their cookie. The cookie will have the following parameters:

| Parameter | Value |
| --------- | ----- |
| Name      | `flip_fab.[name of feature]` |
| Value     | `enabled|disabled` |
| Path      | `/` |
| Expires   | One year from now |
| Domain    | The top-level domain |

To persist the features in a user's cookie, do any of the following operations

```ruby
features[:name_of_feature].enable # Enable the feature for the user
features[:name_of_feature].disable # Disable the feature for the user
features[:name_of_feature].persist # Persist the feature for the user
```

## Defining a custom persistence adapter

1. Create a class that extends the `FlipFab::Persistence` class

  ```ruby
  class ExamplePersistence < FlipFab::Persistence

    def initialize feature_name, context
      super
    end

    def read
      # lookup the state of the feature
    end

    def write state
      # write the state of the feature
    end
  end
  ```

1. Implement the `read` and `write` operations. The following variables will be available from `FlipFab::Persistence`
  1. `feature_name` - the name of the feature to be read/written
  1. `context` - the controller context (whatever class has included `FlipFab::Helper`)

1. Include your persistence class when defining the feature

  ```ruby
  FlipFab.define_feature(:name_of_other_feature, { persistence_adapters: [ExamplePersistence] })
  ```

Note that you can define multiple custom adapters that will be read in precedence of the order specified
