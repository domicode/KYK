$(document).ready(function(){


  $(".new-contacts-button").click(function(event){
    $(".new-contact-list").toggle();
  });



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

  

  $(".addContact").click(function(event){
    // some Ajax request to do something

    userId = $(".user-information").attr("id");
    contactId = this.id;

    console.log(userId)
    console.log(contactId)

    var url = "/addcontact/"+userId+"/"+contactId;

    $.ajax({
      url: url,
      type: "POST",
      dataType: "script",
      // data: 
    }).done(function(data){
      console.log("success" + data);
    }).fail(function(data) {
      console.log("failure" + data);
    });
  });


  $(".refuseContact").click(function(event){
    // some Ajax request to do something else
  });


});