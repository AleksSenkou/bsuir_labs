class CreateDistributions < ActiveRecord::Migration
  def change
    create_table :distributions do |t|
      t.integer :a
      t.integer :b
      t.integer :mx
      t.integer :sigma
      t.integer :lambda
      t.integer :eta

      t.timestamps null: false
    end
  end
end
