<?php

require_once "C:/xampp/htdocs/web-v.1.0.0.1/ApacheRESTServices/SETUP_connection.php";

    $in_shopid=json_decode($_POST['shop_id']);

    try{
        $sth = $pdo->prepare('CALL I_ShopGetOffers(:in_shopid);');
        $sth->bindParam('in_shopid', $in_shopid, PDO::PARAM_INT);
        $sth->execute();
        $result = $sth->fetchAll(\PDO::FETCH_ASSOC);

    }catch (PDOException $e){
      echo json_encode($e);
    }


    echo json_encode($result); //returning the array


?>