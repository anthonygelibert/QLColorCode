/* This code is copyright Nathaniel Gray, licensed under the GPL v3.
    See LICENSE.txt for details. */

#import <CoreFoundation/CoreFoundation.h>
#import <CoreServices/CoreServices.h>
#import <Foundation/Foundation.h>
#import <QuickLook/QuickLook.h>
#import <AppKit/AppKit.h>
#import "Common.h"


/* -----------------------------------------------------------------------------
 Generate a preview for file

 This function's job is to create preview for designated file
 ----------------------------------------------------------------------------- */

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview,
                               CFURLRef url, CFStringRef contentTypeUTI,
                               CFDictionaryRef options)
{
#ifdef DEBUG
    NSDate *startDate = [NSDate date];
#endif
    n8log(@"Generating Preview");
    if (QLPreviewRequestIsCancelled(preview))
        return noErr;

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    // Invoke colorize.sh
    CFBundleRef bundle = QLPreviewRequestGetGeneratorBundle(preview);
    int status;
    NSData *output = colorizeURL(bundle, url, &status, 0);
    n8log(@"Generated preview html page in %.3f sec",
          -[startDate timeIntervalSinceNow] );

    NSData *rtf = nil;
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:myDomain];
    BOOL use_rtf = [defaults boolForKey:@"rtfPreview"];
    [defaults release];

    if (use_rtf) {
        NSDictionary *attrs;
        NSAttributedString *string = [[NSAttributedString alloc] initWithHTML:output documentAttributes:&attrs];
        NSRange range = NSMakeRange(0, [string length]);
        rtf = [string RTFFromRange:range documentAttributes:attrs];
        [string release];
    }

    if (status != 0 || QLPreviewRequestIsCancelled(preview)) {
#ifndef DEBUG
        goto done;
#endif
    }
    // Now let WebKit do its thing
    NSString *textEncoding = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"webkitTextEncoding"];
    if (!textEncoding || [textEncoding length] == 0)
        textEncoding = @"UTF-8";
    CFDictionaryRef properties =
            (CFDictionaryRef)[NSDictionary dictionaryWithObject:textEncoding
                                                         forKey:(NSString *)kQLPreviewPropertyTextEncodingNameKey];

    if (use_rtf)
        QLPreviewRequestSetDataRepresentation(preview, (CFDataRef)rtf, kUTTypeRTF, properties);
    else
        QLPreviewRequestSetDataRepresentation(preview, (CFDataRef)output, kUTTypeHTML, properties);

#ifndef DEBUG
done:
#endif
    n8log(@"Finished preview in %.3f sec", -[startDate timeIntervalSinceNow] );
    [pool release];
    return noErr;
}

void CancelPreviewGeneration(void* thisInterface, QLPreviewRequestRef preview)
{
    // implement only if supported
}
