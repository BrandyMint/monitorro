class User < ApplicationRecord
  include Authority::UserAbilities
  include Authority::Abilities

  authenticates_with_sorcery!
end
