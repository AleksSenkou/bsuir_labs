class App.Views.ChartsIndex extends Backbone.View
  el: '#charts'
  firstSignal: 'first-signal'
  secondSignal: 'second-signal'

  initialize: ->
    [ @firstSignalPoints, @secondSignalPoints ] =
    [ gon.first_signal_points, gon.second_signal_points ]

  render: ->
    chart = new App.Views.Chart
    chart.draw(el: @firstSignal, points: @firstSignalPoints, size: [0, 1.5, 6.5, -1.5])
    chart.draw(el: @secondSignal, points: @secondSignalPoints, size: [0, 1.5, 6.5, -1.5])
    @
