#import "ShortLook-API.h"

@interface KakaoTalkContactPhotoProvider : NSObject <DDNotificationContactPhotoProviding>
  - (DDNotificationContactPhotoPromiseOffer *)contactPhotoPromiseOfferForNotification:(DDUserNotification *)notification;
@end
