//
//  Constants.h
//  Swubble
//
//  Created by John Gibfried on 3/7/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#define ARC4RANDOM_MAX     0x100000000

#define introBackground    @"menuBackgroundImage.png"
#define menuBackground     @"menuBackgroundImage.png"
#define gameBackground     @"menuBackgroundImage.png"
#define borderBackground   @"borderBackground.png"

#define yellowBubbleSprite @"yellowBubble.png"
#define blueBubbleSprite   @"blueBubble.png"
#define redBubbleSprite    @"redBubble.png"
#define greenBubbleSprite  @"greenBubble.png"

#define gameTimeDefault    30

#define bubbleDestroyTime  0.2
#define bubbleSwapTime     0.2
#define bubblePopulateTime 0.2

#define gameGridSizeHeight 9
#define gameGridSizeWidth  6

#define gameGridCellHeight 60 // points
#define gameGridCellWidth  60 // points

#define gameGridOffsetY    80 // points
#define gameGridOffsetX    96 // points

#define gameBubbleDragDistance  30 // points

#define difficultyLevels   5

#define pointsPerBubble    30

#define whiteColor         ccc3(255, 255, 255)

typedef enum dragDirection {
    kDirectionUp,
    kDirectionDown,
    kDirectionLeft,
    kDirectionRight,
} DragDirection;

typedef void (^HandlerBlock)(void);
