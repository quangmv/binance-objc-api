//
//  BARestTestCreateOrderApi.m
//  BinanceApiClient
//
//  Created by LinXi on 03/11/2017.
//

#import "BARestTestCreateOrderApi.h"

@interface BARestTestCreateOrderApi ()

@property(nonatomic, strong) BACreateOrderModel *createOrderModel;

@end

@implementation BARestTestCreateOrderApi

- (instancetype)initWithCreateOrderParam:(BACreateOrderModel *)createOrderModel {
    if (self = [super init]) {
        _createOrderModel = createOrderModel;
        _createOrderModel.timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
        _createOrderModel.recvWindow = 5000;
    }
    return self;
}

- (NSString *)requestUrlWithoutSignature {
    return @"/api/v3/order/test";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSDictionary *)requestArgumentWithoutSignature {
    BACreateOrderModel *model = self.createOrderModel;

    NSMutableDictionary *requestArgument = [NSMutableDictionary dictionary];
    requestArgument[@"symbol"] = model.symbol;
    requestArgument[@"side"] = model.side == kOrderSideBuy ? @"BUY" : @"SELL";
    requestArgument[@"type"] = model.type == kOrderTypeLimit ? @"LIMIT" : @"MARKET";
    if (model.type == kOrderTypeLimit) {
        requestArgument[@"timeInForce"] = model.timeInForce == kTimeInForceGTC ? @"GTC" : @"IOC";
        requestArgument[@"price"] = model.price;
    }
    requestArgument[@"quantity"] = model.quantity;
    if (STRING_HAS_VALUE(model.latestClientOrderId)) {
        requestArgument[@"newClientOrderId"] = model.latestClientOrderId;
    }
    if (STRING_HAS_VALUE(model.stopPrice)) {
        requestArgument[@"stopPrice"] = model.stopPrice;
    }
    if (STRING_HAS_VALUE(model.icebergQty)) {
        requestArgument[@"icebergQty"] = model.icebergQty;
    }
    requestArgument[@"timestamp"] = @(model.timestamp);
    return requestArgument;
}

- (BOOL)isTestSucceed {
    NSDictionary *dic = [self parsedResponseData];
    return dic && !DICTIONARY_HAS_VALUE(dic);
}

@end
