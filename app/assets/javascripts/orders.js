$(document).on('turbolinks:load', function() {
  $( '.country-select' ).change(function() {
    var addressType = $(this).attr('class').split(' ').pop();
    var code = $(this).find('option:selected').data( 'code' );
    $('.phone-code.' + addressType).val(code);
  });

  $( '.billing-flag' ).change(function() {
    if ($(this).is( ':checked' )) {
      $('.shipping-address-form').children().hide();
      $('.form-group.checkbox').show();
    }else{
      $('.shipping-address-form').children().show();
    }
  });

  $('input').keyup(function() {
    var input = $(this)
    var parent = input.closest('.form-group');
    if ( !parent.length ){
      parent = input.closest('.general-input-group');
    }
    var value = input.val();
    var regexp = new RegExp(input.data( 'regexp' ));
    parent.removeClass('has-error');
    if(!regexp.test(value)) {
      parent.addClass('has-error');
      input.tooltip({ disabled: true }).on('keyup', function () {
        input
          .tooltip('enable')
          .tooltip('open');
        }).on('focusout', function () {
        input
          .tooltip('close')
          .tooltip('disable');
        });
    }
  });

  $('.info-icon').hover(function() {
    $(this).tooltip();
  });
  
  $('tr[data-link]').click(function() {
    window.location = $(this).data('link');
  })
  $('table[data-link]').click(function() {
    window.location = $(this).data('link');
  })
});
