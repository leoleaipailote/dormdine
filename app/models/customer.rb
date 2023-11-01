class Customer < ApplicationRecord
  PHONE_REGEX = /\A(\+1|1)?[-.\s]?(\()?(\d{3})(?(2)\))[-.\s]?(\d{3})[-.\s]?(\d{4})\z/

  has_many :reviews, dependent: :destroy

  validates :name, presence: { on: :create }
  validates :email, presence: { on: :create }
  validates :phone_number, presence: { on: :create }
  validates :address, presence: { on: :create }

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "is not a valid email address" }, if: -> { email.present? }
  validates :phone_number, format: { with: PHONE_REGEX, message: "is not a valid US phone number" }, if: -> { phone_number.present? }
  before_save :reformat_phone_number

  def reformat_phone_number
    digits = phone_number.scan(/\d+/).join # Extract all digits
    digits = digits[1..10] if digits.length == 11
    self.phone_number = "#{digits[0..2]}-#{digits[3..5]}-#{digits[6..9]}" if digits.length == 10
  end

end