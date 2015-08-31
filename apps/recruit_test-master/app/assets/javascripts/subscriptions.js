AvidTest.Subscription = {

    /**
     * This function is a generic API call functions.
     * send an ajax request to our rails app with the necessary params
     * Returns callback to the callback function of our context
     */
    currencyConverter: function(){
	    $("#payment_form #user_currency").on('change', function(){

	    	target_currency = $(this).val();
	    	target_plan = $("#payment_form #target_plan").val();
	    	currency_params = {currency_params: {target_currency: target_currency, 
                                                 target_plan: target_plan
                                                }
                            }
            
            AvidTest.Common.callAPI("api/subscriptions/convert_currency.json", currency_params ,  function(response){
            	
                console.log(response.currency.amount)
            	$("#plan_price").text(response.currency.amount);
            });
	    }) 	
    },

    /**
     * This function is a used to make payment.
     * send an ajax request with stripe params
     * 
     */
    makePayment: function(){
      var handler = StripeCheckout.configure({
        key: 'pk_test_bQKadVSr1pM6WE8dmyAz9XZ6',
        image: 'http://www.avidlifemedia.com/img/avidlogo.png',
        token: function(token) {
            amt = parseFloat($("#plan_price").text())*100;
            desc = 'Avid Life Payment';
            currency = $("#user_currency").val();
            plan = $("#payment_form #stripe_plan").val();
            target_plan = $("#payment_form #target_plan").val();
            stripe_params = {stripe_params: {token: token.id, 
				            	             amount: amt, 
				            	             email: token.email, 
				            	             desc: desc, 
				            	             currency: currency,
				            	             stripe_plan: plan,
				            	             card: token.card.id,
				            	             target_plan: target_plan
				            	            }
            	            }

            $.notify("Successfully verified your card", "success");
            $("#make_payment").val("Processing Payment ....");
            $("#make_payment").removeClass("btn-success").addClass("btn-danger");

            AvidTest.Common.callAPI("api/subscriptions/create.json", stripe_params ,  function(response){
            	$.notify(response.flash.message, response.flash.result);
            	$("#payment_form").slideUp();
            	window.location = "/plans";
            });
          
        }
      });

      $('#make_payment').on('click', function(e) {
        // Open Checkout with further options
        handler.open({
          name: 'Avid Life Payment',
          email: $("#user_email").val(),
          amount: parseFloat($("#plan_price").text())*100,
          currency: $("#user_currency").val()
        });
        e.preventDefault();
        return false
      });

      // Close Checkout on page navigation
      $(window).on('popstate', function() {
        handler.close();
      });
    },

    /**
     * Function to initialize common methods .
     * All the common methods are triggered from here
     * 
     */
    initialize: function(){
    	AvidTest.Subscription.currencyConverter();
      AvidTest.Subscription.makePayment();
    }

};

