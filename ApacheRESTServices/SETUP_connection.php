

<?php

	require_once "C:/xampp/htdocs/web-v.1.0.0.1/ApacheRESTServices/SETUP_config.php";

	//if(session_unset()){
		session_start();
	//}

	global $pdo;
	$dsn = "mysql:host=$db_host;dbname=$db_name;charset=UTF8";
	try {
		$options = [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION];
		$pdo=new PDO($dsn, $db_user, $db_password, $options);
	} 
	catch(PDOException $e){
		die($e->getMessage());
		exit('Database error');
	}

?>


