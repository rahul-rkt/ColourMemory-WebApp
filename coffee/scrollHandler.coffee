define ->


    ###

    module:     scrollHandler
    usage:      handles scrolling for internal links
    author:     R

    ###


    "use strict"

    last = 0

    init: ->
        $("a[href*=#]:not([href=#])").click ->
            if(
                location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') ||
                location.hostname == this.hostname
            )
                target = $(this.hash)
                target = if target.length then target else $('[name=' + this.hash.slice(1) +']')
                top = parseInt(target.offset().top)
                navHeight = $("#nav").height()

                if(top != last && top != (last - navHeight))
                    last = top
                    if(target.length)
                        $("html,body").animate
                            scrollTop: top - navHeight
                            400
                        return false
