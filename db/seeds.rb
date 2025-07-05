# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create default categories
categories = [
  { name: "🍜 Ăn uống", color: "#FF6B6B" },
  { name: "🚗 Di chuyển", color: "#4ECDC4" },
  { name: "🏠 Nhà ở", color: "#45B7D1" },
  { name: "🛒 Mua sắm", color: "#96CEB4" },
  { name: "💊 Y tế", color: "#FFEAA7" },
  { name: "🎮 Giải trí", color: "#DDA0DD" },
  { name: "📚 Học tập", color: "#98D8C8" },
  { name: "💼 Công việc", color: "#F7DC6F" },
  { name: "🎁 Quà tặng", color: "#BB8FCE" },
  { name: "📱 Công nghệ", color: "#85C1E9" }
]

categories.each do |category_attrs|
  Category.find_or_create_by!(name: category_attrs[:name]) do |category|
    category.color = category_attrs[:color]
  end
end

# Create sample expenses with categories
if Expense.count.zero?
  food_category = Category.find_by(name: "🍜 Ăn uống")
  transport_category = Category.find_by(name: "🚗 Di chuyển")
  shopping_category = Category.find_by(name: "🛒 Mua sắm")

  Expense.create!(title: "Cà phê sáng", amount: 20000, spent_on: Date.today, category: food_category)
  Expense.create!(title: "Ăn trưa", amount: 45000, spent_on: Date.today, category: food_category)
  Expense.create!(title: "Xăng xe", amount: 150000, spent_on: Date.today, category: transport_category)
  Expense.create!(title: "Mua sách", amount: 120000, spent_on: Date.yesterday, category: shopping_category)
end
