define ->


    ###

    module:     ColourMemoryGame
    usage:      the ColourMemory game class
    author:     R

    ###


    "use strict"

    # shuffles base array to generate random game
    Array::shuffle = ->
        i = @length
        while --i > 0
            j = Math.floor(Math.random()*(i+1))
            [@[i], @[j]] = [@[j], @[i]]
        return


    class ColourMemoryGame
        constructor: ->

            # base array
            @baseCardArray = [
                # set 1
                "red-card"
                "green-card"
                "blue-card"
                "yellow-card"
                "cyan-card"
                "purple-card"
                "magenta-card"
                "orange-card"
                # set 2
                "red-card"
                "green-card"
                "blue-card"
                "yellow-card"
                "cyan-card"
                "purple-card"
                "magenta-card"
                "orange-card"
            ]

            # tracks currently selected card classes
            @selectedCardClass = []

            # tracks currently selected card ids
            @selectedCardID = []

            # tracks total number of cards successfully flipped
            @totalCardsFlipped = 0

            # tracks total game score for the current board
            @totalGameScore = 0

            @baseMessage = "Click on the cards to start!<br/><br/><i>If two match:</i><br/> You <b>get</b> a point.<br/><i>If not:</i><br/>You <b>loose</b> a point.<br/><br/>Simple enough?"

            # match message array
            @matchMessageArray = [
                "Great going,<br/>here's a <b>+1</b> for you"
                "Good job!<br/><b>+1</b> it is"
                "You got this,<br/><b>+1</b> added to your score"
                "You play like a pro!<br/><b>+1</b> <b>+1</b> <b>+1</b>"
            ]

            # mismatch message array
            @mismatchMessageArray = [
                "C'mon concentrate!<br/><b>-1</b> from your score"
                "You can do better!<br/>stop this, <b>-1</b>"
                "Seriously?<br/>a baby can do better <b>-1</b>"
                "What a noob..<br/>here, enjoy this <b>-1</b>"
            ]

            # invlid click response message
            @invalidClickMessage = "Click on an unflipped cards to continue.."


        # generates new game
        newBoard: ->
            @totalCardsFlipped = 0
            @totalGameScore = 0

            $(".current-score").html(@totalGameScore)
            $(".message").html(@baseMessage)

            @baseCardArray.shuffle()

            output = ""
            $(".board").html(output)
            for i in [0...@baseCardArray.length]
                output +=   "<div class=\"placeholder\">
                                <div id=\"card-#{i}\" class=\"card bg-card\" tabindex=\"-1\"></div>
                            </div>"
            $(".board").html(output)
            return


        # handles performed action on cards
        flipCard: (card, type) ->
            # valid click?
            if(card.hasClass("bg-card") && @selectedCardClass.length < 2)
                # animate
                card.addClass("flip")

                # wait for the animation to progress
                setTimeout(
                    (card) ->
                        card.removeClass("bg-card")
                        card.addClass("#{type}")
                        card.removeClass("flip")
                        return
                    200
                    card)

                @selectedCardClass.push type
                @selectedCardID.push card.attr("id")

                # second card?
                if(@selectedCardClass.length == 2)

                    # cards match?
                    if(@selectedCardClass[0] == @selectedCardClass[1])
                        @totalCardsFlipped += 2
                        @selectedCardClass = []
                        @selectedCardID = []

                        $(".current-score").html(++@totalGameScore)

                        msg = Math.floor(Math.random()*(@matchMessageArray.length))
                        $(".message").html(@matchMessageArray[msg])

                        # game over?
                        if(@totalCardsFlipped == @baseCardArray.length)
                            @saveScore()
                            @newBoard()

                    # no match, flip back the cards after timeout
                    else
                        setTimeout(
                            (game) ->
                                card1 = $("##{game.selectedCardID[0]}")
                                card2 = $("##{game.selectedCardID[1]}")

                                # animate
                                card1.addClass("flip-back")
                                card2.addClass("flip-back")

                                # wait for the animation to progress
                                setTimeout(
                                    (card1, card2, game) ->
                                        card1.removeClass("#{game.selectedCardClass[0]}")
                                        card2.removeClass("#{game.selectedCardClass[1]}")
                                        card1.addClass("bg-card")
                                        card2.addClass("bg-card")

                                        game.selectedCardClass = []
                                        game.selectedCardID = []

                                        $(".current-score").html(--game.totalGameScore)

                                        msg = Math.floor(Math.random()*(game.mismatchMessageArray.length))
                                        $(".message").html(game.mismatchMessageArray[msg])

                                        card1.removeClass("flip-back")
                                        card2.removeClass("flip-back")

                                        return
                                    200
                                    card1, card2, game)
                                return
                            400
                            this)

            # invalid click
            else
                $(".message").html(@invalidClickMessage)

            return


        # uploads current game score
        saveScore: ->
            $("#mask").css("display", "block")
            $("#score-message").css("display", "block")
            $("#congrats").append(@totalGameScore)
