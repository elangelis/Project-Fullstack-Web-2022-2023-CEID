<?php


require_once "C:/xampp/htdocs/web-v.1.0.0.1/ApacheRESTServices/SETUP_connection.php";

    
    $arr = json_decode($_POST['jsonarray']);
    $opt = json_decode($_POST['option']);




            
    if (isset($opt)){

        if($opt==1){
            $success=false;
            $error='';
            try
            {
                //PRODUCTS AND CATEGORIES
                $fetchdate=$arr->fetch_date;
                $categories=$arr->categories;
                $products=$arr->products;
            }
            catch(Exception $e)
            {
                echo json_encode($e);
            }
        
            if(isset($categories)){
                // GET CATEGORIES AND SUBCATEGORIES FROM JSON 
                $cat_pointer=0;
                $sub_pointer=0;
                foreach ($categories as $category=>$id_name) {
                
                    foreach ($id_name as $key => $value) {
        
                        if($key=='id')
                        {
                            $ARRAY_CAT[$cat_pointer]['cat_id']=$value;
                        }
                        elseif ($key=='name')
                        {
                            $ARRAY_CAT[$cat_pointer]['cat_name']=$value;
                        }
                        elseif($key=='subcategories')
                        {    
                            $subcategories=$value;
                            foreach ($subcategories as $subcategory => $id_name_sub) {
                                foreach($id_name_sub as $key2=>$value2){
                                    if($key2=='name'){
        
                                        $ARRAY_SUB[$sub_pointer]['sub_name']=$value2;
                                    }
                                    elseif($key2=='uuid'){
        
                                        $ARRAY_SUB[$sub_pointer]['sub_id']=$value2;
                                    }
                                    
                                }
                                $ARRAY_SUB[$sub_pointer]['cat_id']=$ARRAY_CAT[$cat_pointer]['cat_id'];
                                $sub_pointer=$sub_pointer+1;
                            }
                        }
                    }
                    $cat_pointer=$cat_pointer+1;
                }
                $success=true;
            }

            // GET PRODUCTS FROM JSON 
            if(isset($products)){
                $prod_pointer=0;
                foreach ($products as $product => $attributes) {
                    foreach ($attributes as $key => $value) {
                        if($key=='category')
                        {
                            $ARRAY_PROD[$prod_pointer]['cat_id']=$value;
                        }
                        elseif($key=='id')
                        {
                            $ARRAY_PROD[$prod_pointer]['prod_id']=$value;
                        }
                        elseif($key=='name')
                        {
                            $ARRAY_PROD[$prod_pointer]['prod_name']=$value;
                        }
                        elseif($key=='subcategory')
                        {
                            $ARRAY_PROD[$prod_pointer]['sub_id']=$value;
                        }
                    }
                    
                    $prod_pointer=$prod_pointer+1;
                }
            }

            // INSERT CATEGORIES TO DATABASE
            if(isset($ARRAY_CAT)){
                
                $category_success=true;
            
                foreach ($ARRAY_CAT as $category_forInsert=>$row) {
                    unset($cat_id);
                    unset($cat_name);
                    foreach ($row as $attribute => $value) {
                        
                        if($attribute=='cat_id'){
                            $cat_id=$value;
                        }
                        elseif($attribute=='cat_name')
                        {
                            $cat_name=$value;
                        }
                    }
                    if(isset($cat_id)&& isset($cat_name)){
                        try{
                            $insert1 = 'CALL ADMIN_InsertCategories(:cat_id,:cat_name);';
                            $insertcategories= $pdo->prepare($insert1);
                            $insertcategories->execute(array(':cat_id'=>$cat_id,':cat_name'=>$cat_name));

                        }
                        catch(Exception $e){
                            $error=$error+$e;
                            $category_success=false;
                        }
                    }
                }
            }
            // INSERT SUBCATEGORIES TO DATABASE
            if(isset($ARRAY_SUB)){

                $subcategory_success=true;

                foreach ($ARRAY_SUB as $subcategory_forInsert=>$row) {
                    unset($sub_id);
                    unset($sub_name);
                    unset($sub_cat_id);
                    foreach ($row as $attribute => $value) {
                        
                        if($attribute=='sub_id'){
                            $sub_id=$value;
                        }
                        elseif($attribute=='sub_name')
                        {
                            $sub_name=$value;
                        }
                        elseif($attribute=='cat_id')
                        {
                            $sub_cat_id=$value;
                        }
                    }
                    if(isset($sub_id)&& isset($sub_name)&&isset($sub_cat_id)){
                        try{
                            $insert2 = 'CALL ADMIN_InsertSubcategories(:sub_id,:sub_name,:sub_cat_id);';
                            $insertsubcategories= $pdo->prepare($insert2);
                            $insertsubcategories->execute(array(':sub_id'=>$sub_id,':sub_name'=>$sub_name,':sub_cat_id'=>$sub_cat_id));

                        }
                        catch(Exception $e){
                            $error=$error+$e;
                            $subcategory_success=false;
                        }
                    }
                    
                }
            }

            // INSERT PRODUCTS TO DATABASE
            if(isset($ARRAY_PROD)){

                $product_success=true;
                foreach ($ARRAY_PROD as $product_forInsert=>$row) {
                    unset($prod_id);
                    unset($prod_name);
                    unset($prod_sub_id);
                    unset($prod_cat_id);
                    foreach ($row as $attribute => $value) {
                        
                        if($attribute=='prod_id'){
                            $prod_id=$value;
                        }
                        elseif($attribute=='prod_name')
                        {
                            $prod_name=$value;
                        }
                        elseif($attribute=='cat_id')
                        {
                            $prod_sub_id=$value;
                        }
                        elseif($attribute=='sub_id')
                        {
                            $prod_cat_id=$value;
                        }
                    }
                    if(isset($prod_id)&& isset($prod_name)&&isset($prod_sub_id)&&isset($prod_cat_id)){
                        try{
                            $insert3 = 'CALL ADMIN_InsertProducts(:prod_id,:prod_name,:prod_cat_id,:prod_sub_id);';
                            $insertproducts= $pdo->prepare($insert3);
                            $insertproducts->execute(array(':prod_id'=>$prod_id,':prod_name'=>$prod_name,':prod_cat_id'=>$prod_sub_id,':prod_sub_id'=>$prod_cat_id));

                        }
                        catch(Exception $e){
                            $error=$error+$e;
                            $product_success=false;
                        }
                    }
                }
            
            }
            if($product_success==true && $category_success==true && $subcategory_success==true){
                echo json_encode('Insert succesful for products,categories,subcategories!');
            }else{
                echo json_encode($error);
            }

        }elseif($opt==2)
        {
            $success=false;
            $error='';
            $product_prices=$arr->data;
            if(isset($product_prices)){
                // GET CATEGORIES AND SUBCATEGORIES FROM JSON 
                $rowpointer=0;
                foreach ($product_prices as $row=>$product) {
                
                    foreach ($product as $key => $value) {
        
                        if($key=='id')
                        {
                            $product_id=$value;
                        }
                        elseif ($key=='name')
                        {
                            $product_name=$value;
                        }
                        elseif($key=='prices')
                        {   
                            $prices=$value;
                            foreach ($prices as $row_price => $priceid) {
                                foreach($priceid as $key2=>$value2){
                                    if($key2=='date'){
        
                                        $ARRAY_PRODPRICES[$rowpointer]['date']=$value2;
                                    }
                                    elseif($key2=='price'){
        
                                        $ARRAY_PRODPRICES[$rowpointer]['price']=$value2;
                                    }
                                    
                                }
                                $ARRAY_PRODPRICES[$rowpointer]['product_id']    =   $product_id;
                                $ARRAY_PRODPRICES[$rowpointer]['product_name']  =   $product_name;
                                $rowpointer=$rowpointer+1;
                            }
                        }
                    }
                }
                $success=true;
            }

            if(isset($ARRAY_PRODPRICES)){

                $product_price_success=true;
                foreach ($ARRAY_PRODPRICES as $product_priceforinsert=>$row) {
                    unset($prod_id);
                    unset($prod_name);
                    unset($price);
                    unset($date);
                    foreach ($row as $attribute => $value) {
                        
                        if($attribute=='prod_id'){
                            $prod_id=$value;
                        }
                        elseif($attribute=='prod_name')
                        {
                            $prod_name=$value;
                        }
                        elseif($attribute=='price')
                        {
                            $price=$value;
                        }
                        elseif($attribute=='date')
                        {
                            $date=$value;
                        }
                    }
                    if(isset($prod_id)&& isset($prod_name)&&isset($price)&&isset($date)){
                        try{
                            $insert3 = 'CALL ADMIN_InsertProductPrices(:prod_id,:prod_name,:price,:date);';
                            $insertproducts= $pdo->prepare($insert3);
                            $insertproducts->execute(array(':prod_id'=>$prod_id,':prod_name'=>$prod_name,':price'=>$price,':date'=>$date));

                        }
                        catch(Exception $e){
                            $error=$error+$e;
                            $product_price_success=false;
                        }
                    }
                }       
            }
            if($product_price_success==true && $success==true){
                echo json_encode('Insert succesful for product prices!');
                return;
            }else{
                echo json_encode($error);
                return;
            }
        }
    }







?>

