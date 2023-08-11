<?php


    require "./ApacheRESTServices/SETUP_connection.php";

        
    $opt = json_decode($_POST['option']);


    if(isset($opt)){
        if($opt==1){
            try{
                $deleteall = 'CALL DeleteAllData();';
                $trydeleteall= $pdo->prepare($deleteall);
                $trydeleteall->execute();
    
            }catch(Exception $e){
                echo json_encode('error');
                return;
            }
            echo json_encode('Deleted All Data Succesfuly');
            return;
            
        }elseif($opt==2){
            try{
                $deletePOI = 'CALL DeleteAllData();';
                $trydeletePOI= $pdo->prepare($deletePOI);
                $trydeletePOI->execute();

            }catch(Exception $e){
                echo json_encode('error');
                return;
            }
            echo json_encode('Deleted POI Data Succesfuly');
            return;
        }
    }

?>
