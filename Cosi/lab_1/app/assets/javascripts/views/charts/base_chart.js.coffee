#= require 'views/charts/board'

class Lab2.Views.BaseChart extends Backbone.View.extend
  el: 'base-chart'

  constructor: ->
    @size = [-9, 3, 9, -3]
    @xAxisPoints = _.range(-8, 8, 0.05)

  render: ->
    @drawBoard()
    @drawChart()
    @

  drawBoard: ->
    @board = new Lab2.Views.Board(
      el: @el
      size: @size
    ).render()

  drawChart: ->
    _.each @xAxisPoints, (x) =>
      y = Math.sin(5 * x) + Math.cos(x)
      @board.drawPoint(x, y)
