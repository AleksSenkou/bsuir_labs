class DistributionController < ApplicationController
  def new
    @distribution = Distribution.new
  end
end
