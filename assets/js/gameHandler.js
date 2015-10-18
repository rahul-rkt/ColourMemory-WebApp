define(function(require) {

  /*
  
  module:     gameHandler
  usage:      handles the game and api calls
  author:     R
   */
  "use strict";
  return {
    init: function() {
      var ColourMemoryGame, bringToFocus, cancelButton, changeFocus, congratsHeader, congratsHeaderDefault, emailField, errorHeader, game, getRankings, highScoreTable, highScoreTableDefault, inputBlock, maskOverlay, messageBlock, mod, nameField, navDirection, navigateTo, okayButton, performActionOn, postHelper, rankHeader, rankHeaderDefault, selectedCard, submitButton, url;
      ColourMemoryGame = require("ColourMemoryGame");
      url = "http://colour-memory-webapp-api.herokuapp.com";
      game = new ColourMemoryGame();
      game.newBoard();
      highScoreTable = $("#high-scores");
      maskOverlay = $("#mask");
      messageBlock = $("#score-message");
      congratsHeader = $("#congrats");
      rankHeader = $("#your-rank");
      errorHeader = $("#submit-error");
      inputBlock = $("#inputs");
      nameField = $("#input-name");
      emailField = $("#input-email");
      submitButton = $("#submit");
      cancelButton = $("#cancel");
      okayButton = $("#okay");
      highScoreTableDefault = "<tr> <th>Rank</th> <th>Name</th> <th>Email</th> <th>Score</th> </tr>";
      congratsHeaderDefault = "Congratulations, you&nbsp;scored:&nbsp;";
      rankHeaderDefault = "Great, you&nbsp;ranked:&nbsp;";
      selectedCard = $(":focus");
      navDirection = {
        largeScreen: {
          left: -1,
          up: -4,
          right: 1,
          down: 4
        },
        smallScreen: {
          left: -1,
          up: -2,
          right: 1,
          down: 2
        }
      };
      mod = function(x, y) {
        return ((x % y) + y) % y;
      };
      bringToFocus = function() {
        if (!$(":focus").hasClass("card")) {
          selectedCard = $("#card-0");
          return selectedCard.focus();
        }
      };
      changeFocus = function(byFactor) {
        var current, updated;
        current = parseInt(selectedCard.attr("id").substring(5));
        updated = mod(current + byFactor, 16);
        selectedCard = $("#card-" + updated);
        return selectedCard.focus();
      };
      navigateTo = function(nextCard) {
        if (!selectedCard.is(":focus")) {
          return bringToFocus();
        } else {
          return changeFocus(nextCard);
        }
      };
      performActionOn = function(card) {
        var id;
        id = card.attr("id").substring(5);
        return game.flipCard(card, game.baseCardArray[id]);
      };
      $(document).keydown(function(key) {
        var direction, screenSizeIsLarge;
        screenSizeIsLarge = $(window).width() > Math.floor(720 * (parseInt($("html").css("font-size")) / 16));
        direction = screenSizeIsLarge ? navDirection.largeScreen : navDirection.smallScreen;
        switch (key.which) {
          case 37:
            navigateTo(direction.left);
            break;
          case 38:
            navigateTo(direction.up);
            break;
          case 39:
            navigateTo(direction.right);
            break;
          case 40:
            navigateTo(direction.down);
            break;
          case 32:
            performActionOn(selectedCard);
            break;
          case 13:
            performActionOn(selectedCard);
            break;
          default:
            return;
        }
        key.preventDefault();
      });
      $(document.body).on("click", ".card", function() {
        selectedCard = $(this);
        selectedCard.focus();
        return performActionOn(selectedCard);
      });
      $(document.body).on("click", ".restart", function() {
        return game.newBoard();
      });
      getRankings = function() {
        highScoreTable.html(highScoreTableDefault);
        $.ajax({
          type: "GET",
          dataType: "JSON",
          url: url,
          success: function(response) {
            var data, i, len, ranker, rankings;
            rankings = "";
            ranker = 1;
            for (i = 0, len = response.length; i < len; i++) {
              data = response[i];
              rankings += "<tr> <td>" + (ranker++) + "</td> <td>" + data.name + "</td> <td>" + data.email + "</td> <td>" + data.score + "</td> </tr>";
            }
            highScoreTable.append(rankings);
          },
          error: function() {
            var rankings;
            rankings = "<tr> <td>N/A</td> <td>N/A</td> <td>N/A</td> <td>N/A</td> </tr>";
            highScoreTable.append(rankings);
          }
        });
      };
      getRankings();
      setInterval((function() {
        return getRankings();
      }), 300000);
      postHelper = function() {
        inputBlock.css("display", "none");
        congratsHeader.css("display", "none");
        submitButton.css("display", "none");
        cancelButton.css("display", "none");
        okayButton.css("display", "inline-block");
      };
      submitButton.on("click", function() {
        var request;
        request = {
          "name": nameField.val(),
          "email": emailField.val(),
          "score": congratsHeader.html().substring(39)
        };
        $.ajax({
          type: "POST",
          dataType: "JSON",
          url: url,
          contentType: "application/json; charset=utf-8",
          data: JSON.stringify(request),
          success: function(response) {
            postHelper();
            rankHeader.append(response.rank);
            rankHeader.css("display", "block");
          },
          error: function() {
            postHelper();
            errorHeader.css("display", "block");
          }
        });
        game.newBoard();
      });
      cancelButton.on("click", function() {
        maskOverlay.css("display", "none");
        messageBlock.css("display", "none");
        congratsHeader.html(congratsHeaderDefault);
      });
      return okayButton.on("click", function() {
        maskOverlay.css("display", "none");
        messageBlock.css("display", "none");
        congratsHeader.html(congratsHeaderDefault);
        congratsHeader.css("display", "block");
        inputBlock.css("display", "block");
        submitButton.css("display", "inline-block");
        cancelButton.css("display", "inline-block");
        rankHeader.html(rankHeaderDefault);
        rankHeader.css("display", "none");
        okayButton.css("display", "none");
        errorHeader.css("display", "none");
        getRankings();
      });
    }
  };
});
