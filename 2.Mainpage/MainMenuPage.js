

const searchBtn_name = document.getElementById("search_by_name"),
      searchBtn_item = document.getElementById("search_by_item_category"),
      user_profile = document.getElementById("menu_button_1"),
      LikeHistory = document.getElementById("menu_button_2"),
      OffersHistory = document.getElementById("menu_button_3"),
      Tokens = document.getElementById("menu_button_4"),
      Likes = document.getElementById("menu_button_5"),
      Points_Wallet = document.getElementById("menu_button_6"),
      Log_out_btn = document.getElementById("r_s_logout_button");



  const body = document.querySelector('body'),
        sidebars = body.getElementsByClassName('nav'),
        toggle = body.querySelector(".toggle");

//buttons

const settings = document.getElementById("settings"),
      PopUpSettings = document.getElementById("PopUpSettings"),
      // PopUpFilters = document.getElementById("PopUpFilters"),
      modeSwitch = document.getElementById("toggle_switch_1"),
      modeText = body.querySelector(".mode-text");

  const toggle1 = document.getElementById("toggle_header_right"),
        toggle2 = document.getElementById("toggle_header_right");

//TABLES
  const OffersTableBody=document.getElementById('Offers_Table_body');

//SEARCH NAME SHOP AND MARKERS SHOW
searchBtn_name.addEventListener("keydown", (e) => {
  
  let textinput=document.getElementById("search_result").value;

  if (e.key == "Enter" && textinput != "") {
    map.eachLayer((layer) => {
      if(layer!=osm && layer!=LayerUser){
        layer.remove();
      }
    });
    osm.addTo(map);
    map.addLayer(Usermarker);
    map.addLayer(Usercircle);
    searchQuery = textinput;
    CreateMarkersForShopName(searchQuery);
  }
});


//SEARTH ITEM CATEGORY BUTTON AND MARKERS SHOW
searchBtn_item.addEventListener("keydown", (e) => {
  
  let textinput=document.getElementById("search_result_category").value;

  if (e.key == "Enter" && textinput != "") {
    map.eachLayer((layer) => {
      if(layer!=osm && layer!=LayerUser){
        layer.remove();
      }
    });
    osm.addTo(map);
    map.addLayer(Usermarker);
    map.addLayer(Usercircle);
    searchQuery = textinput;
    CreateMarkersForItemCategory(searchQuery);
  }
});


user_profile.addEventListener("click", () => {

  if (PopUpSettings.style.display == "block") {
    PopUpSettings.style.display = "none";
    closeTab();
  } else {
    PopUpSettings.style.display = "block";
    // PopUpFilters.style.display = "none";
    SelectTab("Tab_1");
  }
});

LikeHistory.addEventListener("click", () => {
  if (PopUpSettings.style.display == "block") {
    PopUpSettings.style.display = "none";
    closeTab();
  } else {
    PopUpSettings.style.display = "block";
    // PopUpFilters.style.display = "none";
    SelectTab("Tab_2");
  }
});

OffersHistory.addEventListener("click", () => {
  if (PopUpSettings.style.display == "block") {
    PopUpSettings.style.display = "none";
    closeTab();
  } else {
    PopUpSettings.style.display = "block";
    // PopUpFilters.style.display = "none";
    SelectTab("Tab_3");
  }
});

Tokens.addEventListener("click", () => {
  if (PopUpSettings.style.display == "block") {
    PopUpSettings.style.display = "none";
    closeTab();
  } else {
    PopUpSettings.style.display = "block";
    // PopUpFilters.style.display = "none";
    SelectTab("Tab_4");
  }
});



Log_out_btn.addEventListener("click", () => {
  if(confirm('Are you sure you want to Log Out? \nYou will be redirected to Log in Page.')){
    
    $.ajax({
      url: './MainFunctionality/Logout.php',
      type: 'post',
      success: function(e) {
        if(e=='logout'){
          window.location.href='http://localhost/web-v.1.0.0.1/1.LoginPage/LoginMenuPage.php';
        }
      },
      error:function(e){
        console.log(e);
      }

    });
  }
});

function openTab(tabName) {
  //visible true 
  document.getElementById(tabName).style.visibility = "visible";
}

function closeTab(){
  var i,tabcontent;
  //visible false for all menu
  tabcontent = document.getElementsByClassName("tabcontent");
  for(i=0;i<tabcontent.length;i++){
    tabcontent[i].style.visibility="hidden";
  }
}

function SelectTab(tabName){
  closeTab();
  openTab(tabName);
}


 







      //----------------------------------------------------------------------------------------------------------------------------------------//
      //----------------------------------------------------------------------------------------------------------------------------------------//



  let iframebackground=document.getElementById('iframe_submit_offer');
  let iframeobject=document.getElementById('form_submit_iframe');
  let iframeVisible=false;

  // iframeobject.style.visibility="hidden";


  function Toggle_iFrame(){

    if(iframeVisible==true){

      iframebackground.className="form_submit_iframe_close";
      iframeobject.className="form_submit_iframe_close";
      iframeVisible=false;
      
    }else if(iframeVisible==false){

      iframebackground.className="form_submit_iframe_open";
      iframeobject.className="form_submit_iframe_open";
      iframeVisible=true;
      iframeobject.contentDocument.getElementById('shop_selection').value=CurrentSelectedShop.name;

      if (iframeVisible){
        iframeobject.contentDocument.getElementById('closebutton').addEventListener('click',function(){
          
          iframebackground.className="form_submit_iframe_close";
          iframeobject.className="form_submit_iframe_close";
          iframeVisible=false;

        });
      }
    }
  }



  //----------------------------------------------------------------------------------------------------------------------------------------//
  //----------------------------------------------------------------------------------------------------------------------------------------//

  let TabClickButton=document.getElementById('close_button_popupsettings');
  TabClickButton.addEventListener('click',function(e){
      CloseTabsButton();
  })

  function CloseTabsButton(){
    if (PopUpSettings.style.display == "block") {
      PopUpSettings.style.display = "none";
      closeTab();
    }
  }


window.addEventListener('load',function(e){
  $.ajax({
    url: 'MainFunctionality/GET_UserID.php',
    type: 'post',
    success: function(data) {
      if(data=='error'){
        alert ('An error has occured please try Logging in again.');
      }else if(data!=undefined){
        let userid=JSON.parse(data);
        CreateLikesHistoryTable(userid);
        CreateOffersHistoryTable(userid);
        GetUserScore(userid);
      }
    },
    error:function(e){
      alert ('An error has occured please try Logging in again.');
    }});
})

function CreateLikesHistoryTable(userid){
  var LikesHistoryTable={};
  let table =document.getElementById('likes_history_table');
  let tablebody='';
  let tablerow='';

  // $.ajax({
  //   url: './MainFunctionality/Logout.php',
  //   type: 'post',
  //   data: userid,
  //   success: function(data) {
  //     console.log(data);
  //     LikesHistoryTable=JSON.parse(data);
  //     console.log(LikesHistoryTable);
  //     if(LikesHistoryTable.length>0){
  //       i=1;
  //       LikesHistoryTable.forEach(row => {
          
  //         let no='';
  //         let action='';
  //         let offerno='';
  //         let date='';
  //         let publisher='';
          
  //         if(row.no!=undefined){
  //           no=row.no;
  //         }
  //         if(row.action!=undefined){
  //           action=row.action;
  //         }
  //         if(row.offerno!=undefined){
  //           offerno=row.offerno;
  //         }
  //         if(row.date!=undefined){
  //           date=row.date;
  //         }
  //         if(row.publisher!=undefined){
  //           publisher=row.publisher;
  //         }
  //         tablerow= '<tr id="likes_row'+i+'" class="likes_row">'+
  //                     '<td class="likes_cell_rank">'+no+'</td>'+
  //                     '<td class="likes_cell">'+action+'</td>'+
  //                     '<td class="likes_cell">'+offerno+'</td>'+
  //                     '<td class="likes_cell">'+date+'</td>'+
  //                     '<td class="likes_cell">'+publisher+'</td>'+
  //                   '</tr>';
  //         tablebody+=tablerow;
  //         i++;
  //       });    
  //       table.innerHTML(tablebody);
  //     }
  //   },
  //   error:function(e){
  //     console.log(e);
  //   }

  // });
}

function CreateOffersHistoryTable(userid){
  
  var OffersHistoryTable={};
  let table =document.getElementById('offer_history_table');
  let tablebody='';
  let tablerow='';

  // $.ajax({
  //   url: './MainFunctionality/Logout.php',
  //   type: 'post',
  //   data: userid,
  //   success: function(data) {
  //     console.log(data);
  //     OffersHistoryTable=JSON.parse(data);
  //     console.log(OffersHistoryTable);
  //     if(OffersHistoryTable.length>0){
  //       i=1;
  //       OffersHistoryTable.forEach(row => {
          
  //         let no='';
  //         let offerid='';
  //         let sumbdate='';
  //         let active='';
  //         let price='';
  //         let shop='';
          
  //         if(row.no!=undefined){
  //           no=row.no;
  //         }
  //         if(row.offerid!=undefined){
  //           offerid=row.offerid;
  //         }
  //         if(row.sumbdate!=undefined){
  //           sumbdate=row.sumbdate;
  //         }
  //         if(row.active!=undefined){
  //           if(row.active==1){
  //             active='YES';
  //           }else{
  //             active='NO';
  //           }
  //         }
  //         if(row.price!=undefined){
  //           price=row.price;
  //         }
  //         if(row.shop!=undefined){
  //           shop=row.shop;
  //         }
  //         tablerow= '<tr id="offer_row'+i+'" class="offer_row">'+
  //                     '<td class="offer_cell_rank">'+no+'</td>'+
  //                     '<td class="offer_cell">'+offerid+'</td>'+
  //                     '<td class="offer_cell">'+sumbdate+'</td>'+
  //                     '<td class="offer_cell">'+active+'</td>'+
  //                     '<td class="offer_cell">'+price+'</td>'+
  //                     '<td class="offer_cell">'+shop+'</td>'+
  //                   '</tr>';
  //         tablebody+=tablerow;
  //         i++;
  //       });    
  //       table.innerHTML(tablebody);
  //     }
  //   },
  //   error:function(e){
  //     console.log(e);
  //   }
  // });
}

function GetUserScore(userid){
    let total_tok = document.getElementById('total_tokens');
    let cur_tok = document.getElementById('current_tokens');

    let cur_sc = document.getElementById('total_score');
    let total_sc = document.getElementById('current_score');

    // $.ajax({
    //   url: './MainFunctionality/GET_UserScores.php',
    //   type: 'post',
    //   data: userid,
    //   success: function(data) {
    //     var out;
    //     console.log(data);
    //     out = JSON.parse(data);
    //     console.log(out);
    //     total_tok.value   = out.total_tokens;
    //     cur_tok.value     = out.current_tokens;
    //     cur_sc.value      = out.total_score;
    //     total_sc.value    = out.current_score;
    //   },
    //   error: function(e){
    //     console.log('Error has occured contact your system Administrator');
    //   }
    // });

  }