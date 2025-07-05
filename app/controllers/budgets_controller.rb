class BudgetsController < ApplicationController
  before_action :set_budget, only: [:show, :edit, :update, :destroy]

  def index
    @budgets = Budget.includes(:category).order(:period, :category_id)
    @categories = Category.ordered
  end

  def show
  end

  def new
    @budget = Budget.new
    @categories = Category.ordered
  end

  def create
    @budget = Budget.new(budget_params)
    if @budget.save
      redirect_to budgets_path, notice: 'Ngân sách đã được tạo thành công!'
    else
      @categories = Category.ordered
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Category.ordered
  end

  def update
    if @budget.update(budget_params)
      redirect_to budgets_path, notice: 'Ngân sách đã được cập nhật!'
    else
      @categories = Category.ordered
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @budget.destroy
    redirect_to budgets_path, notice: 'Ngân sách đã được xóa!'
  end

  private

  def set_budget
    @budget = Budget.find(params[:id])
  end

  def budget_params
    params.require(:budget).permit(:category_id, :amount, :period)
  end
end
