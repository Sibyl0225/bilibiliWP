
#import "DBHelper.h"
@implementation DBHelper

static FMDatabaseQueue *databaseQueue = nil;


+(FMDatabaseQueue *) getDatabaseQueue
{
    if (!databaseQueue) {
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"_ZTECommon_common.db"];
        
        if ([fileManager fileExistsAtPath:dbPath] == NO) {
            NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"_ZTECommon_common.db" ofType:nil];
            
            if ([fileManager fileExistsAtPath:resourcePath]==YES) {
                [fileManager copyItemAtPath:resourcePath toPath:dbPath error:&error];
            }else {
                
                NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"_ZTECommon_common.db"];
                NSLog(@"%@",path);
                        // 创建队列
                databaseQueue = [FMDatabaseQueue databaseQueueWithPath:path];
            }
            
        }else {
            
            databaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        }

    }
    
    return databaseQueue;
    
}

+ (BOOL) isTableOK:(NSString *)tableName withDB:(FMDatabase *)db
{
    BOOL isOK = NO;
    
    FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        NSInteger count = [rs intForColumn:@"count"];
        
        if (0 == count)
        {
            isOK =  NO;
        }
        else
        {
            isOK = YES;
        }
    }
    [rs close];
    
    return isOK;
}

@end
