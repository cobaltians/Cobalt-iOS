/**
 *
 * CobaltPluginManager.m
 * Cobalt
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2014 Cobaltians
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "CobaltPluginManager.h"

#import "Cobalt.h"
#import "CobaltAbstractPlugin.h"

@implementation CobaltPluginManager

////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark INITIALISATION

////////////////////////////////////////////////////////////////////////////////////////////////

+ (BOOL)onMessage:(nonnull NSDictionary *)message
      fromWebView:(WebViewType)webView
inCobaltController:(nonnull CobaltViewController *)viewController
{
    NSDictionary *classes = [message objectForKey:kJSPluginClasses];
    if (! classes)
    {
#if DEBUG_COBALT
        NSLog(@"CobaltPluginManager - onMessage:fromWebView:inCobaltController: classes not found or not an object.\n%@", message.description);
#endif
        return NO;
    }
    NSString *className = [classes objectForKey:kConfigurationIOS];
    if (! className)
    {
#if DEBUG_COBALT
        NSLog(@"CobaltPluginManager - onMessage:fromWebView:inCobaltController: classes.ios not found or not a string.\n%@", message.description);
#endif
        return NO;
    }
    Class class = NSClassFromString(className);
    if (! class
        || ! [class isSubclassOfClass:[CobaltAbstractPlugin class]])
    {
#if DEBUG_COBALT
        NSLog(@"CobaltPluginManager - onMessage:fromWebView:inCobaltController: class %@ not found or not inheriting from CobaltAbstractPlugin.", className);
#endif
        return NO;
    }
    
    NSString *action = [message objectForKey:kJSAction];
    if (! action)
    {
#if DEBUG_COBALT
        NSLog(@"CobaltPluginManager - onMessage:fromWebView:inCobaltController: action not found or not a string.\n%@", message.description);
#endif
        return NO;
    }
    NSDictionary *data = [message objectForKey:kJSData];
    NSString *callbackChannel = [message objectForKey:kJSCallbackChannel];
    
    CobaltAbstractPlugin *plugin = [class sharedInstance];
    [plugin onMessageFromWebView:webView
              inCobaltController:viewController
                      withAction:action
                            data:data
              andCallbackChannel:callbackChannel];
    
    return YES;
}

@end
