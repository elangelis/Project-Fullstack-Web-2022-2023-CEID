<?php

include_once "./ApacheRESTServices/SETUP_connection.php";

    if(isset($_SESSION['session_shopid'])){
        echo $_SESSION['session_shopid'];
    }else{
        echo json_encode("error");
    }

?>