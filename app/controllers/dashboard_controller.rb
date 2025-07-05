class DashboardController < ApplicationController
  def index
    @total_expenses = Expense.sum(:amount)
    @monthly_expenses = Expense.where(spent_on: Date.current.beginning_of_month..Date.current.end_of_month).sum(:amount)
    @weekly_expenses = Expense.where(spent_on: Date.current.beginning_of_week..Date.current.end_of_week).sum(:amount)
    @today_expenses = Expense.where(spent_on: Date.current).sum(:amount)

    @expenses_by_month = Expense.group("DATE_TRUNC('month', spent_on)")
                               .sum(:amount)
                               .transform_keys { |k| k.to_date.strftime("%B %Y") }
                               .sort.reverse.to_h

    @recent_expenses = Expense.order(spent_on: :desc).limit(5)
    @top_expenses = Expense.order(amount: :desc).limit(5)
  end
end
