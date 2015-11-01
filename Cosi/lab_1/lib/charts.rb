class Charts
  def initialize(n = 512, range = (-8..8))
    @N = n
    @range = range
    @step = @range.count.to_f / @N.to_f
    @x_axis_points = @range.step(@step).to_a
  end

  def base_chart_points
    @x_axis_points.map { |x| [x, Math.sin(5 * x) + Math.cos(x)] }
  end
end
