class ReportService
  attr_reader :start_date, :end_date

  def initialize(start_date, end_date)
    @start_date = start_date
    @end_date = end_date
  end

  def generate_summary_report
    {
      period: "#{start_date.strftime('%d/%m/%Y')} - #{end_date.strftime('%d/%m/%Y')}",
      total_expenses: total_expenses,
      total_categories: categories_with_expenses.count,
      average_daily_expense: average_daily_expense,
      highest_expense: highest_expense,
      lowest_expense: lowest_expense
    }
  end

  def generate_category_report
    categories_with_expenses.map do |category, amount|
      {
        category: category,
        total_amount: amount,
        percentage: percentage_of_total(amount),
        expense_count: category.expenses.by_date_range(start_date, end_date).count
      }
    end.sort_by { |report| -report[:total_amount] }
  end

  def generate_budget_report
    Budget.includes(:category).map do |budget|
      spent = budget.spent_amount(start_date, end_date)
      remaining = budget.remaining_amount(start_date, end_date)

      {
        category: budget.category,
        budget_amount: budget.amount,
        spent_amount: spent,
        remaining_amount: remaining,
        percentage_used: budget.percentage_used(start_date, end_date),
        exceeded: budget.exceeded?(start_date, end_date),
        status: budget_status(spent, budget.amount)
      }
    end.sort_by { |report| report[:percentage_used] }.reverse
  end

  def generate_detailed_expenses
    Expense.includes(:category)
          .by_date_range(start_date, end_date)
          .recent
          .map do |expense|
      {
        id: expense.id,
        title: expense.title,
        amount: expense.amount,
        category: expense.category&.name || 'Uncategorized',
        date: expense.spent_on,
        formatted_date: expense.spent_on.strftime('%d/%m/%Y')
      }
    end
  end

  def generate_trend_data
    # Group expenses by day for trend analysis
    daily_expenses = Expense.by_date_range(start_date, end_date)
                           .group(:spent_on)
                           .sum(:amount)
                           .sort.to_h

    {
      labels: daily_expenses.keys.map { |date| date.strftime('%d/%m') },
      data: daily_expenses.values,
      total_days: (end_date - start_date).to_i + 1
    }
  end

  private

  def total_expenses
    @total_expenses ||= Expense.total_by_period(start_date, end_date)
  end

  def categories_with_expenses
    @categories_with_expenses ||= Category.includes(:expenses)
                                         .map { |category|
                                           [category, category.total_expenses_in_period(start_date, end_date)]
                                         }
                                         .select { |_, amount| amount > 0 }
  end

  def average_daily_expense
    return 0 if total_expenses.zero?
    days = (end_date - start_date).to_i + 1
    (total_expenses.to_f / days).round(2)
  end

  def highest_expense
    Expense.by_date_range(start_date, end_date).maximum(:amount)
  end

  def lowest_expense
    Expense.by_date_range(start_date, end_date).minimum(:amount)
  end

  def percentage_of_total(amount)
    return 0 if total_expenses.zero?
    ((amount.to_f / total_expenses) * 100).round(1)
  end

  def budget_status(spent, budget_amount)
    if spent > budget_amount
      'exceeded'
    elsif spent >= budget_amount * 0.8
      'warning'
    else
      'good'
    end
  end
end
