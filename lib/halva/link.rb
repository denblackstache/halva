# frozen_string_literal: true

module Halva
  # HAL Link Object
  # See [HAL Draft](https://datatracker.ietf.org/doc/html/draft-kelly-json-hal#section-5)
  class Link
    attr_reader :relation

    # @param [String] href
    # @param [Symbol] relation
    # @param [Hash] options (templated, type, deprecation, name, profile, title, hreflang)
    # @option options [Boolean] :templated true when the Link Object's "href" property is a URI Template
    # @option options [String] :type a hint to indicate the media type expected when dereferencing the target resource
    # @option options [String] :deprecation indicate that the link is to be deprecated (i.e. removed) at a future date
    # @option options [String] :name a secondary key for selecting Link Objects which share the same relation type
    # @option options [String] :profile a URI that hints about the profile of the target resource
    # @option options [String] :title label for the link with a human-readable identifier
    # @option options [String] :hreflang indicate the language of the target resource
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
