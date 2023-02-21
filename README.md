# Halva

HAL-compliant serializer

[![Ruby](https://github.com/denblackstache/halva/actions/workflows/main.yml/badge.svg)](https://github.com/denblackstache/halva/actions/workflows/main.yml) [![Gem Version](https://badge.fury.io/rb/halva.svg)](https://badge.fury.io/rb/halva)

Links
* [HAL - Hypertext Application Language](https://stateless.co/hal_specification.html)
* [Specification Draft](https://datatracker.ietf.org/doc/html/draft-kelly-json-hal-08)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'halva'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install halva

## Usage

### Representing an object

```ruby
order = Order.find(1)
Halva::Resource.from_model(order)
               .embed(Halva::Resource.from_model(order.customer).build, :customer)
               .link(Halva::Link.new('/orders/1', :self))
               .link(Halva::Link.new('/orders/1/customer', :customer))
               .build

```

### Representing a collection

```ruby
orders = Order.find
Halva::Resource.from_empty_model
               .embed(orders.map { |order| Halva::Resource.from_model(order).build })
               .link(Halva::Link.new('/orders?page=3', :next))
               .link(Halva::Link.new('/orders?page=2', :self))
               .link(Halva::Link.new('/orders?page=1', :prev))
               .build

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/denblackstache/halva.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
