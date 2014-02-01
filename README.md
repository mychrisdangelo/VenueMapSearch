Venue Map Search App
===================

Chris D'Angelo  
cd2665@columbia.edu  
1/31/14  
Cellular Networks & Mobile Computing  
Assignment 1  

Demo
====
<p align="center"><img src="https://github.com/mychrisdangelo/VenueMapSearch/tree/master/github-assets/quick-tour.gif"/></p>

Description
==========

A simplified Google Maps like app for iPhone. Category Selection was created and 
later abandoned because it is not a requirement of the Google Places API. 
IB element was removed but the code remains. You may view the search results as a list by pressing the 
list icon in the lower right hand of the map icon. Each venue with a pin in 
the map can be selected and minimal information can be looked at by pressing 
the callout. Responsive to vertical & horizontal orientations for the 
most part. iPhone only.

Sources
=======

Apple Documentation Samples:
* CurrentAddress
* GeocoderDemo
* LocateMe
* MapCallouts
* MapSearch
* PhotosByLocation

Stanford cs193p Fall 2013 Course Example:
* [Photomania Map](http://www.stanford.edu/class/cs193p/cgi-bin/drupal/downloads-2013-winter)
    
Google Places API Framework:
* [COMSMapManager](https://github.com/williamFalcon/6998GoogleMapsFramework)

To Do
=====

1.  Keyword search is not robust but allows for multiword keyword search.
2.  Currently redrawing map in order to refresh annotations.
3.  Use FontAwesome for star rating.
4.  Add a promininent acitivity spinner while in search state.
