class ChartsController < ApplicationController
  def index
    charts = Charts.new

    gon.push base_chart_points: charts.base_chart_points.as_json
  end
end
