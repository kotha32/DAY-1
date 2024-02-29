const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {
    const { States, Business_Partner, Stock, Product, PurchaseApp, SalesApp } = this.entities;

    // READ Business_Partner
    this.on("READ", Business_Partner, async (req) => {
        const results = await cds.run(req.query);
        return results;
    });

    // CREATE Business_Partner
    this.before("CREATE", Business_Partner, async (req) => {
        const { Is_gstn_registered, Gst_num } = req.data;
        if (Is_gstn_registered && !Gst_num) {
            req.error({
                code: "MISSING_GST_NUM",
                message: "GSTIN number is mandatory when Is_gstn_registered is true",
                target: "Gst_num",
            });
        }

        const query1 = SELECT.from(Business_Partner).where({ bp_no: req.data.bp_no });
        const result = await cds.run(query1);
        if (result.length > 0) {
            req.error({
                code: "STEMAILEXISTS",
                message: "Business partner already exists",
                target: "bp_no",
            });
        }
    });

    // CREATE Product
    this.before("CREATE", Product, async (req) => {
        const query2 = SELECT.from(Product).where({ product_id: req.data.product_id });
        const result1 = await cds.run(query2);
        if (result1.length > 0) {
            req.error({
                code: "PRODUCTIDEXISTS",
                message: "Product id already exists",
                target: "product_id",
            });
        }

        const { product_cost, product_sell } = req.data;
        if (product_sell <= product_cost) {
            req.error({
                code: "INVALIDSELL",
                message: "Selling price cannot be less than or equal to cost price",
                target: "product_sell",
            });
        }
    });

    // CREATE PurchaseApp
    this.before("CREATE", PurchaseApp, async (req) => {
        const { Items } = req.data;
        const stoc = req.data.storeId_ID;
        for (const item of Items) {
            const product = await cds.read(Product).where({ ID: item.productId_ID });
            const product_cost = product[0].product_cost;
            const price = item.price;
            if (price > product_cost) {
                req.error({
                    code: "INVALID_PRICE",
                    message: "Price for product cannot be more than cost price for product: " + product[0].name,
                    target: "Items",
                });
            }
            const stockEntry = await cds.read(Stock).where({ productId: item.productId_ID });

            if (stockEntry.length > 0) {
            const currentQuantity = stockEntry[0].stock_qty;
            const newQuantity = currentQuantity + item.qty;
          
            // await cds.update(Stock, { ID: stockEntry[0].ID }).with({ stock_qty: newQuantity });
            await cds.run(UPDATE(Stock).set({ stock_qty: newQuantity }).where({ productId: item.productId_ID}).and({storeId:stoc}));
        }
        }
    });

    // CREATE SalesApp
    this.before("CREATE", SalesApp, async (req) => {
        const { Items } = req.data;
        const stoc = req.data.storeId_ID;
        for (const item of Items) {
            const product = await cds.read(Product).where({ ID: item.productId_ID });
            const product_sell = product[0].product_sell;
            const price = item.price;
            if (price < product_sell) {
                req.error({
                    code: "INVALID_PRICE",
                    message: "Price for product cannot be less than sell price for product: " + product[0].name,
                    target: "Items",
                });
            }
            const stockEntry = await cds.read(Stock).where({ productId: item.productId_ID });

            if (stockEntry.length > 0) {
            const currentQuantity = stockEntry[0].stock_qty;
            const newQuantity = item.qty;

            if (newQuantity > currentQuantity) {
                req.error({
                    code: "INSUFFICIENT_STOCK",
                    message: `Insufficient stock for product ${item.productId_ID}. Available quantity: ${currentQuantity}`,
                    target: "Items",
                });
            } else {
            const updatedStockQuantity = currentQuantity - newQuantity;
            // await cds.update(Stock, { ID: stockEntry[0].ID }).with({ stock_qty: newQuantity });
            await cds.run(UPDATE(Stock).set({ stock_qty: updatedStockQuantity }).where({ productId: item.productId_ID}).and({storeId:stoc}));
        }
    }
}
    });

    // READ States
    this.on('READ', States, async (req) => {
        const stat = [
            { "code": "TS", "description": "Telangana" },
            { "code": "AY", "description": "Ayodha" },
            { "code": "DL", "description": "Delhi" },
        ];
        stat.$count = stat.length;
        return stat;
    });

    // CREATE/UPDATE Business_Partner
    this.before(["CREATE", "UPDATE"], Business_Partner, async (req) => {
        const results = await cds.transaction(req).run(SELECT.from(Business_Partner));
        const count = results.length;
        req.data.bp_no = count + 1;
    });
});