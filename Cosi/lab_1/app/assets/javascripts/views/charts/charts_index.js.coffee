class App.Views.ChartsIndex extends Backbone.View
  el: '#charts'
  base: 'base'
  dftAbs: 'dft-abs'
  dftPhase: 'dft-phase'

  initialize: ->
    [ @basePoints, @dftAbsPoints, @dftPhasePoints ] =
    [ gon.base_points, gon.dft_abs_points, gon.dft_phase_points ]

  render: ->
    chart = new App.Views.Chart
    chart.draw(el: @base, points: @basePoints, size: [0, 3, 7, -3], lines: false)
    chart.draw(el: @dftAbs, points: @dftAbsPoints, size: [0, 0.6, 7, -0.6], lines: true)
    chart.draw(el: @dftPhase, points: @dftPhasePoints, size: [0, 4, 7, -4], lines: true)
    @
