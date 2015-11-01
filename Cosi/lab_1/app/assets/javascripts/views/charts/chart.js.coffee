class App.Views.Chart extends Backbone.View.extend

  constructor: ({ @el, @points }) ->

  render: ->
    @drawBoard()
    @drawChart()
    @

  drawBoard: ->
    @board = new App.Views.Board(el: @el).render()

  drawChart: ->
    _.map @points?, (point) => @board.drawPoint(point[0], point[1])
