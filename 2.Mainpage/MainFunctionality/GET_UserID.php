<?php

    require_once "C:/xampp/htdocs/web-v.1.0.0.1/ApacheRESTServices/SETUP_connection.php";


    if(isset($_SESSION['User ID'])){
        echo json_encode($_SESSION['User ID']);
    }else{
        echo json_encode('error');
    }

?>