class ExchangeLinksForm
  include Virtus.model
  include ActiveModel::Conversion
  extend  ActiveModel::Naming
  include ActiveModel::Validations

  attribute :links, String
  validates :links, presence: true
end
