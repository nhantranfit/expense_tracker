class CreateExpenses < ActiveRecord::Migration[8.0]
  def change
    create_table :expenses do |t|
      t.string :title
      t.integer :amount
      t.text :note
      t.date :spent_on

      t.timestamps
    end
  end
end
