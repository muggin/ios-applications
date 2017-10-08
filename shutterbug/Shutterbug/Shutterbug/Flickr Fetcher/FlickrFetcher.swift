//
//  FlickrFetcher.swift
//  Shutterbug
//
//  Created by Wojtek on 7/31/14.
//  Copyright (c) 2014 Wojtek. All rights reserved.
//

import Foundation
//Flickr API key
let FlickrAPIKey: String = "9dfbeee5888a79630e4356073db27419"

//key paths to photos or places at top-leve of Flickr results
let FLICKR_RESULTS_PHOTOS: String = "photos.photo"
let FLICKR_RESULTS_PLACES: String = "places.place"

//keys to values in photo dictionary
let FLICKR_PHOTO_TITLE: String = "title"
let FLICKR_PHOTO_DESCRIPTION: String = "description._content"
let FLICKR_PHOTO_ID: String = "id"
let FLICKR_PHOTO_OWNER: String = "ownername"
let FLCIKR_PHOTO_UPLOAD_DATE: String = "dateupload"
let FLICKR_PHOTO_PLACE_ID: String = "place_id"

//keys to values in a places dictionary (TopPlaces)
let FLICKR_PLACE_NAME: String = "_content"
let FLICKR_PLACE_ID: String = "place_id"

//keys applicable to all types of Flickr dictionaries
let FLICKR_LATITUDE: String = "latitude"
let FLICKR_LONGITUDE: String = "longitude"
let FLICKR_TAGS: String = "tags"

let FLICKR_PLACE_NEIGHBORHOOD_NAME: String = "place.neighbourhood._content"
let FLICKR_PLACE_NEIGHBORHOOD_PLACE_ID: String = "place.neighbourhood.place_id"
let FLICKR_PLACE_LOCALITY_NAME: String = "place.locality._content"
let FLICKR_PLACE_LOCALITY_PLACE_ID: String = "place.locality.place_id"
let FLICKR_PLACE_REGION_NAME: String = "place.region._content"
let FLICKR_PLACE_REGION_PLACE_ID: String = "place.region.place_id"
let FLICKR_PLACE_COUNTY_NAME: String = "place.county._content"
let FLICKR_PLACE_COUNTY_PLACE_ID: String = "place.county.place_id"
let FLICKR_PLACE_COUNTRY_NAME: String = "place.country._content"
let FLICKR_PLACE_COUNTRY_PLACE_ID: String = "place.country.place_id"
let FLICKR_PLACE_REGION: String = "place.region"

class FlickrFetcher {
    enum FlickrPhotoFormat: Int {
        case FlickrPhotoFormatSquare = 1, FlickrPhotoFormatLarge = 2, FlickrPhotoFormatOriginal = 64
    }
    
    class func URLforQuery(query: String) -> NSURL {
        var new_query: String = "\(query)&format=json&nojsoncallback=1&api_key=\(FlickrAPIKey)"
        new_query = new_query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        return NSURL(string: new_query)
    }
    
    class func URLforTopPlaces() -> NSURL {
        return self.URLforQuery("https://api.flickr.com/services/rest/?method=flickr.places.getTopPlacesList&place_type_id=7")
    }
    
    class func URLforPhotoInPlace(flickrPlaceId: AnyObject!, maxResults: Int) -> NSURL {
        return self.URLforQuery("https://api.flickr.com/services/rest/?method=flickr.photos.search&place_id=\(flickrPlaceId)&per_page=\(maxResults)&extras=original_format,tags,description,geo,date_upload,owner_name,place_url")
    }
    
    class func URLforPhoto(photo: NSDictionary!, format: FlickrPhotoFormat) -> NSURL {
        var urlString = self.urlStringForPhoto(photo!, format: format)
        return NSURL(string: urlString)
    }
    
    class func URLforInformationAboutPlace(flickrPlaceId: AnyObject!) -> NSURL {
        return self.URLforQuery("https://api.flickr.com/services/rest/?method=flickr.places.getInfo&place_id=\(flickrPlaceId)")
    }
    
    class func URLforRecentGeoreferencedPhotos() -> NSURL {
        return self.URLforQuery("https://api.flickr.com/services/rest/?method=flickr.photos.search&license=1,2,4,7&has_geo=1&extras=original_format,description,geo,date_upload,owner_name")
    }
    
    class func urlStringForPhoto(photo: NSDictionary!, format: FlickrPhotoFormat) -> String? {
        var farm: AnyObject? = photo.objectForKey("farm")
        var server: AnyObject? = photo.objectForKey("server")
        var photo_id: AnyObject? = photo.objectForKey("id")
        var secret: AnyObject? = photo.objectForKey("secret")
        
        if (format == .FlickrPhotoFormatOriginal) {
            secret = photo.objectForKey("originalformat")
        }
        
        var fileType: String = "jpg"
        if (format == .FlickrPhotoFormatOriginal) {
            fileType = photo.objectForKey("originalformat") as String
        }
        
        if (farm == nil || server == nil || photo_id == nil || secret == nil) {
            return nil
        }
        
        var formatString: String = "s"
        switch(format) {
        case .FlickrPhotoFormatSquare: formatString = "s"
        case .FlickrPhotoFormatLarge: formatString = "b"
        case .FlickrPhotoFormatOriginal: formatString = "o"
        }
        return "http://farm\(farm!).static.flickr.com/\(server!)/\(photo_id!)_\(secret!)_\(formatString).\(fileType)"
    }
    
    class func extractNameOfPlace(placeId: AnyObject!, fromPlaceInformation place: NSDictionary!) -> String? {
        var name: String?
        
        if (placeId.isEqual(place.valueForKeyPath(FLICKR_PLACE_NEIGHBORHOOD_PLACE_ID))) {
            name = place.valueForKeyPath(FLICKR_PLACE_NEIGHBORHOOD_NAME) as String?
        } else if (placeId.isEqual(place.valueForKeyPath(FLICKR_PLACE_LOCALITY_PLACE_ID))) {
            name = place.valueForKeyPath(FLICKR_PLACE_LOCALITY_NAME) as String?
        } else if (placeId.isEqual(place.valueForKeyPath(FLICKR_PLACE_COUNTY_PLACE_ID))) {
            name = place.valueForKeyPath(FLICKR_PLACE_COUNTY_NAME) as String?
        } else if (placeId.isEqual(place.valueForKeyPath(FLICKR_PLACE_REGION_PLACE_ID))) {
            name = place.valueForKeyPath(FLICKR_PLACE_REGION_NAME) as String?
        } else if (placeId.isEqual(place.valueForKeyPath(FLICKR_PLACE_COUNTRY_PLACE_ID))) {
            name = place.valueForKeyPath(FLICKR_PLACE_COUNTRY_NAME) as String?
        }
        
        return name
    }
    
    class func extractRegionNameFromPlaceInformation(place: NSDictionary!) -> String? {
        return place.valueForKeyPath(FLICKR_PLACE_REGION_NAME) as AnyObject? as String?
    }
    
    
}
