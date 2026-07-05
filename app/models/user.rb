class User < ApplicationRecord
  extend Enumerize

  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  enumerize :role, in: %i[admin editor], default: :editor, predicates: true
end
