sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'stores/test/integration/FirstJourney',
		'stores/test/integration/pages/StoresList',
		'stores/test/integration/pages/StoresObjectPage'
    ],
    function(JourneyRunner, opaJourney, StoresList, StoresObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('stores') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheStoresList: StoresList,
					onTheStoresObjectPage: StoresObjectPage
                }
            },
            opaJourney.run
        );
    }
);