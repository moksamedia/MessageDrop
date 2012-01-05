<?php

	// Get query parameters from POST
	$user = $_POST['user'];
	$lattitude = $_GET['lattitude'];
	$longitude = $_GET['longitude'];
	$accuracy = $_GET['accuracy'];
	$zoom = $_GET['zoom'];

?>			
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
		"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml">
		<head>
		<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
		<title>Google Maps JavaScript API Example: Map Markers</title>
		<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAGlEXPoruZ4XNK6r3at1WyxSklgTU91qF0nvIXi9K1uIe1gawhRSwXlRKxyp8R-HTgZ08BXoPj1ROBg"
		type="text/javascript"></script>
		<script type="text/javascript">

		function initialize() 
		{
			if (GBrowserIsCompatible()) 
			{
				var lattitude = <?php echo($lattitude) ?>;
				var longitude = <?php echo($longitude) ?>;
				var accuracy  = <?php echo($accuracy) ?>;
				var zoom = <?php echo($zoom) ?>;

				var center = new GLatLng(lattitude, longitude);
				
				var map = new GMap2(document.getElementById("map_canvas"));
				map.setCenter(center, zoom);
				
				map.addControl(new GLargeMapControl());
				
				
				//var pointNorthBounds = new GLatLng(36.0, -122.0);
				var pointNorthBounds = new GLatLng( lattitude + accuracy, longitude);
				var pointSouthBounds = new GLatLng(lattitude - accuracy, longitude);
				var pointEastBounds = new GLatLng(lattitude, longitude + accuracy);
				var pointWestBounds = new GLatLng(lattitude, longitude - accuracy);
				
				map.addOverlay(new GMarker(center));
				//map.addOverlay(new GMarker(pointNorthBounds));
				//map.addOverlay(new GMarker(pointSouthBounds));
				//map.addOverlay(new GMarker(pointEastBounds));
				//map.addOverlay(new GMarker(pointWestBounds));
				
				var polygon = new GPolygon([
										   pointNorthBounds,
										   pointEastBounds,
										   pointSouthBounds,
										   pointWestBounds,
										   pointNorthBounds
										   ], "#f33f00", 5, 1, "#ff0000", 0.2);
				map.addOverlay(polygon);
				
			}
		}

		</script>
		</head>
		<body onload="initialize()" onunload="GUnload()">
		<div id="map_canvas" style="width: 300px; height: 312px"></div>
		</body>
		</html>

