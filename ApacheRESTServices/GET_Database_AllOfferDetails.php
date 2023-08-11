<?php

include_once "./ApacheRESTServices/SETUP_connection.php";


$sth = $pdo->prepare("Call Database_AllOffersDetails();");
$sth->execute();
$result = $sth->fetchAll(\PDO::FETCH_ASSOC);


echo json_encode($result); //returning the array

?>