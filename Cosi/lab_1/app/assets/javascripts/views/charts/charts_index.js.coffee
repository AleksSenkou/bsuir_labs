class App.Views.ChartsIndex extends Backbone.View
  el: '#charts'
  base: 'base'
  dftAbs: 'dft-abs'
  dftPhase: 'dft-phase'
  dftRes: 'dft-restore'
  fftAbs: 'fft-abs'
  fftPhase: 'fft-phase'
  fftRes: 'fft-restore'

  initialize: ->
    [ @basePoints, @dftAbsPoints, @dftPhasePoints, @dftResPoints, @fftAbsPoints,
      @fftPhasePoints, @fftResPoints ] =
    [ gon.base_points, gon.dft_abs_points, gon.dft_phase_points, gon.dft_restore_points,
      gon.fft_abs_points, gon.fft_phase_points, gon.fft_restore_points ]

  render: ->
    chart = new App.Views.Chart
    chart.draw(el: @base, points: @basePoints, size: [0, 3, 7, -3], lines: false)
    chart.draw(el: @dftAbs, points: @dftAbsPoints, size: [0, 0.6, 7, -0.6], lines: true)
    chart.draw(el: @dftPhase, points: @dftPhasePoints, size: [0, 4, 7, -4], lines: true)
    chart.draw(el: @dftRes, points: @dftResPoints, size: [0, 3, 7, -3], lines: false)
    chart.draw(el: @fftAbs, points: @fftAbsPoints, size: [0, 0.6, 7, -0.6], lines: true)
    chart.draw(el: @fftPhase, points: @fftPhasePoints, size: [0, 4, 7, -4], lines: true)
    chart.draw(el: @fftRes, points: @fftResPoints, size: [0, 3, 7, -3], lines: false)
    @
