# Virtual Tourist

[![Swift Version](https://img.shields.io/badge/Swift-4.2-success.svg)](https://swift.org)
[![Xcode Version](https://img.shields.io/badge/Xcode-11-success.svg)](https://swift.org)
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](https://swift.org)

## Project Overview
The Virtual Tourist app downloads and stores images from Flickr. The app allows users to drop pins on a map, as if they were stops on a tour. Users will then be able to download pictures for the location and persist both the pictures, and the associated pictures with the pin.

## Features

- [x] Persisting state on the device.
- [x] Downloading data from network resources -Flickr API.
- [x] Building polished user interfaces with UIKit components.
- [x] Using MapKit.

## Requirements

- Mac Machine
- Xcode 11

## Installation
Download and unzip ```VirtualTourist.zip```. or use the following command on your termincal ```git clone https://github.com/debidutt87/Virtual-Tourist.git```


## How to use this app
1. After run VirtualTourist and to add pin, Press the favourite place on the map that you want to see Flickr pictures in that place.
2. When a pin is tapped, the app transitions to the photo album associated with the pin.
3. Click on any picture to delete it.
4. The Photo Album view has the `New Collection` button that initiates the download of a new album, replacing the images in the photo album with a new set from Flickr. The new set should contain different images (if available) from the ones previously displayed.
5. After quit VirtualTourist, the pins and pictures are saved.

## Why this project?
The project requires to persist a complex model using Core Data, and plist persistence of an array of dictionaries - core skills required of any iOS Developer.

## What will you learn?
Use NSURLSessions to interact with a public restful API
Create a user interface that intuitively communicates network activity and download progress
Store media on the device file system Use Core Data for local persistence of an object structure


## API Used
### Flickr API:
This app uses the Flickr API to get the photos associated to an specific location. In order to use this app, you'll have to provide your own Flickr API key. To configure it, you'll need to add a new file called keys.xcconfig, inside the Supporting Files/Secrets/ folder.

Inside this file you can place your api key like this: FLICKR_API_KEY = YOUR_API_KEY_HERE. There's also a keys.example.xcconfig file you can use to copy this simple configuration.
