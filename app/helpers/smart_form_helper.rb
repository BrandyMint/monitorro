# frozen_string_literal: true

module SmartFormHelper
  SIMPLE_FORM_AS = {
    input: :string,
    checkbox: :boolean
  }.freeze

  def smart_input(form, column, params = {})
    as, collection = smart_get_as_input form.object, column
    as = SIMPLE_FORM_AS[as] || as
    form.input column, { as: as, collection: collection, include_blank: false }.merge(params)
  end

  def smart_best_in_place(scope, column, value, collection: nil)
    record = scope.last
    as, builded_collection = smart_get_as_input record, column
    scope = scope.map { |r| r.is_a?(Draper::Decorator) ? r.object : r }
    best_in_place scope, column, as: as, value: value, collection: collection || builded_collection, display_with: smart_display_with(record, column)
  end

  def smart_display_with(record, column)
    if column.to_s.end_with? 'url'
      lambda { |v| humanized_hostname(v).to_s.html_safe }
    elsif column.to_s == 'currency'
      lambda { |v| v.try :iso_code }
    end
  end

  def smart_get_as_input(record, column)
    record = record.object if record.is_a? Draper::Decorator
    record_class = record.class
    attribute_name = record_class.attribute_aliases[column.to_s] || column.to_s
    column_type = record_class.columns_hash[attribute_name]

    # best in place
    # [:input, :textarea, :select, :checkbox, :date]
    if column_type.nil?
      as = :input

    elsif column_type.type == :boolean
      as = :checkbox
    elsif record_class.respond_to?(:enumerized_attributes) && record_class.enumerized_attributes[column].present? || # gem enumerize
          record_class.defined_enums[attribute_name].present? # rails enum rubocop:disable Layout/MultilineOperationIndentation

      as = :select
      collection = smart_get_collection(record_class, attribute_name, record)
    else
      as = :input
    end

    # PaymentSystem#currency
    if as == :input && attribute_name == 'currency'
      as = :select
      collection = Money::Currency.all.map(&:iso_code).map { |s| [s,s] }
    end

    [as, collection]
  end

  def smart_get_collection(record_class, attribute_name, record = nil)
    if record_class.respond_to?(:enumerized_attributes) && record_class.enumerized_attributes[attribute_name.to_sym].present? # gem enumerize
      [[t('.not_selected'), '']] + record_class.enumerized_attributes[attribute_name.to_sym].values.map { |v| [v, v] }
    elsif record_class.defined_enums[attribute_name.to_s].present? # рельсовый enum
      record_class.defined_enums[attribute_name].keys.map do |attribute_value|
        scope = "enums.#{record_class.name.underscore}.#{attribute_name}.#{attribute_value}"
        [(I18n.exists?(scope) ? I18n.t(scope) : attribute_value), attribute_value]
      end
    end
  end
end
