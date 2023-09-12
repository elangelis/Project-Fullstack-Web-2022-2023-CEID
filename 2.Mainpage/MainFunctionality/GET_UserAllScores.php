
<?php


require_once "C:/xampp/htdocs/web-v.1.0.0.1/ApacheRESTServices/SETUP_connection.php";




try{
     if(isset($_SESSION['User ID']))
     {
          $userid=$_SESSION['User ID'];
     
          if(isset($userid))
          {
          

          $sql_check_shopexists    = 'CALL Database_UserScores(:in_userid)';
          $count_shop_exists       = $pdo->prepare($sql_check_shopexists);
          $count_shop_exists->bindParam(':in_userid',$userid);
          $count_shop_exists->execute();

          $result = $count_shop_exists->fetchAll();
          echo json_encode($result); //returning the array     
          return;
          }
          else
          {
               
               echo json_encode('nouserid');
               return;
          }
     }
}
catch(Exception $e)
{
     echo json_encode($e);
}


?>