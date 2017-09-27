//
//  Cat.h
//  RealmDemo
//
//  Created by 王伟虎 on 2017/9/27.
//Copyright © 2017年 wwh. All rights reserved.
//

#import <Realm/Realm.h>

@interface Cat : RLMObject

@property int cat_id;
@property NSString *name;
@property int age;
@property long weight;
@property long height;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Cat *><Cat>
RLM_ARRAY_TYPE(Cat)
