class CreateSchemes < ActiveRecord::Migration[5.0]
  def change
    create_table :schemes do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
