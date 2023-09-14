<!DOCTYPE html>
<html lang="en">  
  <head>
    <title>First Connect to mysql</title>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="LoginPage.css">
  </head>
  
  <body>  
    <div class="form">
      <div>
        <?php
            require_once "C:/xampp/htdocs/web-v.1.0.0.1/ApacheRESTServices/SETUP_connection.php";    
            echo session_id(); 
        ?>
      </div>
      <h2>Web Project 2022-2023</h2>
      <div 
        class="form-toggle">
      </div>
      <div 
        class="form-panel one">
        <div class="form-header">
          <h1>Sign in
            <p>
            </p>
          </h1>
        </div>
        <div class="form-content">
          <div>
            <div class="form-group">
              <label for="username">Username</label>
              <input type="text" id="username" name="login_user" required="required"/>
            </div>
            <div class="form-group">
              <label for="password">Password</label>
              <input type="password" id="password" name="login_pass" required="required"/>
            </div>
            <div class="form-group">
              <label for="email">email</label>
              <input type="email" id="Email" name="login_email" required="required"/>
            </div>
            <div class="form-group">
              <label class="form-remember">
                <input type="checkbox"/>Remember Me
              </label><a class="form-recovery" href="#">Forgot Password?</a>
            </div>
            <div class="form-group">
              <button id="Login_button_page" type="submit" name='Log_In_button'>Log In</button>
            </div>
          </div> 
        </div>
      </div>
      <div class="form-panel two">
        <div class="form-header">
          <h1>Register Account</h1>
        </div>
        <div class="form-content">
          <div>
            <div class="form-group">
              <label for="reg_user">Username</label>
              <input type="text" id="reg_user" name="reg_user" required="required"/>
            </div>
            <div class="form-group">
              <label for="reg_pass">Password</label>
              <input type="password" id="reg_pass" name="reg_pass" required="required"/>
              <php>
                
              </php>
            </div>
            <div class="form-group">
              <label for="reg_conf_pass">Confirm Password</label>
              <input type="password" id="reg_conf_pass" name="reg_conf_pass" required="required"/>
            </div>
            <div class="form-group">
              <label for="reg_email">Email Address</label>
              <input type="email" id="reg_email" name="reg_email" required="required"/>
            </div>
            <div class="form-group">
              <button id="Register_button_page" type="submit"name='Register_button'>Register</button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="pen-footer">
      <!-- <a href="https://github.com/elangelis/Web_Project-full-stack" target="_blank"> -->
      <a href="www.google.com" target="_blank">
          <i 
              class="material-icons"><--
          </i>
          <b> View/Download Source Code on Github </b>
      </a>
      <a href="https://eclass.upatras.gr/modules/document/file.php/CEID1092/%CE%95%CF%81%CE%B3%CE%B1%CF%83%CF%84%CE%B7%CF%81%CE%B9%CE%B1%CE%BA%CE%AE%20%CE%86%CF%83%CE%BA%CE%B7%CF%83%CE%B7%202022%20-%202023/Ergastiriaki_Askisi_22-23-v1.0.pdf" target="_blank">
        <b> Project_Ceid_Upatras:</b>
        <i 
          class="material-icons">
        </i>
      </a>
    </div-->
    <div>
      <script type="text/javascript" src="../AdditionalFiles/JS_jquery-3.6.4.js"></script>
      <script type="text/javascript" src="LoginPage.js"></script>
      <script type="text/javascript" src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    </div>
  </body>
</html>
