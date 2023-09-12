


var ArrayAllOffers=[];
var CurrentOfferArrayForEvaluation = [];
var CurrentOfferShown=[];

window.addEventListener('load', (event) => {
    GetOffers();
    GetCurrentShopId();
});

function GetCurrentShopId(){
        //Fetch Data
        CurrentOfferArrayForEvaluation.length=0;

        $.ajax({
            url: 'GET_CurrentShopIdForEvaluation.php',
            type: 'post',
            success: function(data) {
                response=JSON.parse(data);
                if (response!='error'){
                    if(ArrayAllOffers.length!=0){
                        DataBase_ShopDetails.forEach(shop => {
                            if(shop.id==response){
                                j=0;
                                document.getElementById('table_header_prosf').innerHTML='Προσφορές Καταστήματος: '+'<strong>'+shop.name+'<strong>';
                                ArrayAllOffers.forEach(offer => {
                                    if(offer.shop_id==shop.id){
                                        CurrentOfferArrayForEvaluation[j]=offer;
                                        j++;
                                    }
                                });
                            }
                        });
                        if(CurrentOfferArrayForEvaluation.length!=0){
                            Create_OffersTable(CurrentOfferArrayForEvaluation);
                        }
                    }
                }else{
                    console.log(response);
                }
            },
            error:function(e){
                console.log("Connection to Server was Terminated with error "+e);
            }
        });
}



function GetOffers(){

    //Fetch Data
    $.ajax({
        url: 'GET_OffersUserProductData.php',
        // url: 'GET_Database_AllOfferDetails.php',
        type: 'post',
        success: function(data) {
            ArrayAllOffers.length=0;
            ArrayAllOffers=JSON.parse(data);
            console.log(ArrayAllOffers);
        },
        error:function(e){
            console.log(e);
            console.log("Data Couldnt be Fetched");
        }
    });
}

function Create_OffersTable(ArrayIn){
    
    var table=document.getElementById('table_body');
    var body='';
    let i=0;


    while(i<ArrayIn.length){
        
        let criteria_A='';
        let criteria_B='';

        if (ArrayIn[i].criteria_A==0){
            criteria_A='Όχι';
        }else if(ArrayIn[i].criteria_A==1){
            criteria_A='Ναί';
        }
        if (ArrayIn[i].criteria_B==0){
            criteria_B='Όχι';
        }else if(ArrayIn[i].criteria_B==1){
            criteria_B='Ναί';
        }

        body+=  '<tr id="Row_'+ArrayIn[i].id+'">'+
                    '<td>'+ArrayIn[i].productname+'</td>'+
                    '<td>'+ArrayIn[i].product_price+'</td>'+
                    '<td>'+criteria_A+'</td>'+
                    '<td>'+criteria_B+'</td>'+
                    '<td>'+ArrayIn[i].creation_date+'</td>'+
                    '<td>'+ArrayIn[i].likes+'</td>'+
                    '<td>'+ArrayIn[i].dislikes+'</td>'+
                    '<td>'+ArrayIn[i].has_stock+'</td>'+
                    '<td><button class="buttons_class" onclick="PressedRow('+ArrayIn[i].id+');">Περισσότερες λεπτομέρειες</button></td>'+
                '</tr>';    
        i++;
    }
    table.innerHTML=body;
}


function PressedRow(number){
    Update_OfferDetails(number);
}


function Update_OfferDetails(number){
    number=number;

    ArrayAllOffers.forEach(offer => {
        if(offer.id==number){
            
            
            DataBase_ShopDetails.forEach(shop => {
                if(shop.id==offer.shop_id){
                    document.getElementById('Offer_shop').innerText = shop.name;
                }
            });
            
            document.getElementById('Offer_product_name').innerText     = offer.productname;
            document.getElementById('Offer_product_price').innerText    = offer.product_price;
            
            if(offer.mesi_timi_day_critiria==1){
                document.getElementById('Offer_criteriaA').innerText    = 'Ναί';   
            }else{
                document.getElementById('Offer_criteriaA').innerText    = 'Όχι';
            }
            
            if(offer.mesi_timi_week_critiria==1){
                document.getElementById('Offer_criteriaB').innerText    = 'Ναί';   
            }else{
                document.getElementById('Offer_criteriaB').innerText    = 'Όχι';
            }

            document.getElementById('Offer_date').innerText             = offer.creation_date;
            document.getElementById('Offer_likes').innerText            = offer.likes;
            document.getElementById('Offer_dislikes').innerText         = offer.dislikes;
            
            if(offer.has_stock==1){
                document.getElementById('Offer_stock').innerText    = 'Ναί';   
                document.getElementById('status').style.visibility='visible';
                document.getElementById('ChangeStockStatus').style.visibility='visible';
                document.getElementById('like-button').style.visibility='visible';
                document.getElementById('dislike-button').style.visibility='visible';
            }else{
                document.getElementById('Offer_stock').innerText    = 'Όχι';   
                document.getElementById('status').style.visibility='visible';
                document.getElementById('ChangeStockStatus').style.visibility='visible';
                document.getElementById('like-button').style.visibility='hidden';
                document.getElementById('dislike-button').style.visibility='hidden';
            }
            document.getElementById('Offer_productname').innerText      = offer.productname;
            document.getElementById('Offer_productimage').innerText     = offer.productphoto;
            document.getElementById('Offer_productprice').innerText     = offer.product_price;
            document.getElementById('Offer_username').innerText         = offer.username;
            document.getElementById('Offer_userscore').innerText        = offer.userscore;
            CurrentOfferShown=offer;
        }
    });
}

document.getElementById('like-button').addEventListener('click',function(){
    PressedLike();
})
document.getElementById('dislike-button').addEventListener('click',function(){
    PressedDislike();
})
document.getElementById('ChangeStockStatus').addEventListener('click',function(){
    ChangedStock();
})

function PressedLike(){
    //Send Like Action
    var detailsArray={};

    detailsArray.offer_id=CurrentOfferShown.id;
    detailsArray.action=1;

    $.ajax({
        url: 'SEND_LikeDislike.php',
        type: 'post',
        data: {details:JSON.stringify(detailsArray)},
        success: function(data) {
            var response=JSON.parse(data);
            if(response=='success'){
                alert('Like submitted');
            }else{
                alert(response);
            }
        },
        error:function(e){
            console.log('Couldnt Connect to server!');
        }
    });
}

function PressedDislike(){
    //Send Dislike Action
    var detailsArray={};

    detailsArray.offer_id=CurrentOfferShown.id;
    detailsArray.action=2;

    $.ajax({
        url: 'SEND_LikeDislike.php',
        type: 'post',
        data: {details:JSON.stringify(detailsArray)},
        success: function(data) {
            var response=JSON.parse(data);
            if(response=='success'){
                alert('Dislike submitted');
            }else{
                alert(response);
            }
        },
        error:function(e){
        }
    });
}


function ChangedStock(){

    if(CurrentOfferShown.has_stock==1){
        if(confirm('Are you sure you want to change\nstock status to: Not Available  ?')){
            // CurrentOfferShown.has_stock=0;
            // document.getElementById('Offer_stock').innerText    = 'Όχι';
            // document.getElementById('like-button').style.visibility='hidden';
            // document.getElementById('dislike-button').style.visibility='hidden';
            ChangeStockStatusCall(CurrentOfferShown.id,false);
            
        }
    }else if(CurrentOfferShown.has_stock==0)
    {
        if(confirm('Are you sure you want to change\nstock status to: Available  ?')){
            // CurrentOfferShown.has_stock=1;
            // document.getElementById('Offer_stock').innerText    = 'Ναί';
            // document.getElementById('like-button').style.visibility='visible';
            // document.getElementById('dislike-button').style.visibility='visible';
            ChangeStockStatusCall(CurrentOfferShown.id,true);
        }
    }    

}

function ChangeStockStatusCall(offerid,flag){
    $.ajax({
        url: 'ChangeStock.php',
        type: 'post',
        data: {id:JSON.stringify(offerid),status:JSON.stringify(flag)},
        success: function(data) {
            var reponse=JSON.parse(data);
            if(response!=undefined){
                if(reponse=='error'){
                    if(flag==true){
                        alert('An Error Has Occured coulnt update current status to: Available');
                    }else if(flag==false){
                        alert('An Error has Occured couldnt update current status to: Unavailable')
                    }
                }else{
                    if(flag==true){
                        CurrentOfferShown.has_stock=1;
                        document.getElementById('Offer_stock').innerText    = 'Ναί';
                        document.getElementById('like-button').style.visibility='visible';
                        document.getElementById('dislike-button').style.visibility='visible';
                    }else if(flag==false){
                        CurrentOfferShown.has_stock=0;
                        document.getElementById('Offer_stock').innerText    = 'Όχι';
                        document.getElementById('like-button').style.visibility='hidden';
                        document.getElementById('dislike-button').style.visibility='hidden';
                    }
                    console.log('Updated Offer Row!');
                }
            }else{
                console.log('An Error has occured. Contact your system Admin!');
            
            }
        },
        error:function(e){
            console.log(e);
            console.log('Couldnt Connect to server!');
        }
    });
}