<!DOCTYPE html>
<html>

<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="AdminPage.css">
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css" />
    <script src="https://code.jquery.com/jquery-1.11.1.min.js"></script>
    <script src="https://code.jquery.com/ui/1.11.1/jquery-ui.min.js"></script>
    
</head>

<body id="body">
    <h1 id="pageheader">Administrator Page</h1>
    <div id="content" class="container">

        <div id="insertdatamenu">
            <h2 id="insertdatamenuHeader">Database</h2>
            <div id="datamenu">
                <ul id="buttons_data_list">
                    <li class="buttons_data">
                        <label class="button_labels" for="option1">Add Products, Categories, Sub-Categories</label>
                        <input id="option1" type="file"></input>
                    </li>
                    <li class="buttons_data">
                        <label class="button_labels" for="option2">Add Product Prices</label>
                        <input id="option2" type="file"></input>
                    </li>
                    <li class="buttons_data">
                        <label class="button_labels" for="option3">Add POI's Manually</label>
                        <input id="option3" type="file"></input>
                    </li>
                    <li class="buttons_data">
                        <label class="button_labels" for="option4">Fetch POI's API Call</label>
                        <button id="option4" type="file"></button>
                    </li>
                    <li class="buttons_data">
                        <label class="button_labels" for="option5">Delete POI's</label>
                        <button id="option5" type="button"></button>
                    </li>
                    <li class="buttons_data">
                        <label class="button_labels" for="option6">Delete ALL Data</label>
                        <button id="option6" type="button"></button>
                    </li>
                </ul>
            </div>

        </div>

        <div id="leaderboardmenu">
            <div id="boardmenu">

                <h2 id="boardmenuHeader">Leaderboard</h2>
                <div id="prevnextbuttons">
                    
                        <a id="previous" href="#" class="previous">&laquo; Previous</a>  
                        <a id="current"href="#" class="current">1</a>                        
                        <a id="next" href="#" class="next">Next &raquo;</a>

                </div>
                <table id="boardmenuTable">
                    <thead id="boardmenu_headers">
                        <tr id="headers_row">
                            <th class="boardt_header_rank">Ranking</th>
                            <th class="boardt_header">username</th>
                            <th class="boardt_header">full name</th>
                            <th class="boardt_header">total score</th>
                            <th class="boardt_header">date created</th>
                            <th class="boardt_header">offers created</th>
                            <th class="boardt_header">likes</th>
                            <th class="boardt_header">dislikes</th>
                            <th class="boardt_header">Current Month Tokens</th>
                            <th class="boardt_header">Total Tokens</th>
                        </tr>
                    </thead>
                    <tbody id="boardmenu_body">
                        <!-- <tr id="row1" class="boardt_row">
                            <td class="boardt_cell_rank">1</td>
                            <td class="boardt_cell">tesadsadsast1123123131321</td>
                            <td class="boardt_cell">tesadsadsast1123123131321</td>
                            <td class="boardt_cell">tesadsadsast1123123131321</td>
                            <td class="boardt_cell">tesadsadsast1123123131321</td>
                            <td class="boardt_cell">tesadsadsast1123123131321</td>
                            <td class="boardt_cell">tesadsadsast1123123131321</td>
                            <td class="boardt_cell">tesadsadsast1123123131321</td>
                        </tr>
                        <tr id="row2" class="boardt_row">
                            <td class="boardt_cell_rank">2</td>
                            <td class="boardt_cell">test2</td>
                            <td class="boardt_cell">test2sdsadsadasdsa</td>
                            <td class="boardt_cell">testasdasdasd2</td>
                            <td class="boardt_cell">test2</td>
                            <td class="boardt_cell">tesasdasdasdt2</td>
                            <td class="boardt_cell">tessadasdsadt2</td>
                            <td class="boardt_cell">test2</td>
                        </tr>
                        <tr id="row3" class="boardt_row">
                            <td class="boardt_cell_rank">3</td>
                            <td class="boardt_cell">test2</td>
                            <td class="boardt_cell">test2sdsadsadasdsa</td>
                            <td class="boardt_cell">testasdasdasd2</td>
                            <td class="boardt_cell">test2</td>
                            <td class="boardt_cell">tesasdasdasdt2</td>
                            <td class="boardt_cell">tessadasdsadt2</td>
                            <td class="boardt_cell">test2</td>
                        </tr>
                        <tr id="row4" class="boardt_row">
                            <td class="boardt_cell_rank">4</td>
                            <td class="boardt_cell">test2</td>
                            <td class="boardt_cell">test2sdsadsadasdsa</td>
                            <td class="boardt_cell">testasdasdasd2</td>
                            <td class="boardt_cell">test2</td>
                            <td class="boardt_cell">tesasdasdasdt2</td>
                            <td class="boardt_cell">tessadasdsadt2</td>
                            <td class="boardt_cell">test2</td>
                        </tr>
                        <tr id="row5" class="boardt_row">
                            <td class="boardt_cell_rank">5</td>
                            <td class="boardt_cell">test2</td>
                            <td class="boardt_cell">test2sdsadsadasdsa</td>
                            <td class="boardt_cell">testasdasdasd2</td>
                            <td class="boardt_cell">test2</td>
                            <td class="boardt_cell">tesasdasdasdt2</td>
                            <td class="boardt_cell">tessadasdsadt2</td>
                            <td class="boardt_cell">test2</td>
                        </tr>
                        <tr id="row6" class="boardt_row">
                            <td class="boardt_cell_rank">6</td>
                            <td class="boardt_cell">test2</td>
                            <td class="boardt_cell">test2sdsadsadasdsa</td>
                            <td class="boardt_cell">testasdasdasd2</td>
                            <td class="boardt_cell">test2</td>
                            <td class="boardt_cell">tesasdasdasdt2</td>
                            <td class="boardt_cell">tessadasdsadt2</td>
                            <td class="boardt_cell">test2</td>
                        </tr>
                        <tr id="row7" class="boardt_row">
                            <td class="boardt_cell_rank">7</td>
                            <td class="boardt_cell">test2</td>
                            <td class="boardt_cell">test2sdsadsadasdsa</td>
                            <td class="boardt_cell">testasdasdasd2</td>
                            <td class="boardt_cell">test2</td>
                            <td class="boardt_cell">tesasdasdasdt2</td>
                            <td class="boardt_cell">tessadasdsadt2</td>
                            <td class="boardt_cell">test2</td>
                        </tr>
                        <tr id="row8" class="boardt_row">
                            <td class="boardt_cell_rank">8</td>
                            <td class="boardt_cell">test2</td>
                            <td class="boardt_cell">test2sdsadsadasdsa</td>
                            <td class="boardt_cell">testasdasdasd2</td>
                            <td class="boardt_cell">test2</td>
                            <td class="boardt_cell">tesasdasdasdt2</td>
                            <td class="boardt_cell">tessadasdsadt2</td>
                            <td class="boardt_cell">test2</td>
                        </tr>
                        <tr id="row9" class="boardt_row">
                            <td class="boardt_cell_rank">9</td>
                            <td class="boardt_cell">test2</td>
                            <td class="boardt_cell">test2sdsadsadasdsa</td>
                            <td class="boardt_cell">testasdasdasd2</td>
                            <td class="boardt_cell">test2</td>
                            <td class="boardt_cell">tesasdasdasdt2</td>
                            <td class="boardt_cell">tessadasdsadt2</td>
                            <td class="boardt_cell">test2</td>
                        </tr>
                        <tr id="row10" class="boardt_row">
                            <td class="boardt_cell_rank">10</td>
                            <td class="boardt_cell">test2</td>
                            <td class="boardt_cell">test2sdsadsadasdsa</td>
                            <td class="boardt_cell">testasdasdasd2</td>
                            <td class="boardt_cell">test2</td>
                            <td class="boardt_cell">tesasdasdasdt2</td>
                            <td class="boardt_cell">tessadasdsadt2</td>
                            <td class="boardt_cell">test2</td>
                        </tr>
                        <tr id="row11" class="boardt_row">
                            <td class="boardt_cell_rank">11</td>
                            <td class="boardt_cell">test2</td>
                            <td class="boardt_cell">test2sdsadsadasdsa</td>
                            <td class="boardt_cell">testasdasdasd2</td>
                            <td class="boardt_cell">test2</td>
                            <td class="boardt_cell">tesasdasdasdt2</td>
                            <td class="boardt_cell">tessadasdsadt2</td>
                            <td class="boardt_cell">test2</td>
                        </tr>
                        <tr id="row12" class="boardt_row">
                            <td class="boardt_cell_rank">12</td>
                            <td class="boardt_cell">test2</td>
                            <td class="boardt_cell">test2sdsadsadasdsa</td>
                            <td class="boardt_cell">testasdasdasd2</td>
                            <td class="boardt_cell">test2</td>
                            <td class="boardt_cell">tesasdasdasdt2</td>
                            <td class="boardt_cell">tessadasdsadt2</td>
                            <td class="boardt_cell">test2</td>
                        </tr>
                        <tr id="row13" class="boardt_row">
                            <td class="boardt_cell_rank">13</td>
                            <td class="boardt_cell">test2</td>
                            <td class="boardt_cell">test2sdsadsadasdsa</td>
                            <td class="boardt_cell">testasdasdasd2</td>
                            <td class="boardt_cell">test2</td>
                            <td class="boardt_cell">tesasdasdasdt2</td>
                            <td class="boardt_cell">tessadasdsadt2</td>
                            <td class="boardt_cell">test2</td>
                        </tr>
                        <tr id="row14" class="boardt_row">
                            <td class="boardt_cell_rank">14</td>
                            <td class="boardt_cell">test2</td>
                            <td class="boardt_cell">test2sdsadsadasdsa</td>
                            <td class="boardt_cell">testasdasdasd2</td>
                            <td class="boardt_cell">test2</td>
                            <td class="boardt_cell">tesasdasdasdt2</td>
                            <td class="boardt_cell">tessadasdsadt2</td>
                            <td class="boardt_cell">test2</td>
                        </tr>
                        <tr id="row15" class="boardt_row">
                            <td class="boardt_cell_rank">15</td>
                            <td class="boardt_cell">test2</td>
                            <td class="boardt_cell">test2sdsadsadasdsa</td>
                            <td class="boardt_cell">testasdasdasd2</td>
                            <td class="boardt_cell">test2</td>
                            <td class="boardt_cell">tesasdasdasdt2</td>
                            <td class="boardt_cell">tessadasdsadt2</td>
                            <td class="boardt_cell">test2</td>
                        </tr> -->
                    </tbody>
                </table>
            </div>
        </div>

        <div id="graphmenu">
            <h2>Graphs</h2>
            
            <div>graph1</div>
            <div>graph2</div>
        </div>


    </div>
    <div name='scripts'>
        <script type="text/javascript" src="AdminPage.js"></script>
        <script src="https://code.jquery.com/jquery-1.11.1.min.js"></script>
        <script src="https://code.jquery.com/ui/1.11.1/jquery-ui.min.js"></script>
        </div>
</body>

</html>