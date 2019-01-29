/*
 *  Common.c
 *  QLColorCode
 *
 *  Created by Nathaniel Gray on 12/6/07.
 *  Copyright 2007 Nathaniel Gray.
 *
 *  Modified by Anthony Gelibert on 9/5/12.
 *  Copyright 2012 Anthony Gelibert.
 */

#import <CoreFoundation/CoreFoundation.h>
#import <CoreServices/CoreServices.h>
#import <Foundation/Foundation.h>
#import <limits.h>  // PATH_MAX

#include "Common.h"


NSData *runTask(NSString *script, NSDictionary *env, int *exitCode) {
    NSTask *task = [[NSTask alloc] init];
    [task setCurrentDirectoryPath:@"/tmp"];     /* XXX: Fix this */
    [task setEnvironment:env];
    [task setLaunchPath:@"/bin/sh"];
    [task setArguments:[NSArray arrayWithObjects:@"-c", script, nil]];

    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    // Let stderr go to the usual place
    //[task setStandardError: pipe];

    NSFileHandle *file;
    file = [pipe fileHandleForReading];

    [task launch];

    NSData *data;
    data = [file readDataToEndOfFile];
    [task waitUntilExit];

    *exitCode = [task terminationStatus];
    [task release];
    /* The docs claim this isn't needed, but we leak descriptors otherwise */
    [file closeFile];
    /*[pipe release];*/

    return data;
}

NSString *pathOfURL(CFURLRef url)
{
    NSString *targetCFS = [[(NSURL *)url absoluteURL] path];
    n8log(@"targetCFS = %@", targetCFS);
    //return [targetCFS stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return targetCFS;
}

NSData *colorizeURL(CFBundleRef bundle, CFURLRef url, int *status, int thumbnail)
{
    NSData *output = NULL;
    CFURLRef rsrcDirURL = CFBundleCopyResourcesDirectoryURL(bundle);
    //n8log(@"rsrcDirURL = %@", CFURLGetString(rsrcDirURL));
    NSString *rsrcEsc = pathOfURL(rsrcDirURL);
    CFRelease(rsrcDirURL);
    n8log(@"url = %@", url);
    NSString *targetEsc = pathOfURL(url);
    n8log(@"targetEsc = %@", targetEsc);

    // Set up preferences
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSMutableDictionary *env = [NSMutableDictionary dictionaryWithDictionary:
                                [[NSProcessInfo processInfo] environment]];

    NSString *path = [env objectForKey: @"PATH"];
    NSString *newPath = [path stringByAppendingString: @":/opt/local/bin:/usr/local/bin:/usr/local/sbin"];
    [env setObject: newPath forKey: @"PATH"];

    // Try to find highlight location
    NSString *highlightPath = [[defaults persistentDomainForName:myDomain] valueForKey:@"pathHL"];
    if (highlightPath == nil) {
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] init];
        NSData* data = runTask(@"which highlight", env, status);
        highlightPath = [[[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] autorelease] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        if (*status == 0 && [highlightPath hasPrefix: @"/"] && [highlightPath hasSuffix: @"highlight"]) { // i.e. highlightPath looks like the actual path
            NSMutableDictionary *newDefaults = [NSMutableDictionary dictionaryWithObject:highlightPath forKey:@"pathHL"];
            [newDefaults addEntriesFromDictionary: [defaults persistentDomainForName:myDomain]];
            [userDefaults setPersistentDomain: newDefaults forName:myDomain];
            [userDefaults synchronize];
        }
        [userDefaults release];
    }

    [env addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
#ifdef DEBUG
                                   @"1", @"qlcc_debug",
#endif
                                   @"10", @"fontSizePoints",
                                   @"Menlo", @"font",
                                   @"edit-xcode", @"hlTheme",
//                                   @"-lz -j 3 -t 4 --kw-case=capitalize ", @"extraHLFlags",
                                   @"-t 4 --kw-case=capitalize ", @"extraHLFlags",
                                   @"/opt/local/bin/highlight", @"pathHL",
                                   @"", @"maxFileSize",
                                   @"UTF-8", @"textEncoding",
                                   @"UTF-8", @"webkitTextEncoding", nil]];

    [env addEntriesFromDictionary:[defaults persistentDomainForName:myDomain]];

    // This overrides hlTheme if hlThumbTheme is set and we're generating a thumbnail
    // (This way we won't irritate people with existing installs)
    // Admittedly, it's a little shady, overriding the set value, but I'd rather complicate the compiled code
    if (thumbnail && [[env allKeys] containsObject:@"hlThumbTheme"]) {
        [env setObject:[env objectForKey:@"hlThumbTheme"] forKey:@"hlTheme"];
    }

    NSString *cmd = [NSString stringWithFormat:
                     @"'%@/colorize.sh' '%@' '%@' %s",
                     rsrcEsc, rsrcEsc, [targetEsc stringByReplacingOccurrencesOfString:@"'" withString:@"'\\''"], thumbnail ? "1" : "0"];
    n8log(@"cmd = %@", cmd);

    output = runTask(cmd, env, status);
    if (*status != 0) {
        NSLog(@"QLColorCode: colorize.sh failed with exit code %d.  Command was (%@).",
              *status, cmd);
    }
    return output;
}
