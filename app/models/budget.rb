class Budget < ApplicationRecord
  belongs_to :category

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :period, presence: true, inclusion: { in: %w[weekly monthly yearly] }
  validates :category_id, uniqueness: { scope: :period }

  def spent_amount(start_date, end_date)
    category.total_expenses_in_period(start_date, end_date)
  end

  def remaining_amount(start_date, end_date)
    amount - spent_amount(start_date, end_date)
  end

  def percentage_used(start_date, end_date)
    return 0 if amount.zero?
    ((spent_amount(start_date, end_date).to_f / amount) * 100).round(1)
  end

  def exceeded?(start_date, end_date)
    spent_amount(start_date, end_date) > amount
  end
end
