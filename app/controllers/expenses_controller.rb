class ExpensesController < ApplicationController
  before_action :expense, only: [:show, :edit, :update, :destroy]
  before_action :set_categories, only: [:new, :create, :edit]

  def index
    @expenses = Expense.includes(:category).order(spent_on: :desc)
    @grouped_expenses = @expenses.group_by(&:spent_on)
    @categories = Category.ordered
    @total_expenses = @expenses.sum(:amount)
  end

  def new
    @expense = Expense.new
  end

  def show; end

  def create
    @expense = Expense.new(expense_params)
    if @expense.save
      redirect_to expenses_path, notice: "Đã thêm chi tiêu thành công!"
    else
      render :new, alert: "Có lỗi khi thêm chi tiêu!"
    end
  end

  def edit
    @expense = Expense.find(params[:id])
  end

  def update
    @expense = Expense.find(params[:id])
    if @expense.update(expense_params)
      redirect_to expenses_path, notice: "Đã cập nhật chi tiêu."
    else
      @categories = Category.ordered
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    redirect_to expenses_path, notice: "Đã xoá chi tiêu thành công."
  end

  private

  def set_categories
    @categories = Category.ordered
  end

  def expense_params
    params.require(:expense).permit(:title, :amount, :note, :spent_on, :category_id)
  end

  def expense
    @expense = Expense.find(params[:id])
  end
end
