<?php

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

