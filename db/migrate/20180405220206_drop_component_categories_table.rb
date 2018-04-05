class DropComponentCategoriesTable < ActiveRecord::Migration[5.1]
  def change
    def up
      drop_table :component_categories
    end
  
    def down
      raise ActiveRecord::IrreversibleMigration
    end
  end
end
