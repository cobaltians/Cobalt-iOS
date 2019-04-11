//
//  PubSubWebReceiver.h
//  Cobalt
//
//  Created by Sébastien Vitard - Pro on 04/04/2019.
//  Copyright © 2019 Cobaltians. All rights reserved.
//

#import "PubSubReceiver.h"

@interface PubSubWebReceiver : PubSubReceiver

///////////////////////////////////////////////////////////////////////////

#pragma mark - PROPERTIES

///////////////////////////////////////////////////////////////////////////

/**
 * The WebView (WebView or WebLayer) to which send messages
 */
@property (nonatomic, readonly) WebViewType webView;

/**
 * The CobaltViewController containing the UIWebView to which send messages
 */
@property (weak, nonatomic, readonly) CobaltViewController *viewController;

///////////////////////////////////////////////////////////////////////////

#pragma mark - INIT

///////////////////////////////////////////////////////////////////////////

/**
 * @discussion Creates and returns a PubSubReceiver for the WebView from the specified CobaltViewController registered to the specified channel.
 * @param webView the WebView to which send messages.
 * @param viewController the CobaltViewController containing the UIWebView to which send messages.
 * @param channel the channel from which the messages will come from.
 * @return A new PubSubReceiver for the specified CobaltViewController registered to the specified channel.
 */
- (instancetype)initWithWebView:(WebViewType)webView
             fromViewController:(nonnull CobaltViewController *)viewController
                     forChannel:(nonnull NSString *)channel
            andInternalDelegate:(nonnull id <InternalPubSubDelegate>)internalDelegate;

@end
