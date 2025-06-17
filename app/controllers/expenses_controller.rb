class ExpensesController < ApplicationController
  before_action :expense, only: [:show, :edit, :update, :destroy]
  def index
    @expenses = Expense.order(spent_on: :desc)
    @grouped_expenses = Expense.order(spent_on: :desc).group_by(&:spent_on)
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
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    redirect_to expenses_path, notice: "Đã xoá chi tiêu thành công."
  end

  private

  def expense_params
    params.require(:expense).permit(:title, :amount, :note, :spent_on)
  end

  def expense
    @expense = Expense.find(params[:id])
  end
end
