

var MarkerArrayLayerGroup_A = new Array;
var MarkerArrayLayerGroup_B = new Array;
var MarkerArrayLayerGroup_C = new Array;

var markersLayer_A;
var markersLayer_B;
var markersLayer_C;



var PopupIcon = L.Icon.extend({
    options: {
        iconSize:     [30,30],
        iconAnchor:   [40,40],
        popupAnchor:  [-20,-30]
    }
});



var Allshop_withOffer = new PopupIcon({iconUrl: 'https://img.icons8.com/color/40/null/shop.png'}),
    ShopName_NoOffer = new PopupIcon({iconUrl: 'https://img.icons8.com/ultraviolet/40/null/shop.png'}),
    ShopName_WithOffer = new PopupIcon({iconUrl: 'https://img.icons8.com/arcade/40/null/shop.png'}),
    Shop_withItem = new PopupIcon({iconUrl: 'https://img.icons8.com/arcade/40/null/shop.png'});

    


//------------------------------------------------------------------------------------------------------------------------------------//
//--------------------------------------------  Create Markers For Marker initialization   -------------------------------------------//
//------------------------------------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------------------------------//

var MarkerArray_A = [];
var PopupBodyArray = [];
var CurrentShopOffersArray = [];
let MarkersInit = false;

//Loop to run this function every 2 seconds if not Markers  Initialised already




let intervalId = setInterval(CreateMarkers, 2000);


function CreateMarkers() {

    if (MarkersInit == false) {
        if (DataBase_OfferDetails.length != undefined && DataBase_OfferDetails.length != 0) {
            ClearVariables();
            Create_MarkersForAllShopsWithOffers();
            Create_PopUpbodyForMarkers();
            Create_LayerGroupsForMarkers();
            Create_EventListenersForMarkers();
            clearInterval(intervalId);
            MarkersInit = true;
        }
    }

}

//Function that Creates markers when DOMContent is Loaded and will be passed into leaflet
function Create_MarkersForAllShopsWithOffers() {

    //DataBase_ShopDetails is the Array with all our OffersData
    for (var i = 0; i < DataBase_ShopDetails.length; i++) {
        if (DataBase_ShopDetails[i].active_offer == true) {  //if shop has an offer then create a marker
            MarkerArray_A[i] = L.marker([DataBase_ShopDetails[i].latitude, DataBase_ShopDetails[i].longitude], { icon: Allshop_withOffer }).bindPopup(DataBase_ShopDetails[i].name);
            MarkerArrayLayerGroup_A.push(MarkerArray_A[i]);
        } else if (DataBase_ShopDetails[i].active_offer == false) {
            MarkerArray_A[i] = L.marker([DataBase_ShopDetails[i].latitude, DataBase_ShopDetails[i].longitude], { icon: ShopName_NoOffer }).bindPopup(DataBase_ShopDetails[i].name);
            MarkerArray_A[i].setOpacity(0.7);
            MarkerArrayLayerGroup_A.push(MarkerArray_A[i]);
        }
    }
}


function Create_PopUpbodyForMarkers() {

    for (var i = 0; i < DataBase_ShopDetails.length; i++) {
        CurrentShopOffersArray.length = 0;
        DataBase_OfferDetails.forEach(offer => {
            if (offer.shop_id == DataBase_ShopDetails[i].id) {
                CurrentShopOffersArray.push(offer);
            }
        });
        console.log('CurrentShopOffersArray');
        console.log(CurrentShopOffersArray);
        if (CurrentShopOffersArray.length != 0) {//if current marker has any offers
            PopupBodyArray[i] = L.popup().setContent(createPopUpbody(CurrentShopOffersArray));
            MarkerArray_A[i].bindPopup(PopupBodyArray[i]);
        }else{
            PopupBodyArray[i] = L.popup().setContent(createPopUpbodyForEmptyOffer(DataBase_ShopDetails[i]));
            MarkerArray_A[i].bindPopup(PopupBodyArray[i]);
        }
    }
}





function Create_EventListenersForMarkers() {

    counter = 1;
    MarkerArray_A.forEach(marker => {

        marker.on('click'), function () {
            CheckIfUserLocationIsClosetoShopLocation();
        }
        counter++;
    });
}

function Create_LayerGroupsForMarkers() {
    
    if (markersLayer_B != undefined) {
        map.removeLayer(markersLayer_B);
    }
    if (markersLayer_C != undefined) {
        map.removeLayer(markersLayer_C);
    }
    
    
    MarkerArray_A.forEach(marker => {
        MarkerArrayLayerGroup_A.push(marker);
    });
    markersLayer_A = L.layerGroup(MarkerArrayLayerGroup_A);
    markersLayer_A.addTo(map);
    InitialisedMarkers = true;
}




//CREATE POP up Table Body with Shop Offers



function createPopUpbody(PopUpinfoArray) {
    let shopid = PopUpinfoArray[0].shop_id;

    var body = '<div id="MarkerPopUpTable">' + PopUpinfoArray[0].shop_name + '</div>' +
        '<table class="PopUpTable_object">' + 'Shop Offers' +
        '<thead id="PopUpTable_header_class">' +
        '<th class="PopUpTable_header_product">' + 'Προϊόν' + '</th>' +
        '<th class="PopUpTable_header">' + 'Τιμή' + '</th>' +
        '<th class="PopUpTable_header">' + '5.α.i' + '</th>' +
        '<th class="PopUpTable_header">' + '5.α.ii' + '</th>' +
        '<th class="PopUpTable_header">' + 'Ημερομηνία Καταχώρησης' + '</th>' +
        '<th class="PopUpTable_header">' + 'Αριθμός Likes' + '</th>' +
        '<th class="PopUpTable_header">' + 'Αριθμός Dislikes' + '</th>' +
        '<th class="PopUpTable_header">' + 'Aπόθεμα (Nαι/Όχι)' + '</th>' +
        '<th class="PopUpTable_header">' + 'Button' + '</th>' +
        '</thead>' +
        '<tbody class="PopUpTable_body_class">' +
        CreatePopUpTable(PopUpinfoArray);
    body = body +
        '</tbody>' +
        '</table>' +
        '<button id="evaluate_Shop' + shopid + '" class="PopupLeftButton" input="submit" onclick="EvaluateOffers(' + shopid + ')">' + 'Αξιολόγηση' + '</button>' +
        '<button id="NewOffer_Shop' + shopid + '" class="PopupRightButton" input="submit" onclick="SubmitOffer(' + shopid + ')">' + 'Προσθήκη Προσφοράς' + '</button>';
    return (body);
}


function createPopUpbodyForEmptyOffer(PopUpinfoArray){
    let shopid = PopUpinfoArray.id;

    var body=       '<div id="MarkerPopUpTable">' + PopUpinfoArray.name + '</div>' +
                    '<button id="evaluate_Shop' + shopid + '" class="PopupLeftButton" input="submit" onclick="EvaluateOffers(' + shopid + ')">' + 'Αξιολόγηση' + '</button>' +
                    '<button id="NewOffer_Shop' + shopid + '" class="PopupRightButton" input="submit" onclick="SubmitOffer(' + shopid + ')">' + 'Προσθήκη Προσφοράς' + '</button>';

    return(body);
}

function CreatePopUpTable(PopUpinfoArray) {
    var TableBody = '';
    for (let index = 0; index < PopUpinfoArray.length; index++) {
        let offerid = PopUpinfoArray[index].offer_id;
        let shopid = PopUpinfoArray[0].shop_id;
        let product_name = PopUpinfoArray[index].product_name;
        let product_price = PopUpinfoArray[index].product_price;
        let criteriaA;
        let criteriaB;
        let stock;
        if (PopUpinfoArray[index].criteriaA == 1) {
            criteriaA = 'Ναι';
        } else if (PopUpinfoArray[index].criteriaA == 0) {
            criteriaA = 'Όχι';
        }

        if (PopUpinfoArray[index].criteriaB == 1) {
            criteriaB = 'Ναι';
        } else if (PopUpinfoArray[index].criteriaB == 0) {
            criteriaB = 'Όχι';
        }
        let date = PopUpinfoArray[index].date;
        let likes = PopUpinfoArray[index].likes;
        let dislikes = PopUpinfoArray[index].dislikes;
        if (PopUpinfoArray[index].stock == 1) {
            stock = 'Ναι';
        } else if (PopUpinfoArray[index].stock == 0) {
            stock = 'Όχι';
        }



        TableBody = TableBody + ('<tr id="row_' + index + '">' +
            '<td class="PopUpTable_body_product">' + product_name + '</td>' +
            '<td class="PopUpTable_body">' + product_price + '</td>' +
            '<td class="PopUpTable_body">' + criteriaA + '</td>' +
            '<td class="PopUpTable_body">' + criteriaB + '</td>' +
            '<td class="PopUpTable_body">' + date + '</td>' +
            '<td class="PopUpTable_body">' + likes + '</td>' +
            '<td class="PopUpTable_body">' + dislikes + '</td>' +
            '<td class="PopUpTable_body">' + stock + '</td>' +
            '<td class="PopUpTable_body">' +
            '<button type="submit" id=PoPupOffer_' + offerid + '_shop_' + shopid + ' onclick="OfferClickButton(' + offerid + ',' + shopid + ');">' + 'select' +
            '</button>' +
            '</td>' +
            '</tr>');
    }
    return (TableBody);
}
//CREATE POP up Table Body with Shop Offers


function OfferClickButton(INoffer_id, INshop_id) {
    console.log('INofferid:     ' + INoffer_id);
    console.log('INshop_id:     ' + INshop_id);

}

function EvaluateOffers(shop_id) {
    AssignNewSessionShopID_ForEvaluation(shop_id);
}

function SubmitOffer(shop_id) {
    AssignNewSessionShopID_ForSubmit(shop_id);

}


//------------------------------------------------------------------------------------------------------------------------------------//
//--------------------------------------------  Create Markers For SearchBar Shop name variable   ------------------------------------//
//------------------------------------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------------------------------//

var MarkerArray_B = [];
var Current_ShopOffersArrayForShopName = [];
var Current_ShopDetailsShopName = [];
var PopupBodyArray_B = [];

function CreateMarkersForShopName(in_shopname) {

    if (MarkersInit == true) {
        if (DataBase_OfferDetails.length != undefined && DataBase_OfferDetails.length != 0) {
            ClearVariables();
            Create_MarkersForShopsThatMatchName(in_shopname);
            Create_PopUpbodyForMarkersShopName();
            Create_LayerGroupsForMarkersShopname();
            Create_EventListenersForMarkersShopName();
        }
    }
}

//Function that Creates markers when DOMContent is Loaded and will be passed into leaflet
function Create_MarkersForShopsThatMatchName(in_shopname) {
    let j = 0;
    MarkerArray_B.length = 0;
    //DataBase_ShopDetails is the Array with all our OffersData
    for (var i = 0; i < DataBase_ShopDetails.length; i++) {
        if (DataBase_ShopDetails[i].name != undefined) {
            if (DataBase_ShopDetails[i].name.toUpperCase().includes(in_shopname.toUpperCase())) {

                Current_ShopDetailsShopName[j] = DataBase_ShopDetails[i];

                if (DataBase_ShopDetails[i].active_offer == true) {  //if shop has an offer then create a marker
                    MarkerArray_B[j] = L.marker([DataBase_ShopDetails[i].latitude, DataBase_ShopDetails[i].longitude], { icon: Allshop_withOffer }).bindPopup(DataBase_ShopDetails[i].name);
                    MarkerArrayLayerGroup_B.push(MarkerArray_B[j]);
                } else if (DataBase_ShopDetails[i].active_offer == false) {
                    MarkerArray_B[j] = L.marker([DataBase_ShopDetails[i].latitude, DataBase_ShopDetails[i].longitude], { icon: ShopName_NoOffer }).bindPopup(DataBase_ShopDetails[i].name);
                    MarkerArrayLayerGroup_B.push(MarkerArray_B[j]);
                }
                j++;
            }
        }
    }
}

function Create_PopUpbodyForMarkersShopName() {

    for (var i = 0; i < Current_ShopDetailsShopName.length; i++) {
        Current_ShopOffersArrayForShopName.length = 0;
        DataBase_OfferDetails.forEach(offer => {
            if (offer.shop_id == Current_ShopDetailsShopName[i].id) {
                Current_ShopOffersArrayForShopName.push(offer);
            }
        });
        console.log('Current_ShopOffersArrayForShopName');
        console.log(Current_ShopOffersArrayForShopName);
        if (Current_ShopOffersArrayForShopName.length != 0) {//if current marker has any offers
            PopupBodyArray_B[i] = L.popup().setContent(createPopUpbody(Current_ShopOffersArrayForShopName));
            MarkerArray_B[i].bindPopup(PopupBodyArray_B[i]);
        }else{
            PopupBodyArray_B[i] = L.popup().setContent(createPopUpbodyForEmptyOffer(Current_ShopDetailsShopName[i]));
            MarkerArray_B[i].bindPopup(PopupBodyArray_B[i]);
        }
    }
}

function Create_LayerGroupsForMarkersShopname() {

    if (markersLayer_A != undefined) {
        map.removeLayer(markersLayer_A);
    }
    if (markersLayer_C != undefined) {
        map.removeLayer(markersLayer_C);
    }

    MarkerArray_B.forEach(marker => {
        MarkerArrayLayerGroup_B.push(marker);
    });
    markersLayer_B = L.layerGroup(MarkerArrayLayerGroup_B);
    markersLayer_B.addTo(map);
    InitialisedMarkers = true;
}


function Create_EventListenersForMarkersShopName() {

    counter = 1;
    MarkerArray_B.forEach(marker => {

        marker.on('click'), function () {
            CheckIfUserLocationIsClosetoShopLocation();
        }
        counter++;
    });
}



//------------------------------------------------------------------------------------------------------------------------------------//
//--------------------------------------------  Create Markers For SearchBar Item Category variable   --------------------------------//
//------------------------------------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------------------------------//



var MarkerArray_C = [];
var Current_ShopOffersArrayForItemCategory = [];
var Current_ShopDetailsShopNameItemCategory = [];
var PopupBodyArray_C = [];

function CreateMarkersForItemCategory(in_itemcategory) {

    if (MarkersInit == true) {
        if (DataBase_OfferDetails.length != undefined && DataBase_OfferDetails.length != 0) {
            ClearVariables();
            Create_MarkersForShopsThatMatchItemCategory(in_itemcategory);
            Create_PopUpbodyForMarkersItemCategory();
            Create_LayerGroupsForMarkersItemCategory();
            Create_EventListenersForMarkersItemCategory();
        }
    }
}
function ClearVariables(){
    
    MarkerArrayLayerGroup_A.length=0;
    MarkerArrayLayerGroup_B.length=0;
    MarkerArrayLayerGroup_C.length=0;


    MarkerArray_A.length=0;
    PopupBodyArray.length=0;
    CurrentShopOffersArray.length=0;

    MarkerArray_B.length=0;
    Current_ShopOffersArrayForShopName.length=0;
    Current_ShopDetailsShopName.length=0;
    PopupBodyArray_B.length=0;
    
    MarkerArray_C.length=0;
    Current_ShopOffersArrayForItemCategory.length=0;
    Current_ShopDetailsShopNameItemCategory.length=0;
    PopupBodyArray_C.length=0;
}


//Function that Creates markers when DOMContent is Loaded and will be passed into leaflet
function Create_MarkersForShopsThatMatchItemCategory(in_itemcategory) {
    let j = 0;
    MarkerArray_B.length = 0;
    //DataBase_ShopDetails is the Array with all our OffersData
    for (var i = 0; i < DataBase_OfferDetails.length; i++) {
        if (DataBase_OfferDetails[i].category_name != undefined || DataBase_OfferDetails[i].subcategory_name != undefined) {
            if (DataBase_OfferDetails[i].category_name != undefined) {
                if (DataBase_OfferDetails[i].category_name.toUpperCase().includes(in_itemcategory.toUpperCase())) {

                    DataBase_ShopDetails.forEach(shop => {
                        if(shop.id==DataBase_OfferDetails[i].shop_id){
                            Current_ShopDetailsShopNameItemCategory[j]=shop;
                            
                            if (shop.active_offer == true) {  //if shop has an offer then create a marker
                                MarkerArray_C[j] = L.marker([shop.latitude, shop.longitude], { icon: Allshop_withOffer }).bindPopup(shop.shop_name);
                                MarkerArrayLayerGroup_C.push(MarkerArray_C[j]);
                                j++;
                            } else if (shop.active_offer == false) {
                                MarkerArray_C[j] = L.marker([shop.latitude, shop.longitude], { icon: Allshop_withOffer }).bindPopup(shop.shop_name);
                                MarkerArrayLayerGroup_C.push(MarkerArray_C[j]);
                                j++;
                            }
                        }
                    });
                } else if (DataBase_OfferDetails[i].subcategory_name != undefined) {
                    if (DataBase_OfferDetails[i].subcategory_name.toUpperCase().includes(in_itemcategory.toUpperCase())) {

                        DataBase_ShopDetails.forEach(shop => {
                            if(shop.id==DataBase_OfferDetails[i].shop_id){
                                Current_ShopDetailsShopNameItemCategory[j]=shop;
                                
                                if (shop.active_offer == true) {  //if shop has an offer then create a marker
                                    MarkerArray_C[j] = L.marker([shop.latitude, shop.longitude], { icon: Allshop_withOffer }).bindPopup(shop.shop_name);
                                    MarkerArrayLayerGroup_C.push(MarkerArray_C[j]);
                                    j++;
                                } else if (shop.active_offer == false) {
                                    MarkerArray_C[j] = L.marker([shop.latitude, shop.longitude], { icon: Allshop_withOffer }).bindPopup(shop.shop_name);
                                    MarkerArrayLayerGroup_C.push(MarkerArray_C[j]);
                                    j++;
                                }
                            }
                        });
                    }
                }
            }
        }
    }
} 

function Create_PopUpbodyForMarkersItemCategory() {

    for (var i = 0; i < Current_ShopDetailsShopNameItemCategory.length; i++) {
        Current_ShopOffersArrayForItemCategory.length = 0;
        DataBase_OfferDetails.forEach(offer => {
            if (offer.shop_id == Current_ShopDetailsShopNameItemCategory[i].id) {
                Current_ShopOffersArrayForItemCategory.push(offer);
            }
        });
        console.log('Current_ShopOffersArrayForItemCategory');
        console.log(Current_ShopOffersArrayForItemCategory);
        if (Current_ShopOffersArrayForItemCategory.length != 0) {//if current marker has any offers
            PopupBodyArray_C[i] = L.popup().setContent(createPopUpbody(Current_ShopOffersArrayForItemCategory));
            MarkerArray_C[i].bindPopup(PopupBodyArray_C[i]);
        }
    }
}

function Create_LayerGroupsForMarkersItemCategory() {

    if (markersLayer_A != undefined) {
        map.removeLayer(markersLayer_A);
    }
    if (markersLayer_B != undefined) {
        map.removeLayer(markersLayer_B);
    }

    MarkerArray_C.forEach(marker => {
        MarkerArrayLayerGroup_C.push(marker);
    });
    markersLayer_C = L.layerGroup(MarkerArrayLayerGroup_C);
    markersLayer_C.addTo(map);
    InitialisedMarkers = true;
}


function Create_EventListenersForMarkersItemCategory() {

    counter = 1;
    MarkerArray_C.forEach(marker => {

        marker.on('click'), function () {
            CheckIfUserLocationIsClosetoShopLocation();
        }
        counter++;
    });
}

//------------------------------------------------------------------------------------------------------------------------------------//
//--------------------------------------------  Create Markers For SearchBar Item Category variable   --------------------------------//
//------------------------------------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------------------------------//



function AssignNewSessionShopID_ForEvaluation(in_shopid){
    
    if(CheckIfUserLocationIsClosetoShopLocation(in_shopid)){
        $.ajax({
            url: '/ApacheRESTServices/SEND_NewSesssionShopID.php',
            type: 'post',
            async:true,
            data: {shop_id:JSON.stringify(in_shopid)},
            success: function(data) {
                console.log('New Session shop Id is:'+data);
                window.location.href='../4.EvaluationPage/EvaluationPage.php';
            },
            error:function(e){
                console.log(e);
                alert('Connection to Database Has failed. Unable to Open Next Page');
            }
        });

    }else{
        alert('You need to be in 50m. radius from the shop in orfer to Evaluate Offers!');
    }
    
   
}

var CurrentSelectedShop=[];

function AssignNewSessionShopID_ForSubmit(in_shopid){
    


    if(CheckIfUserLocationIsClosetoShopLocation(in_shopid)){
        
        DataBase_ShopDetails.forEach(shop => {
            if(in_shopid==shop.id){
                CurrentSelectedShop=shop;
            }
        });

        $.ajax({
            url: '/ApacheRESTServices/SEND_NewSesssionShopID.php',
            type: 'post',
            async:true,
            data: {shop_id:JSON.stringify(in_shopid)},
            success: function(data) {
    
                console.log('New Session shop Id is:'+data);
                console.log('CurrentSelectedShop');
                console.log(CurrentSelectedShop);
                Toggle_iFrame();

            },
            error:function(e){
                console.log(e);
                alert('Connection to Database Has failed. Unable to Open Next Page');
            }
        });
    
    }else{
        alert('You need to be in 50m. radius from the shop in orfer to Submit a new offer!');
    }


}


function CheckIfUserLocationIsClosetoShopLocation(in_shopid){
    
    let successflag=false;
    let distance;

    //Get User Latitude, Longitude
    navigator.geolocation.getCurrentPosition(successForce,error,options);
    //Get Shop Latitude, Longitude
    let CurrentShop=[];
    DataBase_ShopDetails.forEach(shop => {
        if(shop.id==in_shopid){
            CurrentShop.latitude=shop.latitude;         //x0
            CurrentShop.longitude=shop.longitude;      //y0
        }
    });

    //Compare User, Shop Distance
    if(CurrentUser.latitude!=undefined && CurrentUser.longitude!=undefined && CurrentShop.latitude!=undefined && CurrentShop.longitude!=undefined){
        distance=calcCrow(CurrentShop.latitude,CurrentShop.longitude,CurrentUser.latitude,CurrentUser.longitude);
        let concat=distance.toString();

        let newdistance=distance.toString().slice(0,distance.toString().indexOf('.')+3);

        if(distance<=50){
            successflag=true;
            console.log('Current Distance is:\n' + newdistance +'  in meters');
        }else{
            successflag=false;       //TODOERG
            // successflag=true;   //Return Always true for now so we can modify Pages and FunctionalityTODOERG
            console.log('Current Distance is:\n' + newdistance +'  in meters');
        }
    }return(successflag);
}

    

    function calcCrow(lat1, lon1, lat2, lon2) 
    {
      var R = 6371; // km
      var dLat = toRad(lat2-lat1);
      var dLon = toRad(lon2-lon1);
      var lat1 = toRad(lat1);
      var lat2 = toRad(lat2);

      var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
        Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2); 
      var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
      var d = R * c;
      return d*1000;
    }


    function toRad(Value) 
    {
        return Value * Math.PI / 180;
    }