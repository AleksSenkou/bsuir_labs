class ChartsController < ApplicationController
  def index
    charts = Charts.new

    gon.push(
      input_signal_points: charts.input_signal_points.as_json,
      transform_signal_points: charts.transform_signal_points.as_json,
      reverse_signal_points: charts.reverse_signal_points.as_json
    )
  end
end
