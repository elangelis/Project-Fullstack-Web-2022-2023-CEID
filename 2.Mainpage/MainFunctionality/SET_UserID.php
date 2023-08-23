<?php

    require_once "C:/xampp/htdocs/web-v.1.0.0.1/ApacheRESTServices/SETUP_connection.php";

    $userid =  json_decode($_POST['userid']);



    unset($_SESSION['User ID']);

    if(isset($userid)){
          $_SESSION['User ID']=$userid;
    }

?>