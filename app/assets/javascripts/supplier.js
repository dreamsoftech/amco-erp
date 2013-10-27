$(function(){
	$('.add-location').on('click', function(){
    var template = $("#template").clone();
    var add_button = template.find(".add-location");
    // change add button to remove button
    add_button.removeClass("add-location");
    add_button.addClass("remove-location");
    add_button.html("<i class='icon-minus'></i>");

    // clear template info
    template.attr("id", "");
    template.find("label").html("");

    template.appendTo("#locations").fadeIn("slow");
  });

  $(".edit-location").on('click', '.remove-location', function(){
  	$(this).parent().parent().parent().remove(); //a->span->div->div.form-control remove
  });

  $("#locations").on("ajax:success", function(e, data, status, xhr){
  	console.log(data);
    $("#location-" + data.id).remove();
  });


});