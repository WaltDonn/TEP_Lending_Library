//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require foundation

$(function(){ $(document).foundation(); });

// Sticky footer js
// Thanks to Charles Smith for this -- http://foundation.zurb.com/forum/posts/629-sticky-footer
$(window).bind("load", function () {
  var footer = $("#footer");
  var pos = footer.position();
  var height = $(window).height();
  height = height - pos.top;
  height = height - footer.height();
  if (height > 0) {
    footer.css({
      'margin-top': height + 'px'
    });
  }
});

// Flash fade
$(function() {
  $('.alert-box').delay(3700).fadeOut();
});

$("[data-menu-underline-from-center] a").addClass("underline-from-center");
