class Expense < ApplicationRecord
  belongs_to :category, optional: true

  validates :spent_on, :title, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }

  scope :by_category, ->(category_id) { where(category_id: category_id) if category_id.present? }
  scope :by_date_range, ->(start_date, end_date) { where(spent_on: start_date..end_date) }
  scope :recent, -> { order(spent_on: :desc) }

  def self.total_by_period(start_date, end_date)
    where(spent_on: start_date..end_date).sum(:amount)
  end
end
