class DistributionsController < ApplicationController
  def new
    @distribution = Distribution.new
  end

  def create
    @distribution = Distribution.create distribution_params
    if @distribution.save
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  private
    def distribution_params
      params.require(:distribution).permit(:R, :a, :b, :mx, :lambda,
                                           :eta, :sigma )
    end
end
