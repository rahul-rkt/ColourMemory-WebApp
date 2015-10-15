define(function() {

  /*
  
  module:     tabHandler
  usage:      handles behaviour of the documentation tabs
  author:     R
   */
  "use strict";
  return {
    init: function() {
      return $(".container .menu li a").click(function() {
        var replacement, toReplace;
        toReplace = $(".container .wrapper .active");
        replacement = $($(this).attr("href")).parent();
        $(toReplace).hide();
        $(toReplace).removeClass("active");
        $(replacement).fadeIn();
        $(replacement).addClass("active");
        return false;
      });
    }
  };
});
