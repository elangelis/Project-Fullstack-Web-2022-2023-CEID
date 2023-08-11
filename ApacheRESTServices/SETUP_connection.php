<?php

<<<<<<< HEAD
=======
//database connection
// require_once 'SETUP_config.php';

require_once "./ApacheRESTServices/SETUP_config.php";
>>>>>>> 1b5fb0b1de7b1f5074f6655be32093823ab03dd2

	require_once "C:/xampp/htdocs/Web_Project-full-stack/ApacheRESTServices/SETUP_config.php";

	session_start();

	global $pdo;


	$dsn = "mysql:host=$db_host;dbname=$db_name;charset=UTF8";

	try {

		$options = [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION];

		$pdo=new PDO($dsn, $db_user, $db_password, $options);
		//echo 'Connection to MySql Succesful';

	} catch(PDOException $e){

		die($e->getMessage());
		exit('Database error');

	}

?>

