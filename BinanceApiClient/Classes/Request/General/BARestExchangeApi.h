//
//  BAExchangeApi.h
//  BinanceApiClient
//
//  Created by MAI VAN QUANG on 8/2/20.
//

#import "BARestRequest.h"
#import "BAExchangeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BARestExchangeApi : BARestRequest

@property(nonatomic, strong) BAExchangeModel *exchangeModel;

@end

NS_ASSUME_NONNULL_END
