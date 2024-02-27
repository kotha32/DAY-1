namespace com.sumanth.nnrg;
using { managed, cuid } from '@sap/cds/common';

@title: 'Business Partners'
entity BusinessPartners : cuid, managed {
    @title: 'Business Partner Number'
    BPNumber        : Integer;
    @title: 'Name'
    Name            : String(20);
    @title: 'Address Line 1'
    Address1        : String(20);
    @title: 'Address Line 2'
    Address2        : String(20);
    @title: 'City'
    City            : String(20);
    @title: 'State'
    state : Association to States;
    @title: 'PIN Code'
    PINCode         : String(6);
    @title: 'GSTN Registered?'
    IsGSTNRegistered: Boolean;
    @title: 'GSTIN Number'
    GSTINNumber     : String(50);
    @title: 'Is Vendor?'
    IsVendor        : Boolean default false;
    @title: 'Is Customer?'
    IsCustomer      : Boolean default false;
}

@title: 'Stores'
entity Stores : cuid, managed {
    @title: 'Store ID' // Updated to use UUID
    StoreID   : UUID;
    @title: 'Name'
    Name      : String;
    @title: 'Address Line 1'
    Address1  : String;
    @title: 'Address Line 2'
    Address2  : String;
    @title: 'City'
    City      : String;
    @title: 'State'
    State     : Association to States;
    @title: 'PIN Code'
    PINCode   : String(6);
}

@title: 'Products'
entity Products : cuid, managed {
    @title: 'Product ID' // Updated to use UUID
    ProductID    : UUID;
    @title: 'Name'
    Name         : String;
    @title: 'Image URL'
    ImageURL     : String;
    @title: 'Cost Price'
    CostPrice    : Decimal(15,2);
    @title: 'Sell Price'
    SellPrice    : Decimal(15,2);
}

@title: 'States'
entity States  {
    @title: 'Code'
    key Code        : String;
    @title: 'Description'
    Description : String;
}

@title: 'Stock'
entity Stock : cuid, managed {
    @title: 'Store'
    Store       : Association to Stores;
    @title: 'Product'
    Product     : Association to Products;
    @title: 'Stock Quantity'
    StockQty    : Integer;
}

@title: 'Purchase Orders'
entity PurchaseOrders : cuid, managed {
    BusinessPartner : Association to BusinessPartners;
    PurchaseOrderDate : Date;
    Items : Composition of many PurchaseOrderItems on Items.PurchaseOrder = $self;
}

@title: 'Purchase Order Items'
entity PurchaseOrderItems : cuid {
    PurchaseOrder : Association to PurchaseOrders;
    Product : Association to Products;
    Quantity : Integer;
    Price : Decimal(15,2);
}

@title: 'Sales Orders'
entity SalesOrders : cuid, managed {
    BusinessPartner : Association to BusinessPartners;
    SalesDate : Date;
    Items : Composition of many SalesOrderItems on Items.SalesOrder = $self;
}

@title: 'Sales Order Items'
entity SalesOrderItems : cuid {
    SalesOrder : Association to SalesOrders;
    Product : Association to Products;
    Quantity : Integer;
    Price : Decimal(15,2);
}
