$(document).on('turbolinks:load', function() {

  var starsWrapper = $('.rating > .fa-star');
  var quantityInput = $('.quantity-input');
  var buttonPlus  = $('.increment');
  var buttonMinus = $('.decrement');
  var imageLink = $('.img-link');
  var readMoreLink = $('.read-more');
  var readLessLink = $('.read-less');
  var fullDescription = $('.full-descr');
  var shortDescription = $('.short-descr');

  if (starsWrapper.length) {
    var checked = 'rate-star'
    var empty = 'rate-empty'
    var starsHover = starsWrapper.hover(function() { 
      var last_index = $(this).attr('class').split(' ')[0];
      starsWrapper.each(function(idx, obj){
        if (idx <= last_index) {
          if (!$(obj).hasClass(checked)) {
            $(obj).toggleClass(empty);
          }
        }
      })
    });

    starsWrapper.click(function() {
      starsWrapper.removeClass(checked);
      var last_index = $(this).attr('class').split(' ')[0];
      starsWrapper.each(function(idx, obj){
        if (idx <= last_index) {
          $(obj).addClass(checked);
        }else{
          $(obj).addClass(empty);
        }
      })
    });
  }

  imageLink.click(function() {
    var image = $(this).html();
    var mainImage = $('.product-gallery > .mb-20').html();
    $('.product-gallery > .mb-20').html(image);
    $(this).html(mainImage);
  });

  buttonMinus.click(function(){
    var amount = Number(quantityInput.val());
    if (amount > 1) {
      quantityInput.val(amount - 1);
    }
  });

  buttonPlus.click(function(){
    var amount = Number(quantityInput.val());
    if (amount < 10) {
      quantityInput.val(amount + 1);
    }
  });

  function toggleDescriptionElements() {
    readLessLink.toggleClass('hidden');
    readMoreLink.toggleClass('hidden');
    shortDescription.toggleClass('hidden');
  }

  readMoreLink.click(function(){
    fullDescription.toggleClass('hidden');
    fullDescription.slideDown('slow');
    toggleDescriptionElements();
  });

  readLessLink.click(function(){
    fullDescription.toggleClass('hidden');
    fullDescription.slideUp('slow');
    toggleDescriptionElements();
  });
});
