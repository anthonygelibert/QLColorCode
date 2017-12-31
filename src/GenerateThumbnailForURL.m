/* Copyright Nathaniel Gray */

#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>
#include <WebKit/WebKit.h>
#import "Common.h"

#define minSize 32

/* -----------------------------------------------------------------------------
    Generate a thumbnail for file

   This function's job is to create thumbnail for designated file as fast as possible
   ----------------------------------------------------------------------------- */

OSStatus
GenerateThumbnailForURL(void *thisInterface,
                                 QLThumbnailRequestRef thumbnail,
                                 CFURLRef url,
                                 CFStringRef contentTypeUTI,
                                 CFDictionaryRef options,
                                 CGSize maxSize)
{
    n8log(@"Generating Thumbnail");
    // For some reason we seem to get called for small thumbnails even though
    // we put a min size in our .plist file...
    if (maxSize.width < minSize || maxSize.height < minSize)
        return noErr;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
#ifdef DEBUG
    NSDate *startDate = [NSDate date];
#endif

    // Render as though there is an 600x800 window, and fill the thumbnail
    // vertically.  This code could be more general.  I'm assuming maxSize is
    // a square, though nothing horrible should happen if it isn't.

    NSRect renderRect = NSMakeRect(0.0, 0.0, 600.0, 800.0);
    float scale = (float)(maxSize.height/800.0);
    NSSize scaleSize = NSMakeSize(scale, scale);
    CGSize thumbSize = NSSizeToCGSize(
                            NSMakeSize((maxSize.width * (600.0/800.0)),
                                       maxSize.height));

    /* Based on example code from quicklook-dev mailing list */
    // NSSize previewSize = NSSizeFromCGSize(maxSize);
    int status;
    CFBundleRef bundle = QLThumbnailRequestGetGeneratorBundle(thumbnail);
    NSData *data = colorizeURL(bundle, url, &status, 1);
    //NSLog(@"%s", [data bytes]);
#ifdef DEBUG
    n8log(@"Generated thumbnail html page in %.3f sec", -[startDate timeIntervalSinceNow] );
#endif
    if (status != 0) {
#ifndef DEBUG
        goto done;
#endif
    }
    //NSRect previewRect;
    //previewRect.size = previewSize;

    WebView* webView = [[WebView alloc] initWithFrame:renderRect];
    [webView scaleUnitSquareToSize:scaleSize];
    [[[webView mainFrame] frameView] setAllowsScrolling:NO];

    [[webView mainFrame] loadData:data MIMEType:@"text/html"
                 textEncodingName:@"UTF-8" baseURL:nil];

    while([webView isLoading]) {
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, true);
    }

    // Get a context to render into
    CGContextRef context =
        QLThumbnailRequestCreateContext(thumbnail, thumbSize, false, NULL);

    if(context != NULL) {
        NSGraphicsContext* nsContext =
                    [NSGraphicsContext
                        graphicsContextWithGraphicsPort:(void *)context
                                                flipped:[webView isFlipped]];

        [webView displayRectIgnoringOpacity:[webView bounds]
                                  inContext:nsContext];

        QLThumbnailRequestFlushContext(thumbnail, context);

        CFRelease(context);
    }
    [webView release];

#ifndef DEBUG
done:
#endif
#ifdef DEBUG
    n8log(@"Finished thumbnail after %.3f sec\n\n", -[startDate timeIntervalSinceNow] );
#endif
    [pool release];
    return noErr;
}

void CancelThumbnailGeneration(void* thisInterface,
                               QLThumbnailRequestRef thumbnail)
{
    // implement only if supported
}
