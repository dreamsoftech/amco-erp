$(function()
{
	$.mask.definitions['~']='[+-]';
  $('.input-phone').mask('(999) 999-9999')

  $('.date-picker').datepicker({ format: 'yyyy-mm-dd' });

  $('.tooltip').on("click", function(){
  	console.log("hey");
  	$(this).tooltip('show');
  });

  $('.tooltip').on("mouseout", function(){
  	$(this).tooltip('hide');
  });
})