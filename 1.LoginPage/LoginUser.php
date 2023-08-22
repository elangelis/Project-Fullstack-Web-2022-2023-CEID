<?php

    
    require_once "C:/xampp/htdocs/web-v.1.0.0.1/ApacheRESTServices/SETUP_connection.php";




    $sucess_login=false;
    $login_username = "";
    $login_password = "";
    $login_email = "";

    if(isset($_POST['user'])){
        try{
        
            $user= json_decode($_POST['user']);
            $login_username = $user->user; 
            $login_password = $user->pass;
            $login_email    = $user->email; 
    
    
        }catch(Exception $e){
            echo json_encode('An Error has occured please Register again.');
            return;
        }
    }
    if(isset($_POST['user'])){
        if(isset($_SESSION['login_user'])){
        
            echo json_encode('success');
    
            return;
        }
        else
        {
            if(isset($login_username) &&isset($login_password) && isset($login_email)){
                
                if($login_username != "" || $login_password != "" || $login_email != ""){    
                    
                    $sql_login_check='SELECT COUNT(id) FROM object_user WHERE username=:login_user AND password=:login_pass AND email=:login_email';
                    $check_login= $pdo->prepare($sql_login_check);
                    $check_login->execute(array(':login_user'=>$login_username,':login_pass'=>$login_password,':login_email'=>$login_email));
                    
                    $user_exists= $check_login->fetchColumn();
                    
                    if( $user_exists==1 ){
                        try{
                            
                            $Get_user_id='SELECT id from object_user WHERE username=:in_username AND email=:in_email';
                            $trygetuserid= $pdo->prepare($Get_user_id);
                            $trygetuserid->execute(array(':in_username'=>$login_username,':in_email'=>$login_email));
                            
                            $_SESSION['User ID']=$trygetuserid->fetchColumn();
        
                            $_SESSION['Logged User']=$login_username;
                            $_SESSION['Logged Password']=$login_password;
                            $_SESSION['Logged Confirm Password']=$login_password;
                            $_SESSION['Logged Email']=$login_email;
                            
                            echo json_encode('success');
                            
                            return;
                        }
                        catch(ErrorException $e){
                            echo json_encode('An Error has occured while accesing the Database. Please contact a system admin.'); 
                            
                            return;
                        }
                    }
                    else{
                        try{
        
                            $sql_login_check='SELECT COUNT(id) FROM object_admin WHERE username=:login_user AND password=:login_pass AND email=:login_email';
                            $check_login= $pdo->prepare($sql_login_check);
                            $check_login->execute(array(':login_user'=>$login_username,':login_pass'=>$login_password,':login_email'=>$login_email));
                            
                            $admin_exists= $check_login->fetchColumn();
                            if( $admin_exists==1 ){
                                
                                echo json_encode('success_admin');
                                
                                return;
                                
                            }
                        }catch(ErrorException $e){
                            
                            echo json_encode('An Error has occured while accesing the Database. Please contact a system admin.'); 
                            return;
                        }
                    }
                    
                    echo json_encode('User Could not be found!');
                    return;
                    
                }
                else{
                    echo json_encode('Please fill in fields before trying to Login');
                    return;
                }
            }else{
                echo json_encode('Couldnt fetch user Data from the Login Post. Contact a system admin');
                return;
            } 
        }
    }
    
    

?>