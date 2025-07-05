class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.ordered.includes(:expenses, :budgets)
  end

  def show
    @expenses = @category.expenses.recent.limit(10)
    @monthly_budget = @category.budget_for_period('monthly')
    @weekly_budget = @category.budget_for_period('weekly')
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: 'Danh mục đã được tạo thành công!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: 'Danh mục đã được cập nhật!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.expenses.any?
      redirect_to categories_path, alert: 'Không thể xóa danh mục đang có chi tiêu!'
    else
      @category.destroy
      redirect_to categories_path, notice: 'Danh mục đã được xóa!'
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :color)
  end
end
