class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :question_text, null: false
      t.integer :poll_id, null: false

      t.timestamps null: false
    end

    add_index :questions, :poll_id
  end
end
