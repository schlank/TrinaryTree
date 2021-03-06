//
//  TrinaryTree.h
//  TrinaryTree
//
//  Created by Steve Baker on 12/5/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Node;

@protocol TrinaryTreeDelegate <NSObject>
- (void)trinaryTreeDidInsertNode:(Node *)aNode;
- (void)trinaryTreeDidDeleteNode;
@end

@interface TrinaryTree : NSObject

@property (nonatomic, weak) id<TrinaryTreeDelegate> delegate;

@property (nonatomic, strong) Node *rootNode;

- (void)listTreeBranchStartingAtNode:(Node *)aNode;
- (void)insertNode:(Node *)node;
- (void)deleteNode:(Node *)node;
- (Node*)deleteNode:(Node*)targetNode fromRoot:(Node*)currentNode;

@end
