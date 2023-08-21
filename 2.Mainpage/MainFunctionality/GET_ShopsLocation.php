<?php

require_once "C:/xampp/htdocs/web-v.1.0.0.1/ApacheRESTServices/SETUP_connection.php";

$case = json_decode($_POST['call_case']);

if($case===0){
    
    $sth = $pdo->prepare("CALL F_ShopOffer();");
    $sth->execute();
    $result = $sth->fetchAll(\PDO::FETCH_ASSOC);

    echo json_encode($result); //ALL shops that Have an Offer Available
}
elseif($case===1){

    $_name=json_decode($_POST['shop_name']);

    $sth = $pdo->prepare("SELECT id,name,address,description,has_Offer,latitude,longitude FROM object_shop WHERE name=:in_name");
    $sth->execute(array(':in_name'=>$_name));
    $result = $sth->fetchAll(\PDO::FETCH_ASSOC);
    
    echo json_encode($result); //ALL shops that Have a name specified

}
elseif($case===2){
    
    $item_category=json_decode($_POST['item_cat']);

    $sth = $pdo->prepare("CALL F_ShopItemCategory(:in_category_name);");
    $sth->execute(array(':in_category_name'=>$item_category));
    $result = $sth->fetchAll(\PDO::FETCH_ASSOC);

    echo json_encode($result); //returning the array for every shop that has Offer but its outside Radius

}


?>
