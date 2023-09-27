

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
    }else if(e.key == "Enter" && textinput == ""){
      Create_MarkersForAllShopsWithOffers();
      Create_PopUpbodyForMarkers();
      Create_LayerGroupsForMarkers();
      Create_EventListenersForMarkers();
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
    }else if(e.key == "Enter" && textinput == ""){
      Create_MarkersForAllShopsWithOffers();
      Create_PopUpbodyForMarkers();
      Create_LayerGroupsForMarkers();
      Create_EventListenersForMarkers();
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
      success: function(data) {
        e=JSON.parse(data);
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

  let created=false;
  const myInterval = setInterval(dosomething, 1000);


  function dosomething() {
    CreateLikesHistoryTable();
    CreateOffersHistoryTable();
    GetUserScore();
    // navigator.geolocation.watchPosition(success, errorCallback, options);
    clearInterval(myInterval);
  }



function CreateLikesHistoryTable(){
  var LikesHistoryTable_User={};
  let table =document.getElementById('likes_history_body');
  let tablebody='';
  let tablerow='';

  $.ajax({
    url: 'MainFunctionality/Get_UserAllLikesHistory.php',
    type: 'post',
    success: function(data) {
      console.log(data);
      if (JSON.parse(data)!='nouserid')
      {
        LikesHistoryTable_User=JSON.parse(data);
        console.log(LikesHistoryTable_User);
        if(LikesHistoryTable_User.length>0){
          i=1;
          LikesHistoryTable_User.forEach(row => {
            
            let no='';
            let action='';
            let offerno='';
            let date='';
            let publisher='';
            let shopname='';
            
            no=i;
            
            if(row.action!=undefined){
              action=row.action;
            }
            if(row.offer_id!=undefined){
              offerno=row.offer_id;
            }
            if(row.date!=undefined){
              date=row.date;
            }
            if(row.offer_user!=undefined){
              publisher=row.offer_user;
            }
            if(row.shop_name!=undefined){
              shopname=row.shop_name;
            }
            tablerow= '<tr id="likes_row'+i+'" class="likes_row">'+
                        '<td class="likes_cell_rank">'+no+'</td>'+
                        '<td class="likes_cell">'+action+'</td>'+
                        '<td class="likes_cell">'+offerno+'</td>'+
                        '<td class="likes_cell">'+date+'</td>'+
                        '<td class="likes_cell">'+publisher+'</td>'+
                        '<td class="likes_cell">'+shopname+'</td>'+
                      '</tr>';
            tablebody+=tablerow;
            i++;
          });    
          table.innerHTML=tablebody;
        }
      }
    },
    error:function(e){
      console.log(e);
    }

  });
}

function CreateOffersHistoryTable(){
  
  var OffersHistoryTable_User={};
  let table =document.getElementById('offer_history_body');
  let tablebody='';
  let tablerow='';

  $.ajax({
    url: 'MainFunctionality/Get_UserAllOfferHistory.php',
    type: 'post',
    success: function(data) {
      
      console.log(data);
      if (JSON.parse(data)!='nouserid')
        {
          OffersHistoryTable_User=JSON.parse(data);
          console.log(OffersHistoryTable_User);
          if(OffersHistoryTable_User.length>0){
            i=1;
            OffersHistoryTable_User.forEach(row => {
              
              let no='';
              let offerid='';
              let sumbdate='';
              let price='';
              let shop='';
              let product='';
              
              no=i;
              
              if(row.offer_id!=undefined){
                offerid=row.offer_id;
              }
              if(row.creation_date!=undefined){
                sumbdate=row.creation_date;
              }
              
              if(row.offer_price!=undefined){
                price=row.offer_price;
              }
              if(row.shop_name!=undefined){
                shop=row.shop_name;
              }
              
              if(row.product_name!=undefined){
                product=row.product_name;
              }
              tablerow= '<tr id="offer_row'+i+'" class="offer_row">'+
                          '<td class="offer_cell_rank">'+no+'</td>'+
                          '<td class="offer_cell">'+offerid+'</td>'+
                          '<td class="offer_cell">'+sumbdate+'</td>'+
                          '<td class="offer_cell">'+price+'</td>'+
                          '<td class="offer_cell">'+shop+'</td>'+
                          '<td class="offer_cell_product">'+product+'</td>'+
                        '</tr>';
              tablebody+=tablerow;
              i++;
            });    
            table.innerHTML=tablebody;
          }
      }
    },
    error:function(e){
      console.log(e);
    }
  });
}

function GetUserScore(){
    let total_tok = document.getElementById('total_tokens');
    let cur_tok = document.getElementById('current_tokens');

    let total_sc = document.getElementById('total_score');
    let cur_sc = document.getElementById('current_score');

    $.ajax({
      url: 'MainFunctionality/GET_UserAllScores.php',
      type: 'post',
      success: function(data) {
        var out;
        console.log(data);
        if (JSON.parse(data)!='nouserid')
        {
        out = JSON.parse(data);
        console.log(out);
        total_tok.innerText   = out[0].tokens_total;
        cur_tok.innerText     = out[0].tokens_month;
        cur_sc.innerText      = out[0].score_month;
        total_sc.innerText    = out[0].score_total;
        }
      },
      error: function(e){
        console.log('Error has occured contact your system Administrator');
      }
    });

  }