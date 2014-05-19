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

    
    if ($(".new-contact").size() == 2) {
      $(".new-contacts").hide()
    }

    if ($(event.target).hasClass("addContact")) {
      
      $(this).remove()

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

      if (confirm("are you sure?")) {

        $(this).remove()

        var url = "/users/"+userId+"/contacts/"+contactId;

        $.ajax({
          url: url,
          type: "DELETE",
          dataType: "json",
          // data: 
        }).done(function(){
        }).fail(function(data) {
        });

      };



    };

  });






});