<?php

require_once "C:/xampp/htdocs/Web_Project-full-stack/ApacheRESTServices/SETUP_connection.php";

    if(isset($_POST['userid'])){
        
        $userid=json_decode($_POST['userid']);

        try{
            $sth = $pdo->prepare('CALL Database_UserScores(:in_userid);');
            $sth->bindParam('in_userid', $userid, PDO::PARAM_INT);
            $sth->execute();
            $result = $sth->fetchAll(\PDO::FETCH_ASSOC);
    
        }catch (PDOException $e){
          echo json_encode($e);
        }
    
    
        echo json_encode($result); //returning the array

    }
    

?>