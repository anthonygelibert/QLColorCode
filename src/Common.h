/*
 *  Common.h
 *  QLColorCode
 *
 *  Created by Nathaniel Gray on 12/6/07.
 *  Copyright 2007 Nathaniel Gray.
 *
 */
@import CoreFoundation;
@import Foundation;

#ifdef DEBUG
#define n8log(...) NSLog(__VA_ARGS__)
#else
#define n8log(...)
#endif

#define myDomain @"org.n8gray.QLColorCode"

// Status is 0 on success, nonzero on error (like a shell command)
// If thumbnail is 1, only render enough of the file for a thumbnail
NSData *colorizeURL(CFBundleRef myBundle, CFURLRef url, int *status,
                    int thumbnail);
