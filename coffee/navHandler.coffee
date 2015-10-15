define ->


    ###

    module:     navHandler
    usage:      handles behaviour of the navigation bar
    author:     R

    ###


    "use strict"

    init: ->
        navHeight = $("#nav").height()
        viewportHeight = $(window).height() - navHeight
        $("#nav-buffer").css("height", navHeight)

        $(window)
            .on "scroll", ->
                if($(this).scrollTop() > viewportHeight)
                    $("#nav").css("position", "fixed")
                    $("#nav-buffer").css("display", "block")
                    $("#icon").css("display", "inline-block")

                else
                    $("#nav").css("position", "relative")
                    $("#nav-buffer").css("display", "none")
                    $("#icon").css("display", "none")

            .on "resize", ->
                viewportHeight = $(this).height() - $("#nav").height()
