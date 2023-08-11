<?php

include_once "./ApacheRESTServices/SETUP_connection.php";


$sth = $pdo->prepare("CALL F_GetOffersProductUser();");
$sth->execute();
$result = $sth->fetchAll(\PDO::FETCH_ASSOC);

echo json_encode($result); //returning the array

?>