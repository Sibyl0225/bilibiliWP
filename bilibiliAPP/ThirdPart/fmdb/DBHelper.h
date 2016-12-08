
#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface DBHelper : NSObject

+(FMDatabaseQueue *) getDatabaseQueue;

+(BOOL) isTableOK:(NSString *)tableName withDB:(FMDatabase *)db;
@end

