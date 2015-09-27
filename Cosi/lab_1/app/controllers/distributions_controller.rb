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
    @distribution = Distribution.first
    condition = @distribution.update_attributes(distribution_params)
    check_for_errors condition
  end
  
  def use_created_distribution
    @distribution = Distribution.first
    @temp, @size = init_variables
    @list = create_list @temp
  end

  def check_for_errors condition
    if condition
      redirect_to root_url
    else
      render 'main_page'
    end
  end

  private

    def init_variables
      temp = []
      size = 0.05
      case @distribution.which
        when 1 then temp = uniform 
        when 2 then temp = gauss 
        when 3 then temp = exponential
        when 4
          temp = gamma         
          size = 0.0005
        when 5 then temp = triangular
        when 6 then temp = simpson
      end 
      return temp, size
    end

    def create_list(array)
      list = [['Number', 'Value']]
      array.each_index { |x| list.push [x.to_s, array[x]] }
      return list
    end

    def distribution_params
      params.require(:distribution).permit(:a, :b, :mx, :lambda,
                                           :eta, :sigma, :which )
    end
end
