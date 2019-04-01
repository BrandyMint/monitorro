// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery
//= require best_in_place
//= require jquery-ui
//= require best_in_place.jquery-ui
//= require nprogress
//= require nprogress-turbolinks
//= require nprogress-ajax
//= require noty_flash
//= require bootstrap-sprockets
//= require_tree .


jQuery(document).on('best_in_place:error', function (event, request, error) {
  // Display all error messages from server side validation
  jQuery.each(jQuery.parseJSON(request.responseText), function (index, value) {
    if (typeof value === "object") {value = index + " " + value.toString(); }
     Flash.error(value);
  });
});

document.addEventListener("turbolinks:load", function() {
  $(".best_in_place").best_in_place();
  $('.best_in_place').bind("ajax:success", function () {$(this).closest('td').effect('highlight'); });
  $('.best_in_place').bind("ajax:error", function () {$(this).closest('td').effect('bounce'); });
  $('.best_in_place[data-reload-on-success]').bind("ajax:success", function () {NProgress.start(); location.reload();});
  $('[data-toggle="tooltip"]').tooltip();
  $('[data-toggle="popover"]').popover();
  $("[data-effect='highlight']").effect('highlight', {}, 1000);

  //$('.affix').affix();

  initializeStickyTable()
  // initializeSwitchery();
});
