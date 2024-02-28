using { com.sumanth.nnrg as db } from '../db/schema';
service nnrg {
    entity BusinessPartners as projection on db.BusinessPartners;
    entity Stores as projection on db.Stores{
        @UI.Hidden:true
        ID,
        *
    };
    entity Products as projection on db.Products{
        @UI.Hidden:true
        ID,
        *
    };
    entity Stock as projection on db.Stock{
        @UI.Hidden:true
        ID,
        *
    };
    entity States as projection on db.States;
    entity PurchaseOrder as projection on db.PurchaseOrder;
}

annotate nnrg.BusinessPartners with @odata.draft.enabled;
annotate nnrg.Stores with @odata.draft.enabled;
annotate nnrg.Products with @odata.draft.enabled;
annotate nnrg.States with @odata.draft.enabled;
annotate nnrg.Stock with @odata.draft.enabled;
annotate nnrg.PurchaseOrder with @odata.draft.enabled;

// Validation annotations
annotate nnrg.BusinessPartners with {
    GSTINNumber @assert.format: '^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$';
    PINCode @assert.format: '^[1-9][0-9]{5}$';
    //IsGSTNRegistered @(mandatory: true, default: false);
};

annotate nnrg.Products with {
    ImageURL @assert.match: '^https?:\/\/.*\.(?:png|jpg|jpeg)$';
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
        { Label: 'State', Value: state_Code },
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
            { Label: 'State', Value: state_Code },
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
        { $Type: 'UI.DataField', Value: ProductName },
        { $Type: 'UI.DataField', Value: ImageURL },
        { $Type: 'UI.DataField', Value: CostPrice },
        { $Type: 'UI.DataField', Value: SellPrice }
    ],
    UI.SelectionFields: [ ProductName ],
    UI.FieldGroup #ProductInformation: {
        $Type: 'UI.FieldGroupType',
        Data: [
            { $Type: 'UI.DataField', Value: ProductID },
            { $Type: 'UI.DataField', Value: ProductName },
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

annotate nnrg.Stores with {
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

annotate nnrg.Stock with @(
    UI.LineItem: [
        {
            Label: 'Store ID',
            Value: storeId_ID // Adjusted for association
        },
        {
            Label: 'Product ID',
            Value: productId_ID // Adjusted for association
        },
        {
            Label: 'Stock Quantity',
            Value: stock_qty
        }
    ],
    UI.FieldGroup #Stock: {
        $Type: 'UI.FieldGroupType',
        Data: [
            {
                Label: 'Store ID',
                Value: storeId_ID // Adjusted for association
            },
            {
                Label: 'Product ID',
                Value: productId_ID // Adjusted for association
            },
            {
                Label: 'Stock Quantity',
                Value: stock_qty
            }
        ]
    },
    UI.Facets: [{
        $Type: 'UI.ReferenceFacet',
        ID: 'StockFacet',
        Label: 'Stock',
        Target: '@UI.FieldGroup#Stock'
    }]
);

annotate nnrg.Stock with {
    Store @(
        Common.ValueListWithFixedValues:true,
        Common.Text: Store.Name,
        Common.ValueList: {
            Label :'Stores',
            CollectionPath:'Stores',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty: Store.ID,
                    ValueListProperty:'StoreID'
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty:'Name'
                }
            ]
        }
    )
}

annotate nnrg.Stock with {
    storeId   @(
        Common.Text: storeId.StoreID,
        Common.TextArrangement: #TextOnly,
        Common.ValueListWithFixedValues: true,
        Common.ValueList               : {
            Label         : 'Store id',
            CollectionPath: 'Stores',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: storeId_ID,
                    ValueListProperty: 'ID'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'Name'
                },

            ]
        }
    );
    productId @(
        Common.Text: productId.ProductID,
        Common.TextArrangement: #TextOnly,
        Common.ValueListWithFixedValues: true,
        Common.ValueList               : {
            Label         : 'Product id',
            CollectionPath: 'Products',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: productId_ID,
                    ValueListProperty: 'ID'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'ProductName'
                },

            ]
        }
    );
}


annotate nnrg.PurchaseOrder.items with @(
    UI.LineItem: [
        {
            Value: product_id_ID,
        },
        {
            Value: qty,
        },
        {
            Value: price_ID,
        },
        {
            Value: store_id_ID,
        },
    ],
    UI.FieldGroup #PurchaseOrderItem: {
        $Type: 'UI.FieldGroupType',
        Data: [
                {
                $Type: 'UI.DataField',
                Value: product_id_ID,
                },
                {
                $Type: 'UI.DataField',
                Value: qty,
                },
            {
                $Type: 'UI.DataField',
                Value: price_ID,
                },
                {
                $Type: 'UI.DataField',
                Value: store_id_ID,
                },

        ]
    },
    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'PurchaseOrderItemFacet',
            Label: 'Purchase Order item',
            Target: '@UI.FieldGroup#PurchaseOrderItem'
        },
    ]
);

annotate nnrg.PurchaseOrder with @(
    UI.LineItem: [
            {
            $Type: 'UI.DataField',
            Value: purchaseOrderNumber
            },
            {
            $Type: 'UI.DataField',
            Value: businessPartner_ID
            },
            {
            $Type: 'UI.DataField',
            Value: purchaseOrderDate
            }
    ],
    UI.FieldGroup #PurchaseOrderHeader: {
        $Type: 'UI.FieldGroupType',
        Data: [
                {
                $Type: 'UI.DataField',
                Value: purchaseOrderNumber
                },
                {
                $Type: 'UI.DataField',
                Value: businessPartner_ID
                },
                {
                $Type: 'UI.DataField',
                Value: purchaseOrderDate
                }
        ]
    },
    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'PurchaseOrderHeaderFacet',
            Label: 'Purchase Order Header',
            Target: '@UI.FieldGroup#PurchaseOrderHeader'
        },
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'PurchaseOrderItems',
            Label: 'Purchase Order Items',
            Target: 'items/@UI.LineItem',
        },
    ]
);

annotate nnrg.PurchaseOrder.items with {
    product_id @(
        Common.ValueListWithFixedValues: true,
        Common.ValueList: {
            Label: 'Product List',
            CollectionPath: 'Products',
            Parameters: [
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: product_id_ID,
                    ValueListProperty: 'ID'
                },
                {
                    $Type: 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'ProductName'
                },
                
                    ]
        }
                );
        store_id @(
        Common.ValueListWithFixedValues: true,
        Common.ValueList: {
            Label: 'Store List',
            CollectionPath: 'Stores',
            Parameters: [
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: store_id_ID,
                    ValueListProperty: 'ID'
                },
                {
                    $Type: 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'Name'
                },
            ]
        }
    );
    price @(
        Common.ValueListWithFixedValues: true,
        Common.ValueList: {
            Label: 'Price List',
            CollectionPath: 'Products',
            Parameters: [
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: price_ID,
                    ValueListProperty: 'ID'
                },
                {
                    $Type: 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'ProductName'
                },
                {
                    $Type: 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'SellPrice'
                },
            ]
        }
    );
};

annotate nnrg.PurchaseOrder with {
    businessPartner@(
        Common.Text: businessPartner.Name,
        Common.TextArrangement: #TextOnly,
        Common.ValueListWithFixedValues: true,
        Common.ValueList               : {
            Label         : 'businessPartner',
            CollectionPath: 'BusinessPartners',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: businessPartner_ID,
                    ValueListProperty: 'ID'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'Name'
                },

            ]
        }
    );
};


