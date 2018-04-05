class AddNameToComponents < ActiveRecord::Migration[5.1]
  def change
    add_column :components, :name, :string
  end
end
