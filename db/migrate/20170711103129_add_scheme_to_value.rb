class AddSchemeToValue < ActiveRecord::Migration[5.0]
  def change
  	add_reference :values, :scheme, index: true, foreign_key: true
  end
end
