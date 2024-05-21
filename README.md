# Facio

Command pattern for Ruby (on Rails). From Wikipedia:

> In object-oriented programming, the command pattern is a behavioral design pattern in which an object is used to encapsulate all information needed to perform an action or trigger an event at a later time. This information includes the method name, the object that owns the method and values for the method parameters.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add facio

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install facio

## Usage
**Every** service has a context, which encapsulates all the information to perform the action.

simple_service.rb:
```ruby
class SimpleService < Facio::Service
  context do
    attribute :value
    attribute :result
  end
  def perform
    context.result = context.value.to_s.reverse
  end
end
```

You can call the service as follows:
```ruby
SimpleService.perform(value: "no lemon, no melon").result # => "nolem on ,nomel on"
```

later_service.rb:
```ruby
class LaterService < Facio::Service
  context do
    attribute :message
    attribute :result
  end
  def perform
    context.message.text.reverse
    context.message.save!
  end
end
```

You can also have the service execute at a later time:
```ruby
SimpleService.perform_later(message: Message.find(1))
```
In this case, once the service is done, you should see the Message's text being reversed.


### Context

A context is just an PORO, which includes the ActiveModel::API. 
Context can be created in separate files, but also inline in the service. 
Using context like below will then construct a Class, with Facio::Context as a base_class. 
As mentioned above, a context encapsulates all information to perform the action, for simple services like above you can inline the context. You can also use external context classes and refer to the in the inline class using the base_class

some_context.rb
```ruby
class SomeContext < Facio::Context
  attribute :special
end
```

simple_service.rb:
```ruby
class OtherService < Facio::Service
  context base_class: "SomeContext" do
    attribute :value
    attribute :result
  end
  def perform
    context.result = context.value.to_s.reverse
    context.result += "special" if context.special.present?
  end
end
```

Next to this, you can have your service-class be accompanied by a context-class. The service will find the matching context:

fancy_context.rb
```ruby
class FancyContext < Facio::Context
  attribute :fancy
end
```

fancy_service.rb
```ruby
class Fancy:Service < Facio::Service
  def perform
    context.result = context.fancy.to_s.reverse
  end
end
```

A context is in basis a ActiveModel, with useful extra's allowing for associations (has_one/has_many). 
It also has a type caster for models, so that you can pass the id or the model itself into an attribute.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
