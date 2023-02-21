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
require 'halva'

order = Order.find(1)
Halva::Resource.from_model(order)
               .embed(Halva::Resource.from_model(order.customer), :customer)
               .link(Halva::Link.new('/orders/1', :self))
               .link(Halva::Link.new('/orders/1/customer', :customer))
               .to_h

# {
#   :id => 1, 
#   :name => "Order Example"
#   :_embedded => {
#     :customer => [{
#       :id => 1, 
#       :name => "Customer Example"
#     }]
#   }, 
#   :_links => { 
#     :self => {:href => "/orders/1"}, 
#     :customer => {:href => "/orders/1/customer"} 
#   }
# }
```

### Representing a collection

```ruby
require 'halva'

orders = Order.find
Halva::Resource.from_empty_model
               .embed(orders.map do |order|
                 Halva::Resource.from_model(order)
                                .link(Halva::Link.new("/orders/#{order.id}", :self))
               end)
               .link(Halva::Link.new('/orders?page=2', :self))
               .link(Halva::Link.new('/orders?page=3', :next))
               .link(Halva::Link.new('/orders?page=1', :prev))
               .to_h

# {
#   :_embedded => {
#     :item => [{
#       :id => 1, 
#       :name => "Example"
#       :_links => {:self => {:href => "/orders/1"} }
#     }]
#   }, 
#   :_links => { 
#     :self => {:href => "/orders/1?page=2"}, 
#     :next => {:href => "/orders/1?page=3"}, 
#     :prev => {:href => "/orders/1?page=1"}
#   }
# }

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/denblackstache/halva.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
