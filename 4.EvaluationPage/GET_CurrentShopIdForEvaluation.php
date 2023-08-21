<?php

    
require_once "C:/xampp/htdocs/web-v.1.0.0.1/ApacheRESTServices/SETUP_connection.php";

    if(isset($_SESSION['session_shopid'])){
        echo $_SESSION['session_shopid'];
    }else{
        echo json_encode("error");
    }

?>