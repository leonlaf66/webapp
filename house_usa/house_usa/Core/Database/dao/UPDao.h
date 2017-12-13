

#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "DaoDefines.h"
#import "Precompile.h"

typedef void (^DatabaseBlock)(FMDatabase *db);
typedef void (^TransactionBlock)(FMDatabase *db, BOOL *rollback);

@interface UPDao : NSObject

AS_SINGLETON(UPDao);

- (void)inDatabase:(DatabaseBlock)block;

- (void)inTransaction:(TransactionBlock)block;


@end
