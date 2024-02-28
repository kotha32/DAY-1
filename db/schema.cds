namespace com.sumanth.nnrg;
using { managed, cuid } from '@sap/cds/common';

@title: 'Business Partners'
entity BusinessPartners : cuid, managed {
    @title: 'Business Partner Number'
    BPNumber        : Integer  @Core.Computed;
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
    key ID : UUID;
    @title: 'Store ID' // Updated to use UUID
    StoreID   : String(10);
    @title: 'Name'
    Name      : String;
    @title: 'Address Line 1'
    Address1  : String;
    @title: 'Address Line 2'
    Address2  : String;
    @title: 'City'
    City      : String;
    @title: 'State'
    state     : Association to States;
    @title: 'PIN Code'
    PINCode   : String(6);
}
@title: 'Products'
entity Products : cuid, managed {
    key ID : UUID;
    @title: 'Product ID' // Updated to use UUID
    ProductID    : String(10);
    @title: 'Name'
    ProductName         : String;
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
    key Code : String;
    @title: 'Description'
    Description : String;
}

@title: 'Stock'
entity Stock  {
    key ID : UUID;
    @title: 'Store'
    storeId       : Association to Stores;
    @title: 'Product'
    productId     : Association to Products;
    @title: 'Stock Quantity'
    stock_qty    : Integer;
}

entity PurchaseOrder : cuid, managed {
    @title:'Purchase Order Number'
    purchaseOrderNumber : Integer;
    @title:'Purchase Order Date'
    purchaseOrderDate : Date;
    @title:'Business Partner'
    businessPartner : Association to BusinessPartners;
    @title:'Items'
    items: Composition of many {
        @title:'Product ID'
        product_id : Association to Products;
        @title:'Quantity'
        qty : Integer;
        @title:'Price'
        price : Association to Products;
        @title:'Store ID'
        store_id : Association to Stores;
    };
}