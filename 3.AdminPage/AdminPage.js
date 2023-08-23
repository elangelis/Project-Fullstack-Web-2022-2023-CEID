


  var JsonContent;
  var min_counter=1;
  var counter=1;
  var UserLeaderboardData=[];

  var next = document.getElementById('next');
  var previous = document.getElementById('previous');
  var current = document.getElementById('current');

  var ShopsArray=[];

  window.onload=InitialisePage();

  function InitialisePage(){
    
    GetData();

    document.getElementById("option1").addEventListener("change", function() {
      GetContent(1);      
    });
    
    document.getElementById("option2").addEventListener("change", function() {
      GetContent(2);      
    });
    
    document.getElementById("option3").addEventListener("change", function() {
      GetContent(3);      
    });

    document.getElementById("option4").addEventListener("click", function() {
      
      GetShopFromOverpassAPI_BasedOnLocation();
    });


  
    document.getElementById("option5").addEventListener("click", function() {
      if(confirm("Are you sure you want to Delete current POI's From Database ?")){
        if(confirm("Are you REALLY sure you want to DELETE ALL POI's ?")){
          DeletePOISDataMysql();  
        }
      }
    });

    document.getElementById("option6").addEventListener("click", function() {
      if(confirm('Are you sure you want to Delete current Data From Database?')){
        if(confirm('Are you REALLY sure you want to DELETE ALL DATA?')){
          DeleteAllDataMysql();  
        }
      }
    });

    previous.addEventListener('click',function(){
      max_counter=CalcMaxCounter();
      if((min_counter<counter)){
        counter--;
        ShowTable(counter);
        current.innerText = counter;
      }
    });
    
    
    next.addEventListener('click',function(){
      max_counter=CalcMaxCounter();
      if((counter<max_counter)){
        counter++;
        ShowTable(counter);
        current.innerText = counter;
      }
    });
  }




//Read Input files Content
  
  function GetContent(option){
    if(JsonContent!=undefined){
      JsonContent.length=0;
    }
    var element ='option'+option;
    var file_to_read = document.getElementById(element).files[0];
    var fileread = new FileReader();

    if(fileread.readyState==0){
      console.log(fileread.readyState);
    }
    fileread.onload = function(e) {
        var content = e.target.result;
        JsonContent = JSON.parse(content);  
    };
    fileread.onloadend = () => {
      
      if(option==1){
        console.log(JsonContent);
        PostToMysql(JsonContent,option);

      }else if(option==2){
        console.log(JsonContent);
        PostToMysql(JsonContent,option);
      
      }else if(option==3){
        console.log(JsonContent);
        InsertPOISintoDatabase(JsonContent);
      
      }

    };
    fileread.readAsText(file_to_read);

  }




  
  // Create Leaderboard Table


  function GetData(){
    GetLeaderBoardData();

    
  }

  function CreateLeaderBoardTable(User_Array){
    
    var tablebody=document.getElementById('boardmenu_body');
    var finalbody='';
    var i=0;

    User_Array.forEach(row => {
        
        i++;

        let username='';
        let full_name='';
        let total_score='';
        let date_created='';
        let offers_created='';
        let likes='';
        let dislikes='';
        let curr_tokens='';
        let tot_tokens='';

        if(row.username!=undefined){
          username=row.username;
        }else{
          username='Empty';
        }
        if(row.full_name!=undefined){
          full_name=row.full_name;
        }else{
          full_name='Empty';
        }
        if(row.total_score!=undefined){
          total_score=row.total_score;
        }else{
          total_score='Empty';
        }
        if(row.date_created!=undefined){
          date_created=row.date_created;
        }else{
          date_created='Empty';
        }
        if(row.offers!=undefined){
          offers_created=row.offers;
        }else{
          offers_created='Empty';
        }
        if(row.likes!=undefined){
          likes=row.likes;
        }else{
          likes='Empty';
        }
        if(row.dislikes!=undefined){
          dislikes=row.dislikes;
        }else{
          dislikes='Empty';
        }
        if(row.current_tokens!=undefined){
          curr_tokens=row.current_tokens;
        }else{
          curr_tokens='0';
        }
        if(row.total_tokens!=undefined){
          tot_tokens=row.total_tokens;
        }else{
          tot_tokens='0';
        }

        var body= '<tr id="row'+i+'" class="boardt_row">'+
                '<td class="boardt_cell_rank">'+i+'</td>'+
                '<td class="boardt_cell">'+username+'</td>'+
                '<td class="boardt_cell">'+full_name+'</td>'+
                '<td class="boardt_cell">'+total_score+'</td>'+
                '<td class="boardt_cell">'+date_created+'</td>'+
                '<td class="boardt_cell">'+offers_created+'</td>'+
                '<td class="boardt_cell">'+likes+'</td>'+
                '<td class="boardt_cell">'+dislikes+'</td>'+
                '<td class="boardt_cell">'+curr_tokens+'</td>'+
                '<td class="boardt_cell">'+tot_tokens+'</td>'+
              '</tr>';
        finalbody=finalbody+body;               
    });

    //Test for pageination
    // let testfinalbody           =' <tr id="row1" class="boardt_row"><td class="boardt_cell_rank">1</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td></tr>';
    // testfinalbody=testfinalbody +' <tr id="row2" class="boardt_row"><td class="boardt_cell_rank">2</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td></tr>';
    // testfinalbody=testfinalbody +' <tr id="row3" class="boardt_row"><td class="boardt_cell_rank">3</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td></tr>';
    // testfinalbody=testfinalbody +' <tr id="row4" class="boardt_row"><td class="boardt_cell_rank">4</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td></tr>';
    // testfinalbody=testfinalbody +' <tr id="row5" class="boardt_row"><td class="boardt_cell_rank">5</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td></tr>';
    // testfinalbody=testfinalbody +' <tr id="row6" class="boardt_row"><td class="boardt_cell_rank">6</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td></tr>';
    // testfinalbody=testfinalbody +' <tr id="row7" class="boardt_row"><td class="boardt_cell_rank">7</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td></tr>';
    // testfinalbody=testfinalbody +' <tr id="row8" class="boardt_row"><td class="boardt_cell_rank">8</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td></tr>';
    // testfinalbody=testfinalbody +' <tr id="row9" class="boardt_row"><td class="boardt_cell_rank">9</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td></tr>';
    // testfinalbody=testfinalbody +' <tr id="row10" class="boardt_row"><td class="boardt_cell_rank">10</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td></tr>';
    // testfinalbody=testfinalbody +' <tr id="row11" class="boardt_row"><td class="boardt_cell_rank">11</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td></tr>';
    // testfinalbody=testfinalbody +' <tr id="row12" class="boardt_row"><td class="boardt_cell_rank">12</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td></tr>';
    // testfinalbody=testfinalbody +' <tr id="row13" class="boardt_row"><td class="boardt_cell_rank">13</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td></tr>';
    // testfinalbody=testfinalbody +' <tr id="row14" class="boardt_row"><td class="boardt_cell_rank">14</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td></tr>';
    // testfinalbody=testfinalbody +' <tr id="row15" class="boardt_row"><td class="boardt_cell_rank">15</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td></tr>';
    // testfinalbody=testfinalbody +' <tr id="row16" class="boardt_row"><td class="boardt_cell_rank">16</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td></tr>';
    // testfinalbody=testfinalbody +' <tr id="row17" class="boardt_row"><td class="boardt_cell_rank">17</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td><td class="boardt_cell">tesadsadsast1123123131321</td></tr>';
    // tablebody.innerHTML=testfinalbody;

    tablebody.innerHTML=finalbody;

  }



//Call to OverPassAPI

function GetShopFromOverpassAPI_BasedOnLocation(){
  const overpassUrl = "https://overpass-api.de/api/interpreter";
  const query = `
  [out:json];
  (  
    node["shop"="convenience"](around:200000, 38.0125, 23.7975);
    node["shop"="supermarket"](around:200000, 38.0125, 23.7975);
  );
  out body;
  >;
  out skel qt;
  out meta;
  `;

  $.ajax({
    url: overpassUrl,
    method: "POST",
    data: query,
    dataType: "json",
    success: function(data) {
      console.log(data);
      InsertPOISintoDatabase(data);

    },
    error: function(xhr, status, error) {
      console.error("Error fetching data:", error);
    }
  });

}


//Calls to PHP


function InsertPOISintoDatabase(datain){
  
  $.ajax({
    url: 'SEND_Admin_POIS.php',
    type: 'post',
    data: {shops:JSON.stringify(datain)},
    success: function(responsedata) {
      console.log(JSON.parse(responsedata));
      // ShopsArray.length=0; 
      // ShopsArray=JSON.parse(responsedata);
      // console.log(ShopsArray);
    },
    error:function(e){
        console.log(e);
    }
  });
}



function GetLeaderBoardData(){
  $.ajax({
    url: '../ApacheRESTServices/GET_Database_AllUserLeaderboard.php',
    type: 'post',
    success: function(responsedata) {
      UserLeaderboardData.length=0; 
      UserLeaderboardData=JSON.parse(responsedata);
      CreateLeaderBoardTable(UserLeaderboardData);
    },
    error:function(e){
        console.log(e);
    }
  });

}


function PostToMysql(JsonContent_in,option_in){
  //Fetch Categories
  var jsonarray=JSON.stringify(JsonContent_in);
  var option=JSON.stringify(option_in);
  $.ajax({
    url: 'AdminPageFunctionality.php',
    type: 'post',
    data: {jsonarray,option},
    success: function(data) {
        var response=JSON.parse(data);
        console.log(response);
    },
    error:function(e){
        console.log(e);
    }
  });

}



  function DeleteAllDataMysql(){

    let selection=1;
    var option=JSON.stringify(selection);
    $.ajax({
      url: 'AdminDeleteData.php',
      type: 'post',
      data: {option},
      success: function(data) {
          var response=JSON.parse(data);
          if (response!=undefined){
            if(response=='error'){
              alert('Couldnt Delete All Data an Error has Occured!')
            }else{
              console.log(response);
            }
          }
      },
      error:function(e){
          console.log(e);
      }
    });
  }


  function DeletePOISDataMysql(){
    let selection=2;
    var option=JSON.stringify(selection);
    $.ajax({
      url: 'AdminDeleteData.php',
      type: 'post',
      data: {option},
      success: function(data) {
        var response=JSON.parse(data);
        if (response!=undefined){
          if(response=='error'){
            alert('Couldnt Delete POI Data an Error has Occured!')
          }else{
            console.log(response);
          }
        }
      },
      error:function(e){
          console.log(e);
      }
    });
  }



  // Page-ination Functions
  function CalcMaxCounter(){
    // UserLeaderboardData.length=15;

    if(UserLeaderboardData.length!=0){
      var array_length=UserLeaderboardData.length;

      if(array_length / 7){
        division=Math.floor(array_length/7);
        // console.log(division);
        // console.log(array_length%7);
        if((array_length  % 7)!=0){
          division = division+1;
          // console.log(division);
        }
      }
      return(division)
    }
    return(0);
  }


  function ShowTable(in_counter){
    
    //Display Current Page-ination
    for (let index = 1; index <= UserLeaderboardData.length; index++) {
      if (document.getElementById('row'+index.toString())!=undefined){
        document.getElementById('row'+index.toString()).visibility='hidden';
        document.getElementById('row'+index.toString()).style.display='none';
      }
    }
    //Display Current Page-ination
    for (let index = 1; index <=7; index++) {
      if (document.getElementById('row'+(index+7*(in_counter-1)).toString())!=undefined){
        document.getElementById('row'+(index+7*(in_counter-1)).toString()).style.display='flex';
      }
    }
    
  }