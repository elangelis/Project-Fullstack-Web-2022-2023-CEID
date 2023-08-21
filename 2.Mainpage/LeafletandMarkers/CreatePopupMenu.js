

// var ShopOffersArray={};



// function GetOffersForShop(in_shop_id){
//   $.ajax({
//     url: '/MainFunctionality/GET_OffersShop.php',
//     type: 'post',
//     async:true,
//     data: {shop_id:JSON.stringify(in_shop_id)},
//     success: function(data) {
//         ShopOffersArray.length=0;
//         ShopOffersArray=JSON.parse(data);
//         if (ShopOffersArray[0]!=null){
//           console.log(ShopOffersArray);
//           var Markertest = new L.marker([ShopOffersArray[0].latitude, ShopOffersArray[0].longitude],{icon: Allshop_withOffer})
//           var testPopUpbody= new L.popup().setContent(createPopUpbody(ShopOffersArray));
          
//           Markertest.bindPopup(testPopUpbody);
//           Markertest.addTo(map);  
//         }
//     },
//     error:function(){
//         console.log("den brethikan katastimata pou na exoun prosfora stin katigoria");
//     }

// });
// }



// //createPopUpbody(PopUpinfoArray);

// function createPopUpbody(PopUpinfoArray){
//     var body=   '<div>'+PopUpinfoArray[0].shop_name+'</div>'+
//                 '<table>'+'Shop Offers'+
//                     '<thead id="Offers_Table_header">'+
//                         '<th class="Off_T_user_header">'+'Προϊόν'+'</th>'+
//                         '<th class="Off_T_user_header">'+'Τιμή'+'</th>'+
//                         '<th class="Off_T_pass_header">'+'5.α.i'+'</th>'+
//                         '<th class="Off_T_pass_header">'+'5.α.ii'+'</th>'+
//                         '<th class="Off_T_pass_header">'+'Ημερομηνία Καταχώρησης'+'</th>'+
//                         '<th class="Off_T_pass_header">'+'Αριθμός Likes'+'</th>'+
//                         '<th class="Off_T_pass_header">'+'Αριθμός Dislikes'+'</th>'+
//                         '<th class="Off_T_pass_header">'+'Aπόθεμα (Nαι/Όχι)'+'</th>'+
//                         '<th class="Off_T_pass_header">'+'Button'+'</th>'+
//                     '</thead>'+
//                     '<tbody>'+
//                       CreatePopUpTable(PopUpinfoArray);+
//                     '</tbody>'+
//                 '</table>'+        
//                 '<button>'+'Αξιολόγηση'+'</button>'+
//                 '<button>'+'Προσθήκη Προσφοράς'+'</button>';   
//                 return(body);
// }

// function CreatePopUpTable(PopUpinfoArray){
//   var TableBody='';
//   for (let index = 0; index < PopUpinfoArray.length; index++) {
//           TableBody = TableBody+ ('<tr id="row_'+index+'">'+
//                                     '<td>' + PopUpinfoArray[index].product_name + '</td>'+
//                                     '<td>' + PopUpinfoArray[index].product_price + '</td>'+
//                                     '<td>' + PopUpinfoArray[index].criteriaA + '</td>'+
//                                     '<td>' + PopUpinfoArray[index].criteriaB + '</td>'+
//                                     '<td>' + PopUpinfoArray[index].date + '</td>'+
//                                     '<td>' + PopUpinfoArray[index].likes + '</td>'+
//                                     '<td>' + PopUpinfoArray[index].dislikes + '</td>'+
//                                     '<td>' + PopUpinfoArray[index].stock + '</td>'+
//                                     '<td>'+
//                                         '<button type="submit" id=PoPupOffer_'+index+'>'+'select'+
//                                         '</button>'+
//                                     '</td>'+
//                                 '</tr>');    
//           }
//           return(TableBody);
// }
