class Movie < ApplicationRecord
  acts_as_paranoid

  # Regex for director and producer names:
  NAME_REGEX = /\A[\p{L}\s'-]+\z/u

  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { minimum: 10, maximum: 500 }
  validates :director, presence: true,
    format: { with: NAME_REGEX, message: "only allows letters, spaces, apostrophes, and hyphens" }
  validates :producer, presence: true,
    format: { with: NAME_REGEX, message: "only allows letters, spaces, apostrophes, and hyphens" }
  validates :release_date, presence: true
  validate :release_date_validity

  private

  # Custom validation method for release_date
  def release_date_validity
    # Check release_date is a valid date and in valid range
    if release_date.is_a?(String)
      begin
        date = Date.parse(release_date)
      rescue ArgumentError
        errors.add(:release_date, "must be a valid date")
        return
      end
    elsif release_date.is_a?(Date)
      date = release_date
    else
      errors.add(:release_date, "must be a string or date")
      return
    end

    unless date.year.between?(1900, Date.today.year)
      errors.add(:release_date, "must be between 1900 and the current year")
    end
  end
end
