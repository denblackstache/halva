# frozen_string_literal: true

module Halva
  # HAL Link Object
  # https://datatracker.ietf.org/doc/html/draft-kelly-json-hal#section-5}
  class Link
    attr_reader :relation, :href

    def initialize(href, relation, options = {})
      @href = href
      @relation = relation.to_sym
      @options = options
    end

    def to_h
      { href: @href, **@options }
    end
  end
end
