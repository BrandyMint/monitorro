# frozen_string_literal: true

# Взял отсюда https://github.com/kaize/validates/blob/master/lib/uri_component_validator.rb
# потому что на gem ругается bootsnap

class UriComponentValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :uri_component, options.merge(value: value)) unless value&.match?(URI::DEFAULT_PARSER.regexp[component])
  end

  def check_validity!
    valid_components = URI::DEFAULT_PARSER.regexp.keys

    raise ArgumentError, "Component must be of the following type: #{valid_components}" if valid_components.exclude? component
  end

  def component
    options[:component]
  end
end
