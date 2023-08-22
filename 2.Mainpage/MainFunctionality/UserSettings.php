<?php
    
    
    require_once "C:/xampp/htdocs/web-v.1.0.0.1/ApacheRESTServices/SETUP_connection.php";

    echo json_encode($_SESSION['User ID']);
    return;
    
    $usernewdata = json_decode($_POST['usernewdata']);

    $password           =   $usernewdata    ->pass;
    $confirm_password   =   $usernewdata    ->conf_pass;
    $e_mail             =   $usernewdata    ->email;
    $username           =   $usernewdata    ->user;
    $error=true;
    
    
    
    try{
        
        $sql_update_credentials='UPDATE object_user SET username=:in_username,password=:in_password,email=:in_email WHERE id=:in_User_ID';

        $update= $pdo->prepare($sql_update_credentials);
        $update->execute(array(':in_username'=>$username,':in_password'=>$password,':in_email'=>$e_mail,':in_User_ID'=>$_SESSION['User ID']));
        $error=false;
    }catch (PDOException $e){
        $error=true;
    }

    if ($error===false){
        $_SESSION['Logged User']=$username;
        $_SESSION['Logged Password']=$password;
        $_SESSION['Logged Confirm Password']=$password;
        $_SESSION['Logged Email']=$e_mail;
    }  
?>