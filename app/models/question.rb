class Question < ApplicationRecord
  belongs_to :test
  has_many :options, dependent: :destroy
  accepts_nested_attributes_for :options, allow_destroy: true

  validates :label, :content, presence: true

  before_validation :check_validations

  protected

  def check_validations
    errors.add(:options, 'each Question has at least one Option must be marked as the correct answer') if options.blank? || !options&.first&.is_correct_answer
  end
end
