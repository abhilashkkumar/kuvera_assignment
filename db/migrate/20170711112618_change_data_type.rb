class ChangeDataType < ActiveRecord::Migration[5.0]
  def change
  	change_column :values, :date, :date
  end
end
