class DistributionsController < ApplicationController
  def main_page
    if Distribution.any?
      use_created_distribution
    else
      @distribution = Distribution.new
    end
  end

  def create
    @distribution = Distribution.create distribution_params
    check_for_errors @distribution.save
  end

  def update
    use_created_distribution
    condition = @distribution.update_attributes(distribution_params)
    check_for_errors condition
  end

  private
    def distribution_params
      params.require(:distribution).permit(:R, :a, :b, :mx, :lambda,
                                           :eta, :sigma )
    end

    def use_created_distribution
      @distribution = Distribution.find(1)
    end

    def check_for_errors condition
      if condition
        redirect_to root_url
      else
        render 'main_page'
      end
    end
end
