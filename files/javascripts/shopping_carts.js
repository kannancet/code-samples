$(document).ready(function(){

/*==================================
Feature : Function to update cart view
Page : http://firstnational.plainandsimpleapp.com/shopping_carts/23
Element :  Triggered from Udpate Cart and Trash icon click on cart view.
====================================*/
	function updateCartView(response){
	    $("#cart_product_table").html(response.cart_table);
	    $("#shopping_cart").html(response.cart_dropdown);

	    $(".cart_gross_amount").text("$"+response.cart_gross_amount);
	    $(".cart_tax_amount").text("$"+response.cart_tax_amount);
	    $(".cart_net_amount").text("$"+response.cart_net_amount);
	    $(".total-tax-ecl").text("$"+response.cart_gross_amount);

	    $("input[name='quanitySniper']").TouchSpin({
	        buttondown_class: "btn btn-link",
	        buttonup_class: "btn btn-link"
	    });

	}


/*==================================
Feature : Delete single item from cart list
Page : http://firstnational.plainandsimpleapp.com/shopping_carts/23
Element :  Trash Icon.
====================================*/
	function removeProductFromCartPage(){

		$(document).on('click', ".remove_from_cart_page", function(){

		  data = {shopping_cart_id: $(this).attr("data-cart-product-id")}
	      $.ajax({url: '/shopping_carts/remove_from_cart_page' ,
	              method: 'POST',
	              data: data,
	              success: function(response){

	              	updateCartView(response);
	              	$.notify("Product removed from cart.", "success");
	              },
	              error: function(response){
	                 console.log(response);
	       		  }
    	  });
		})
	}


/*==================================
Feature : Udpate total price for single item on + button click for quantity.
Page : http://firstnational.plainandsimpleapp.com/shopping_carts/23
Element : + icon near text field of quantity.
====================================*/
	function updateCartItemPrice(){

		$(document).on('change', ".product_cart_quantity", function(){
			minimum_qty = $(this).attr("data-minimum-quantity");
			maximum_qty = $(this).attr("data-maximum-quantity");
			product_quantity = $(this).val();
			product_id = $(this).attr("data-product-cart-id");
			product_price = $(this).attr("data-product-cart-price");
			new_total = "$" + (parseFloat(parseFloat(product_price) * parseInt(product_quantity)).toFixed(2));

			if(parseInt(product_quantity) > maximum_qty){
			  $.notify(("Maximum " + maximum_qty + " products only avaliable."), "success");
			  $(this).val(maximum_qty);
			  return false
			}

			if(parseInt(product_quantity) < minimum_qty){
			  $.notify(("Minimum " + minimum_qty + " product needed for checkout."), "success");
			  $(this).val(minimum_qty);
			  return false
			}

			$("#single_cart_item_total_" + product_id).text(new_total);
			
		});
	}


/*==================================
Feature : Submit cart to server via AJAX
Page : http://firstnational.plainandsimpleapp.com/shopping_carts/23
Element :  Triggered from update_cart
====================================*/
	function submitCartForUpdation(cart_updations){

	      $.ajax({url: '/shopping_carts/bulk_update_product_cart' ,
	              method: 'POST',
	              data: {product_carts: cart_updations},
	              success: function(response){

	                 updateCartView(response);

		  			$("#update_customer_cart").removeClass().addClass("btn btn-primary");
		  			$("#update_customer_cart").html("<i class='fa fa-undo'></i> &nbsp; Update cart");

	                 $.notify("Updated cart successfully.", "success");
	              },
	              error: function(response){
	                 console.log(response);
	       		  }
    	  });		
	}

/*==================================
Feature : Udpate Cart Feature
Page : http://firstnational.plainandsimpleapp.com/shopping_carts/23
Element :  Udate Cart button.
====================================*/
	function update_cart(){

		$(document).on("click", "#update_customer_cart", function(){

		  $(this).removeClass().addClass("btn btn-danger");
		  $(this).html("<i class='fa fa-undo'></i> &nbsp; Updating .....")

			cart_updations = [];
			$.each($(".product_cart_quantity"), function(idx, ele){

				product_cart_id = $(ele).attr("data-product-cart-id");
				product_quantity = $(ele).val();

				cart_updations.push({id: product_cart_id, product_quantity: product_quantity})
			});

			submitCartForUpdation(cart_updations);
			
			return false
		});
	}

/*==================================
Feature : Submitting the order
Page : http://firstnational.plainandsimpleapp.com/shopping_carts/checkout
Element :  Order Button.
====================================*/
	function submitSOComment(){
		$(".sumit_po_comment").on('click', function(){

			//Check if T and C agreed
		 	checked = $("#tandc_area #icr-2").hasClass("checked");
		 	if(checked == false){
		 		$.notify("Please agree to T&C checkbox.", "error");
		 		return false
		 	}	

		 	//Check if comment added
		 	comments = $("#CommentsOrder").val();
		 	if(comments == ""){
		 		$.notify("Please fill in comments.", "error");
		 		return false		 		
		 	}

			//Check if T and C agreed
		 	checked1 = $("#order_pickup #icr-1").hasClass("checked");
		 	if(checked1 == true){
		 		comments = comments + ".\n\nOrder for Pick up : YES" ;
		 	}	


		 	$(".sumit_po_comment").removeClass().addClass("btn btn-danger sumit_po_comment");
		 	$(".sumit_po_comment").text("Ordering ...");
		 	
		 	//Proceed to comment submission
		      $.ajax({url: '/shopping_carts/submit_po_comment' ,
		              method: 'POST',
		              data: {comment: comments},
		              success: function(response){
		              	
		              	 shopping_url = $("#back_to_shopping").attr("href");
		              	 $("#shopping_cart").html(response.html);
		              	 $("#submit_po_box").html("<h4>Your order was placed successfully!</h4><p><a href='" + shopping_url + "' class='btn btn-primary'> Return to Home &nbsp; <i class='fa fa-arrow-circle-right'></i> </a></p>");
		                 $.notify(response.msg, response.type);
		              },
		              error: function(response){
		                 console.log(response);
		       		  }
	    	  });			 	

		})

	}

/*==================================
Feature : Submitting the Credit Card
Page : http://firstnational.plainandsimpleapp.com/shopping_carts/checkout
Element :  Order Button.
====================================*/
	function submitCreditCard(){
		$("#credit_card_form").on('submit', function(){

			card_number = $("#credit_card_form #CardNumber").val()
			if(card_number != parseInt(card_number, 10) ){
				$.notify("Card number needs to be integer", "error");
				return false
			}

			verify_code = $("#credit_card_form #VerificationCode").val()
			if(verify_code != parseInt(verify_code, 10) ){
				$.notify("Verification Code needs to be integer", "error");
				return false
			}		

		    status = confirm("I hereby confirm my Credit Card information");
		    if(status == false){
		       return false;
		    }

			$("#credit_card_form .payment_btn").removeClass().addClass("btn btn-danger btn-small payment_btn");
			$("#credit_card_form .payment_btn").html("Processing Payment... &nbsp;<i class='fa fa-arrow-circle-right'></i>");
			shopping_url = $("#back_to_shopping").attr("href");

		 	//Make Payment
		      $.ajax({url: '/shopping_carts/make_payment' ,
		              method: 'POST',
		              data: $('#credit_card_form').serialize(),
		              success: function(response){
		              	 $("#credit_card_form").html("<h4>Your order was placed sucessfully. Your transaction ID is <strong>#" + response.receipt_id + " </strong>.</h4><p><a href='" + shopping_url + "' class='btn btn-primary'> Return to Home &nbsp; <i class='fa fa-arrow-circle-right'></i> </a></p>");
		              	 
		              	 $("#shopping_cart").html(response.html);
		                 $.notify(response.msg,response.type);
		              },
		              error: function(response){
		                 console.log(response);
		       		  }
	    	  });			 	

		    return false
		})

	}
/*==================================
Feature : All features related to cart show page
Page : http://firstnational.plainandsimpleapp.com/shopping_carts/23
Element :  Program start here.
====================================*/
	removeProductFromCartPage();

	updateCartItemPrice();

	update_cart();

	submitSOComment();

	submitCreditCard();
})


