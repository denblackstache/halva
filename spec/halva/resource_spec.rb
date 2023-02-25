# frozen_string_literal: true

require 'ostruct'
require 'spec_helper'

RSpec.describe 'Halva::Resource' do
  let(:order) { OpenStruct.new(id: 100, name: 'Example', phone: '555-555-5555') }
  let(:related_order) { OpenStruct.new(id: 500, name: 'Related', phone: '111-111-1111') }

  context 'when creating resource from model' do
    it 'succeeds' do
      represented = Halva::Resource.from_model(order).to_h
      expect(represented).to eq({ id: 100, name: 'Example', phone: '555-555-5555' })
    end
  end

  context 'when creating resource from empty model' do
    it 'succeeds' do
      represented = Halva::Resource.from_empty_model.to_h
      expect(represented).to eq({})
    end
  end

  context 'when embedding a resource to current resource' do
    it 'succeeds' do
      represented = Halva::Resource.from_model(order)
                                   .embed(Halva::Resource.from_model(related_order), :related)
                                   .to_h
      expect(represented).to eq({
                                  id: 100,
                                  name: 'Example',
                                  phone: '555-555-5555',
                                  _embedded: {
                                    related: {
                                      id: 500,
                                      name: 'Related',
                                      phone: '111-111-1111'
                                    }
                                  }
                                })
    end
  end

  context 'when creating resource from empty model and representing collection' do
    it 'succeeds' do
      represented = Halva::Resource.from_empty_model
                                   .embed([])
                                   .to_h
      expect(represented).to eq({ _embedded: { item: [] } })
    end
  end

  context 'when adding a link to current resource' do
    it 'succeeds' do
      represented = Halva::Resource.from_empty_model
                                   .embed([Halva::Resource.from_model(order)
                                                          .link(Halva::Link.new("/orders/#{order.id}", :self))])
                                   .link(Halva::Link.new('/orders?page=3', :next))
                                   .link(Halva::Link.new('/orders?page=2', :self))
                                   .link(Halva::Link.new('/orders?page=1', :prev))
                                   .to_h
      expect(represented).to eq({
                                  _links: {
                                    next: { href: '/orders?page=3' },
                                    self: { href: '/orders?page=2' },
                                    prev: { href: '/orders?page=1' }
                                  },
                                  _embedded: {
                                    item: [{
                                      _links: { self: { href: '/orders/100' } },
                                      id: 100,
                                      name: 'Example',
                                      phone: '555-555-5555'
                                    }]
                                  }
                                })
    end
  end

  context 'when adding curies' do
    it 'succeeds' do
      represented = Halva::Resource.from_empty_model
                                   .embed([Halva::Resource.from_model(order)
                                                          .link(Halva::Link.new("/orders/#{order.id}", :self))], :'acme:order')
                                   .link(Halva::Link.new('/orders?page=2', :self))
                                   .link(Halva::Curie.new('https://docs.acme.com/relations/{rel}', 'acme'))
                                   .to_h
      expect(represented).to eq({
                                  _links: {
                                    self: { href: '/orders?page=2' },
                                    curies: [{
                                      name: 'acme',
                                      href: 'https://docs.acme.com/relations/{rel}',
                                      templated: true
                                    }]
                                  },
                                  _embedded: {
                                    'acme:order': [{
                                      _links: { self: { href: '/orders/100' } },
                                      id: 100,
                                      name: 'Example',
                                      phone: '555-555-5555'
                                    }]
                                  }
                                })
    end
  end
end
