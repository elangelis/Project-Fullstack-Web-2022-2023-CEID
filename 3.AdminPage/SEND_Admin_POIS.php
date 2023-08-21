<?php

    require_once "C:/xampp/htdocs/web-v.1.0.0.1/ApacheRESTServices/SETUP_connection.php";
    

    $arr = json_decode($_POST['shops']);

    


            
    if (isset($arr)){

        try
        {

            $shops      =       $arr->elements;
            
        }
        catch(Exception $e)
        {
            echo json_encode($e);
        }
        if(isset($shops)){
            $success=true;
            $shop_pointer=0;
            foreach ($shops as $shop => $attributes) {
                
                foreach ($attributes as $key => $value) {

                    if($key=='lat')
                    {
                        $ARRAY_POIS[$shop_pointer]['latitude']=$value;
                    }                    
                    if($key=='lon')
                    {
                        $ARRAY_POIS[$shop_pointer]['longitude']=$value;
                    }
                    if($key=='tags')
                    {
                        foreach ($value as $info => $value2) {
                            if($info=='brand')
                            {
                                $ARRAY_POIS[$shop_pointer]['brand']=$value2;
                            }
                            if($info=='name')
                            {
                                $ARRAY_POIS[$shop_pointer]['name']=$value2;
                            }
                            if($info=='shop')
                            {
                                $ARRAY_POIS[$shop_pointer]['description']=$value2;
                            }
                            if($info=='addr:street')
                            {
                                $ARRAY_POIS[$shop_pointer]['address1']=$value2;
                            }
                            if($info=='addr:housenumber')
                            {
                                $ARRAY_POIS[$shop_pointer]['address2']=$value2;
                            }     
                        }
                        
                    }
                }
                $shop_pointer=$shop_pointer+1;
            }
        }

        if(isset($ARRAY_POIS)){
            foreach ($ARRAY_POIS as $row => $poi) {
                
                $lat="";
                $long="";
                $address="";
                $address1="";
                $address2="";
                $name="";
                $description="";
                $brand="";

                foreach ($poi as $key2 => $value3) {
                    if($key2=='brand')
                    {
                        $brand=$value3;
                    }
                    if($key2=='description')
                    {
                        $description=$value3;
                    }
                    if($key2=='latitude')
                    {
                        $lat=$value3;
                    }   
                    if($key2=='longitude')
                    {
                        $long=$value3;
                    }
                    if($key2=='name')
                    {
                        $name=$value3;
                    }
                    if($key2=='address1')
                    {
                        $address1=strval($value3);
                    }
                    if($key2=='address2')
                    {
                        $address2=strval($value3);
                    }
                }

                if(isset($address1)||isset($address2)){
                    if(isset($address1)){
                        $address = $address1;
                    }

                    if(isset($address2)){

                        if($address2!=0){
                            $address = $address . "" . strval($address2);    
                        }
                    }
                }

                if(isset($name)||isset($brand)){
                    if(!isset($name)){
                        if(isset($brand)){
                            $name=$brand;
                        }
                    }
                }

                if(($lat!="")&&($long!="")&&($name!="")){
                    try
                    {
                        $insert_pois = 'CALL InsertPOIS(:name,:description,:latitude,:longitude,:address);';
                        $insert_pois_exec= $pdo->prepare($insert_pois);
                        $insert_pois_exec->execute(array(':name'=>$name,':description'=>$description,':latitude'=>$lat,':longitude'=>$long,':address'=>$address));
    
                    }catch(Exception $e){
                        $error=$error+$e;
                        $success=false;
                        
                    }
                
                
                
                }
            }
        }

        
    }
    if($success==true){
        echo json_encode('input was succesful!');
    }elseif($success==false){
        echo json_encode($error);
    }
    

?>