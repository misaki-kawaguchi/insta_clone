class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :username, uniqueness: true, presence: true;
  validates :email, uniqueness: true, presence: true;
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
end
