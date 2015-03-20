class Distribution < ActiveRecord::Base
  # validates :R, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
  validates :a, :b, :mx, :lambda, :sigma, :eta, numericality: true
  validates :b, numericality: { greater_than: :a }

  # def a_not_eq_to_b
  #   :a != :b
  # end
end
