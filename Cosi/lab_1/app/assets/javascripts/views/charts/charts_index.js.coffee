class Lab2.Views.ChartsIndex extends Backbone.View
  el: '#charts'

  initialize: ->
    @baseChartBox = 'base-chart'

  render: ->
    @drawBaseChart()
    @

  drawBaseChart: ->
    @drawBaseBoard()
    @baseBoard.removeEventHandlers()
    _.each _.range(-8, 8, 0.02), (x) =>
      y = Math.sin(5 * x) + Math.cos(x)
      @drawPoint(@baseBoard, x, y)
    debugger

  drawBaseBoard: ->
    @baseBoard = JXG.JSXGraph.initBoard(@baseChartBox, { boundingbox: [-9, 3, 9, -3] })
    @baseBoard.create 'axis', [ [0, 0], [1, 0] ]
    @baseBoard.create 'axis', [ [0, 0], [0, 1] ]

  drawPoint: (board, x, y) ->
    board.create 'point', [ x, y ], { strokeWidth: 0.1, name: '', fillcolor: 'blue' }
