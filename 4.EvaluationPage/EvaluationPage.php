<!DOCTYPE html>
<html>

    <head>
        <meta http-equiv="content-type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="EvaluationPage.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    </head>

    <body id="body">
        <div class="container">
            <header id="container_header">
                <h1>Αξιολόγηση</h1>
            </header>
            <div id="content">
                <h3 id="table_header_prosf">Προσφορές</h3>
                <div id="table_object">
                    <table id="table_offers">
                        <caption>Πίνακας Προσφορών</caption>
                        <thead id="table-headers">
                            <th class="headers">Προϊόν</th>
                            <th class="headers">Τιμή</th>
                            <th class="headers">Kριτήρια 5ai</th>
                            <th class="headers">Kριτήρια 5aii</th>
                            <th class="headers">Hμ/νία Καταχώρησης</th>
                            <th class="headers">Likes</th>
                            <th class="headers">Dislikes</th>
                            <th class="headers">Απόθεμα</th>
                            <th class="headers"></th>
                        </thead>
                        <tbody id="table_body"></tbody>
                    </table>
                </div>

                <div id="offer_object">
                    <h3>Λεπτομέρειες Προσφοράς</h3>
                    <div id="offer-details">
                        <h4>Πληροφορίες Προσφοράς</h4>
                        <div class="offer-details-data">
                            <label for="Offer_shop">Κατάστημα</label>
                            <div id="Offer_shop"></div>
                        </div>
                        <div class="offer-details-data">
                            <label for="Offer_product_name">Προϊόν</label>
                            <div id="Offer_product_name"></div>
                        </div>
                        <div class="offer-details-data">
                            <label for="Offer_product_price">Τιμή</label>
                            <div id="Offer_product_price"></div>
                        </div>
                        <div class="offer-details-data">
                            <label for="Offer_criteriaA">Kριτήρια 5ai</label>
                            <div id="Offer_criteriaA"></div>
                        </div>
                        <div class="offer-details-data">
                            <label for="Offer_criteriaB">Kριτήρια 5aii</label>
                            <div id="Offer_criteriaB"></div>
                        </div>
                        <div class="offer-details-data">
                            <label for="Offer_date">Hμ/νία Καταχώρησης</label>
                            <div id="Offer_date"></div>
                        </div>
                        <div class="offer-details-data">
                            <label for="Offer_likes">Likes</label>
                            <div id="Offer_likes"></div>
                        </div>
                        <div class="offer-details-data">
                            <label for="Offer_dislikes">Dislikes</label>
                            <div id="Offer_dislikes"></div>
                        </div>
                        <div class="offer-details-data">
                            <label for="Offer_stock">Απόθεμα</label>
                            <div id="Offer_stock"></div>
                        </div>
                        <div id="status" class="offer-details-data">
                            <label for="ChangeStockStatus"></label>
                            <Button id="ChangeStockStatus">Change Stock</Button>
                        </div>
                    </div>
                    <div>
                        <div id="product_details">
                            <h4 id="product_header">Πληροφορίες Προϊόντος</h4>
                            <div class="product_details_data">
                                <label for="Offer_productname">Προϊόν</label>
                                <div id="Offer_productname"></div>
                            </div>
                            <div class="product_details_data">
                                <label for="Offer_productprice">Τιμή</label>
                                <div id="Offer_productprice"></div>
                            </div>
                            <div id="image_container" class="product_details_data">
                                <label for="Offer_productimage" style="display: block;">Εικόνα</label>
                                <img id="Offer_productimage" src="../AdditionalFiles/pngegg.png"></img>
                            </div>
                        </div>
                        <div id="user-details">
                            <h4 id="user_header">Πληροφορίες Χρήστη</h4>

                            <div class="user-details-data">
                                <label for="Offer_username">Όνομα Χρηστη</label>
                                <div id="Offer_username"></div>
                            </div>


                            <div class="user-details-data">
                                <label for="Offer_userscore">Συνολικό Score Χρήστη</label>
                                <div id="Offer_userscore"></div>
                            </div>
                        </div>
                        <div id="buttons">
                            <button class="buttons_class" id="like-button">Like</button>
                            <button class="buttons_class" id="dislike-button">Dislike</button>
                        </div>
                    </div>
                </div>

            </div>

        </div>

        <div name='scripts'>
            <script type="text/javascript" src="EvaluationPage.js"></script>
            <script type="text/javascript" src="../ApacheRESTServices/JS_GetDatabaseData.js"></script>
        </div>
        <div id="footer"></div>
    </body>
</html>