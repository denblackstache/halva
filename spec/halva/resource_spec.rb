# frozen_string_literal: true

require 'halva/resource'
require 'halva/link'
require 'ostruct'
require 'spec_helper'

RSpec.describe 'Halva::Resource' do
  let(:order) { OpenStruct.new(id: 100, name: 'Example', phone: '555-555-5555') }
  let(:related_order) { OpenStruct.new(id: 500, name: 'Related', phone: '111-111-1111') }

  context 'when creating resource from model' do
    it 'succeeds' do
      represented = Halva::Resource.from_model(order).build
      expect(represented).to eq({ id: 100, name: 'Example', phone: '555-555-5555' })
    end
  end

  context 'when creating resource from empty model' do
    it 'succeeds' do
      represented = Halva::Resource.from_empty_model.build
      expect(represented).to eq({})
    end
  end

  context 'when embedding a resource to current resource' do
    it 'succeeds' do
      represented = Halva::Resource.from_model(order)
                                   .embed(Halva::Resource.from_model(related_order).build, 'related')
                                   .build
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
                                   .build
      expect(represented).to eq({ _embedded: { item: [] } })
    end
  end

  context 'when adding a link to current resource' do
    it 'succeeds' do
      represented = Halva::Resource.from_empty_model
                                   .embed([Halva::Resource.from_model(order).build])
                                   .link(Halva::Link.new('/orders/1?page=3', :next))
                                   .link(Halva::Link.new('/orders/1?page=2', :self))
                                   .link(Halva::Link.new('/orders/1?page=1', :prev))
                                   .build
      expect(represented).to eq({
                                  _links: {
                                    next: { href: '/orders/1?page=3' },
                                    self: { href: '/orders/1?page=2' },
                                    prev: { href: '/orders/1?page=1' }
                                  },
                                  _embedded: {
                                    item: [{
                                      id: 100,
                                      name: 'Example',
                                      phone: '555-555-5555'
                                    }]
                                  }
                                })
    end
  end
end
