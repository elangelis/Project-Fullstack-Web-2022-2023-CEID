<!DOCTYPE html>
<html lang="en">

<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="MainMenuPage.css">
    <link rel="stylesheet" href="https://unpkg.com/boxicons@2.1.1/css/boxicons.min.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css" integrity="sha256-kLaT2GOSpHechhsozzB+flnD+zUyjE2LlfWPgU04xyI=" crossorigin="" />
    <script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js" integrity="sha256-WBkoXOwTeyKclOHuWtc+i2uENFpDZ9YPdf5Hf+D7ewM=" crossorigin=""></script>
</head>

<body>
    <header class="header_class" id="header">
        <?php
<<<<<<< HEAD
        require_once  "C:/xampp/htdocs/Web_Project-full-stack/1.LoginPage/LoginUser.php";
        require_once  "C:/xampp/htdocs/Web_Project-full-stack/1.LoginPage/RegisterUser.php";
        ?>
        <div id="User_loggedin">you are logged in as:
            <?php
        require_once  "C:/xampp/htdocs/Web_Project-full-stack/1.LoginPage/LoginUser.php";
=======
        require_once  "./1.LoginPage/LoginUser.php";
        require_once  "./1.LoginPage/RegisterUser.php";
        ?>
        <div id="User_loggedin">you are logged in as:
            <?php
        require_once  "./1.LoginPage/LoginUser.php";
>>>>>>> 1b5fb0b1de7b1f5074f6655be32093823ab03dd2
                echo $_SESSION['Logged User'];
            ?>
        </div>
    </header>
    <div id="iframe_submit_offer" class="iframe_submit_offer_close">
        <iframe id="form_submit_iframe" class="form_submit_iframe_close" src="../5.SubmissionPage/SubmissionPage.php" title="formfill"></iframe>
    </div>
    <div class="content_class" id="content_id">
        <nav class="sidebar_left_class" id="sidebar_left">
            <div class="sidebar_left_menu_class" id="sidebar_left_menu">
                <ul class="menu_links_class" id="menu_links">
                    <li class="nav_link">
                        <a href="#" id="menu_button_1"">
                            <i class='bx bx-cog icon'></i>
                            <span class=" text nav-text">User Settings</span>
                        </a>
                    </li>
                    <li class="nav_link">
                        <a href="#" id="menu_button_2">
                            <i class='bx bx-like icon'></i>
                            <span class="text nav-text">Likes History
                            </span>
                        </a>
                    </li>
                    <li class="nav_link">
                        <a href="#" id="menu_button_3">
                            <i class='bx bx-history icon'></i>
                            <span class="text nav-text">Offers History</span>
                        </a>
                    </li>
                    <li class="nav_link">
                        <a href="#" id="menu_button_4">
                            <i class='bx bxs-invader icon'></i>
                            <span class="text nav-text">SCORE & TOKENS</span>
                        </a>
                    </li>
                    <!-- <li class="nav_link">
                        <a href="#" id="menu_button_5">
                            <i class='bx bx-heart icon'></i>
                            <span class="text nav-text">Υποβολή</span>
                        </a>
                    </li>
                    <li class="nav_link">
                        <a href="#" id="menu_button_6">
                            <i class='bx bx-wallet icon'></i>
                            <span class="text nav-text">Ιστορικό Υποβολών</span>
                        </a>
                    </li> -->
            </div>

        </nav>
        <div class="map_widnow" id="map_window">
            <form></form>
            <div id="map_text"></div>
            <div id="map"></div>
            <div class="PopUpMenus">
                <div id="PopUpSettings" class="PopUpSettings_class">
                    <span id="close_button_popupsettings" class="close">&times;</span>
                    <div id="Tabs">
                        <div id="Tab_1" class="tabcontent">
                            <h3 id="usersettingsheader">User's Settings</h3>
                            <form id="Change_Credentials_Form">
                                <div id="settings_username" class="form-group">
                                    <label for="username">Username: </label>
                                    <input type="text" id="Change_User" required="required" value="<?php echo $_SESSION['Logged User']; ?>" />
                                </div>
                                <div id="settings_email" class="form-group">
                                    <label for="username">E-mail: </label>
                                    <input type="email" id="Change_Email" required="required" value="<?php echo $_SESSION['Logged Email']; ?>" />
                                </div>
                                <div id="settings_password" class="form-group">
                                    <label for="username">Password: </label>
                                    <input type="password" id="Change_Password" required="required" value="<?php echo $_SESSION['Logged Password']; ?>"></input>
                                </div>
                                <div id="settings_confpassword" class="form-group">
                                    <label for="username">Confirmation Password </label>
                                    <input type="password" id="Confirm_Password" required="required" value="<?php echo $_SESSION['Logged Confirm Password']; ?>"></input>
                                </div>
                                <div>
                                    <div id="settings_update">
                                        <!-- <label for="Update_Credentials">Update Credentials:</label> -->
                                        <input type="submit" id="Update_Credentials" value="Update Credentials"></input>
                                    </div>
                                    <div id="settings_show">
                                        <label for="Show_Password">Show Password:</label>
                                        <input type="checkbox" id="Show_Password"></input>
                                    </div>
                                </div>
                            </form>
                        </div>
                        <div id="Tab_2" class="tabcontent">
                            <h3 id="likesheader">Likes/Dislikes History</h3>

                            <table id="likes_history_table">
                                <thead id="likes_history_headers">
                                    <tr id="likes_header_row">
                                        <th id="likes_header_rank">No.</th>
                                        <th class="likes_header">Action</th>
                                        <th class="likes_header">Offer Number</th>
                                        <th class="likes_header">Date</th>
                                        <th class="likes_header">Offer Publisher</th>
                                    </tr>
                                </thead>
                                <tbody id="likes_history_body">
                                    <tr id="likes_row1" class="likes_row">
                                        <td class="likes_cell_rank">1</td>
                                        <td class="likes_cell">like</td>
                                        <td class="likes_cell">12</td>
                                        <td class="likes_cell">12/05/2023</td>
                                        <td class="likes_cell">ilias</td>
                                    </tr>
                                    <tr id="likes_row2" class="likes_row">
                                        <td class="likes_cell_rank">1</td>
                                        <td class="likes_cell">like</td>
                                        <td class="likes_cell">12</td>
                                        <td class="likes_cell">12/05/2023</td>
                                        <td class="likes_cell">ilias</td>
                                    </tr>
                                    <tr id="likes_row3" class="likes_row">
                                        <td class="likes_cell_rank">1</td>
                                        <td class="likes_cell">like</td>
                                        <td class="likes_cell">12</td>
                                        <td class="likes_cell">12/05/2023</td>
                                        <td class="likes_cell">ilias</td>
                                    </tr>
                                    <tr id="likes_row4" class="likes_row">
                                        <td class="likes_cell_rank">1</td>
                                        <td class="likes_cell">like</td>
                                        <td class="likes_cell">12sadasdasdasdasdasd</td>
                                        <td class="likes_cell">12/05/2023asdasdasdasdasdas</td>
                                        <td class="likes_cell">iliaasdasdasdasdsas</td>
                                    </tr>
                                    <tr id="likes_row5" class="likes_row">
                                        <td class="likes_cell_rank">1</td>
                                        <td class="likes_cell">like</td>
                                        <td class="likes_cell">12</td>
                                        <td class="likes_cell">12/05/2023</td>
                                        <td class="likes_cell">ilias</td>
                                    </tr>
                                    <tr id="likes_row6" class="likes_row">
                                        <td class="likes_cell_rank">1</td>
                                        <td class="likes_cell">like</td>
                                        <td class="likes_cell">12</td>
                                        <td class="likes_cell">12/05/2023</td>
                                        <td class="likes_cell">ilias</td>
                                    </tr>
                                </tbody>
                            </table>

                        </div>
                        <div id="Tab_3" class="tabcontent">
                            <h3 id="offers_history_header">Offer Submittion History</h3>
                            <p></p>
                            <table id="offer_history_table">
                                <thead id="offer_history_headers">
                                    <tr id="offer_header_row">
                                        <th id="offer_header_rank">No.</th>
                                        <th class="offer_header">Offer ID</th>
                                        <th class="offer_header">Subm. Date</th>
                                        <th class="offer_header">Active</th>
                                        <th class="offer_header">Price</th>
                                        <th class="offer_header">Shop</th>
                                    </tr>
                                </thead>
                                <tbody id="offer_history_body">
                                    <tr id="offer_row1" class="offer_row">
                                        <td class="offer_cell_rank">1</td>
                                        <td class="offer_cell">like</td>
                                        <td class="offer_cell">12</td>
                                        <td class="offer_cell">12/05/2023</td>
                                        <td class="offer_cell">ilias</td>
                                        <td class="offer_cell">ilias</td>
                                    </tr>
                                    <tr id="offer_row2" class="offer_row">
                                        <td class="offer_cell_rank">1</td>
                                        <td class="offer_cell">like</td>
                                        <td class="offer_cell">12</td>
                                        <td class="offer_cell">12/05/2023</td>
                                        <td class="offer_cell">ilias</td>
                                        <td class="offer_cell">ilias</td>
                                    </tr>
                                    <tr id="offer_row3" class="offer_row">
                                        <td class="offer_cell_rank">1</td>
                                        <td class="offer_cell">like</td>
                                        <td class="offer_cell">12</td>
                                        <td class="offer_cell">12/05/2023</td>
                                        <td class="offer_cell">ilias</td>
                                        <td class="offer_cell">ilias</td>
                                    </tr>
                                    <tr id="offer_row4" class="offer_row">
                                        <td class="offer_cell_rank">1</td>
                                        <td class="offer_cell">like</td>
                                        <td class="offer_cell">12</td>
                                        <td class="offer_cell">12/05/2023</td>
                                        <td class="offer_cell">ilias</td>
                                        <td class="offer_cell">ilias</td>
                                    </tr>
                                    <tr id="offer_row5" class="offer_row">
                                        <td class="offer_cell_rank">1</td>
                                        <td class="offer_cell">like</td>
                                        <td class="offer_cell">12</td>
                                        <td class="offer_cell">12/05/2023</td>
                                        <td class="offer_cell">ilias</td>
                                        <td class="offer_cell">ilias</td>
                                    </tr>
                                    <tr id="offer_row6" class="offer_row">
                                        <td class="offer_cell_rank">1</td>
                                        <td class="offer_cell">like</td>
                                        <td class="offer_cell">12</td>
                                        <td class="offer_cell">12/05/2023</td>
                                        <td class="offer_cell">ilias</td>
                                        <td class="offer_cell">ilias</td>
                                    </tr>
                                    <tr id="offer_row7" class="offer_row">
                                        <td class="offer_cell_rank">1</td>
                                        <td class="offer_cell">like</td>
                                        <td class="offer_cell">12</td>
                                        <td class="offer_cell">12/05/2023</td>
                                        <td class="offer_cell">ilias</td>
                                        <td class="offer_cell">ilias</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div id="Tab_4" class="tabcontent">
                            <h3 id="user_score_header">User Score</h3>
                            <div id="tokens_border">
                                <label id="total_tokens_lbl" for="total_tokens">Total TOKENS: </label>
                                <div id="total_tokens">13123</div>                            
                                
                                <label id="current_tokens_lbl" for="total_tokens">Current TOKENS: </label>
                                <div id="current_tokens">123123</div>
                                
                            </div>
                            <div id="score_border">
                                <label id="total_score_lbl" for="total_tokens">Total Score: </label>
                                <div id="total_score">231312</div>
                                
                                <label id="current_score_lbl" for="total_tokens">Current Score: </label>
                                <div id="current_score">1231231</div>
                            
                            </div>
                        </div>
                        <!-- <div id="Tab_5" class="tabcontent">
                            <h3>Υποβολή</h3>
                            <p></p>
                        </div>
                        <div id="Tab_6" class="tabcontent">
                            <h3></h3>
                            <table id="Offers_Table">Ιστορικό Υποβολών
                                <thead id="Offers_Table_header">
                                    <th class="Off_T_user_header">No</th>
                                    <th class="Off_T_user_header">Username</th>
                                    <th class="Off_T_pass_header">Password</th>
                                    <th class="Off_T_mail_header">E-mail</th>
                                    <th class="Off_T_mail_header">Date Created</th>
                                    <th class="Off_T_mail_header">Latitude</th>
                                    <th class="Off_T_mail_header">Longitude</th>
                                    <th class="Off_T_mail_header">Month Score</th>
                                    <th class="OFF_T_select">Show Info</th>
                                </thead>
                                <tbody id="Offers_Table_body">
                                </tbody>
                            </table>
                            <button type="button" onclick="FindOffersTable()">Show All Offers</button>
                        </div> -->
                    </div>

                </div>
                <!-- <div id="PopUpFilters" class="PopUpFilters_class">
                    <div>
                    </div>
                </div> -->
            </div>
        </div>
    </div>
    <nav class="sidebar_right_class" id="sidebar_right">
        <div class="sidebar_right_menu_class" id="sidebar_right_menu">
            <ul class="filters_class" id="filters">
                <li class="filter_box" id="filter_1">
                    <span class="text nav-text">Search By Shop Name </span>
                <li class="search-box" id="search_by_name">
                    <a href="#" draggable="false">
                        <i class='bx bx-search icon'></i>
                        <input id="search_result" type="text" placeholder="Shop Name...">
                    </a>
                </li>
                </li>
                <li class="filter_box" id="filter_2">
                    <span class="text nav-text">Search By Item Category</span>
                <li class="search-box" id="search_by_item_category">
                    <a href="#" draggable="false">
                        <i class='bx bx-search icon'></i>
                        <input id="search_result_category" type="text" placeholder="Item Category...">
                    </a>
                </li>
                </li>
                <li class="r_s_logout_button_class" id="r_s_logout_button">
                    <a href="#">
                        <i class='bx bx-log-out icon'></i>
                        <span class="text nav-text">Logout</span>
                    </a>
                </li>
        </div>
    </nav>
    <footer class="footer_class" id="footer">
    </footer>
    <div name='scripts'>
        <script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js" integrity="sha256-WBkoXOwTeyKclOHuWtc+i2uENFpDZ9YPdf5Hf+D7ewM=" crossorigin=""></script>
        <script type="text/javascript" src="https://code.jquery.com/jquery-3.6.4.min.js"></script>

        <script type="text/javascript" src="../AdditionalFiles/JS_leaflet.js"></script>
        <script type="text/javascript" src="MainMenuPage.js"></script>

        <script type="text/javascript" src="GeolocationPosition/WatchPosition.js"></script>

        <script type="text/javascript" src="LeafletandMarkers/CreateMarkers.js"></script>
        <script type="text/javascript" src="LeafletandMarkers/CreatePopupMenu.js"></script>

        <script type="text/javascript" src="MainFunctionality/OfferHistory.js"></script>
        <script type="text/javascript" src="MainFunctionality/UserSettings.js"></script>

        <script type="text/javascript" src="../ApacheRESTServices/JS_GetDatabaseData.js"></script>
    </div>
</body>

</html>