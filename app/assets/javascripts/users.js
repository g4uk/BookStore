$(document).on('turbolinks:load', function() {
  $('.checkbox-delete-user').change(function() {
    var removeButton = $('.delete-user');
    removeButton.toggleClass('disabled');
    removeButton.toggleClass('btn-default');
  });
});

