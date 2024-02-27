using { com.sumanth.nnrg as db } from '../db/schema';
service nnrg {
    entity BusinessPartners as projection on db.BusinessPartners;
    entity Stores as projection on db.Stores;
    entity Products as projection on db.Products;
    entity Stock as projection on db.Stock;
    entity States as projection on db.States;
    entity PurchaseOrders as projection on db.PurchaseOrders;
    entity PurchaseOrderItems as projection on db.PurchaseOrderItems;
    entity SalesOrders as projection on db.SalesOrders;
    entity SalesOrderItems as projection on db.SalesOrderItems;
}
annotate nnrg.BusinessPartners with @odata.draft.enabled;
annotate nnrg.Stores with @odata.draft.enabled;
annotate nnrg.Products with @odata.draft.enabled;
annotate nnrg.States with @odata.draft.enabled;
annotate nnrg.Stock with @odata.draft.enabled;
annotate nnrg.PurchaseOrders with @odata.draft.enabled;
annotate nnrg.PurchaseOrderItems with @odata.draft.enabled;
annotate nnrg.SalesOrders with @odata.draft.enabled;
annotate nnrg.SalesOrderItems with @odata.draft.enabled;

// Validation annotations
annotate nnrg.BusinessPartners with {
    GSTINNumber @assert.format: '^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$';
    PINCode @assert.format: '^[1-9][0-9]{5}$';
    IsGSTNRegistered @(mandatory: true, default: false);
};

annotate nnrg.Products with {
    ImageURL @assert.match: '^https?:\/\/.*\.(?:png|jpg|jpeg)$';
    SellPrice @assert.range: [0,];
};
// Annotations for Business Partners
annotate nnrg.BusinessPartners with @(
    UI.LineItem: [
        { $Type: 'UI.DataField', Value: BPNumber },
        { $Type: 'UI.DataField', Value: Name },
        { $Type: 'UI.DataField', Value: Address1 },
        { $Type: 'UI.DataField', Value: Address2 },
        { $Type: 'UI.DataField', Value: City },
        { Label: 'State', Value: state_Code },
        { Label: 'PINCode', Value: PINCode },
        { $Type: 'UI.DataField', Value: IsGSTNRegistered },
        { $Type: 'UI.DataField', Value: GSTINNumber },
        { $Type: 'UI.DataField', Value: IsVendor },
        { $Type: 'UI.DataField', Value: IsCustomer }
    ],
    UI.SelectionFields: [ Name, City ],
    UI.FieldGroup #BusinessPartnerInformation: {
        $Type: 'UI.FieldGroupType',
        Data: [
            { $Type: 'UI.DataField', Value: BPNumber },
            { $Type: 'UI.DataField', Value: Name },
            { $Type: 'UI.DataField', Value: Address1 },
            { $Type: 'UI.DataField', Value: Address2 },
            { $Type: 'UI.DataField', Value: City },
            { Label: 'State', Value: state_Code },
            { Label: 'PINCode', Value: PINCode },
            { $Type: 'UI.DataField', Value: IsGSTNRegistered },
            { $Type: 'UI.DataField', Value: GSTINNumber },
            { $Type: 'UI.DataField', Value: IsVendor },
            { $Type: 'UI.DataField', Value: IsCustomer }
        ]
    },
    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'BusinessPartnerInfoFacet',
            Label: 'Business Partner Information',
            Target: '@UI.FieldGroup#BusinessPartnerInformation'
        }
    ]
);

// Annotations for States
annotate nnrg.States with @(
    UI.LineItem: [
        {
            Value: Code
        },
        {
            Value: Description
        }
    ],
    UI.FieldGroup #States: {
        $Type: 'UI.FieldGroupType',
        Data: [
            {
                Value: Code,
            },
            {
                Value: Description,
            }
        ],
    },
    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'StatesFacet',
            Label: 'States',
            Target: '@UI.FieldGroup#States',
        },
    ],
);

// Annotations for Store
annotate nnrg.Stores with @(
    UI.LineItem: [
        { $Type: 'UI.DataField', Value: StoreID },
        { $Type: 'UI.DataField', Value: Name },
        { $Type: 'UI.DataField', Value: Address1 },
        { $Type: 'UI.DataField', Value: Address2 },
        { $Type: 'UI.DataField', Value: City },
        { Label: 'State', Value: State.Code },
        { Label: 'PINCode', Value: PINCode }
    ],
    UI.SelectionFields: [ Name, City ],
    UI.FieldGroup #StoreInformation: {
        $Type: 'UI.FieldGroupType',
        Data: [
            { $Type: 'UI.DataField', Value: StoreID },
            { $Type: 'UI.DataField', Value: Name },
            { $Type: 'UI.DataField', Value: Address1 },
            { $Type: 'UI.DataField', Value: Address2 },
            { $Type: 'UI.DataField', Value: City },
            { Label: 'State', Value: State.Code },
            { Label: 'PINCode', Value: PINCode }
        ]
    },
    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'StoreInfoFacet',
            Label: 'Store Information',
            Target: '@UI.FieldGroup#StoreInformation'
        }
    ]
);

// Annotations for Product
annotate nnrg.Products with @(
    UI.LineItem: [
        { $Type: 'UI.DataField', Value: ProductID },
        { $Type: 'UI.DataField', Value: Name },
        { $Type: 'UI.DataField', Value: ImageURL },
        { $Type: 'UI.DataField', Value: CostPrice },
        { $Type: 'UI.DataField', Value: SellPrice }
    ],
    UI.SelectionFields: [ Name ],
    UI.FieldGroup #ProductInformation: {
        $Type: 'UI.FieldGroupType',
        Data: [
            { $Type: 'UI.DataField', Value: ProductID },
            { $Type: 'UI.DataField', Value: Name },
            { $Type: 'UI.DataField', Value: ImageURL },
            { $Type: 'UI.DataField', Value: CostPrice },
            { $Type: 'UI.DataField', Value: SellPrice }
        ]
    },
    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'ProductInfoFacet',
            Label: 'Product Information',
            Target: '@UI.FieldGroup#ProductInformation'
        }
    ]
);

// Annotations for Stock
annotate nnrg.Stock with @(
    UI.LineItem: [
        { $Type: 'UI.DataField', Value: 'Store.StoreID' },
        { $Type: 'UI.DataField', Value: 'Product.ProductID' },
        { Label: 'Stock Quantity', Value: StockQty }
    ],
    UI.FieldGroup #StockInformation: {
        $Type: 'UI.FieldGroupType',
        Data: [
            { $Type: 'UI.DataField', Value: 'Store.StoreID' },
            { $Type: 'UI.DataField', Value: 'Product.ProductID' },
            { Label: 'Stock Quantity', Value: StockQty }
        ]
    },
    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'StockInfoFacet',
            Label: 'Stock Information',
            Target: '@UI.FieldGroup#StockInformation'
        }
    ]
);

annotate nnrg.BusinessPartners with {
    state @(
        Common.ValueListWithFixedValues:true,
        Common.Text: state.Description,
        Common.ValueList: {
            Label :'Genders',
            CollectionPath:'States',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty: state_Code,
                    ValueListProperty:'Code'
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty:'Description'
                }

            ]
        }
    )
}

annotate nnrg.Products with {
@Common.Text : ' {Product}'
@Core.IsURL: true
@Core.MediaType: 'image/jpg'
ImageURL;
};

annotate nnrg.PurchaseOrders with @(
    UI.LineItem: [
        { $Type: 'UI.DataField', Value: BusinessPartner.BPNumber },
        { $Type: 'UI.DataField', Value: PurchaseOrderDate }
    ],
    UI.SelectionFields: [ BusinessPartner.BPNumber ],
    UI.FieldGroup #PurchaseOrderInformation: {
        $Type: 'UI.FieldGroupType',
        Data: [
            { $Type: 'UI.DataField', Value: BusinessPartner.BPNumber },
            { $Type: 'UI.DataField', Value: PurchaseOrderDate }
        ]
    },
    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'PurchaseOrderInfoFacet',
            Label: 'Purchase Order Information',
            Target: '@UI.FieldGroup#PurchaseOrderInformation'
        }
    ]
);

annotate nnrg.PurchaseOrderItems with @(
    UI.LineItem: [
        { $Type: 'UI.DataField', Value: PurchaseOrder.ID },
        { $Type: 'UI.DataField', Value: Product.ProductID },
        { $Type: 'UI.DataField', Value: Quantity },
        { $Type: 'UI.DataField', Value: Price }
    ],
    UI.FieldGroup #PurchaseOrderItemInformation: {
        $Type: 'UI.FieldGroupType',
        Data: [
            { $Type: 'UI.DataField', Value: PurchaseOrder.ID },
            { $Type: 'UI.DataField', Value: Product.ProductID },
            { $Type: 'UI.DataField', Value: Quantity },
            { $Type: 'UI.DataField', Value: Price }
        ]
    },
    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'PurchaseOrderItemInfoFacet',
            Label: 'Purchase Order Item Information',
            Target: '@UI.FieldGroup#PurchaseOrderItemInformation'
        }
    ]
);

annotate nnrg.SalesOrders with @(
    UI.LineItem: [
        { $Type: 'UI.DataField', Value: BusinessPartner_ID },
        { $Type: 'UI.DataField', Value: SalesDate }
    ],
    UI.SelectionFields: [ BusinessPartner_ID ],
    UI.FieldGroup #SalesOrderInformation: {
        $Type: 'UI.FieldGroupType',
        Data: [
            { $Type: 'UI.DataField', Value: BusinessPartner_ID },
            { $Type: 'UI.DataField', Value: SalesDate }
        ]
    },
    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'SalesOrderInfoFacet',
            Label: 'Sales Order Information',
            Target: '@UI.FieldGroup#SalesOrderInformation'
        }
    ]
);

annotate nnrg.SalesOrderItems with @(
    UI.LineItem: [
        { $Type: 'UI.DataField', Value: SalesOrder_ID },
        { $Type: 'UI.DataField', Value: Product_ID },
        { $Type: 'UI.DataField', Value: Quantity },
        { $Type: 'UI.DataField', Value: Price }
    ],
    UI.FieldGroup #SalesOrderItemInformation: {
        $Type: 'UI.FieldGroupType',
        Data: [
            { $Type: 'UI.DataField', Value: SalesOrder_ID },
            { $Type: 'UI.DataField', Value: Product_ID },
            { $Type: 'UI.DataField', Value: Quantity },
            { $Type: 'UI.DataField', Value: Price }
        ]
    },
    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'SalesOrderItemInfoFacet',
            Label: 'Sales Order Item Information',
            Target: '@UI.FieldGroup#SalesOrderItemInformation'
        }
    ]
);
