<?php

require_once "C:/xampp/htdocs/web-v.1.0.0.1/ApacheRESTServices/SETUP_connection.php";

        
    $opt = json_decode($_POST['option']);


    if(isset($opt)){
        if($opt==1){
            try{
                $deleteall = 'CALL DeleteAllData();';
                $trydeleteall= $pdo->prepare($deleteall);
                $trydeleteall->execute();
            
            }catch(Exception $e){
                echo json_encode($e);
                return;
            }
            echo json_encode('success');
            return;

        }elseif($opt==2){
            try{
                $deletePOI = 'CALL DeleteAllData();';
                $trydeletePOI= $pdo->prepare($deletePOI);
                $trydeletePOI->execute();

            }catch(Exception $e){
                echo json_encode($e);
                return;
            }
            echo json_encode('success');
            return;
        }
    }

?>
