# Facio

Command pattern for Ruby (on Rails). From Wikipedia:

> In object-oriented programming, the command pattern is a behavioral design pattern in which an object is used to encapsulate all information needed to perform an action or trigger an event at a later time. This information includes the method name, the object that owns the method and values for the method parameters.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add facio

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install facio

## Usage

Every service has a context, which encapsulates all the information to perform the action.
A context is just an PORO, which includes the ActiveModel::API.

simple_context.rb:
```
class SimpleContext < Facio::Context
  attr_accessor :value
  attr_accessor :result
end
```

Then you can define a service, which inherits from ActiveJob::Base. 
This is awesome as it allows you to perform things immediately or at a later time.

simple_service.rb:
```ruby
class SimpleService < Facio::Service
  def perform
    context.result = context.value.to_s.reverse
  end
end
```

You can call the service as follows:
```ruby
result = SimpleService.perform(value: "no lemon, no melon") # => "nolem on ,nomel on"
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
