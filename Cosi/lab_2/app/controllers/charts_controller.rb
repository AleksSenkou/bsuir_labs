class ChartsController < ApplicationController
  def index
    charts = Charts.new

    gon.push(
      first_signal_points: charts.first_signal_points.as_json,
      second_signal_points: charts.second_signal_points.as_json,
      convolution_result_points: charts.convolution_result_points.as_json,
      convolution_fourier_points: charts.convolution_fourier_points.as_json
    )
  end
end
