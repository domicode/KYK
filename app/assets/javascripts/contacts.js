$(document).ready(function(){

  $(".contact").click(function(event){
    if ($(this).height() > 100 ) {
      // $(this).css('height', '100px');
      $(this).addClass("contact")
      $(this).removeClass("contactfullsize")
    } else {
      // $(this).css('height', 'auto');
      $(this).addClass("contactfullsize")
      $(this).removeClass("contact")
    }
  });



});