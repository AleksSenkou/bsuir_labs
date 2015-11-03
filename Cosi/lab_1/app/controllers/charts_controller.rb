class ChartsController < ApplicationController
  def index
    charts = Charts.new

    gon.push(
      base_points: charts.base_points.as_json,
      dft_abs_points: charts.dft_abs_points.as_json,
      dft_phase_points: charts.dft_phase_points.as_json,
      dft_restore_points: charts.dft_restore_points.as_json
    )
  end
end
