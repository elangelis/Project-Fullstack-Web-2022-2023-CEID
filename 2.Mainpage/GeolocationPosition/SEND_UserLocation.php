<?php
    
    require_once "C:/xampp/htdocs/web-v.1.0.0.1/ApacheRESTServices/SETUP_connection.php";

    $userData = json_decode($_POST['userdata1']);
    $lat=$userData->lat;
    $long=$userData->long;

    if(isset($_SESSION['Logged User'])){
        $User_name=$_SESSION['Logged User'];
    }

    $sql_update_location='UPDATE object_user SET latitude=:in_latitude, longitude=:in_longitude WHERE username=:in_User_ID';
    $update= $pdo->prepare($sql_update_location);
    $update->execute(array(':in_latitude'=>$lat,':in_longitude'=>$long,':in_User_ID'=>$User_name));

?>
