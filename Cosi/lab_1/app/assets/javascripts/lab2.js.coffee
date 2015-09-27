window.Lab2 =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    new Lab2.Routers.Charts()
    Backbone.history.start()

$(document).ready ->
  Lab2.initialize()
