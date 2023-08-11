<?php
    
include_once "./ApacheRESTServices/SETUP_connection.php";

    $details = json_decode($_POST['details']);
    

    $offerid    =   $details    ->  offer_id;
    $actiontype =   $details    ->  action;

    if(isset($_SESSION['User ID'])){

        $userid =   $_SESSION['User ID'];

        if(isset($actiontype)){

            if($actiontype==1){

                try{
                    $sql_check_like = 'SELECT COUNT(id) FROM archive_user_actions WHERE user_id=:in_user AND offer_id=:in_offer AND type=1;';
                    $count_likes= $pdo->prepare($sql_check_like);
                    $count_likes->execute(array(':in_user'=>$userid,':in_offer'=>$offerid));
                    
                    $like_exists = $count_likes->fetchColumn();

                    
                    if ($like_exists==0){
                        try{
                            $sql_deleteuserlikes='DELETE FROM archive_user_actions WHERE user_id=:in_user AND offer_id=:in_offer;';
                            $delete= $pdo->prepare($sql_deleteuserlikes);
                            $delete->execute(array(':in_user'=>$userid,':in_offer'=>$offerid));
        
        
                        }catch(PDOException $e){
                            echo json_encode('Couldnt Delete previous actions.');
                            return;
                        }        

                        try{


                            $sql_updatelike='INSERT INTO archive_user_actions (user_id,offer_id,type)VALUES(:in_user,:in_offer,1);';
                            $insert= $pdo->prepare($sql_updatelike);
                            $insert->execute(array(':in_user'=>$userid,':in_offer'=>$offerid));
        
                            echo json_encode('success');
                            return;
                        }catch(PDOException $e){
                            
                            echo json_encode($e);
                            return;
                        }

                    }else{
                        echo json_encode('User has already Pressed Like for this offer.');
                        return;
                    }
                }catch(PDOException $e){
                    echo json_encode($e);
                    return;
                }
                return;


            }elseif($actiontype==2){
                try{
                    $sql_check_dislike = 'SELECT COUNT(id) FROM archive_user_actions WHERE user_id=:in_user AND offer_id=:in_offer AND type=2;';
                    $count_dislikes= $pdo->prepare($sql_check_dislike);
                    $count_dislikes->execute(array(':in_user'=>$userid,':in_offer'=>$offerid));
        
                    $dislike_exists = $count_dislikes->fetchColumn();

                    if ($dislike_exists==0){
                        try{
                            $sql_deleteuserlikes='DELETE FROM archive_user_actions WHERE user_id=:in_user AND offer_id=:in_offer;';
                            $delete= $pdo->prepare($sql_deleteuserlikes);
                            $delete->execute(array(':in_user'=>$userid,':in_offer'=>$offerid));
        
        
                        }catch(PDOException $e){
                            echo json_encode('Couldnt Delete previous actions.');
                            return;
                        }        


                        try{                       
                            $sql_updatedislike='INSERT INTO archive_user_actions (user_id,offer_id,type)VALUES(:in_user,:in_offer,2);';
                            $insert= $pdo->prepare($sql_updatedislike);
                            $insert->execute(array(':in_user'=>$userid,':in_offer'=>$offerid));
        
                            echo json_encode('success');

                        }catch(PDOException $e){
                            echo json_encode($e);
                            return;
                        }

    
                    }else{
                        echo json_encode('User has already Pressed dislike for this offer.');
                    }

                }catch(PDOException $e){
                    echo json_encode($e);
                    return;
                }

                return;
                                
            }else{
                echo json_encode('An Error has occured');
                
                return;
            }
        }
    }else{
        echo json_encode('Error. Please Log in again!');
        
        return;
    }

?>