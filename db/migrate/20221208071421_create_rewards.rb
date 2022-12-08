class CreateRewards < ActiveRecord::Migration[6.1]
  def change
    create_table :rewards do |t|
      t.string :name, null: false
      t.references :question, null: false, foreign_key: true
      t.references :answer, foreign_key: true
      t.timestamps
    end
  end
end
