class Category < ApplicationRecord
  has_many :expenses, dependent: :nullify
  has_many :budgets, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :color, presence: true

  scope :ordered, -> { order(:name) }

  def total_expenses_in_period(start_date, end_date)
    expenses.where(spent_on: start_date..end_date).sum(:amount)
  end

  def budget_for_period(period)
    budgets.find_by(period: period)
  end
end
