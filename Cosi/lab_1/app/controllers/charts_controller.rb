class ChartsController < ApplicationController
  include Charts

  def index
    gon.push base_chart_points: base_chart_points.as_json
  end
end
