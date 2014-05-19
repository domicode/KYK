$(document).ready(function(){


  // Function to show contacts in full size and small size with a css trigger
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



  $(".new-contacts-button").click(function(event){
    $(".new-contact-list").toggle();
  });

  

  $(".new-contact").click(function(event){
    // some Ajax request to do something

    userId = $(".user-information").attr("id");
    contactId = this.id;

    $(this).remove()

    if ($(".new-contact").size() == 1) {
      $(".new-contacts").hide()
    }

    if ($(event.target).hasClass("addContact")) {
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
    }

    if ($(event.target).hasClass("refuseContact")) {
      // some Ajax request to do something else
      alert("contact was refused")
      var url = "/users/"+userId+"/contacts/"+contactId;

      // something to fix, deletes the whole user for now:
      // $.ajax({
      //   url: url,
      //   type: "DELETE",
      //   // dataType: "script",
      //   // data: 
      // }).done(function(data){
      //   console.log("success" + data);
      // }).fail(function(data) {
      //   console.log("failure" + data);
      // });

    };

  });






});