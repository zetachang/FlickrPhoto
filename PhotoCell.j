/*
 * PhotoCell.j
 * FlickrPhoto
 *
 * Created by David Chang (zetachang) on April 30, 2012.
 * Copyright 2012, All rights reserved.
 */

// This class displays a single photo from our collection
@implementation PhotoCell : CPView {
    CPImage         image;
    CPImageView     imageView;
    CPView          highlightView;
}

- (void)setRepresentedObject:(JSObject)anObject {
    if(!imageView) {
        imageView = [[CPImageView alloc] initWithFrame:CGRectMakeCopy([self bounds])];
        [imageView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        [imageView setImageScaling:CPScaleProportionally];
        [imageView setHasShadow:YES];
        [self addSubview:imageView];
    }
    
    [image setDelegate:nil];
    image = [[CPImage alloc] initWithContentsOfFile:thumbForFlickrPhoto(anObject)];

    [image setDelegate:self];
    
    if([image loadStatus] == CPImageLoadStatusCompleted) {
       [imageView setImage:image];
    } else {
      [imageView setImage:nil];
    }
}

- (void)imageDidLoad:(CPImage)anImage {
    [imageView setImage:anImage];
}

- (void)setSelected:(BOOL)flag {
    if(!highlightView) {
        highlightView = [[CPView alloc] initWithFrame:[self bounds]];
        [highlightView setBackgroundColor:[CPColor colorWithCalibratedWhite:0.8 alpha:0.6]];
        [highlightView setAutoresizingMask:CPViewWidthSizable|CPViewHeightSizable];
    }

    if(flag) {
        [highlightView setFrame:[self bounds]];
        [self addSubview:highlightView positioned:CPWindowBelow relativeTo:imageView];
    } else {
      [highlightView removeFromSuperview];
    }
}

@end

// helper javascript functions for turning a Flickr photo object into a URL for getting the image

function urlForFlickrPhoto(photo) {
    return "http://farm" + photo.farm + ".static.flickr.com/" + photo.server + "/" + photo.id + "_" + photo.secret + ".jpg";
}

function thumbForFlickrPhoto(photo) {
    return "http://farm" + photo.farm + ".static.flickr.com/" + photo.server + "/" + photo.id + "_" + photo.secret + "_m.jpg";
}