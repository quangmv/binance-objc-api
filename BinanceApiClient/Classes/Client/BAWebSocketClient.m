//
//  BAWebSocketClient.m
//  BinanceApiClient
//
//  Created by LinXi on 03/11/2017.
//

#import "BAWebSocketClient.h"
#import <SocketRocket/SRWebSocket.h>
#import "BAConstants.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "BAKLineModel.h"
#import <YYCategories/NSString+YYAdd.h>

typedef void (^MessageListenBlock)(NSString *message);

@interface BAWebSocketClient () <SRWebSocketDelegate>

@property(nonatomic, strong) SRWebSocket *socketClient;
@property(nonatomic, copy) MessageListenBlock listenBlock;

@end

@implementation BAWebSocketClient

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

#pragma mark - private methods
- (void)socketClientWithChannel:(NSString *)channel listenBlock:(MessageListenBlock)listenBlock {
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", BA_WEBSOCKET_API_BASE_URL, channel]]];
    SRWebSocket *socketClient = [[SRWebSocket alloc] initWithURLRequest:urlRequest];
    socketClient.delegate = self;
    self.socketClient = socketClient;
    self.listenBlock = listenBlock;
    [self.socketClient open];
}

- (void)socketClientWithChannels:(NSString *)channels listenBlock:(MessageListenBlock)listenBlock {
//    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"wss://stream.binance.com:9443/stream?streams=%@", channels]]];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"wss://stream.binance.com:9443/stream?streams=ethbtc@aggTrade/ltcbtc@aggTrade/bnbbtc@aggTrade/neobtc@aggTrade/bccbtc@aggTrade/gasbtc@aggTrade/hsrbtc@aggTrade/mcobtc@aggTrade/wtcbtc@aggTrade/lrcbtc@aggTrade/qtumbtc@aggTrade/yoyobtc@aggTrade/omgbtc@aggTrade/zrxbtc@aggTrade/stratbtc@aggTrade/snglsbtc@aggTrade/bqxbtc@aggTrade/kncbtc@aggTrade/funbtc@aggTrade/snmbtc@aggTrade/iotabtc@aggTrade/linkbtc@aggTrade/xvgbtc@aggTrade/ctrbtc@aggTrade/saltbtc@aggTrade/mdabtc@aggTrade/mtlbtc@aggTrade/subbtc@aggTrade/eosbtc@aggTrade/sntbtc@aggTrade/etcbtc@aggTrade/mthbtc@aggTrade/engbtc@aggTrade/dntbtc@aggTrade/zecbtc@aggTrade/bntbtc@aggTrade/astbtc@aggTrade/dashbtc@aggTrade/oaxbtc@aggTrade/icnbtc@aggTrade/btgbtc@aggTrade/evxbtc@aggTrade/reqbtc@aggTrade/vibbtc@aggTrade/trxbtc@aggTrade/powrbtc@aggTrade/arkbtc@aggTrade/xrpbtc@aggTrade/modbtc@aggTrade/enjbtc@aggTrade/storjbtc@aggTrade/venbtc@aggTrade/kmdbtc@aggTrade/rcnbtc@aggTrade/nulsbtc@aggTrade/rdnbtc@aggTrade/xmrbtc@aggTrade/dltbtc@aggTrade/ambbtc@aggTrade/batbtc@aggTrade/bcptbtc@aggTrade/arnbtc@aggTrade/gvtbtc@aggTrade/cdtbtc@aggTrade/gxsbtc@aggTrade/poebtc@aggTrade/qspbtc@aggTrade/btsbtc@aggTrade/xzcbtc@aggTrade/lskbtc@aggTrade/tntbtc@aggTrade/fuelbtc@aggTrade/manabtc@aggTrade/bcdbtc@aggTrade/dgdbtc@aggTrade/adxbtc@aggTrade/adabtc@aggTrade/pptbtc@aggTrade/cmtbtc@aggTrade/xlmbtc@aggTrade/cndbtc@aggTrade/lendbtc@aggTrade/wabibtc@aggTrade/tnbbtc@aggTrade/wavesbtc@aggTrade/gtobtc@aggTrade/icxbtc@aggTrade/ostbtc@aggTrade/elfbtc@aggTrade/aionbtc@aggTrade/neblbtc@aggTrade/brdbtc@aggTrade/edobtc@aggTrade/wingsbtc@aggTrade/navbtc@aggTrade/lunbtc@aggTrade/trigbtc@aggTrade/appcbtc@aggTrade/vibebtc@aggTrade/rlcbtc@aggTrade/insbtc@aggTrade/pivxbtc@aggTrade/iostbtc@aggTrade/chatbtc@aggTrade/steembtc@aggTrade/nanobtc@aggTrade/viabtc@aggTrade/blzbtc@aggTrade/aebtc@aggTrade/rpxbtc@aggTrade/ncashbtc@aggTrade/poabtc@aggTrade/zilbtc@aggTrade/ontbtc@aggTrade"]];
    
    SRWebSocket *socketClient = [[SRWebSocket alloc] initWithURLRequest:urlRequest];
    socketClient.delegate = self;
    self.socketClient = socketClient;
    self.listenBlock = listenBlock;
    [self.socketClient open];
}

#pragma mark - BAWebSocketClientProtocol
- (void)onDepthEventWithSymbol:(NSString *)symbol listen:(BAWebSocketEventBlock)eventHandleBlock {
    NSString *channel = [NSString stringWithFormat:@"%@@depth", [symbol lowercaseString]];
    [self socketClientWithChannel:channel
                      listenBlock:^void(NSString *message) {
                        BADepthEventModel *eventModel = [[BADepthEventModel alloc] initWithString:message error:nil];
                        eventHandleBlock(eventModel);
                      }];
}

- (void)onKLineEventWithSymbol:(NSString *)symbol interval:(kKLineInterval)interval listen:(BAWebSocketEventBlock)eventHandleBlock {
    NSString *intervalString = [BAKLineModel kLineIntervalEnumStringDictionary][@(interval)];
    NSString *channel = [NSString stringWithFormat:@"%@@kline_%@", [symbol lowercaseString], intervalString];
    [self socketClientWithChannel:channel
                      listenBlock:^(NSString *message) {
                        BAKLineEventModel *eventModel = [[BAKLineEventModel alloc] initWithString:message error:nil];
                        eventHandleBlock(eventModel);
                      }];
}

- (void)onTradeEventWithSymbol:(NSString *)symbol listen:(BAWebSocketEventBlock)eventHandleBlock {
    NSString *channel = [NSString stringWithFormat:@"%@@aggTrade", [symbol lowercaseString]];
    [self socketClientWithChannel:channel
                      listenBlock:^(NSString *message) {
                        BAAggTradeEventModel *eventModel = [[BAAggTradeEventModel alloc] initWithString:message error:nil];
                        eventHandleBlock(eventModel);
                      }];
}

- (void)onTradeEventWithSymbols:(NSArray *)symbols listen:(BAStreamAggTradeEventBlock)eventHandleBlock {
    NSString *channels = [[[symbols componentsJoinedByString:@"@aggTrade/"] stringByAppendingString:@"@aggTrade"] lowercaseString];
    [self socketClientWithChannels:channels
                      listenBlock:^(NSString *message) {
                          BAStreamAggTradeEventModel *eventModel = [[BAStreamAggTradeEventModel alloc] initWithString:message error:nil];
                          eventHandleBlock(eventModel);
                      }];
}

- (void)onUserDataEventWithListenKey:(NSString *)listenKey listen:(BAWebSocketEventBlock)eventHandleBlock {
    NSString *channel = [NSString stringWithFormat:@"%@", listenKey];
    [self socketClientWithChannel:channel
                      listenBlock:^(NSString *message) {
                        NSDictionary *dictionary = [message jsonValueDecoded];
                        NSString *eventType = dictionary[@"e"];
                        BAWebSocketEventModel *eventModel = nil;
                        if ([eventType isEqualToString:@"outboundAccountInfo"]) {
                            eventModel = [[BAAccountUpdateEventModel alloc] initWithDictionary:dictionary error:nil];
                        } else if ([eventType isEqualToString:@"executionReport"]) {
                            eventModel = [[BAOrderTradeUpdateEventModel alloc] initWithDictionary:dictionary error:nil];
                        }
                        eventHandleBlock(eventModel);
                      }];
}

- (void)close {
    [self.socketClient close];
}

#pragma mark - web socket delegate
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    if (self.listenBlock) {
        if ([message isKindOfClass:[NSString class]]) {
            self.listenBlock(message);
        } else {
            DDLogWarn(@"Receive unknown message: %@", message);
        }
    }
}

@end
