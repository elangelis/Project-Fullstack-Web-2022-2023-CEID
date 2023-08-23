var DataBase_ShopDetails={};        //Array of all Shop details in Database
var DataBase_OfferDetails={};       //Array of all Offers in Database
var DataBase_UserData={};           //Array of all User Data in Databse
var DataBase_ProductDetails={};     //Array of all Product Details In Database;

window.addEventListener("DOMContentLoaded", (event) => {
    console.log("DOMContentLoaded trigger");
    UpdateNewDatabaseData();
});



function UpdateNewDatabaseData(){
    GetDataBaseData();
}

function GetDataBaseData(){
    GetAllShopDetails();    
    GetAllOffers();         
    GetCurrentUserData();   
    GetProductDetails();
}

function GetAllShopDetails(){
    $.ajax({
        url: '../ApacheRESTServices/GET_Database_AllShopDetails.php',
        type: 'post',
        async:true,
        success: function(Response) {
            DataBase_ShopDetails.length=0;
            DataBase_ShopDetails=JSON.parse(Response);
            console.log('DataBase_ShopDetails:');
            console.log(DataBase_ShopDetails);
        },
        error:function(ResponseError){
            console.log(ResponseError);
        }
    });
    return(false);
}

function GetAllOffers(){
    
    $.ajax({
        url: '../ApacheRESTServices/GET_Database_AllOfferDetails.php',
        async:true,
        type: 'post',
        success: function(Response) {
            DataBase_OfferDetails.length=0;
            DataBase_OfferDetails=JSON.parse(Response);
            console.log('DataBase_OfferDetails:');
            console.log(DataBase_OfferDetails);
        },
        error:function(ResponseError){
            console.log(ResponseError);
        }
    }); 
    return(false);
}

function GetCurrentUserData(){
    $.ajax({
        url: '../ApacheRESTServices/GET_Database_AllUserDetails.php',
        type: 'post',
        async:true,
        success: function(Response) {
            DataBase_UserData.length=0;
            DataBase_UserData=JSON.parse(Response);
            console.log('DataBase_UserData:');
            console.log(DataBase_UserData);
        },
        error:function(ResponseError){
            console.log(ResponseError);
            
        }
    });
}

function GetProductDetails(){
    $.ajax({
        url: '../ApacheRESTServices/GET_Database_AllProductDetails.php',
        type: 'post',
        async:true,
        success: function(Response) {
            DataBase_ProductDetails.length=0;
            DataBase_ProductDetails=JSON.parse(Response);
            console.log('DataBase_ProductDetails:');
            console.log(DataBase_ProductDetails);
        },
        error:function(ResponseError){
            console.log(ResponseError);
            
        }
    });
}






























