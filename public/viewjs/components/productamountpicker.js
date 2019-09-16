Grocy.Components.ProductAmountPicker = {};
Grocy.Components.ProductAmountPicker.AllowAnyQuEnabled = false;

Grocy.Components.ProductAmountPicker.Reload = function(productId, destinationQuId, forceInitialDisplayQu = false)
{
	if (!Grocy.Components.ProductAmountPicker.AllowAnyQuEnabled)
	{
		var conversionsForProduct = FindAllObjectsInArrayByPropertyValue(Grocy.QuantityUnitConversionsResolved, 'product_id', productId);
		$("#qu_id").find("option").remove().end();
		$("#qu_id").attr("data-destination-qu-name", FindObjectInArrayByPropertyValue(Grocy.QuantityUnits, 'id', destinationQuId).name);
		conversionsForProduct.forEach(conversion =>
		{
			$("#qu_id").append('<option value="' + conversion.to_qu_id + '" data-qu-factor="' + conversion.factor + '">' + conversion.to_qu_name + '</option>');
		});
	}

	if (!Grocy.Components.ProductAmountPicker.InitalValueSet || forceInitialDisplayQu)
	{
		$("#qu_id").val($("#qu_id").attr("data-inital-qu-id"));
	}

	if (!Grocy.Components.ProductAmountPicker.InitalValueSet)
	{
		var convertedAmount = $("#display_amount").val() * $("#qu_id option:selected").attr("data-qu-factor");
		$("#display_amount").val(convertedAmount);

		Grocy.Components.ProductAmountPicker.InitalValueSet = true;
	}

	$(".input-group-productamountpicker").trigger("change");
}

Grocy.Components.ProductAmountPicker.SetQuantityUnit = function()
{
	$("#qu_id").val(quId);
}

Grocy.Components.ProductAmountPicker.AllowAnyQu = function(quId)
{
	Grocy.Components.ProductAmountPicker.AllowAnyQuEnabled = true;
	
	$("#qu_id").find("option").remove().end();
	Grocy.QuantityUnits.forEach(qu =>
	{
		$("#qu_id").append('<option value="' + qu.id + '" data-qu-factor="1">' + qu.name + '</option>');
	});

	$(".input-group-productamountpicker").trigger("change");
}

$(".input-group-productamountpicker").on("change", function()
{
	var destinationQuName = $("#qu_id").attr("data-destination-qu-name");
	var selectedQuName = $("#qu_id option:selected").text();
	var quFactor = $("#qu_id option:selected").attr("data-qu-factor");
	var amount = $("#display_amount").val();
	var destinationAmount = amount / quFactor;

	if (destinationQuName == selectedQuName || Grocy.Components.ProductAmountPicker.AllowAnyQuEnabled)
	{
		$("#qu-conversion-info").addClass("d-none");
	}
	else
	{
		$("#qu-conversion-info").removeClass("d-none");
		$("#qu-conversion-info").text(__t("This equals %1$s %2$s in stock", destinationAmount.toLocaleString(), destinationQuName));
	}

	$("#amount").val(destinationAmount);
});

$("#display_amount").on("keyup", function()
{
	$(".input-group-productamountpicker").trigger("change");
});
