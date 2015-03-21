class Distribution < ActiveRecord::Base
  validates :a, :b, :mx, :lambda, :sigma, :eta, numericality: true
  validates :which, presence: true
  validates :b, numericality: { greater_than: :a }
end
