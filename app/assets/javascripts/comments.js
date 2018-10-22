

$(document).on('turbolinks:load', function() {
  var starsWrapper = $('.rating > .fa-star');

  if (starsWrapper.length) {
    let checked = 'rate-star'
    let empty = 'rate-empty'
    let starsHover = starsWrapper.hover(function() { 
      let last_index = $(this).attr('class').split(' ')[0];
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
      let last_index = $(this).attr('class').split(' ')[0];
      starsWrapper.each(function(idx, obj){
        if (idx <= last_index) {
          $(obj).addClass(checked);
        }else{
          $(obj).addClass(empty);
        }
      })
      let rating = $('.rating').children('.rate-star').length;
      $('#comment_rating').val(rating);
    });
  }
});