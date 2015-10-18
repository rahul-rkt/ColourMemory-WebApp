define (require) ->


    ###

    module:     gameHandler
    usage:      handles the game and api calls
    author:     R

    ###


    "use strict"

    init: ->
        ColourMemoryGame = require "ColourMemoryGame"
        url = "http://colour-memory-webapp-api.herokuapp.com"


        # start new game
        game = new ColourMemoryGame()
        game.newBoard()


        # cache DOM elements
        highScoreTable  = $("#high-scores")

        maskOverlay     = $("#mask")
        messageBlock    = $("#score-message")

        congratsHeader  = $("#congrats")
        rankHeader      = $("#your-rank")
        errorHeader     = $("#submit-error")

        inputBlock      = $("#inputs")
        nameField       = $("#input-name")
        emailField      = $("#input-email")

        submitButton    = $("#submit")
        cancelButton    = $("#cancel")
        okayButton      = $("#okay")


        # default inner html
        highScoreTableDefault = "<tr>
                                    <th>Rank</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Score</th>
                                </tr>"
        congratsHeaderDefault = "Congratulations, you&nbsp;scored:&nbsp;"
        rankHeaderDefault = "Great, you&nbsp;ranked:&nbsp;"


        # key press defaults
        selectedCard = $(":focus")
        dir = {
                left    : -1
                up      : -4
                right   :  1
                down    :  4
              }


        # helper to calculate modulo
        mod = (x, y) ->
            ((x % y) + y) % y


        # helper to set focus
        bringToFocus = ->
            if(!$(":focus").hasClass("card"))
                selectedCard = $("#card-0")
                selectedCard.focus()


        # helper to change focus
        changeFocus = (byFactor) ->
            current = parseInt(selectedCard.attr("id").substring(5))
            updated = mod((current + byFactor), 16)
            selectedCard = $("#card-#{updated}")
            selectedCard.focus()


        # handle navigation to next card
        navigateTo = (nextCard) ->
            if not selectedCard.is(':focus')
                bringToFocus()
            else
                changeFocus(nextCard)


        # takes action on selected card
        performActionOn = (card) ->
            id = card.attr("id").substring(5)
            game.flipCard(card, game.baseCardArray[id])


        # handle key press
        $(document).keydown (key) ->
            switch key.which
                when 37 # left
                    navigateTo dir.left
                when 38 # up
                    navigateTo dir.up
                when 39 # right
                    navigateTo dir.right
                when 40 # down
                    navigateTo dir.down
                when 32 # space
                    performActionOn selectedCard
                when 13 # enter
                    performActionOn selectedCard
                else
                    return
            key.preventDefault()
            return


        # handle click over cards
        $(document.body).on "click", ".card", ->
            selectedCard = $(this)
            selectedCard.focus()
            performActionOn selectedCard


        # handle click over restart button
        $(document.body).on "click", ".restart", ->
            game.newBoard()


        # handle ajax call to GET all rankings
        getRankings = ->
            highScoreTable.html(highScoreTableDefault)

            $.ajax
                type: "GET"
                dataType: "JSON"
                url: url

                success: (response) ->
                    rankings = ""
                    ranker  = 1

                    for data in response
                        rankings += "<tr>
                                        <td>#{ranker++}</td>
                                        <td>#{data.name}</td>
                                        <td>#{data.email}</td>
                                        <td>#{data.score}</td>
                                     </tr>"

                    highScoreTable.append(rankings)
                    return

                error: ->
                    rankings = "<tr>
                                    <td>N/A</td>
                                    <td>N/A</td>
                                    <td>N/A</td>
                                    <td>N/A</td>
                                </tr>"

                    highScoreTable.append(rankings)
                    return

            return
        getRankings()


        # repeat GET call every 5mins
        setInterval (->
            getRankings()
        ), 300000


        # helper for POST call
        postHelper = ->
            inputBlock.css("display", "none")
            congratsHeader.css("display", "none")
            submitButton.css("display", "none")
            cancelButton.css("display", "none")
            okayButton.css("display", "inline-block")
            return


        # handle ajax call to POST new score on submit
        submitButton.on "click", ->
            request = {
                        "name"      : nameField.val()
                        "email"     : emailField.val()
                        "score"     : congratsHeader.html().substring(39)
                      }

            $.ajax
                type: "POST"
                dataType: "JSON"
                url: url
                contentType: "application/json; charset=utf-8"
                data: JSON.stringify(request)

                success: (response) ->
                    postHelper()
                    rankHeader.append(response.rank)
                    rankHeader.css("display", "block")
                    return

                error: ->
                    postHelper()
                    errorHeader.css("display", "block")
                    return

            game.newBoard()
            return


        # handle cancellation of posting new score
        cancelButton.on "click", ->
            maskOverlay.css("display", "none")
            messageBlock.css("display", "none")
            congratsHeader.html(congratsHeaderDefault)
            return

        # reset DOM elements after posting new score
        okayButton.on "click", ->
            maskOverlay.css("display", "none")
            messageBlock.css("display", "none")

            congratsHeader.html(congratsHeaderDefault)
            congratsHeader.css("display", "block")
            inputBlock.css("display", "block")
            submitButton.css("display", "inline-block")
            cancelButton.css("display", "inline-block")

            rankHeader.html(rankHeaderDefault)
            rankHeader.css("display", "none")
            okayButton.css("display", "none")
            errorHeader.css("display", "none")
            getRankings()
            return
