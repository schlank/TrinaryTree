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
- (void)trinaryTreeWillDeleteNode:(Node *)aNode;
@end

@interface TrinaryTree : NSObject
{
    id<TrinaryTreeDelegate> __weak delegate;
}
@property (nonatomic, weak) id<TrinaryTreeDelegate> delegate;

@property (nonatomic, strong) Node *rootNode;

@property (nonatomic, strong) Node *leftOrphanNode;
@property (nonatomic, strong) Node *middleOrphanNode;
@property (nonatomic, strong) Node *rightOrphanNode;

- (void)listTreeBranchStartingAtNode:(Node *)aNode;
- (void)insertNode:(Node *)aNode;
- (void)deleteNode:(Node *)aNode;

@end
