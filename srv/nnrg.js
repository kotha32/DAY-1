const cds = require('@sap/cds');
module.exports = cds.service.impl(function () {
    const { BusinessPartners, States, Products } = this.entities();
    this.before(["CREATE"], BusinessPartners, async (req) => {
        const results = await cds
        .transaction(req)
        .run(SELECT.from(BusinessPartners));
        const count = results.length;
    
        req.data.BPNumber = count + 1;
    });

    // Adjusted entity names according to the new schema

    this.on("READ", BusinessPartners, async (req) => {
        const results = await cds.run(req.query);
        return results;
    });

    this.before("CREATE", BusinessPartners, async (req) => {
        // Adjusted field names according to the new schema
        const { BPNumber, IsGSTNRegistered, GSTINNumber } = req.data;
        if (IsGSTNRegistered && !GSTINNumber) {
            req.error({
                code: "MISSING_GST_NUM",
                message: "GSTIN number is mandatory when IsGSTNRegistered is true",
                target: "GSTINNumber",
            });
        }

        // Query to check if the BPNumber already exists
        const query = SELECT.from(BusinessPartners).where({ BPNumber: req.data.BPNumber });
        const result = await cds.run(query);
        if (result.length > 0) {
            req.error({
                code: "BPNUMBER_EXISTS",
                message: "Business Partner number already exists",
                target: "BPNumber",
            });
        }
    });

    this.before(["CREATE"], Products, async (req) => {
        // Adjusted field names according to the new schema
        const { CostPrice, SellPrice } = req.data;
        if (SellPrice < CostPrice) {
            req.error({
                code: "INVALID_SELLING_PRICE",
                message: "Selling price should not be less than Cost Price",
                target: "SellPrice",
            });
        }
    });

    // Commented out custom handling for States as it seems you might want static data
    // Uncomment and adjust if needed
    // this.on('READ', States, async (req) => {
    //     const states = [
    //         { "code": "TS", "description": "Telangana" },
    //         { "code": "AY", "description": "Ayodha" },
    //         { "code": "DL", "description": "Delhi" },
    //     ];
    //     states.$count = states.length;
    //     return states;
    // });
});
