//
//  BAExchangeApi.m
//  BinanceApiClient
//
//  Created by MAI VAN QUANG on 8/2/20.
//

#import "BARestExchangeApi.h"

@interface BARestExchangeApi ()
@end

@implementation BARestExchangeApi

- (NSString *)requestUrl {
    return @"/api/v1/exchangeInfo";
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    NSDictionary *dic = [self parsedResponseData];
    self.exchangeModel = [[BAExchangeModel alloc] initWithDictionary:dic error:nil];
}

@end
