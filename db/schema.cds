namespace com.sumanth.nnrg;
using { managed, cuid } from '@sap/cds/common';
@assert.unique:{
    bp_no:[bp_no]
}
entity Business_Partner {
    key ID: UUID;
    bp_no:Integer default 0 @Core.Computed;
    @title:'Name'
    name:String(20);
    @title:'Address 1'
    add1:String(20);
    @title:'Address 2'
    add2:String(20);
    @title:'City'
    city:String(20);
    @title:'State'
    state:Association to States;
    @title:'pin code'
    pinCode:String(10);
    @title:'Is_gstn_registered'
    Is_gstn_registered:Boolean default false;


    @title:'GSTIN number'
    Gst_num:String(20);
    @title:'is_vendor'
    Is_vendor:Boolean default false;
    @title:'is_customer'
    Is_customer:Boolean default false;
}

entity Store {
    key ID: UUID;
    store_id :String(10);
    name         : String(100);
    add1     : String(255);
    add2     : String(255);
    city         : String(100);
    state        : Association to States;
    PinCode      : String(10) ;
}

entity Product : cuid, managed {
    key ID            : UUID;
    @title: 'ProductID'
    product_id: String(30);
    @title: 'Product Name'
    product_name: String(20) ;
    @title: 'Product Image URL'
    product_img: String default 'https://imgur.com/djS2boy.jpg';
    @title: 'Product Cost Price'
    product_cost: Decimal(15, 5) ;
    @title: 'Product Sell Price'
    product_sell: Decimal(15, 5) ;
}


entity Stock {
    key ID            : UUID;
    storeId         : Association to Store;
    productId       : Association to Product;
    stock_qty        : Integer;
}

entity PurchaseApp {
    key ID            : UUID;
    pon:Integer;
    bp:Association to Business_Partner;
    pDate:Date;
    storeId         : Association to Store;
    Items:Composition of many{
        key ID:UUID;
        qty:Integer;
        productId       : Association to Product;
        price:String(10);
    }
}


entity SalesApp {
    key ID :UUID;
    son:Integer;
    bp:Association to Business_Partner;
    saleDate: Date;
    storeId         : Association to Store;
     Items:Composition of many{
        key ID:UUID;
        qty:String(10);
        productId       : Association to Product;
        price:String(10);
    }
}
@cds.persistence.skip
entity States {
    @title:'code'
    key code: String(10);
    @title:'description'
    description:String(10);
    
}