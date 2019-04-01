module EditableHelper
  def allow_edit_column?(record, column)
    return false if column.to_s == 'id'

    # Бывает в декораторе есть метод, а в самой модели нет
    return false unless record.respond_to? column
    return false unless record.respond_to? column.to_s + '='

    value = record.send column
    return false if value.is_a? ActiveRecord::Associations::CollectionProxy

    if record.respond_to? :updatable_by?
      return record.updatable_by? current_user
    elsif record.respond_to? :parent
      return record.parent.updatable_by? current_user if record.parent.respond_to? :updatable_by?
    else
      true
    end

    true
  end
end
