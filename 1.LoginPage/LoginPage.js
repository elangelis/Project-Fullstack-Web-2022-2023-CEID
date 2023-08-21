
//register menu click event
document.querySelector('.form-panel.two').addEventListener('click', function() {
  document.querySelector('.form-toggle').classList.add('visible');
  document.querySelector('.form-panel.one').classList.add('hidden');
  document.querySelector('.form-panel.two').classList.add('active');
});

//log_in menu click event
document.querySelector('.form-toggle').addEventListener('click', function(e) {
  document.querySelector('.form-toggle').classList.remove('visible');
  document.querySelector('.form-panel.one').classList.remove('hidden');
  document.querySelector('.form-panel.two').classList.remove('active');
});


  

  var panelOne = document.querySelector('.form-panel.one');
  var panelTwo = document.querySelector('.form-panel.two');


  var login_button =document.getElementById('Login_button_page');
  login_button.addEventListener('click',function (e){

    let username_login  = document.getElementById('username').value;
    let password_login  = document.getElementById('password').value;
    let email_login     = document.getElementById('Email').value;

    if(username_login!=undefined && password_login!=undefined && email_login!=undefined){
      if(username_login!=''&& password_login!='' && email_login!=''){
        
        var userdata = {};
            userdata.pass       = password_login;
            userdata.user       = username_login;
            userdata.email      = email_login;

          $.ajax({
            url: 'LoginUser.php',
            type: 'post',
            data: {user:JSON.stringify(userdata)},
            success: function(data) {
              let response =JSON.parse(data);
              if(response=='success'){
                
                window.location.href='http://localhost/web-v.1.0.0.1/2.Mainpage/MainMenuPage.php';

              }else if(response=='success_admin'){
                
                window.location.href='http://localhost/web-v.1.0.0.1/3.AdminPage/AdminPage.php';
              
              }else{
                console.log(response);
              }
              console.log(data); 
            },
            error:function(e){
                console.log(e);
                alert('Connection to Database Has failed. Unable to Log in');
            }
          });
      }
      else if(username_login==''){
        alert('Username is required in order to Log in!');
      }else if(email_login==''){
        alert('Email is required in order to Log in!');
      }else if(password_login==''){
        alert('Password is required in order to Log in!');
      }
    }
  })



  var register_button=document.getElementById('Register_button_page');
  register_button.addEventListener('click',function (e){

    let username_register       = document.getElementById('reg_user').value;
    let password_register       = document.getElementById('reg_pass').value;
    let conf_password_register  = document.getElementById('reg_conf_pass').value;
    let email_register          = document.getElementById('reg_email').value;

    if(username_register!=undefined && password_register!=undefined && conf_password_register!=undefined && email_register!=undefined){
      if(username_register!=''&& email_register!='' && password_register!='' && conf_password_register!=''){
        if(CheckPasswordRequirements(password_register,conf_password_register)){
          RegisterUser(username_register,password_register,email_register,conf_password_register);
        }
      }else if(username_register==''){
        alert('Username is required in order to register!');
      }else if(email_register==''){
        alert('Email is required in order to register!');
      }else if(password_register==''){
        alert('Password is required in order to register!');
      }else if(conf_password_register==''){
        alert('Confirmation Password is required in order to register!');
      }
    }
  })


  function CheckPasswordRequirements(pass,conf){
    if(pass.length>=8){
      if(containsUppercase(pass)){
        if(containsNumber(pass)){
          if(containsSymbol(pass)){
            if(pass==conf){
                return(true);
            }
            else{
              alert('Password doesnt match Confirmation Password!');
            }
          }else{
            alert('Password should include at least one Symbol:  #$*&@');
          }
        }else{
          alert ('Password should include at least one number!');
        }
      }else{
        alert('Password should include at least one Capital Letter!')
      }
    }else{
      alert('Password should have more than 8 characters!');
    }
    return(false);
  }

  function containsSymbol(str){
    return /[#$*&@]/.test(str);
  }

  function containsNumber(str){
    return /[0-9]/.test(str);
  }

  function containsUppercase(str) {
    return /[A-Z]/.test(str);
  }

  function RegisterUser(us,pass,email,conf_pass){
    var userdata = {};
    userdata.pass       = us;
    userdata.user       = pass;
    userdata.email      = email;
    userdata.conf_pass  = conf_pass;
    $.ajax({
      url: 'RegisterUser.php',
      type: 'post',
      async: false,
      data: {user:JSON.stringify(userdata)},
      success: function(data) {
        console.log(data); 
      },
      error:function(e){
          console.log(e);
          alert('Connection to Database Has failed. Unable to Register');
      }
    });
  }