class App.Views.ChartsIndex extends Backbone.View
  el: '#charts'
  base: 'base'
  difFour: 'dft-abs'

  initialize: ->
    [ @basePoints, @difFourPoints ] = [ gon.base_chart_points, gon.dft_abs_chart_points ]

  render: ->
    chart = new App.Views.Chart
    chart.draw(el: @base, points: @basePoints, size: [0, 3, 7, -3], lines: false)
    chart.draw(el: @difFour, points: @difFourPoints, size: [0, 0.6, 7, -0.6], lines: true)
    @
