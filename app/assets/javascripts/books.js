$(document).on('turbolinks:load', function() {
  var quantityInput = $('.quantity-input');
  var buttonPlus  = $('.increment');
  var buttonMinus = $('.decrement');
  var imageLink = $('.img-link');
  var readMoreLink = $('.read-more');
  var readLessLink = $('.read-less');
  var fullDescription = $('.full-descr');
  var shortDescription = $('.short-descr');

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
