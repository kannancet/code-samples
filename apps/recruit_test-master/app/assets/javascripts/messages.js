AvidTest.Message = {

    /**
     * Function to add users
     * send an ajax request to our rails app with user params
     */
    addMessage: function() { 
        $('#add_message_form').on('submit', function() {

            form_params = {message: $(this).serializeObject()};
            $('#add_message_form #submit_message').val("Adding ...");

            AvidTest.Common.callAPI("api/messages.json", form_params ,  function(response){
            	console.log(response);
                $.notify("Successfully created message", "success");
            	$('#add_message_form #submit_message').val("Add");              
                new_message = '<p><a href="#" data-messageid=' + response.message.id + ' class="single_message"> ' + response.message.id +'. ' + response.message.subject +'</a></p>';
                hidden = '<input type="hidden" name="message_body_'+ response.message.id +'" id="message_body_'+ response.message.id +'" value='+response.message.body+'>';
                $("#message_list").append(new_message+hidden);
            })

            return false
        })
    },  

    /**
     * Function to view message body
     * Takes message body from hidden field to sho on right.
     */
    clickMessage: function() { 
        $(document).on('click', '.single_message', function() {

        	id = $(this).data("messageid")
        	body = $("#message_body_"+id).val()
            $("#message_box").fadeIn();
        	$("#message_show").text(body);
            $("#message_show").fadeIn();
            return false
        })
    },

    /**
     * Function to open and close message form
     * Click to open and close to close.
     */
    openCloseCreateMsg: function() { 
        $('.create_message_btn').on('click', function() {
        	$("#add_message_form").slideDown();
        	return false;
        });

        $('#close_message').on('click', function() {
        	$("#add_message_form").slideUp();
        	return false;
        });
    }, 

    /**
     * Function to initualize users javascript methods
     * This is the starting point for all user methods.
     */
     initialize: function(){
        AvidTest.Message.addMessage();
        AvidTest.Message.clickMessage();
        AvidTest.Message.openCloseCreateMsg();
     } 

};
