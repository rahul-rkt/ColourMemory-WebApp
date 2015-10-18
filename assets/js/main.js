require.config({
  baseUrl: "./assets/js",
  paths: {
    jquery: "./lib/jquery-2.1.4.min",
    magnificPopup: "./lib/jquery.magnific-popup.min"
  }
});

require(["jquery", "magnificPopup", "navHandler", "scrollHandler", "tabHandler", "gameHandler"], function($, magnificPopup, navHandler, scrollHandler, tabHandler, gameHandler) {

  /*
  
  module:     main
  usage:      everything starts here
  author:     R
   */
  "use strict";
  return $(document).ready(function() {
    $(".wireframes").magnificPopup({
      delegate: "a",
      type: "image",
      gallery: {
        enabled: true
      }
    });
    navHandler.init();
    scrollHandler.init();
    tabHandler.init();
    gameHandler.init();
  });
});
