class App.Views.BaseChart extends Backbone.View.extend
  el: 'base-chart'

  constructor: ->
    @size = [-9, 3, 9, -3]
    @points = gon.base_chart_points

  render: ->
    @drawBoard()
    @drawChart()
    @

  drawBoard: ->
    @board = new App.Views.Board(el: @el, size: @size).render()

  drawChart: ->
    _.map @points, (point) => @board.drawPoint(point[0], point[1])
