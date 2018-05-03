// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require best_in_place
//= require jquery_ujs
//= require best_in_place.jquery-ui
//= require foundation
//= require highcharts
//= require chartkick
//= require vue
//= require chosen-jquery
//= require scaffold
//= require_tree .

$(function(){ $(document).foundation(); });

/* Setting footer position on page load */
$(window).bind("load", function () { FooterPosition() });

/* Activating Best In Place */
$(document).ready(function() {
  jQuery(".best_in_place").best_in_place();
});

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


function ToggleOpen(toClose, toOpen) {
  var close = toClose;
  var open = toOpen;
  $('ul.accordion').foundation('toggle', close);
  $('ul.accordion').foundation('toggle', open);
}


// Flash fade
$(function() {
  $('.alert-box').delay(3700).fadeOut();
});


// Datepicker code
$(function() {
  $(".datepicker").datepicker({
    dateFormat: 'yy-mm-dd'
  });
});


$("[data-menu-underline-from-center] a").addClass("underline-from-center");
