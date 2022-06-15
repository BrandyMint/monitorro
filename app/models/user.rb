class User < ApplicationRecord
  include Authority::UserAbilities
  include Authority::Abilities

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  authenticates_with_sorcery!

  def to_s
    name
  end
end
