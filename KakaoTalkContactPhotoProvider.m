#import <sqlite3.h>
#import "FolderFinder.h"
#import "KakaoTalkContactPhotoProvider.h"

@implementation KakaoTalkContactPhotoProvider

  - (DDNotificationContactPhotoPromiseOffer *)contactPhotoPromiseOfferForNotification:(DDUserNotification *)notification {
    NSDictionary *payload = [notification applicationUserInfo];
    NSString *authorId = [NSString stringWithFormat:@"%@", payload[@"authorId"]];
    NSString *containerPath = [FolderFinder findSharedFolder:@"group.com.iwilab.KakaoTalk"];
    NSString *databasePath = [NSString stringWithFormat:@"%@/Library/PrivateDocuments/SharedTalk.sqlite", containerPath];
    NSString *imageURLStr;

    const char *dbpath = [databasePath UTF8String];
    sqlite3 *_db;

    if (sqlite3_open(dbpath, &_db) == SQLITE_OK) {
      const char *stmt = [[NSString stringWithFormat:@"SELECT ZTHUMBNAILURL as url FROM ZUSER WHERE ZID = '%@';", authorId] UTF8String];
      sqlite3_stmt *statement;

      if (sqlite3_prepare_v2(_db, stmt, -1, &statement, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
          const unsigned char *result = sqlite3_column_text(statement, 0);
          imageURLStr = [NSString stringWithUTF8String:(char *)result];
        }
        sqlite3_finalize(statement);
      }
      sqlite3_close(_db);
    }

    if (imageURLStr) {
      NSURL *imageURL = [NSURL URLWithString:imageURLStr];
      return [NSClassFromString(@"DDNotificationContactPhotoPromiseOffer") offerDownloadingPromiseWithPhotoIdentifier:imageURLStr fromURL:imageURL];
    } else {
      return nil;
    }
  }

@end
