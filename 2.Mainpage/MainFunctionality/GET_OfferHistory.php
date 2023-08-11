<?php

require_once "./ApacheRESTServices/SETUP_connection.php";

$sth = $pdo->prepare("SELECT username,password,email,date_creation,latitude,longitude,user_token_month FROM object_user");
$sth->execute();
$result = $sth->fetchAll(\PDO::FETCH_ASSOC);

echo json_encode($result); //returning the array

?>
