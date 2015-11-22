class App.Views.ChartsIndex extends Backbone.View
  el: '#charts'
  firstSignal: 'first-signal'
  secondSignal: 'second-signal'
  convolutionR: 'convolution-result'
  convolutionF: 'convolution-fourier'

  initialize: ->
    [ @firstSignalPoints, @secondSignalPoints, @convolutionRPoints,
      @convolutionFPoints ] =
    [ gon.first_signal_points, gon.second_signal_points, gon.convolution_result_points,
      gon.convolution_fourier_points ]

  render: ->
    chart = new App.Views.Chart
    chart.draw(el: @firstSignal, points: @firstSignalPoints, size: [0, 1.5, 6.5, -1.5])
    chart.draw(el: @secondSignal, points: @secondSignalPoints, size: [0, 1.5, 6.5, -1.5])
    chart.draw(el: @convolutionR, points: @convolutionRPoints, size: [0, 4.5, 6.5, -4.5])
    chart.draw(el: @convolutionF, points: @convolutionFPoints, size: [0, 1, 6.5, -1])
    @
