<?php

    require_once "./ApacheRESTServices/SETUP_connection.php";
    
    unset($_SESSION['User ID']);
    unset($_SESSION['Logged User']);
    unset($_SESSION['Logged Password']);
    unset($_SESSION['Logged Confirm Password']);
    unset($_SESSION['Logged Email']);
    

    session_reset();

    header('location: ./1.LoginPage/LoginMenuPage.php');
    
?>