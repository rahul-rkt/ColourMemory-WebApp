define(function() {

  /*
  
  module:     navHandler
  usage:      handles behaviour of the navigation bar
  author:     R
   */
  "use strict";
  return {
    init: function() {
      var navHeight, viewportHeight;
      navHeight = $("#nav").height();
      viewportHeight = $(window).height() - navHeight;
      $("#nav-buffer").css("height", navHeight);
      return $(window).on("scroll", function() {
        if ($(this).scrollTop() > viewportHeight) {
          $("#nav").css("position", "fixed");
          $("#nav-buffer").css("display", "block");
          return $("#icon").css("display", "inline-block");
        } else {
          $("#nav").css("position", "relative");
          $("#nav-buffer").css("display", "none");
          return $("#icon").css("display", "none");
        }
      }).on("resize", function() {
        return viewportHeight = $(this).height() - $("#nav").height();
      });
    }
  };
});
