$(function(){
	$("#btn_add_item").on("click", function(){
		if (!$("#new_purchase_order").valid()) return false;

		var total = parseInt($("#quantity").val()) * parseInt($("span#product_price").text());
		var budget = parseInt($("#left_budget").text());
		var lot_index = parseInt($("select#lots").val());
		var product_index = parseInt($("select#products").val());
		

		if (!total || !budget || total > budget)
		{
			$.msgGrowl ({
				type: "warning"
				, title: 'Warning'
				, text: 'Total price must be less than left budget'
			});
			return false;
		}
		else // valid
		{
			// calculate the left buget
			lot_budgets[lot_index] -= total;
			$("#left_budget").text(lot_budgets[lot_index]);
		}


		var template = $("#template_line_item").clone();

		template.find("#lot_name > span").text($("#lots option:selected").text());
		template.find("#lot_name > input").val($("#lots").val());
		template.find("#lot_name > input").attr("id", lot_index);
		template.find("#lot_name > input").attr("name", "lot_ids[]");

		template.find("#product_name > span").text($("#products option:selected").text());
		template.find("#product_name > input").val($("#products").val());
		template.find("#product_name > input").attr("id", product_index); // put the product index into input id field
		template.find("#product_name > input").attr("name", "product_ids[]");
		
		template.find("#order_amount").text(total);
		
		template.find("#product_quantity > span").html($("#quantity").val());
		template.find("#product_quantity > input").val($("#quantity").val());
		template.find("#product_quantity > input").attr("name", "quantities[]");

		template.find("#location_name > span").text($("#locations option:selected").text());
		template.find("#location_name > input").val($("#select#locations").val());
		template.find("#location_name > input").attr("id", $("#locations").val()); // put the location index into input id field
		template.find("#location_name > input").attr("name", "location_ids[]");

		template.removeClass("hidden");
		$("#order_line_list tbody").append(template);
	});

	$("#order_line_list").on("click", "a.remove", function(){
		var line_item = $(this).parent().parent();

		var lot_index 		= parseInt(line_item.find("#lot_name input").attr("id"));
		var product_index = parseInt(line_item.find("#product_name input").attr("id"));
		var quantity 			= parseInt(line_item.find("#product_quantity input").val());
		
		lot_budgets[lot_index] += product_prices[product_index] * quantity;
		$("#left_budget").text(lot_budgets[lot_index]);

		line_item.remove();
	});
	
});