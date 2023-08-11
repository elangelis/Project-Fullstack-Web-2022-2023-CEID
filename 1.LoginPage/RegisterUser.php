<?php


<<<<<<< HEAD
    require_once "C:/xampp/htdocs/Web_Project-full-stack/ApacheRESTServices/SETUP_connection.php";
=======
    require_once "./ApacheRESTServices/SETUP_connection.php";
>>>>>>> 1b5fb0b1de7b1f5074f6655be32093823ab03dd2

    $reg_user="";
    $reg_pass= "";
    $reg_email= "";
    $reg_confirm_password= "";
    $success_register = false;
    $password_conditions = '/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?!.* )(?=.*[^a-zA-Z0-9]).{8,}$/m';

<<<<<<< HEAD
    if(isset($_POST['user'])){
        try{
            $user1=json_decode($_POST['user']);
            if(isset($user1)){
                $reg_user               =   $user1->user;
                $reg_pass               =   $user1->pass;
                $reg_email              =   $user1->email;
                $reg_confirm_password   =   $user1->conf_pass;
            }else{
               echo json_encode('An Error has Occured.Contact your System Administrator.');
               return; 
            }
        }catch(Exception $e){
            echo json_encode('An Error has Occured.Contact your System Administrator.');
            return;
        }
    }
    
    if(isset($_POST['user'])){
        if(isset($_SESSION['login_user'])){
        
            echo json_encode('You have already Logged in, you will be redirected to Main Page automatically');
    
            header('location: ./2.Mainpage/MainMenuPage.php');
    
            return;
        }
        else
        {
            if(isset($reg_user)&&isset($reg_pass)&&isset($reg_email)&&isset($reg_confirm_password)){
                
                if($reg_user != "" || $reg_pass != "" || $reg_email != "" || $reg_confirm_password != ""){
    
                    if($reg_pass == $reg_confirm_password){
        
                        if(preg_match('/^(?=.*\d)(?=.*[A-Za-z])[0-9A-Za-z!@#$%]{8,}$/', $reg_pass)) {
                            
                            $success_register=true;
                            $user_taken=false;
                            $password_taken=false;
                            $email_taken=false;
        
                            $sql_check_user = 'SELECT COUNT(id) FROM object_user WHERE username=:reg_user';
                            $count_user= $pdo->prepare($sql_check_user);
                            $count_user->bindParam(':reg_user',$reg_user,PDO::PARAM_STR_CHAR);
                            $count_user->execute();
        
                            $user_exists= $count_user->fetchColumn();
                            if ($user_exists<>0){
        
                                $success_register=false;
                                echo json_encode('User is already taken! Please Change your username.');
                                return;
                            }
        
                            $sql_check_pass = 'SELECT COUNT(id) FROM object_user WHERE password=:reg_pass';
                            $count_pass= $pdo->prepare($sql_check_pass);
                            $count_pass->bindParam(':reg_pass',$reg_pass,PDO::PARAM_STR_CHAR);
                            $count_pass->execute();
                            $pass_exists= $count_pass->fetchColumn();
                            if ($pass_exists<>0){
                                $success_register=false;
                                echo json_encode('Password is already taken! Please Change your Password.');
                                return;
                            }
        
                            $sql_check_email = 'SELECT COUNT(*) as total_1 FROM object_user WHERE email=:reg_email';
                            $count_email= $pdo->prepare($sql_check_email);
                            $count_email->bindParam(':reg_email',$reg_pass,PDO::PARAM_STR_CHAR);
                            $count_email->execute();
                            $email_exists= $count_email->fetchColumn();
                            if ($email_exists<>0){
                                $success_register=false;
                                echo json_encode('Email is already taken! Please Change your Email.');
                                return;
                            }
    
                            if($success_register==true){
                                try{
    
                                    $sql_register= 'CALL M_UserCreation(:reg_user, :reg_pass, :reg_email)';
                                    $statement = $pdo->prepare($sql_register);
                                    $statement->bindParam(':reg_user',$reg_user,PDO::PARAM_STR_CHAR);
                                    $statement->bindParam(':reg_pass',$reg_pass,PDO::PARAM_STR_CHAR);
                                    $statement->bindParam(':reg_email',$reg_pass,PDO::PARAM_STR_CHAR);
                                    $statement->execute();
        
                                    $Get_user_id='SELECT id from object_user WHERE username=:in_username AND email=:in_email';
                                    $get= $pdo->prepare($Get_user_id);
                                    $get->execute(array(':in_username'=>$login_username,':in_email'=>$login_email));
                                    
                                    $_SESSION['User ID']=$get->fetchColumn();
                                    $_SESSION['Logged User']=$reg_user;
                                    $_SESSION['Logged Password']=$reg_pass;
                                    $_SESSION['Logged Confirm Password']=$reg_confirm_password;
                                    $_SESSION['Logged Email']=$reg_email;
    
                                    session_regenerate_id();                            
                                    header('location: ./2.Mainpage/MainMenuPage.php');
                                    return;   
                                }
                                catch(PDOException $e){
                                    echo json_encode('An Error has Occured.Contact your System Administrator.');
                                    return; 
                                }   
                            }
                        }else{
                            echo json_encode('Password must contain 1 Capital letter, 1 Number and any of those "  @ # $ %  " symbols and more than 8 Characters');
                            return;
                        }
                    }
                    else{
                        echo json_encode('Confirmation Password should match Password');
                        return;
                    }
                }else{
                    echo json_encode('An Error has Occured.Contact your System Administrator.');
                    return; 
=======
    try{
        $user1=json_decode($_POST['user']);
        if(isset($user1)){
            $reg_user               =   $user1->user;
            $reg_pass               =   $user1->pass;
            $reg_email              =   $user1->email;
            $reg_confirm_password   =   $user1->conf_pass;
        }else{
           echo json_encode('An Error has Occured.Contact your System Administrator.');
           return; 
        }
    }catch(Exception $e){
        echo json_encode('An Error has Occured.Contact your System Administrator.');
        return;
    }

    
    if(isset($_SESSION['login_user'])){
        
        echo json_encode('You have already Logged in, you will be redirected to Main Page automatically');

        header('location: ./2.Mainpage/MainMenuPage.php');

        return;
    }
    else
    {
        if(isset($reg_user)&&isset($reg_pass)&&isset($reg_email)&&isset($reg_confirm_password)){
            
            if($reg_user != "" || $reg_pass != "" || $reg_email != "" || $reg_confirm_password != ""){

                if($reg_pass == $reg_confirm_password){
    
                    if(preg_match('/^(?=.*\d)(?=.*[A-Za-z])[0-9A-Za-z!@#$%]{8,}$/', $reg_pass)) {
                        
                        $success_register=true;
                        $user_taken=false;
                        $password_taken=false;
                        $email_taken=false;
    
                        $sql_check_user = 'SELECT COUNT(id) FROM object_user WHERE username=:reg_user';
                        $count_user= $pdo->prepare($sql_check_user);
                        $count_user->bindParam(':reg_user',$reg_user,PDO::PARAM_STR_CHAR);
                        $count_user->execute();
    
                        $user_exists= $count_user->fetchColumn();
                        if ($user_exists<>0){
    
                            $success_register=false;
                            echo json_encode('User is already taken! Please Change your username.');
                            return;
                        }
    
                        $sql_check_pass = 'SELECT COUNT(id) FROM object_user WHERE password=:reg_pass';
                        $count_pass= $pdo->prepare($sql_check_pass);
                        $count_pass->bindParam(':reg_pass',$reg_pass,PDO::PARAM_STR_CHAR);
                        $count_pass->execute();
                        $pass_exists= $count_pass->fetchColumn();
                        if ($pass_exists<>0){
                            $success_register=false;
                            echo json_encode('Password is already taken! Please Change your Password.');
                            return;
                        }
    
                        $sql_check_email = 'SELECT COUNT(*) as total_1 FROM object_user WHERE email=:reg_email';
                        $count_email= $pdo->prepare($sql_check_email);
                        $count_email->bindParam(':reg_email',$reg_pass,PDO::PARAM_STR_CHAR);
                        $count_email->execute();
                        $email_exists= $count_email->fetchColumn();
                        if ($email_exists<>0){
                            $success_register=false;
                            echo json_encode('Email is already taken! Please Change your Email.');
                            return;
                        }

                        if($success_register==true){
                            try{

                                $sql_register= 'CALL M_UserCreation(:reg_user, :reg_pass, :reg_email)';
                                $statement = $pdo->prepare($sql_register);
                                $statement->bindParam(':reg_user',$reg_user,PDO::PARAM_STR_CHAR);
                                $statement->bindParam(':reg_pass',$reg_pass,PDO::PARAM_STR_CHAR);
                                $statement->bindParam(':reg_email',$reg_pass,PDO::PARAM_STR_CHAR);
                                $statement->execute();
    
                                $Get_user_id='SELECT id from object_user WHERE username=:in_username AND email=:in_email';
                                $get= $pdo->prepare($Get_user_id);
                                $get->execute(array(':in_username'=>$login_username,':in_email'=>$login_email));
                                
                                $_SESSION['User ID']=$get->fetchColumn();
                                $_SESSION['Logged User']=$reg_user;
                                $_SESSION['Logged Password']=$reg_pass;
                                $_SESSION['Logged Confirm Password']=$reg_confirm_password;
                                $_SESSION['Logged Email']=$reg_email;

                                session_regenerate_id();                            
                                header('location: ./2.Mainpage/MainMenuPage.php');
                                return;   
                            }
                            catch(PDOException $e){
                                echo json_encode('An Error has Occured.Contact your System Administrator.');
                                return; 
                            }   
                        }
                    }else{
                        echo json_encode('Password must contain 1 Capital letter, 1 Number and any of those "  @ # $ %  " symbols and more than 8 Characters');
                        return;
                    }
                }
                else{
                    echo json_encode('Confirmation Password should match Password');
                    return;
>>>>>>> 1b5fb0b1de7b1f5074f6655be32093823ab03dd2
                }
            }else{
                echo json_encode('An Error has Occured.Contact your System Administrator.');
                return; 
            }
<<<<<<< HEAD
        }
    }
    
=======
        }else{
            echo json_encode('An Error has Occured.Contact your System Administrator.');
            return; 
        }
    }
>>>>>>> 1b5fb0b1de7b1f5074f6655be32093823ab03dd2


?>
