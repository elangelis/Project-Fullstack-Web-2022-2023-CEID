<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="SubmissionPage.css">
</head>
<body id="body">
    <div id="content" class="container">
        <h2 id="main_header">Menu Υποβολής προσφοράς</h2>
        <span id="closebutton" class="close">&times;</span>
        <div id="shop_info">
            <h3 id="shop_info_header">Επιλεγμένο Κατάστημα</h3>
            <div id="shop_info_field">
                <label for="shop_selection">Κατάστημα</label>
                <input type="text" id="shop_selection"></input>
            </div>
        </div>
        <div id="dropdown_info">
            <h3 id="dropdown_info_header">Επιλογή Προϊόντος</h3>
            <div id="dropdown_info_field">
                <div id="dropdown_searchbar">
                    <label for="item-selection">Αναζητήστε προϊόν</label>
                    <input class="fstdropdown-select" id="item-selection">
                        <div id="list_object">
                            <ol type="1" id="list"></ol>
                        </div>
                    </input>
                </div>
                <div id="dropdown_treebar">
                    <label for="dropdownlist">Επιλέξτε από την λίστα</label>
                    <div id="dropdownlist" class="dropdown" onclick="PressedDropDown();"></div>
                </div>
            </div>
        </div>
        <div id="price_info">
            <h3 id="price_info_header">Εισάγετε την τιμή της προσφοράς</h3>
            <div id="price_info_field">
                <label for="price_selection">Τιμή</label>
                <input type="number" id="price_selection"></input>
            </div>
        </div>
        <div id="submit_info_button">
            <div id="submit_info_field">
                <label for="submit_button"></label>
                <input type="submit" id="submit_button" value="Καταχώρηση προσφοράς"></input>
            </div>
        </div>
    </div>
    <div name='scripts'>
        <script type="text/javascript" src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
        <script type="text/javascript" src="SubmissionPage.js"></script>
        <script type="text/javascript" src="../ApacheRESTServices/JS_GetDatabaseData.js"></script>
    </div>
</body>

</html>