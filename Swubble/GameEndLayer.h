//
//  GameEndLayer.h
//  Swubble
//
//  Created by John Gibfried on 5/14/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import "BaseLayer.h"

@interface GameEndLayer : BaseLayer

- (BaseLayer *) initWithScore: (int) totalScore;

@property (nonatomic, strong) CCLabelTTF *totalScoreLabel;
@property (nonatomic, strong) CCLabelTTF *restartButton;

@end
