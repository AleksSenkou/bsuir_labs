module Charts
  def base_chart_points
    (-8..8).step(0.05).map { |x| [x, Math.sin(5 * x) + Math.cos(x)] }
  end
end
