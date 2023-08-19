<?php

    require_once "C:/xampp/htdocs/Web_Project-full-stack/ApacheRESTServices/SETUP_connection.php";
    
    
    
    
    if(isset($_POST['id'])&&isset($_POST['status'])){
        $status=json_decode($_POST['status']);    
        $offerid=json_decode($_POST['id']);

        try{
            $sth = $pdo->prepare('CALL ChangeOfferStockStatus(:in_offerid,:in_status);');
            $changestatus_try= $pdo->prepare($sth);
            $changestatus_try->execute(array(':in_offerid'=>$offerid,':in_status'=>$status));
            
        }catch (PDOException $e){
            echo json_encode('error');
            return;
        }

        if ($status==true){
            echo json_encode('Changed status succesfuly to:  Available'); //returning the array
            return;    
        }elseif($status==false){
            echo json_encode('Changed status succesfuly to:  Unavailable'); //returning the array
            return;   
        }
    }




?>