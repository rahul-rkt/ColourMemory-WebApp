# config ----------------------------------------------------------------------
require.config

    baseUrl: "./assets/js"

    paths:
        jquery: "//code.jquery.com/jquery-2.1.4.min"
        magnificPopup: "./lib/jquery.magnific-popup.min"


# main ------------------------------------------------------------------------
require [

    "jquery"
    "magnificPopup"
    "navHandler"
    "scrollHandler"
    "tabHandler"
    "gameHandler"

    ], ($, magnificPopup, navHandler, scrollHandler, tabHandler, gameHandler) ->


    ###

    module:     main
    usage:      everything starts here
    author:     R

    ###


    "use strict"

    $(document).ready ->
        $(".wireframes").magnificPopup
            delegate: "a"
            type: "image"
            gallery:
                enabled: true

        navHandler.init()
        scrollHandler.init()
        tabHandler.init()
        gameHandler.init()
        return
