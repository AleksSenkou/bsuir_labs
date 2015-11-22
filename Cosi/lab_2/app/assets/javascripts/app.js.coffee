window.App =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    new App.Routers.Charts()
    Backbone.history.start()

$(document).ready ->
  App.initialize()
