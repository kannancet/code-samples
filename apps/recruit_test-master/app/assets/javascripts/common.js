AvidTest.Common = {

    /**
     * This function is a generic API call functions.
     * send an ajax request to our rails app with the necessary params
     * Returns callback to the callback function of our context
     */

    callAPI: function(path, params, callback){
	    $.post(window.location.origin + "/" + path , params, callback); 	
    },


    /**
     * Function to initialize common methods .
     * All the common methods are triggered from here
     * 
     */
    initialize: function(){

    }

};

