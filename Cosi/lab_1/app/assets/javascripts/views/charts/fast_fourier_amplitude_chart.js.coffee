class App.Views.FastFourierAmplitudeChart extends Backbone.View.extend
  el: 'fast-fourier-amplitude-chart'

  constructor: ->
    @size = [-9, 6, 9, -6]
    @xAxisPoints = _.range(-8, 8, 1)

  render: ->
    @drawBoard()
    @

  drawBoard: ->
    @board = new App.Views.Board(el: @el, size: @size).render()
