class CreateChangers < ActiveRecord::Migration[5.2]
  def change
    create_table :changers do |t|
      t.integer :id
      t.name :name

      t.timestamps
    end
  end
end
