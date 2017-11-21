class CreateActivityLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :activity_logs do |t|
      t.string :model_type
      t.integer :model_id
      t.text :changes_text
    end
  end
end
