define ->


    ###

    module:     tabHandler
    usage:      handles behaviour of the documentation tabs
    author:     R

    ###


    "use strict"

    init: ->
        $(".container .menu li a").click ->
            toReplace = $(".container .wrapper .active")
            replacement = $($(this).attr("href")).parent()

            $(toReplace).hide()
            $(toReplace).removeClass("active")

            $(replacement).fadeIn()
            $(replacement).addClass("active")

            return false
