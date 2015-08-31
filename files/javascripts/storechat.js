var StoreChat = {

    initialize: function() {
        try {
        	
        	StoreChat.Home.initialize();
        	StoreChat.Place.initialize();
            StoreChat.User.initialize();
        	StoreChat.Authentication.initialize();
            StoreChat.Common.initialize();
            StoreChat.Dashboard.initialize();
            StoreChat.Offer.initialize();
            StoreChat.Recommendation.initialize();
            StoreChat.Analytics.initialize();
        } catch(e) {
            console.log(e);
        }
    }

};