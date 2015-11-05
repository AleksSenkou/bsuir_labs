class Charts

  def initialize(n = 64)
    @N = n
    @range = 0..@N
    @x_axis = []
    @y_axis = []

    find_x_and_y_axis
    find_dft_complex_y_axis
    find_dft_restore_y_axis
    @fft_complex_y_axis = find_fft_complex_y_axis @y_axis
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
    @range.map { |i| [ @x_axis[i], @dft_complex_y_axis[i].phase ] }
  end

  def dft_restore_points
    @range.map { |i| [ @x_axis[i], @dft_restore_y_axis[i] ] }
  end

  def fft_abs_points
    @range.map { |i| [ @x_axis[i], (@fft_complex_y_axis[i] / @N).abs ] }
  end

  def find_fft_complex_y_axis(image)
    length = image.count
    return image if length == 1
    first, second = [], []
    w = Complex(1, 0)
    wn = Math::E ** (-1 * complex / length)
    (0..length / 2).map do |i|
      break if image[i + length / 2].nil?
      first.push image[i] + image[i + length / 2]
      second.push (image[i] - image[i + length / 2]) * w
      w *= wn
    end
    first_image = find_fft_complex_y_axis(first)
    second_image = find_fft_complex_y_axis(second)
    result = []
    (0..length / 2).map do |i|
      result.push first_image[i]
      result.push second_image[i]
    end
    result
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
          sum + @y_axis[n] * Math::E ** (-1 * complex * k * n / @N)
        end / @N.to_f
      end
    end

    def find_dft_restore_y_axis
      @dft_restore_y_axis = @range.map do |k|
        @range.inject do |sum, n|
          sum + @dft_complex_y_axis[n] * Math::E ** (complex * k * n / @N)
        end.real
      end
    end

    def complex
      Complex(0, 1) * 2 * Math::PI
    end
end
