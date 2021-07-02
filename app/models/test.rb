class Test < ApplicationRecord
  has_many :questions, dependent: :destroy
  accepts_nested_attributes_for :questions, allow_destroy: true

  validates :name, :description, presence: true
  validates :questions, presence: { message: 'each Test has at least one Quesion' }
end
