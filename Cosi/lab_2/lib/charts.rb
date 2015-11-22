class Charts

  def initialize(n = 16)
    @N = n
    @first_signal = []
    @second_signal = []

    find_signals
  end

  def first_signal_points
    find_points_for @first_signal
  end

  def second_signal_points
    find_points_for @second_signal
  end

  def find_fft_complex_y_axis(image)
    length = image.count
    return image if length == 2
    first, second = [], []
    w = Complex(1, 0)
    (0..length / 2).each do |i|
      first << image[i] + image[i + length / 2]
      second << (image[i] - image[i + length / 2]) * w
      w *= Math::E ** (-1 * complex / length)
    end
    first_image = find_fft_complex_y_axis(first)
    second_image = find_fft_complex_y_axis(second)
    result = []
    (0..length / 2).each do |i|
      result << first_image[i]
      result << second_image[i]
    end
    result
  end

  def find_fft_restore_y_axis(real)
    length = real.count
    return real if length == 1
    first, second = [], []
    w = 1
    (0..length / 2).each do |i|
      break if real[i + length / 2].nil?
      first << real[i] + real[i + length / 2]
      second << (real[i] - real[i + length / 2]) * w
      w *= Math::E ** (complex / length)
    end
    first_image = find_fft_restore_y_axis(first)
    second_image = find_fft_restore_y_axis(second)
    result = []
    (0..length / 2).each do |i|
      result << first_image[i]
      result << second_image[i]
    end
    result
  end

  private

    def find_signals
      interval = 2 * Math::PI / @N

      @N.times do |i|
        @first_signal << Math.sin(2 * i * interval)
        @second_signal << Math.cos(7 * i * interval)
      end
    end

    def find_points_for(array)
      (0...array.count).map do |i|
        x = i * 2 * Math::PI / array.count
        y = array[i].real

        [ x, y ]
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
