# frozen_string_literal: true

module Halva
  # HAL Resource object
  # See [HAL Draft](https://datatracker.ietf.org/doc/html/draft-kelly-json-hal#section-4)
  class Resource
    EMBEDDED_KEY = :_embedded
    LINKS_KEY = :_links
    CURIES_KEY = :curies

    def self.from_model(model)
      new(model.to_h)
    end

    def self.from_empty_model
      new({})
    end

    def initialize(model)
      @model = model.freeze
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

    def to_h
      document = @model.dup
      unless @embedded.empty?
        document[EMBEDDED_KEY] = {} unless document.key?(EMBEDDED_KEY)
        @embedded.each do |emb|
          is_collection = emb[:resource].is_a?(Enumerable)
          document[EMBEDDED_KEY][emb[:relation]] = if is_collection
                                                     emb[:resource].map(&:to_h)
                                                   else
                                                     emb[:resource].to_h
                                                   end
        end
      end

      unless @links.empty?
        document[LINKS_KEY] = {} unless document.key?(LINKS_KEY)
        @links.each do |link|
          if link.relation == CURIES_KEY
            document[LINKS_KEY][CURIES_KEY] = [] unless document[LINKS_KEY].key?(CURIES_KEY)
            document[LINKS_KEY][CURIES_KEY] << link.to_h
          else
            document[LINKS_KEY][link.relation] = link.to_h
          end
        end
      end

      document
    end
  end
end
