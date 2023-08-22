


var pass_input = document.getElementById("Change_Password");
var Conf_pass_input = document.getElementById("Confirm_Password");
var Change_Email=document.getElementById("Change_Email");
var Change_User=document.getElementById("Change_User");


var Show_Password = document.getElementById("Show_Password");
var Update_Credentials = document.getElementById("Update_Credentials");

Show_Password.addEventListener("click", function () {
  
  const type_pass = pass_input.getAttribute("type") === "password" ? "text" : "password";
  pass_input.setAttribute("type", type_pass);
  
  const type_conf_pass = Conf_pass_input.getAttribute("type") === "password" ? "text" : "password";
  Conf_pass_input.setAttribute("type", type_conf_pass);

});


$( "#Change_Credentials_Form" ).submit(
  function UpdateCredentials() {
    if(confirm("Are you sure you want to update your credentials")==true){
      var userdata = {};
      userdata.pass       = $( "#Change_Password" ).val();
      userdata.conf_pass  = $( "#Confirm_Password" ).val();
      userdata.user       = $( "#Change_User" ).val();
      userdata.email      = $( "#Change_Email" ).val();

      $.ajax({
          url: "UserSettings.php",
          type: "POST",
          data:  {usernewdata:JSON.stringify(userdata)},
          success: function(e){    
            let response=JSON.parse(e);
            console.log(response);
            window.location.reload();
            console.log(userdata);
            // FindOffersTable();
            
          },
          error:function(e){
            let response=JSON.parse(e);
            console.log(response);
          }
      });
      // simple way to prevent default action of form submission:
      return false;
    }else
    {
      return false;
    }
    
  }
);


