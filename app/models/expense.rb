class Expense < ApplicationRecord
  validates :spent_on, :title, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }

end
