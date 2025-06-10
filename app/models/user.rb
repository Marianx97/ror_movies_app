class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, length: { in: 3..20 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 },
            format: {
              with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).+\z/,
              message: "must include uppercase, lowercase, number, and special character"
            },
            if: -> { new_record? || !password.nil? }
end
