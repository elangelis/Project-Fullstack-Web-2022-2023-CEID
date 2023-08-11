function FindOffersTable(){

    $.ajax({ 
        url: 'GET_OfferHistory.php',
        type: 'post',
        success: function(data) {

            var ArrayNew = {}
            ArrayNew = JSON.parse(data);
            var tableContent ='';
            console.log(ArrayNew);

            for (var i = 0; i < ArrayNew.length; i++) {
                tableContent += '<tr class="Offers_Table_row">';
                    tableContent += '<td class="Offers_Table_count">' + (i+1) + '</td>';
                    tableContent += '<td class="Offers_Table_cells">' + ArrayNew[i].username + '</td>';
                    tableContent += '<td class="Offers_Table_cells">' + ArrayNew[i].password + '</td>';
                    tableContent += '<td class="Offers_Table_cells">' + ArrayNew[i].email + '</td>';
                    tableContent += '<td class="Offers_Table_cells">' + ArrayNew[i].date_creation + '</td>';
                    tableContent += '<td class="Offers_Table_cells">' + ArrayNew[i].latitude + '</td>';
                    tableContent += '<td class="Offers_Table_cells">' + ArrayNew[i].longitude + '</td>';
                    tableContent += '<td class="Offers_Table_cells">' + ArrayNew[i].user_token_month + '</td>';
                    tableContent += '<td class="Offers_Table_cells">'+ '<input id="row_button_' + i + '" class="Offers_Tbl_button" type="checkbox"></input>'+'</td>'
                tableContent += '</tr>';
            }
            
            //var string=tableContent.toString();
            OffersTableBody.innerHTML = tableContent;
            
            //document.replaceChild(function(){
            //        OffersTableBody.append(string);
            //})
                   
      
        }
        
    });
}

