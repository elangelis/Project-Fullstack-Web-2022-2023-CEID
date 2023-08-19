<?php

    require_once "C:/xampp/htdocs/Web_Project-full-stack/ApacheRESTServices/SETUP_connection.php";


    if(isset($_SESSION['User ID'])){
        echo json_encode($_SESSION['User ID']);
    }else{
        echo json_encode('error');
    }

?>