class CreateBudgets < ActiveRecord::Migration[8.0]
  def change
    create_table :budgets do |t|
      t.references :category, null: false, foreign_key: true
      t.integer :amount
      t.string :period

      t.timestamps
    end
  end
end
