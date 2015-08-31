// initialize Controller level javascript functions.
var AvidTest = {

    initialize: function() {
        try {
        	
        	AvidTest.Common.initialize();
            AvidTest.User.initialize();
            AvidTest.Message.initialize();
            AvidTest.Subscription.initialize();
            
        } catch(e) {
            console.log(e);
        }
    }

};