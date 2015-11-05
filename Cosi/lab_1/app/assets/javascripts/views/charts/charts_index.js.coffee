class App.Views.ChartsIndex extends Backbone.View
  el: '#charts'
  base: 'base'
  dftAbs: 'dft-abs'
  dftPhase: 'dft-phase'
  dftRes: 'dft-restore'
  fftAbs: 'fft-abs'

  initialize: ->
    [ @basePoints, @dftAbsPoints, @dftPhasePoints, @dftResPoints, @fftAbsPoints ] =
    [ gon.base_points, gon.dft_abs_points, gon.dft_phase_points, gon.dft_restore_points,
      gon.fft_abs_points ]

  render: ->
    chart = new App.Views.Chart
    chart.draw(el: @base, points: @basePoints, size: [0, 3, 7, -3], lines: false)
    chart.draw(el: @dftAbs, points: @dftAbsPoints, size: [0, 0.6, 7, -0.6], lines: true)
    chart.draw(el: @dftPhase, points: @dftPhasePoints, size: [0, 4, 7, -4], lines: true)
    chart.draw(el: @dftRes, points: @dftResPoints, size: [0, 3, 7, -3], lines: false)
    chart.draw(el: @fftAbs, points: @fftAbsPoints, size: [0, 1.1, 7, -1.1], lines: true)
    @
