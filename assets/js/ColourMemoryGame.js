define(function() {

  /*
  
  module:     ColourMemoryGame
  usage:      the ColourMemory game class
  author:     R
   */
  "use strict";
  var ColourMemoryGame;
  Array.prototype.shuffle = function() {
    var i, j, ref;
    i = this.length;
    while (--i > 0) {
      j = Math.floor(Math.random() * (i + 1));
      ref = [this[j], this[i]], this[i] = ref[0], this[j] = ref[1];
    }
  };
  return ColourMemoryGame = (function() {
    function ColourMemoryGame() {
      this.baseCardArray = ["red-card", "green-card", "blue-card", "yellow-card", "cyan-card", "purple-card", "magenta-card", "orange-card", "red-card", "green-card", "blue-card", "yellow-card", "cyan-card", "purple-card", "magenta-card", "orange-card"];
      this.selectedCardClass = [];
      this.selectedCardID = [];
      this.totalCardsFlipped = 0;
      this.totalGameScore = 0;
      this.baseMessage = "Click on the cards to start!<br/><br/><i>If two match:</i><br/> You <b>get</b> a point.<br/><i>If not:</i><br/>You <b>loose</b> a point.<br/><br/>Simple enough?";
      this.matchMessageArray = ["Great going,<br/>here's a <b>+1</b> for you", "Good job!<br/><b>+1</b> it is", "You got this,<br/><b>+1</b> added to your score", "You play like a pro!<br/><b>+1</b> <b>+1</b> <b>+1</b>"];
      this.mismatchMessageArray = ["C'mon concentrate!<br/><b>-1</b> from your score", "You can do better!<br/>stop this, <b>-1</b>", "Seriously?<br/>a baby can do better <b>-1</b>", "What a noob..<br/>here, enjoy this <b>-1</b>"];
      this.invalidClickMessage = "Click on an unflipped cards to continue..";
    }

    ColourMemoryGame.prototype.newBoard = function() {
      var i, k, output, ref;
      this.totalCardsFlipped = 0;
      this.totalGameScore = 0;
      $(".current-score").html(this.totalGameScore);
      $(".message").html(this.baseMessage);
      this.baseCardArray.shuffle();
      output = "";
      $(".board").html(output);
      for (i = k = 0, ref = this.baseCardArray.length; 0 <= ref ? k < ref : k > ref; i = 0 <= ref ? ++k : --k) {
        output += "<div class=\"placeholder\"> <div id=\"card-" + i + "\" class=\"card bg-card\"></div> </div>";
      }
      $(".board").html(output);
    };

    ColourMemoryGame.prototype.flipCard = function(card, type) {
      var flipUnmatchedCards, msg;
      if (card.hasClass("bg-card")) {
        card.removeClass("bg-card");
        card.addClass("" + type);
        this.selectedCardClass.push(type);
        this.selectedCardID.push(card.attr("id"));
        if (this.selectedCardClass.length === 2) {
          if (this.selectedCardClass[0] === this.selectedCardClass[1]) {
            this.totalCardsFlipped += 2;
            this.selectedCardClass = [];
            this.selectedCardID = [];
            $(".current-score").html(++this.totalGameScore);
            msg = Math.floor(Math.random() * this.matchMessageArray.length);
            $(".message").html(this.matchMessageArray[msg]);
            if (this.totalCardsFlipped === this.baseCardArray.length) {
              this.saveScore();
              this.newBoard();
            }
          } else {
            setTimeout(flipUnmatchedCards = function(instance) {
              card = $("#" + instance.selectedCardID[0]);
              card.removeClass("" + instance.selectedCardClass[0]);
              card.addClass("bg-card");
              card = $("#" + instance.selectedCardID[1]);
              card.removeClass("" + instance.selectedCardClass[1]);
              card.addClass("bg-card");
              instance.selectedCardClass = [];
              instance.selectedCardID = [];
              $(".current-score").html(--instance.totalGameScore);
              msg = Math.floor(Math.random() * instance.mismatchMessageArray.length);
              $(".message").html(instance.mismatchMessageArray[msg]);
            }, 666, this);
          }
        }
      } else {
        $(".message").html(this.invalidClickMessage);
      }
    };

    ColourMemoryGame.prototype.saveScore = function() {
      $("#mask").css("display", "block");
      $("#score-message").css("display", "block");
      return $("#congrats").append(this.totalGameScore);
    };

    return ColourMemoryGame;

  })();
});
