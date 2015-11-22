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

  def convolution_result_points
    find_points_for convolution
  end

  def convolution_fourier_points
    find_points_for convolution_fourier
  end

  def correlation_result_points
    find_points_for correlation
  end

  def correlation_fourier_points
    find_points_for correlation_fourier
  end

  private

    def find_signals
      interval = 2 * Math::PI / @N

      @N.times do |i|
        @first_signal << Math.sin(2 * i * interval)
        @second_signal << Math.cos(7 * i * interval)
      end
    end

    def correlation
      (0...@N).map do |i|
        (0...@N).inject do |sum, n|
          if i + n < 0
            sum + @first_signal[n] * @second_signal[i + n]
          else
            sum + @first_signal[n] * @second_signal[i + n - @N]
          end
        end / @N * 10 ** 16
      end
    end

    def correlation_fourier
      first_image = make_fft_for @first_signal
      second_image = make_fft_for @second_signal

      @N.times do |i|
        first_image[i] = first_image[i].conjugate
        first_image[i] *= second_image[i]
      end

      (restore first_image).compact.map { |num| num * 10 ** 13 }
    end

    def convolution
      (0...@N).map do |i|
        (0...@N).inject do |sum, n|
          if i - n >= 0
            sum + @first_signal[n] * @second_signal[i - n]
          else
            sum + @first_signal[n] * @second_signal[i - n + @N]
          end
        end / @N * 10 ** 16
      end
    end

    def convolution_fourier
      first_image = make_fft_for @first_signal
      second_image = make_fft_for @second_signal

      @N.times { |i| first_image[i] *= second_image[i] }

      (restore first_image).compact.map { |num| num * 10 ** 13 }
    end

    def make_fft_for(signal)
      length = signal.count
      return signal if length == 1
      first, second = [], []
      w = Complex(1, 0)

      (0...length / 2).each do |i|
        first << signal[i] + signal[i + length / 2]
        second << (signal[i] - signal[i + length / 2]) * w

        w *= Math::E ** (-2 * Complex(0, 1) * Math::PI / length)
      end

      first_image = make_fft_for first
      second_image = make_fft_for second

      result = []
      (0...length / 2).each do |i|
        result << first_image[i]
        result << second_image[i]
      end
      result
    end

    def restore(image)
      length = image.count
      return image if length == 1
      first, second = [], []
      w = 1

      (0...length / 2).each do |i|
        first << image[i] + image[i + length / 2]
        second << (image[i] - image[i + length / 2]) * w

        w *= Math::E ** (2 * Complex(0, 1) * Math::PI / length)
      end

      first_image = restore first
      second_image = restore second

      result = []
      (0..length / 2).each do |i|
        result << first_image[i]
        result << second_image[i]
      end
      result
    end

    def find_points_for(signal)
      (0...signal.count).map do |i|
        x = i * 2 * Math::PI / signal.count
        y = signal[i].real

        [ x, y ]
      end
    end
end
