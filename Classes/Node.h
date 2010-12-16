//
//  Node.h
//  TrinaryTree
//
//  Created by Steve Baker on 12/5/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Node : NSObject {

}
@property (nonatomic, retain) NSNumber *nodeContent;

// It's possible to manage a tree without each node having a reference to its parent.
// However it's convenient to have the reference.
// Manage property with assign to avoid circular retain between parent node and child node
@property (nonatomic, assign) Node *parentNode;

@property (nonatomic, retain) Node *leftNode;
@property (nonatomic, retain) Node *middleNode;
@property (nonatomic, retain) Node *rightNode;

@end
