sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'businesspartners/test/integration/FirstJourney',
		'businesspartners/test/integration/pages/BusinessPartnersList',
		'businesspartners/test/integration/pages/BusinessPartnersObjectPage'
    ],
    function(JourneyRunner, opaJourney, BusinessPartnersList, BusinessPartnersObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('businesspartners') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheBusinessPartnersList: BusinessPartnersList,
					onTheBusinessPartnersObjectPage: BusinessPartnersObjectPage
                }
            },
            opaJourney.run
        );
    }
);