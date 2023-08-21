<?php

    
require_once "C:/xampp/htdocs/web-v.1.0.0.1/ApacheRESTServices/SETUP_connection.php";


$sth = $pdo->prepare("CALL F_GetOffersProductUser();");
$sth->execute();
$result = $sth->fetchAll(\PDO::FETCH_ASSOC);

echo json_encode($result); //returning the array

?>