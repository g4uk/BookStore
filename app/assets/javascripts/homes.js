$(function() {
  loader = $('#loading-indicator');
  $(document)  
    .ajaxStart(function() {
      loader.show();
    })
    .ajaxStop(function() {
      loader.hide();
  });
});