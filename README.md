# Facio

Command pattern for Ruby (on Rails). From Wikipedia:

> In object-oriented programming, the command pattern is a behavioral design pattern in which an object is used to encapsulate all information needed to perform an action or trigger an event at a later time. This information includes the method name, the object that owns the method and values for the method parameters.

It basically allows you to encapsulate bits of code for a specific purpose. It's also nicely explained by [refactoring.guru](https://refactoring.guru/design-patterns/command)

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add facio

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install facio

## Generator

Facio comes with a handy generator to generate a service and context:

```shell
rails g facio:service module/my_service
```

this will do the following:

```
create  app/services/module/my_service_service.rb
create  app/services/module/my_service_context.rb
create  test/services/module/my_service_test.rb
```

## Usage

### Service

Every service has a context, which encapsulates all the information to perform the action. The perform method on the service should be your main point of entry.

```ruby
# simple_service.rb
class SimpleService < Facio::Service
  context do
    attribute :value
    attribute :result
  end
  def perform
    context.result = context.value.to_s.reverse
  end
end

# You can perform the service as follows:
SimpleService.perform(value: "no lemon, no melon").result 
# => "nolem on ,nomel on"
```

You can also have the service perform at a later time:
```ruby
# later_service.rb
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

# This will perform the service at a later time:
SimpleService.perform_later(message: Message.find(1))
```
In this case, once the service is done, you should see the Message's text being reversed.

Services are subclasses of ActiveJob::Base, which basically gives you things like concurrency control and retry logic.

### Context

A context is just an PORO, which includes the ActiveModel::API, which includes validation. You can add validation to the context, 
Facio will check the validity of the context before performing the service. Context can be created in separate files, but also inline in the service. 

It has some useful extra's allowing for associations (has_one/has_many), it also has a type caster for models, so that you can pass the id or the model itself into an attribute.

Using context like below (inline) will then construct a Class, with Facio::Context as a base_class. You can also use external context classes and refer to the in the inline class using the base_class.
```ruby
# some_context.rb
class SomeContext < Facio::Context
  attribute :special
end

# simple_service.rb
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

Next to this, you can have your service-class be accompanied by a context-class, if that's your preference. The service will find the matching context:

```ruby
# fancy_context.rb
class FancyContext < Facio::Context
  attribute :fancy
end

# fancy_service.rb
class FancyService < Facio::Service
  def perform
    context.result = context.fancy.to_s.reverse
  end
end
```

### Result

When the context model includes a result attribute, you can (and should) use that to return the outcome of the service. Facio will set it to the last value of the perform if you don't. Additionally, when the return value is more complex, or you need validation on the return, you can use the result object. This works as follows:

```ruby
class InlineResultService < Facio::Service
  context do
    attribute :value
  end
  result do
    attribute :text
  end
  def perform
    result.text = context.value.to_s.reverse
  end
end

```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
