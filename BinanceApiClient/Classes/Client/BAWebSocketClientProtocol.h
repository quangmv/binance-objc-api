//
//  BAWebSocketClientProtocol.h
//  BinanceApiClient
//
//  Created by LinXi on 03/11/2017.
//

#import <Foundation/Foundation.h>
#import "BAEnums.h"
#import "BAWebSocketEventModel.h"

@class BAStreamAggTradeEventModel;

typedef void (^BAWebSocketEventBlock)(__kindof BAWebSocketEventModel *eventModel);
typedef void (^BAStreamAggTradeEventBlock)(__kindof BAStreamAggTradeEventModel *eventModel);

@protocol BAWebSocketClientProtocol <NSObject>

- (void)onDepthEventWithSymbol:(NSString *)symbol listen:(BAWebSocketEventBlock)eventHandleBlock;

- (void)onKLineEventWithSymbol:(NSString *)symbol interval:(kKLineInterval)interval listen:(BAWebSocketEventBlock)eventHandleBlock;

- (void)onTradeEventWithSymbol:(NSString *)symbol listen:(BAWebSocketEventBlock)eventHandleBlock;

- (void)onTradeEventWithSymbols:(NSArray *)symbols listen:(BAStreamAggTradeEventBlock)eventHandleBlock;

- (void)onUserDataEventWithListenKey:(NSString *)listenKey listen:(BAWebSocketEventBlock)eventHandleBlock;

- (void)close;

@end
