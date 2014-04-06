//
//  Node.h
//  TrinaryTree
//
//  Created by Steve Baker on 12/5/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface Node : NSObject

@property (nonatomic, strong) NSNumber *nodeContent;

@property (nonatomic, strong) Node *leftNode;
@property (nonatomic, strong) Node *middleNode;
@property (nonatomic, strong) Node *rightNode;

- (id)initWithNumber:(NSNumber *)nodeContent;
+ (id)nodeWithNumber:(NSNumber*)nodeContent;

#pragma mark - Mutating Methods
- (void)insertNode:(Node *)newNode;

#pragma mark - Traversing Methods
- (Node*)smallestNode;
- (Node*)leafMostNode:(Node *)currentNode;
- (Node*)parentNodeWithChildNode:(Node *)childNode;
- (Node*)nodeWithValue:(int)nodeValue;


@end


