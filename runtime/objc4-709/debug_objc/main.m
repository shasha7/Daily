//
//  main.m
//  debug_objc
//
//  Created by Holy_Han on 19/09/2017.
//
//

#import <Foundation/Foundation.h>
#import "Dog.h"

int main(int argc, const char * argv[]) {

    @autoreleasepool {
        // insert code here...
        Dog *dog = [[Dog alloc] init];
        NSLog(@"%@", dog);
    }
    return 0;
}
