define(function() {

  /*
  
  module:     scrollHandler
  usage:      handles scrolling for internal links
  author:     R
   */
  "use strict";
  var last;
  last = 0;
  return {
    init: function() {
      return $("a[href*=#]:not([href=#])").click(function() {
        var navHeight, target, top;
        if (location.pathname.replace(/^\//, '') === this.pathname.replace(/^\//, '') || location.hostname === this.hostname) {
          target = $(this.hash);
          target = target.length ? target : $('[name=' + this.hash.slice(1)(+']'));
          top = parseInt(target.offset().top);
          navHeight = $("#nav").height();
          if (top !== last && top !== (last - navHeight)) {
            last = top;
            if (target.length) {
              $("html,body").animate({
                scrollTop: top - navHeight
              }, 400);
              return false;
            }
          }
        }
      });
    }
  };
});
