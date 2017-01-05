// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require bootstrap
//= require jquery_ujs
//= require jquery-ui
//= require jquery_nested_form
//= require_tree .

$(function() {
  $.datepicker.regional['cs'] = {
    closeText: 'Cerrar',
    prevText: 'Předchozí',
    nextText: 'Další',
    currentText: 'Hoy',
    monthNames: ['Leden','Únor','Březen','Duben','Květen','Červen', 'Červenec','Srpen','Září','Říjen','Listopad','Prosinec'],
    monthNamesShort: ['Le','Ún','Bř','Du','Kv','Čn', 'Čc','Sr','Zá','Ří','Li','Pr'],
    dayNames: ['Neděle','Pondělí','Úterý','Středa','Čtvrtek','Pátek','Sobota'],
    dayNamesShort: ['Ne','Po','Út','St','Čt','Pá','So',],
    dayNamesMin: ['Ne','Po','Út','St','Čt','Pá','So'],
    weekHeader: 'Sm',
    dateFormat: 'dd.mm.yy',
    firstDay: 1,
    isRTL: false,
    showMonthAfterYear: false,
    yearSuffix: ''
  };

  $.datepicker.setDefaults($.datepicker.regional['cs']);

  // Enables the JQuery's datepicker.
  $('.datepicker').datepicker({
      dateFormat: "yy-mm-dd"
  });

  $("#invoice_issuer_true").each(function(index, button){
     $(button).click(function(){
        value = $('#issuer_true_hidden').val()
        current_value = $("#invoice_number").val()
        if (value != undefined) {
          $("#invoice_number").val(value);
        }
     });
  });

  $("#invoice_issuer_false").each(function(index, button){
     $(button).click(function(){
        value = $('#issuer_false_hidden').val()
        current_value = $("#invoice_number").val()
        if (value != undefined) {
          $("#invoice_number").val(value);
        }
     });
  });

  $("#receipt_issuer_true").each(function(index, button){
     $(button).click(function(){
        value = $('#issuer_true_hidden').val()
        current_value = $("#receipt_number").val()
        if (value != undefined) {
          $("#receipt_number").val(value);
        }
     });
  });

  $("#receipt_issuer_false").each(function(index, button){
     $(button).click(function(){
        value = $('#issuer_false_hidden').val()
        current_value = $("#receipt_number").val()
        if (value != undefined) {
          $("#receipt_number").val(value);
        }
     });
  });

  // Toggles the templates option in bills' forms.
  var prefill = false

  $('.prefill-toggle').click(function() {
    if (prefill == false) {
      prefill = true;
      $('.prefill-toggle').css('background','lightgrey');
    } else {
      prefill = false;
      $('.prefill-toggle').css('background','white');
    }
    $('#prefill-form').slideToggle('slow', function() {
      // Animation complete.
    });
  });
});

function change_to_deposit_invoice(element) {
  $(element).closest('.item').find('.number').hide();
  $(element).closest('.item').find('.unit').hide();
  $(element).closest('.item').find('.price').hide();
  $(element).closest('.item').find('.deposit-invoice').show();
  $(element).hide();
};
