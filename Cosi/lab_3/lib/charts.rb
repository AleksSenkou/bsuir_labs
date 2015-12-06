class Charts

  def initialize(n = 16)
    @N = n

    @input_signal = find_input_signal
    @transform_signal = find_transform_signal_of(@input_signal).map { |i| i / @N }
    @reverse_signal = find_reverse_signal_of(@transform_signal).map { |i| i * @N }
  end

  def input_signal_points
    find_points_for @input_signal
  end

  def transform_signal_points
    find_points_for @transform_signal
  end

  def reverse_signal_points
    find_points_for @reverse_signal
  end

  private

  def find_input_signal
    interval = 2 * Math::PI / @N

    (0...@N).map { |i| Math.sin(5 * i * interval) + Math.cos(i * interval) }
  end

  def find_transform_signal_of(signal)
    n = signal.count
    return signal if n == 1

    first = (0...n / 2).map { |i| signal[i] + signal[i + n / 2] }
    second = (0...n / 2).map { |i| signal[i] - signal[i + n / 2] }

    first = find_transform_signal_of first
    second = find_transform_signal_of second

    result = []

    (0...n / 2).each do |i|
      result[i] = first[i]
      result[i + n / 2] = second[i]
    end

    result
  end

  def find_reverse_signal_of(signal)
    n = signal.count
    return signal if n == 1

    first = (0...n / 2).map { |i| signal[i] }
    second = (0...n / 2).map { |i| signal[i + n / 2] }

    first = find_reverse_signal_of first
    second = find_reverse_signal_of second

    result = []

    (0...n / 2).each do |i|
      result[i] = (first[i] + second[i]) / 2
      result[i + n / 2] = (first[i] - second[i]) / 2
    end

    result
  end

  def find_points_for(signal)
    (0...signal.count).map { |i| [ i * Math::PI / signal.count, signal[i] ] }
  end
end
