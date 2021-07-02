class CreateTests < ActiveRecord::Migration[6.1]
  def change
    create_table :tests do |t|
      t.string :name, unique: true
      t.text :description

      t.timestamps
    end

    create_table :questions do |t|
      t.references :test, index: true, foreign_key: true
      t.string :label
      t.text :content

      t.timestamps
    end

    create_table :options do |t|
      t.references :question, index: true, foreign_key: true
      t.text :content
      t.boolean :is_correct_answer
      
      t.timestamps
    end
  end
end
