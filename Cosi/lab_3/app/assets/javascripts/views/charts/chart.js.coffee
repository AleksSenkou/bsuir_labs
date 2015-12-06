class App.Views.Chart extends Backbone.View.extend

  draw: ({ @el, @points, @size, @lines }) ->
    @drawBoard()
    @drawChart()

  drawBoard: ->
    @board = JXG.JSXGraph.initBoard(@el, { boundingbox: @size })
    @board.create 'axis', [ [0, 0], [1, 0] ]
    @board.create 'axis', [ [0, 0], [0, 1] ]
    @board.removeEventHandlers()

  drawChart: ->
    linesCount = _.range(0, @points.length)
    _.map linesCount, (key) =>
      return if _.isUndefined @points[key + 1]
      firstPoint = [ @points[key][0], @points[key][1] ]
      secondPoint = [ @points[key + 1][0], @points[key + 1][1] ]
      @drawLine(firstPoint, secondPoint)

  drawLine: (firstPoint, secondPoint) ->
    @board.create 'line', [ firstPoint, secondPoint ],
      { straightFirst: false, straightLast: false, strokeWidth: 3 }
