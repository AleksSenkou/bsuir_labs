class Charts

  def initialize(n = 64)
    @N = n
    @e = 2.718281828459045 # sometimes ruby can't do ```float_complex.to_f```
    @range = 0..@N
    @x_axis = []
    @y_axis = []

    find_x_and_y_axis
    find_dft_complex_y_axis
  end

  def base_chart_points
    @range.map { |i| [ @x_axis[i], @y_axis[i] ] }
  end

  def dft_abs_chart_points
    @range.map { |i| [ @x_axis[i], @dft_complex_y_axis[i].abs ] }
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
          sum + @y_axis[n] * -1 * @e ** complex_from(k, n)
        end / @N.to_f
      end
    end

    def complex_from(k, n)
      Complex(0, 1) * 2 * Math::PI / @N * k * n
    end
end
