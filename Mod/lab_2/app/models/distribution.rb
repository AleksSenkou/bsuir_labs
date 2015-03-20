class Distribution < ActiveRecord::Base
  validates :R, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
  validates :a, numericality: true
  validates :b, numericality: true
  validates :mx, numericality: true
  validates :lambda, numericality: true
  validates :sigma, numericality: true
  validates :eta, numericality: true
end
