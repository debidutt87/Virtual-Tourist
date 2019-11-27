# Virtual Tourist

## Project Overview
The Virtual Tourist app downloads and stores images from Flickr. The app allows users to drop pins on a map, as if they were stops on a tour. Users will then be able to download pictures for the location and persist both the pictures, and the associated pictures with the pin.

## Why this project?
The project requires to persist a complex model using Core Data, and plist persistence of an array of dictionaries - core skills required of any iOS Developer.

## What will you learn?
Use NSURLSessions to interact with a public restful API
Create a user interface that intuitively communicates network activity and download progress
Store media on the device file system Use Core Data for local persistence of an object structure

## Requirements to run this app
### Versions:
Xcode 11+
Swift 4+

## API Used
## Flickr API:
This app uses the Flickr API to get the photos associated to an specific location. In order to use this app, you'll have to provide your own Flickr API key. To configure it, you'll need to add a new file called keys.xcconfig, inside the Supporting Files/Secrets/ folder.

Inside this file you can place your api key like this: FLICKR_API_KEY = YOUR_API_KEY_HERE. There's also a keys.example.xcconfig file you can use to copy this simple configuration.
