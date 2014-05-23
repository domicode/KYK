$(document).ready(function(){

    $('#tag-search-form :submit').click(function(){
        
        event.preventDefault();
        var action = window.location.origin + window.location.pathname;

        $.ajax({

            url: action +'?search_tags='+ $('#search_tags').val(),
            type: 'GET',
            dataType: 'script'

        });
        
    });


    $("#tag_cloud").click(function(event){

        event.preventDefault();
        $(this).children().css({backgroundColor: 'none'})
        $(event.target).css({backgroundColor: 'black'})

        $.ajax({
            url: event.target.href,
            type: 'GET',
            dataType: 'script'
        });
    });

    $("#tag_cloud_push").click(function(event){

        event.preventDefault();
        $(this).children().css({backgroundColor: 'none'})
        $(event.target).css({backgroundColor: 'black'})

        $.ajax({
            url: event.target.href,
            type: 'GET',
            dataType: 'script'
        });
    });


    $("#clearSearch").click(function(){

        event.preventDefault();
        $("#tag_cloud").children().css({backgroundColor: 'none'})
        $("#search_tags").val("")
        
        var action = window.location.origin + window.location.pathname;

        $.ajax({
            url: action,
            type: 'GET',
            dataType: 'script'
        });
    });

  //$("#map").hide(); // there is a bug, don't uncomment! :P  

  $("#map-trigger").click(function(event){
    $("#map").toggle();
  });

  $(".search-type").click(function(event){
    $(".tag-search").toggle();
    $(".name-search").toggle();
  });


});