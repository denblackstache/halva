# frozen_string_literal: true

module Halva
  # HAL Resource object
  # https://datatracker.ietf.org/doc/html/draft-kelly-json-hal#section-4
  class Resource
    EMBEDDED_KEY = :_embedded
    LINKS_KEY = :_links

    def self.from_model(model)
      new(model.to_h)
    end

    def self.from_empty_model
      new({})
    end

    def initialize(model)
      @model = model
      @embedded = []
      @links = []
    end

    def embed(resource, relation = :item)
      @embedded << { resource: resource, relation: relation.to_sym }
      self
    end

    def link(link)
      @links << link
      self
    end

    def build
      unless @embedded.empty?
        @model[EMBEDDED_KEY] = {} unless @model.key?(EMBEDDED_KEY)
        @embedded.each do |emb|
          @model[EMBEDDED_KEY][emb[:relation]] = emb[:resource]
        end
      end

      unless @links.empty?
        @model[LINKS_KEY] = {} unless @model.key?(LINKS_KEY)
        @links.each do |link|
          @model[LINKS_KEY][link.relation] = link.to_h
        end
      end

      @model.to_h
    end
  end
end
