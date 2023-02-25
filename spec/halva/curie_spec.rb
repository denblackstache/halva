# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Halva::Curie' do
  context 'when converting to hash' do
    it 'succeeds' do
      curie = Halva::Curie.new('https://docs.acme.com/relations/{rel}', 'acme')
      expect(curie.to_h).to eq({ name: 'acme', href: 'https://docs.acme.com/relations/{rel}', templated: true })
    end
  end
end
