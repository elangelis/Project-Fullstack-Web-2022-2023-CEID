
<?php


require_once "C:/xampp/htdocs/web-v.1.0.0.1/ApacheRESTServices/SETUP_connection.php";

if(isset($_SESSION['User ID']))
{
  $userid=$_SESSION['User ID'];
}


try{
     if(isset($userid))
     {
       

       $sql_check_shopexists    = 'CALL Database_AllUserOffers(:in_userid)';
       $count_shop_exists       = $pdo->prepare($sql_check_shopexists);
       $count_shop_exists->bindParam(':in_userid',$userid);
       $count_shop_exists->execute();

       echo json_encode($result); //returning the array     
       return;
     }
     else
     {
          
          echo json_encode('nouserid');
          return;
     }
     
}
catch(Exception $e)
{
     echo json_encode($e);
}


?>