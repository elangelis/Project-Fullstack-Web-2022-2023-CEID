<?php

require_once "C:/xampp/htdocs/web-v.1.0.0.1/ApacheRESTServices/SETUP_connection.php";
    
    unset($_SESSION['User ID']);
    unset($_SESSION['Logged User']);
    unset($_SESSION['Logged Password']);
    unset($_SESSION['Logged Confirm Password']);
    unset($_SESSION['Logged Email']);
    

    session_reset();

    header('location: ./1.LoginPage/LoginMenuPage.php');
    
?>