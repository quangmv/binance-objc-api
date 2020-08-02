//
//  BAExchangeModel.h
//  BinanceApiClient
//
//  Created by MAI VAN QUANG on 8/2/20.
//

#import "BAJSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BAExchangeFilterModel : BAJSONModel

@property(nonatomic, copy) NSString* filterType;
@property(nonatomic, assign) CGFloat minQty;
@property(nonatomic, assign) CGFloat maxQty;
@property(nonatomic, assign) CGFloat stepSize;
@property(nonatomic, assign) CGFloat tickSize;
@end

@protocol BAExchangeFilterModel;

@interface BAExchangeSymbolModel : BAJSONModel
@property(nonatomic, copy) NSString* symbol;
@property(nonatomic, copy) NSString* baseAsset;
@property(nonatomic, copy) NSString* quoteAsset;
@property(nonatomic, strong) NSArray<BAExchangeFilterModel *> *filters;
@end

@protocol BAExchangeSymbolModel;

@interface BAExchangeModel : BAJSONModel
@property(nonatomic, strong) NSArray<BAExchangeSymbolModel *> *symbols;
@end

NS_ASSUME_NONNULL_END
