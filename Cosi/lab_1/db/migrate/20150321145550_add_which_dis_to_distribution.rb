class AddWhichDisToDistribution < ActiveRecord::Migration
  def change
    add_column :distributions, :which_dis, :integer
  end
end
