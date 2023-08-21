
<?php

require_once "C:/xampp/htdocs/web-v.1.0.0.1/ApacheRESTServices/SETUP_connection.php";


    $offerdetails = json_decode($_POST['offerdetails']);
    
    $in_shopname    =   $offerdetails       ->  shopname;
    $in_shopid      =   $offerdetails       ->  shop_id;
    $in_productname =   $offerdetails       ->  productname;
    $in_productid   =   $offerdetails       ->  product_id;
    $in_price       =   $offerdetails       ->  productprice;
    $in_userid      =   $_SESSION['User ID'];

    try{

        if (CheckIfOfferisNotAlreadyActive($in_shopid,$in_productid)===true)
        {
            if (InsertNewOffer($in_shopid,$in_productid,$in_userid,$in_price)===true){
                echo json_encode('New offer submitted!');
            }else{
                echo json_encode('An error occured while submitting new offer.');
            }

        } elseif (CheckIfOfferisNotAlreadyActive($in_shopid,$in_productid)===false)
        {
            if (CheckIfNewOfferHasLowerPrice($in_shopid,$in_productid,$in_price)===true){

                if(UpdateOldOffer($in_shopid,$in_productid,$in_userid,$in_price)===true){
                    echo json_encode('There is already an offer active for the same product, shop from the same user!\nPrevious offer updated!');
                }else{
                    echo json_encode('There is already an offer active for the same product, shop from the same user!\nAn error has occured while updating previous offer.');
                }

            }else{
                echo json_encode('There is already an offer active for the same product, shop from the same user!\nNew offer does not have a low enough price to modify previous offer.');
            }

        }else{
            echo json_encode('An Error has Occured');
        }
        
    }catch (Exception $e){

        echo json_encode($e);
        return;
    }

    function CheckIfOfferisNotAlreadyActive($shop,$product) : bool {

        global $pdo;
        try
        {
            $checkofferuserproduct = 'SELECT COUNT(id) FROM object_offer WHERE shop_id=:in_shopid AND product_id=:in_productid AND expiration_date>=CURRENT_DATE;';
            $offercount= $pdo->prepare($checkofferuserproduct);
            $offercount->execute(array(':in_shopid'=>$shop,':in_productid'=>$product));

            $offerexists = $offercount->fetchColumn();
            
            if ($offerexists==0){
                return(true);
            }elseif($offerexists>=0){
                return(false);
            }

        }catch(PDOException $e){
            return(false);
        }
    }

    function CheckIfNewOfferHasLowerPrice($shop,$product,$price) : bool {

        global $pdo;
        try
        {

            $checkofferuserproduct = 'SELECT product_price FROM object_offer WHERE shop_id=:in_shopid AND product_id=:in_productid';
            $offercount= $pdo->prepare($checkofferuserproduct);
            $offercount->execute(array(':in_shopid'=>$shop,':in_productid'=>$product));

            $oldprice = $offercount->fetchColumn();
            $percentage=$oldprice*(20/100);
            
            if($price<=$oldprice-$percentage){

                return(true);
            }else{
                return(false);
            
            }

        }catch(PDOException $e){
            return(false);
        }
    }

    function InsertNewOffer($shopid,$productid,$user,$price) : bool {

        global $pdo;
        try
        {
            $sql_Submitoffer='CALL SubmitOffer(:in_shopid,:in_productid,:in_userid,:in_price);';
            $submit= $pdo->prepare($sql_Submitoffer);
            $submit->execute(array(':in_shopid'=>$shopid,':in_productid'=>$productid,':in_userid'=>$user,':in_price'=>$price));
            return(true);

        }catch(PDOException $e){
            return(false);
        }
    }

    function UpdateOldOffer($shopid,$productid,$user,$price):bool{
        
        global $pdo;
        
        try
        {
            $sql_Submitoffer='UPDATE object_offer SET product_price=:in_price,creation_date=CURRENT_DATE,expiration_date=DATE_ADD(CURRENT_DATE,INTERVAL 7 DAY),creation_user_id=:in_userid WHERE product_id=:in_productid AND shop_id=:in_shopid;';
            $submit= $pdo->prepare($sql_Submitoffer);
            $submit->execute(array(':in_price'=>$price,':in_userid'=>$user,':in_productid'=>$productid,':in_shopid'=>$shopid));
            
            return(true);

        }catch(PDOException $e){
            return(false);
        }
    }

?>

