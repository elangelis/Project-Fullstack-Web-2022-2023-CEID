    var LayerUser;  
    let i=1000000000000000000000000000000000n;


    var CurrentUser=[];
    var lat,lng,accuracy;
    let MarkersFetched,MarkersCreated;
    var Usermarker,Usercircle;
    



   const options = {
    enableHighAccuracy: true, 
    // Get high accuracy reading, if available (default false)
    timeout: 500000, 
    // Time to return a position successfully before error (default infinity)
    maximumAge: 2000, 
    // Milliseconds for which it is acceptable to use cached position (default 0)
    };
    
    function errorCallback(err){
        if (err.code==1){
            alert("Please allow Geolocation Access");
        }else{
            alert("Cannot Get Current Location");
        }
    }
    
    function success(position){
        i++;
        if(i>=1000000000n){
            i=0;
            lat = position.coords.latitude,
            lng = position.coords.longitude,
            accuracy = position.coords.accuracy; // Accuracy in metres
            if(Usermarker){
                map.removeLayer(Usermarker);
                map.removeLayer(Usercircle);
            }
            Usermarker = L.marker([lat,lng]).addTo(map);
            Usercircle = L.circle([lat,lng],{fillColor: '#f03',fillOpacity: 0.5,radius:100}).addTo(map);
            
            LayerUser = L.layerGroup(Usermarker,Usercircle);
            LayerUser.addTo(map);
            map.fitBounds(Usercircle.getBounds());
            map.setView([lat,lng],14);
            update_Lat_Long(lat,lng);
        }
    }

    function successForce(position){
        
        lat = position.coords.latitude,
        lng = position.coords.longitude,
        accuracy = position.coords.accuracy; // Accuracy in metres
        
        update_Lat_Long(lat,lng);
    }
    
    
    navigator.geolocation.watchPosition(success, errorCallback, options);
    
    function update_Lat_Long(lat,lng) {
        var userdata = {};
        userdata.lat=lat;
        userdata.long=lng;

        $.ajax({
            url:"GeolocationPosition/SEND_UserLocation.php",
            method:"post",
            data:  {userdata1:JSON.stringify(userdata)},
            success: function(data){    
                
                console.log(userdata); 
                CurrentUser.latitude=userdata.lat;
                CurrentUser.longitude=userdata.long;
            },
            error:  function(e){
                console.log(e);
            }
        });
    }
