@import Cocoa;
@import CoreFoundation;
@import QuickLook;

#import "Common.h"

OSStatus GenerateThumbnailForURL(void *thisInterface, QLThumbnailRequestRef thumbnail, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options, CGSize maxSize);
void CancelThumbnailGeneration(void *thisInterface, QLThumbnailRequestRef thumbnail);

/* -----------------------------------------------------------------------------
 Generate a thumbnail for file
 
 This function's job is to create thumbnail for designated file as fast as possible
 ----------------------------------------------------------------------------- */

OSStatus GenerateThumbnailForURL(void *thisInterface, QLThumbnailRequestRef thumbnail, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options, CGSize maxSize)
{
    @autoreleasepool {
    NSStringEncoding usedEncoding = 0;
    NSError *readError = nil;

    [NSString stringWithContentsOfURL:(__bridge NSURL*)url usedEncoding:&usedEncoding error:&readError];
    
    if (usedEncoding == 0) {
        NSLog(@"Failed to determine encoding for file %@", [(__bridge NSURL*)url path]);
        return noErr;
    }

    if (QLThumbnailRequestIsCancelled(thumbnail))
        return noErr;
    
    NSDictionary *previewProperties = @{
        (NSString *)kQLPreviewPropertyStringEncodingKey : @( usedEncoding )
    };
    
    NSDictionary *properties = @{
        (__bridge NSString *)kQLPreviewPropertyMIMETypeKey : @"text/html"
    };

    QLThumbnailRequestSetThumbnailWithURLRepresentation(
        thumbnail,
        url,
        kUTTypePlainText,
        (__bridge CFDictionaryRef)previewProperties,
        (__bridge CFDictionaryRef)properties);
    
    return noErr;
    }
}

void CancelThumbnailGeneration(void *thisInterface, QLThumbnailRequestRef thumbnail)
{
    // Implement only if supported
}
