// initialize AvidTest namespace in javascript.
$(document).ready(function(){
	if (!window.AvidTest || typeof window.AvidTest !== 'object') {
        window.AvidTest = {};
    }

	AvidTest.initialize();
});


