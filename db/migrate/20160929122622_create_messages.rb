class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.belongs_to :theme, index: true	
      t.timestamps null: false
    end
  end
end
