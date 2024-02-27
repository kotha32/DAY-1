const cds = require('@sap/cds');
module.exports = cds.service.impl(function () {
    const { BusinessPartners, States, Products } = this.entities();
    this.before(["CREATE", "UPDATE"], BusinessPartners, async (req) => {
        // const gst = req.data.gst_no;
        // const is_gstn_registered = req.data.is_gstn_registered;
        // if (is_gstn_registered == true && gst == null) {
        //   req.error({
        //     code: "INVALID_GST_NO",
        //     message: "Enter gst registered number please",
        //     target: "is_gstn_registered",
        //   });
        // }
        const results = await cds
        .transaction(req)
        .run(SELECT.from(BusinessPartners));
        const count = results.length;
    
        req.data.BPNumber = count + 1;
    });

});

