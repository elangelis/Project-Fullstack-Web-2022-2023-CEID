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

map.setView([0, 0], 12);

/*
function CreateLayer() {
    MarkerArray[1] = L.marker([39.61, -105.02]).bindPopup('This is Littleton, CO.');
    MarkerArray[2] = L.marker([39.74, -104.99]).bindPopup('This is Denver, CO.');
    MarkerArray[3] = L.marker([39.73, -104.8]).bindPopup('This is Aurora, CO.');
    MarkerArray[4] = L.marker([39.77, -105.23]).bindPopup('This is Golden, CO.');
    MarkerArrayLayerGroup = new Array();
    MarkerArrayLayerGroup.push(MarkerArray[1]);
    MarkerArrayLayerGroup.push(MarkerArray[2]);
    MarkerArrayLayerGroup.push(MarkerArray[3]);
    MarkerArrayLayerGroup.push(MarkerArray[4]);
    markersLayer = L.layerGroup(MarkerArrayLayerGroup);
}
map.removeLayer(markersLayer);
markersLayer.addTo(map);
*/





//alert(" Leaflet Loaded");