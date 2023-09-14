//GLOBAL VARIABLES LEAFLET
//alert("Leaflet Start ");



var osm = L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 18,
    minZoom: 3,
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
});

const map = L.map('map', {
    zoom: 10,
    layers: [osm]
});


Usercircle = L.circle([51.508, -0.11], {
    color: 'red',
    fillColor: '#f03',
    fillOpacity: 0.1,
    radius: 500
}).addTo(map);

Usermarker = L.marker([51.5, -0.09]).addTo(map);

map.setView([38.0184653,23.8003564], 12);
var mapinitialised=true;
var locationinitialised=false;
// navigator.geolocation.watchPosition(success, errorCallback, options);



