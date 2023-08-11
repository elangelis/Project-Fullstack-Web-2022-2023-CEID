<?php


include_once "./ApacheRESTServices/SETUP_connection.php";


$sth = $pdo->prepare("SELECT id,name,category_id FROM object_subcategory");
$sth->execute();
$result = $sth->fetchAll(\PDO::FETCH_ASSOC);

echo json_encode($result); //returning the array

?>