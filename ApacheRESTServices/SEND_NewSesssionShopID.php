<?php

require_once "C:/xampp/htdocs/web-v.1.0.0.1/ApacheRESTServices/SETUP_connection.php";

    $in_shopid=0;

    $in_shopid=json_decode($_POST['shop_id']);

    try
    {
        $sql_check_shopexists = 'SELECT COUNT(id) FROM object_shop WHERE id=:in_shop_id';
        $count_shop_exists= $pdo->prepare($sql_check_shopexists);
        $count_shop_exists->bindParam(':in_shop_id',$in_shopid,PDO::PARAM_STR_CHAR);
        $count_shop_exists->execute();
    
        $shop_exist= $count_shop_exists->fetchColumn();
        if ($shop_exist<>0){
    
            $_SESSION['session_shopid']=$in_shopid;
            
            echo json_decode($_SESSION['session_shopid']);

        }
    }
    catch (PDOException $e)
    {
        echo json_encode($e);
    }
  
    


?>