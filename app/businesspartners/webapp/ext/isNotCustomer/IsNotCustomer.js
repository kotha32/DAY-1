sap.ui.define([
    "sap/m/MessageToast"
], function(MessageToast) {
    'use strict';

    return {
        IsNotCustomer: function(oBindingContext, aSelectedContexts) {
            aSelectedContexts.forEach(element => {
                var aData = jQuery.ajax({
                    type: "PATCH",
                    contentType: "application/json",
                    url: "/odata/v4/nnrg" + element.sPath,
                    data: JSON.stringify({IsCustomer: false})
                }).then(element.requestRefresh());
            });
        }
    };
});
