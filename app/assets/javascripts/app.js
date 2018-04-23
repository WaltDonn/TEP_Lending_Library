//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require foundation

$(function(){ $(document).foundation(); });

/* Setting footer position on page load */
$(window).bind("load", function () { FooterPosition() });

$(window).resize(function () { FooterPosition(); });

// Sticky footer js
// Thanks to Charles Smith for this -- http://foundation.zurb.com/forum/posts/629-sticky-footer
// Altered by Juliann -- If the body is longer than the page, make sure the footer is under that.
//                       If it's not, allow a peice of the footer to show.
function FooterPosition() {
  // getting parts of page
  var footer = $("#footer");
  var body = $("#body_content");
  var nav = $(".home-nav");

  // height and position values
  var pos = footer.position();
  var height = $(window).height();
  var bodyHeight = body.height() + nav.height() + footer.height()/3;

  // footer position logic (shown on screen or not)
  if (bodyHeight > height) {
    height = bodyHeight - pos.top;
  }
  else {
    var fheight = footer.height()/3; // 1/3 of the footer height
    height = height - pos.top;
    height = height - fheight;
  }

  // moving the footer
  if (height > 0) {
      footer.css({
          'margin-top': height + 'px'
      });
  }
};

// Flash fade
$(function() {
  $('.alert-box').delay(3700).fadeOut();
});

// nav underlining animation
$("[data-menu-underline-from-center] a").addClass("underline-from-center");
