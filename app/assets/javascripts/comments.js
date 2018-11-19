

$(document).on('turbolinks:load', function() {
  var starsWrapper = $('.rating > .fa-star');

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
      var rating = $('.rating').children('.rate-star').length;
      $('#comment_form_rating').val(rating);
    });
  }
});
