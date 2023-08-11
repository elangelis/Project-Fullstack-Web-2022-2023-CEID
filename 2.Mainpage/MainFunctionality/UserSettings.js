


const pass_input = document.getElementById("Change_Password");
const Conf_pass_input = document.getElementById("Confirm_Password");
const Change_Email=document.getElementById("Change_Email");
const Change_User=document.getElementById("Change_User");


const Show_Password = document.getElementById("Show_Password");
const Update_Credentials = document.getElementById("Update_Credentials");

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
          data:  {usernewdata:JSON.stringify(userdata)},
          type: "POST",
          success: function(){    
            window.location.reload();
            console.log(userdata);
            FindOffersTable();
            return true;
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


