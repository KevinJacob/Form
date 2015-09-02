@import Foundation;

#import "FORMFields.h"

@interface FORMFieldValue : NSObject

@property (nonatomic) id valueID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *info;
@property (nonatomic) NSArray *targets;
@property (nonatomic) FORMFields *field;
@property (nonatomic) NSString *value;
@property (nonatomic) BOOL defaultValue;
@property (nonatomic) BOOL selected;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

- (BOOL)identifierIsEqualTo:(id)identifier;

@end
