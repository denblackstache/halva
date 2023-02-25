# frozen_string_literal: true

module Halva
  # Compact URI Link Object
  # See [HAL Draft](https://datatracker.ietf.org/doc/html/draft-kelly-json-hal#section-8.2)
  class Curie
    attr_reader :relation, :href

    # @param [String] href
    # @param [String] name
    def initialize(href, name)
      @href = href
      @relation = :curies
      @link = Halva::Link.new(@href, @relation, { templated: true, name: name })
    end

    def to_h
      @link.to_h
    end
  end
end
