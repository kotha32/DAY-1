// const cds = require('@sap/cds');

// module.exports = cds.service.impl(async function () {
//     const { States, BusinessPartners } = this.entities;

//     this.on("READ", BusinessPartners, async (req) => {
//         const results = await cds.run(req.query);
//         return results;
//     });

//     this.before("CREATE", BusinessPartners, async (req) => {
//         const { BPNumber, IsGSTNRegistered, GSTINNumber } = req.data;
//         if (IsGSTNRegistered && !GSTINNumber) {
//             req.error({
//                 code: "MISSING_GST_NUM",
//                 message: "GSTIN number is mandatory when IsGSTNRegistered is true",
//                 target: "GSTINNumber",
//             });
//         }

//         const query1 = SELECT.from(BusinessPartners).where({ BPNumber: BPNumber });
//         const result = await cds.run(query1); // Execute the query using cds.run()
//         if (result.length > 0) {
//             req.error({
//                 code: "BPNUMBEREXISTS",
//                 message: "Business Partner with this BPNumber already exists",
//                 target: "BPNumber",
//             });
//         }
//     });

// });
