class CreateThemes < ActiveRecord::Migration
  def change
    create_table :themes do |t|
      t.belongs_to :section, index: true	
      t.timestamps null: false
    end
  end
end
