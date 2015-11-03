class Charts

  def initialize(n = 64)
    @N = n
    @range = 0..@N
    @x_axis = []
    @y_axis = []

    find_x_and_y_axis
    find_dft_complex_y_axis
  end

  def base_points
    @range.map { |i| [ @x_axis[i], @y_axis[i] ] }
  end

  # Return the abs of x
  def dft_abs_points
    @range.map { |i| [ @x_axis[i], @dft_complex_y_axis[i].abs ] }
  end

  # Return the phase of x (argument of x)
  def dft_phase_points
    @range.map { |i| [ @x_axis[i], @dft_complex_y_axis[i].angle ] }
  end

  private

    def find_x_and_y_axis
      @range.map do |number|
        @x_axis.push x = number * 2 * Math::PI / @N
        @y_axis.push Math.sin(5 * x) + Math.cos(x)
      end
    end

    def find_dft_complex_y_axis
      @dft_complex_y_axis = @range.map do |k|
        @range.inject do |sum, n|
          sum + @y_axis[n] * -1 * Math::E ** complex_from(k, n)
        end / @N.to_f
      end
    end

    def complex_from(k, n)
      Complex(0, 1) * 2 * Math::PI / @N * k * n
    end
end
