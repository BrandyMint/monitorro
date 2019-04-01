class User < ApplicationRecord
  include Authority::UserAbilities
  include Authority::Abilities

  authenticates_with_sorcery!

  def to_s
    name
  end
end
