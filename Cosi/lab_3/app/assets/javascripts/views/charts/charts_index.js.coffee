class App.Views.ChartsIndex extends Backbone.View
  el: '#charts'
  inputS: 'input-signal'
  transformS: 'transform-signal'
  reverseS: 'reverse-signal'

  initialize: ->
    [ @inputSPoints, @transformSPoints, @reverseSPoints ] =
    [ gon.input_signal_points, gon.transform_signal_points,
      gon.reverse_signal_points ]

  render: ->
    chart = new App.Views.Chart
    chart.draw(el: @inputS, points: @inputSPoints, size: [0, 2, 3.2, -2])
    chart.draw(el: @transformS, points: @transformSPoints, size: [0, 0.6, 3.2, -0.6])
    chart.draw(el: @reverseS, points: @reverseSPoints, size: [0, 2.2, 3.5, -2.2])
    @
