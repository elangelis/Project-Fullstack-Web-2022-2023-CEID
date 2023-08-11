




// var Form_Categories = new Array();
// var Form_SubCategories =new Array();
// var Form_Items = new Array();


let Form_Categories = {};
let Form_SubCategories = {};
let Form_Items = {};
var success2;
var Dropdownbody;
var Item_body;
var Sub_body;
var Catbody;
var bodyadded=false;

var productbox= document.getElementById('item-selection');
var dropdownlist =document.getElementById('dropdownlist');

var CloseDropDown,SubCategoryOpen_id,CategoryOpen_id,selected;
var submitbutton=document.getElementById('submit_button');

//---------------------------------------------------------------------------------------------------------------------------------//
//------------------------------------------------------ FETCH DATA ---------------------------------------------------------------//
//---------------------------------------------------------------------------------------------------------------------------------//
//---------------------------------------------------------------------------------------------------------------------------------//



window.addEventListener('load', (event) => {
    UpdateArrays();

});

submitbutton.addEventListener('click',function e(){
    Submit_Offer();
});



function UpdateArrays(){

    //sucess boolean to return if every fetch was succesful
    
    
    //Fetch Categories
    $.ajax({
        url: 'GET_Categories.php',
        type: 'post',
        // data: {},
        success: function(data) {
            Form_Categories.length=0;
            Form_Categories=JSON.parse(data);
            console.log(Form_Categories);
            success2=true;
        },
        error:function(e){
            console.log(e);
            console.log("Categories Couldnt be Fetched");
            success2=false;
        }
    });
    



    //Fetch SubCategories
    $.ajax({
        url: 'GET_Subcategories.php',
        type: 'post',
        // data: {},
        success: function(data) {
            Form_SubCategories.length=0;
            Form_SubCategories=JSON.parse(data);
            console.log(Form_SubCategories);
            if(success2==true){
                success2=true;
            }
        },
        error:function(e){
            console.log(e);
            console.log("den brethikan katastimata pou na exoun prosfora stin katigoria");
            success2=false;
        }
    });

    
    //Fetch Items
    $.ajax({
        url: 'GET_Items.php',
        type: 'post',
        // data: {},
        success: function(data) {
            Form_Items.length=0;
            Form_Items=JSON.parse(data);
            console.log(Form_Items);
            if(success2==true){
                var text=CreateDropDown();
                //Add Created Drop down to dropdownlist body
                dropdownlist.innerHTML+=text;
                CreateSearchBarOptions_Lines();
            }
        },
        error:function(e){
            console.log(e);
            console.log("den brethikan katastimata pou na exoun prosfora stin katigoria");
            success2=false;
        }    
    });

}



//---------------------------------------------------------------------------------------------------------------------------------//
//------------------------------------------------------ DROPDOWN LIST ------------------------------------------------------------//
//---------------------------------------------------------------------------------------------------------------------------------//
//---------------------------------------------------------------------------------------------------------------------------------//

function CreateDropDown(){

    Dropdownbody=           '<button id="dropdownbutton" class="btn btn-default dropdown-toggle" type="button" >Επιλογή'+
                            '<span class="caret"></span>'+
                                '</button><ul class="dropdown-menu">';
    Dropdownbody+=             CreateCategories()+
                            '</ul>';

    return(Dropdownbody);
}
function CreateCategories(){
    Catbody='';
    let i=0;
    while (i<Form_Categories.length) {
        Catbody+=   '<li id="category'+Form_Categories[i].id.toString()+'" class="dropdown-submenu">'+
                        '<a onclick="PressedCategory('+Form_Categories[i].id.toString()+');" class="test" tabindex="-1" href="#">'+Form_Categories[i].name+'<span class="caret"></span></a>';
        Catbody+=           '<ul class="dropdown-menu">'+
                                CreateSubCategories(Form_Categories[i].id)+
                            '</ul>'+
                    '</li>';
        i++;
    }
    return(Catbody);
};
function CreateSubCategories(in_category_id){
    Sub_body='';
    let i=0;
    while (i<Form_SubCategories.length) {
        if( Form_SubCategories[i].category_id   ==  in_category_id   )
        {
            Sub_body+=  '<li id="subcategory'+Form_SubCategories[i].id.toString()+'" class="dropdown-submenu">'+
                            '<a class="test" href="#" onclick="PressedSubcategory('+Form_SubCategories[i].id.toString()+');" >'+Form_SubCategories[i].name+'<span class="caret"></span></a>'+
                                '<ul class="dropdown-menu">';
            Sub_body+=              CreateItems(Form_SubCategories[i].id)+
                                '</ul>'+
                        '</li>';                        
        }
        i++;
    }
    return(Sub_body);
};
function CreateItems(in_subcategory_id){
    Item_body='';
    let i=0;
    while (i<Form_Items.length) {
        if( Form_Items[i].subcategory_id   ==  in_subcategory_id   )
        {
            Item_body+= '<li>'+'<a id="product'+Form_Items[i].id.toString()+'" onclick="PressedProduct('+Form_Items[i].id.toString()+');" href="#">'+Form_Items[i].name+'</a>'+'</li>';
        }
        i++;
    }
    return(Item_body);
};




        
function PressedDropDown(){
    HideSearchBarOptions();
    if(!CloseDropDown){
        ShowCategories();
    }
    CloseDropDown=false;
}
function PressedCategory(id){
    HideSubcategories();
    HideProducts();
    if(CategoryOpen_id!==id){
        ShowSubcategories(id);
        CategoryOpen_id=id;
    }
}
function PressedSubcategory(id){
    HideProducts();
    if(SubCategoryOpen_id!=id){
        ShowProducts(id);
        SubCategoryOpen_id=id;
    }
}
function PressedProduct(id){
    text='product'.toString()+id.toString();
    selected=document.getElementById(text).innerText;
    productbox.value='';
    productbox.value=selected;
    HideCategories();

}


function HideCategories(){
    HideProducts();
    HideSubcategories();
    SubCategoryOpen_id=null;
    CategoryOpen_id=null;
    CloseDropDown=true;
    if(document.getElementById('dropdownlist').className=='dropdown open'){
        document.getElementById('dropdownlist').className='dropdown';
    }
}
function HideSubcategories(){
    let i=0;
    while(i<=Form_Categories.length){
        let text='category';
        let string=text.toString()+i.toString();
        if( document.getElementById(string)!=null){

            if( document.getElementById(string).className='dropdown-submenu open'){
                document.getElementById(string).className='dropdown-submenu';
            }
        }
        i++;
    }
}
function HideProducts(){
    let text='subcategory';
        let i=0;
        while(i<Form_SubCategories.length){
            let string=text.toString()+i.toString();
            if( document.getElementById(string)!=null){
                if( document.getElementById(string).className='dropdown-submenu open'){
                    document.getElementById(string).className='dropdown-submenu';
                }
            }
            i++;
        }
}


function ShowCategories(){
    if(document.getElementById('dropdownlist').className=='dropdown'){
        document.getElementById('dropdownlist').className='dropdown open';
    }
}
function ShowSubcategories(categoryid){
    let text='category'+categoryid;
    let string=text.toString();
    if(document.getElementById(string).className=='dropdown-submenu'){
        document.getElementById(string).className='dropdown-submenu open';
    }
}
function ShowProducts(subcategoryid){
    let text='subcategory'+subcategoryid;
    let string=text.toString();
    if(document.getElementById(string).className=='dropdown-submenu'){
        document.getElementById(string).className='dropdown-submenu open';
    }
}




//---------------------------------------------------------------------------------------------------------------------------------//
//------------------------------------------------------ DROPDOWN LIST ------------------------------------------------------------//
//---------------------------------------------------------------------------------------------------------------------------------//
//---------------------------------------------------------------------------------------------------------------------------------//


//---------------------------------------------------------------------------------------------------------------------------------//
//------------------------------------------------------ SEARCH BAR ---------------------------------------------------------------//
//---------------------------------------------------------------------------------------------------------------------------------//
//---------------------------------------------------------------------------------------------------------------------------------//

productbox.addEventListener('keypress',function(){
    HideSearchBarOptions();
    let i=0;
    let inputOption=productbox.value;
    if(inputOption!=null && inputOption!=""){
        while(i<Form_Items.length){
            let textOption=Form_Items[i].name.toString();
            if(textOption.includes(inputOption)){   
                let text='ListProduct'+Form_Items[i].id;
                document.getElementById(text.toString()).setAttribute('class','ListProducts_visible');
            }    
            i++;
        }
    }
});

productbox.addEventListener('keyup',function(){
    HideSearchBarOptions();
    let i=0;
    let inputOption=productbox.value;
    if(inputOption!=null && inputOption!=""){
        while(i<Form_Items.length){
            let textOption=Form_Items[i].name.toString();
            if(textOption.includes(inputOption)){   
                let text='ListProduct'+Form_Items[i].id;
                document.getElementById(text.toString()).setAttribute('class','ListProducts_visible');
            }    
            i++;
        }
    }
});


function SelectedProductSearchBar(id){
    let text='ListProduct'
    text=text.toString()+id.toString();
    if(document.getElementById(text)!=null){
        productbox.value=document.getElementById(text).innerText;
    }
}



function CreateSearchBarOptions_Lines(){
    let i=0;
    let body='';
    //Create Child Body
    while(i<Form_Items.length){
        body+='<li onclick="SelectedProductSearchBar('+Form_Items[i].id+');" id="ListProduct'+Form_Items[i].id+'" class="ListProducts_hidden">'+Form_Items[i].name+'</li>'
        i++;
    }
    //Assing Body Childs
    if (body!=''){
        document.getElementById('list').innerHTML=body;
    }
    //Hide Childs
    HideSearchBarOptions();
}


function HideSearchBarOptions(){
    //Hide Childs
    let i=0;
    while(i<Form_Items.length){
        text='ListProduct';
        newtext=text.toString()+Form_Items[i].id.toString();
        if(document.getElementById(newtext)!=null){
            document.getElementById(newtext).setAttribute('class','ListProducts_hidden');
        }
        i++;
    }
}

    function Submit_Offer(){
    
        var OfferForSubmit={};
        shopname=document.getElementById('shop_selection').value;
        productname=document.getElementById('item-selection').value;
        productprice=document.getElementById('price_selection').value;

        if(shopname!=undefined && shopname!=''){
            if(productname!=undefined && productname!=''){
                if(productprice!=undefined && productprice!=0){
                    OfferForSubmit.shopname=shopname;
                    OfferForSubmit.productname=productname;
                    OfferForSubmit.productprice=parseFloat(productprice);
                    
                }else{alert('You have to fill product price in order to submit an offer.');return;}
            }else{alert('You have to fill product name in order to submit an offer.');return;}
        }else{alert('You have to fill shopName in order to submit an offer.');return;}

        DataBase_ProductDetails.forEach(product => {
            if(product.name==OfferForSubmit.productname){
                OfferForSubmit.product_id=product.id;
            }
        });

        DataBase_ShopDetails.forEach(shop=>{
            if(shop.name==OfferForSubmit.shopname){
                OfferForSubmit.shop_id=shop.id;
            }
        })
        
        console.log('OfferForSubmit');
        console.log(OfferForSubmit);
        
        //Submit Offer
        $.ajax({
            
            url: 'SubmissionFunctionality.php',
            type: 'post',
            data:  {offerdetails:JSON.stringify(OfferForSubmit)},

            success: function(data) {
                var response=JSON.parse(data);
                if(response.toString().includes('\\n')){
                    response=response.replace("\\n", "\n");
                }
                alert(response);
            },
            error:function(e){
                alert('An error occured. Offer couldnt be submitted');
            }
        });

    }

