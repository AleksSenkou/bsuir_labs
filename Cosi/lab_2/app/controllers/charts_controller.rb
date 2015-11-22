class ChartsController < ApplicationController
  def index
    charts = Charts.new

    gon.push(
      first_signal_points: charts.first_signal_points.as_json,
      second_signal_points: charts.second_signal_points.as_json
    )
  end
end
