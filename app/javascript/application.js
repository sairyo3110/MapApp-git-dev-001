// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

var searchButton = document.querySelector('.search-button');
var routeButton = document.querySelector('.route-button');
var sidebar = document.querySelector('.sidebar');
var closeButton = document.querySelector('.close-button');
var searchContent = document.getElementById('search-content');
var routeContent = document.getElementById('route-content');

searchButton.addEventListener('click', function(event) {
  event.preventDefault();
  searchContent.style.display = 'block';
  routeContent.style.display = 'none';
  sidebar.classList.add('show');
});

routeButton.addEventListener('click', function(event) {
  event.preventDefault();
  searchContent.style.display = 'none';
  routeContent.style.display = 'block';
  sidebar.classList.add('show');
});

closeButton.addEventListener('click', function(event) {
  event.preventDefault();
  sidebar.classList.remove('show');
})

mapboxgl.accessToken = 'pk.eyJ1IjoiMzExMHJ5b3UiLCJhIjoiY2xkcG5wbjN4MTUyODNvdGJxNWF4bmR1ayJ9.cod8B0HJHns-hMdsMjRglg';

var map = new mapboxgl.Map({
  container: 'map',
  style: 'mapbox://styles/3110ryou/cldpq4wt0000301n13isaug1m',
  center: [139.6917, 35.6895], // 東京都庁の緯度経度情報
  zoom: 12, // 適切な拡大率を指定
  maxBounds: [ // マップの表示範囲を東京都内に限定
    [139.562587, 35.531549],
    [139.910206, 35.817813]
  ]
});

navigator.geolocation.getCurrentPosition(function(position) {
  var lng = position.coords.longitude;
  var lat = position.coords.latitude;
  map.jumpTo({center: [lng, lat], zoom: 14});
});

var geolocate = new mapboxgl.GeolocateControl({
  positionOptions: {
    enableHighAccuracy: true
  },
  trackUserLocation: true
});

map.addControl(geolocate, 'top-right');

var geocoder = new MapboxGeocoder({
  accessToken: mapboxgl.accessToken,
  mapboxgl: mapboxgl
});
document.getElementById('search-box').appendChild(geocoder.onAdd(map));

var markers = [];

var locations = document.querySelectorAll('.location');
locations.forEach(function(location) {
  var id = location.getAttribute('id');
  var latitude = location.getAttribute('data-latitude');
  var longitude = location.getAttribute('data-longitude');
  var icon = location.getAttribute('data-icon');

  var popup = new mapboxgl.Popup()
    .setHTML(`<iframe src="/maps/${id}/popup"></iframe>`);

  var el = document.createElement('div');
  el.className = 'marker';
  el.style.backgroundImage = `url(${icon}.png)`;
  el.setAttribute('data-type', icon); // マーカーの種別を属性に追加

  var marker = new mapboxgl.Marker(el)
    .setLngLat([longitude, latitude])
    .setPopup(popup);
  markers.push(marker);
  marker.addTo(map); // マーカーを地図に追加
});

var geocoder = new MapboxGeocoder({
  accessToken: mapboxgl.accessToken,
  mapboxgl: mapboxgl,
  marker: false // マーカーを非表示にする
});
document.getElementById('geocoder').appendChild(geocoder.onAdd(map));

var imageContainers = document.querySelectorAll('.image-container');

imageContainers.forEach(function(container) {
  container.addEventListener('click', function() {
    var type = container.getAttribute('data-type');

    markers.forEach(function(marker) {
      var markerType = marker.getElement().getAttribute('data-type');

      if (markerType === type) {
        marker.addTo(map);
      } else {
        marker.remove();
      }
    });
  });
});

markers.forEach(function (marker, index) {
  // Add click event listener to each marker
  marker.getElement().addEventListener('click', function () {
    // Set the appropriate URL for the iframe in the sidebar
    var iframe = document.querySelector('.sidebar-content iframe');
    var locationId = locations[index].getAttribute('id');
    iframe.src = `/maps/${locationId}/content`;

    // Show the sidebar if it's not visible
    if (!sidebar.classList.contains('show')) {
      sidebar.classList.add('show');
    }
  });
});