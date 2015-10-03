class App.Views.Board extends Backbone.View.extend

  constructor: (options) ->
    @el = options.el
    @size = options.size

  render: ->
    @board = JXG.JSXGraph.initBoard(@el, { boundingbox: @size })
    @board.create 'axis', [ [0, 0], [1, 0] ]
    @board.create 'axis', [ [0, 0], [0, 1] ]
    @board.removeEventHandlers()
    @

  drawPoint: (x, y) ->
    @board.create 'point', [ x, y ], { strokeWidth: 0.1, name: '', fillcolor: 'blue' }
