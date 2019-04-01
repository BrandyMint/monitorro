# frozen_string_literal: true

module AuthorizerAdjectives
  extend ActiveSupport::Concern

  DEFAULT_ADJECTIVES = %i[readable creatable updatable deletable].freeze
  # TODO: Вынести в Authority
  VERBS = Authority.abilities.invert.symbolize_keys
  # adjective -> verbs
  # {:creatable=>:create, :readable=>:read, :updatable=>:update, :deletable=>:destroy, :acceptable=>:accept, :rejectable=>:reject}

  included do
    # Атрибуты запрещенные менять НЕ админам
    class_attribute :restricted_attributes
    class_attribute :adjectives
  end

  module ClassMethods
    def restricted_attributes_set
      Set.new(Array(restricted_attributes).map(&:to_s)).freeze
    end

    def allowed_adjectives
      Set.new adjectives || DEFAULT_ADJECTIVES
    end

    def allowed_adjective?(adjective)
      allowed_adjectives.include? adjective.to_sym
    end

    def require_allowed_adjective!(adjective)
      return true if allowed_adjective? adjective

      raise "Adjective (#{adjective}) is not allowed for this authorizer (#{self}). Allowed set: #{allowed_adjectives.to_a.join(', ')}"
    end

    def verb_from_adjective(adjective)
      VERBS[adjective] || raise("Unknown adjective (#{adjective})")
    end
  end
end
