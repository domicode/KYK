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

        $.ajax({
            url: event.target.href,
            type: 'GET',
            dataType: 'script'
        });
    });


    $("#clearSearch").click(function(){

        var action = window.location.origin + window.location.pathname;

        $.ajax({
            url: action,
            type: 'GET',
            dataType: 'script'
        });
    });



});