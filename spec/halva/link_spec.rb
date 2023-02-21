# frozen_string_literal: true

require 'halva/link'
require 'spec_helper'

RSpec.describe 'Halva::Link' do
  context 'when converting to hash' do
    context 'and it has no options' do
      it 'succeeds' do
        link = Halva::Link.new('/orders?page=2', :self)
        expect(link.to_h).to eq({ href: '/orders?page=2' })
      end
    end

    context 'and it has some options' do
      it 'succeeds' do
        link = Halva::Link.new('/orders/{?id}', :self, { templated: true })
        expect(link.to_h).to eq({ href: '/orders/{?id}', templated: true })
      end
    end
  end
end
