//
//  Human.h
//  RealmDemo
//
//  Created by 王伟虎 on 2017/9/27.
//Copyright © 2017年 wwh. All rights reserved.
//

#import <Realm/Realm.h>

@interface Human : RLMObject

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Human *><Human>
RLM_ARRAY_TYPE(Human)
