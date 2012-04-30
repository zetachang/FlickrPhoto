/*
 * AppController.j
 * FlickrPhoto
 *
 * Created by David Chang (zetachang) on April 30, 2012.
 * Copyright 2012, All rights reserved.
 */

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>
@import "PhotoCell.j"
@import "PhotosListCell.j"

@implementation AppController : CPObject {
    CPWindow  theWindow; //this "outlet" is connected automatically by the Cib
    CPString  lastIdentifier;
    CPDictionary photosets;
    @outlet CPCollectionView  listCollectionView;
    @outlet CPCollectionView  photosCollectionView;
    @outlet CPSlider slider;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification {
  
      // This is called when the application is done loading.
      photosets = [CPDictionary dictionary]; //storage for our sets of photos return from Flickr
      
      
      // Customize the collectionView.
      [listCollectionView setMinItemSize:CGSizeMake(20.0, 45.0)];
      [listCollectionView setMaxItemSize:CGSizeMake(1000.0, 45.0)];
      [listCollectionView setVerticalMargin:0.0];

      [photosCollectionView setMinItemSize:CGSizeMake(150, 150)];
      [photosCollectionView setMaxItemSize:CGSizeMake(150, 150)];

      // Set max, min, interval of slider.
      [slider setMinValue:50.0];
      [slider setMaxValue:250.0];
      [slider setIntValue:150.0];
      
      // Bring forward the window to display it
      [theWindow orderFront:self];

      // Get the most interesting photos on flickr
      var request = [CPURLRequest requestWithURL:"http://www.flickr.com/services/rest/?method=flickr.interestingness.getList&per_page=20&format=json&api_key=ca4dd89d3dfaeaf075144c3fdec76756"];
      
      lastIdentifier = "Interesting Photos";

      var connection = [CPJSONPConnection sendRequest:request callback:"jsoncallback" delegate:self];
}

// ImageList Operation
- (void)addImageList:(CPArray)images withIdentifier:(CPString)aString {
    [photosets setObject:images forKey:aString];
    
    [listCollectionView setContent:[[photosets allKeys] copy]];
    [listCollectionView setSelectionIndexes:[CPIndexSet indexSetWithIndex:[[photosets allKeys] indexOfObject:aString]]];
}

- (void)removeImageListWithIdentifier:(CPString)aString {
    var nextIndex = MAX([[listCollectionView content] indexOfObject:aString] - 1, 0);
    
    [photosets removeObjectForKey:aString];

    [listCollectionView setContent:[[photosets allKeys] copy]];
    [listCollectionView setSelectionIndexes:[CPIndexSet indexSetWithIndex:nextIndex]];    
}

//CollectionView Delegate methods

- (void)collectionViewDidChangeSelection:(CPCollectionView)aCollectionView {
    if (aCollectionView == listCollectionView) {
        var listIndex = [[listCollectionView selectionIndexes] firstIndex],
            key = [listCollectionView content][listIndex];
            
        [photosCollectionView setContent:[photosets objectForKey:key]];
        [photosCollectionView setSelectionIndexes:[CPIndexSet indexSet]];
    }
}

//CPJSONP Delegate methods

- (void)connection:(CPJSONPConnection)aConnection didReceiveData:(CPString)data {
    //this method is called when the network request returns. the data is the returned
    //information from flickr. we set the array of photo urls as the data to our collection view
    [self addImageList:data.photos.photo withIdentifier:lastIdentifier];
}

- (void)connection:(CPJSONPConnection)aConnection didFailWithError:(CPString)error {
    alert(error); //a network error occurred
}

// IBAction methods

- (IBAction)adjustImageSize:(id)sender {
    var newSize = [sender value];
    
    [photosCollectionView setMinItemSize:CGSizeMake(newSize, newSize)];
    [photosCollectionView setMaxItemSize:CGSizeMake(newSize, newSize)];
}

- (IBAction)add:(id)sender {
    var string = prompt("Enter a tag to search Flickr for photos.");
    
    if(string) {
        //create a new request for the photos with the tag returned from the javascript prompt
        var request = [CPURLRequest requestWithURL:"http://www.flickr.com/services/rest/?" + 
                                                    "method=flickr.photos.search&tags=" + encodeURIComponent(string) +                                       "&media=photos&machine_tag_mode=any&per_page=20&format=json&api_key=ca4dd89d3dfaeaf075144c3fdec76756"];
    
        [CPJSONPConnection sendRequest:request callback:"jsoncallback" delegate:self];        
        lastIdentifier = string;
    }
}

- (IBAction)remove:(id)sender {
    //remove this photo
    [self removeImageListWithIdentifier:[[photosets allKeys] objectAtIndex:[[listCollectionView selectionIndexes] firstIndex]]];
}

- (void)awakeFromCib {
    // This is called when the cib is done loading.
    // You can implement this method on any object instantiated from a Cib.
    // It's a useful hook for setting up current UI values, and other things.

    // In this case, we want the window from Cib to become our full browser window
    [theWindow setFullPlatformWindow:YES];
}
@end