//
//  Definitions.h
//  TheApp
//
//  Created by Joel Oliveira on 7/16/13.
//  Copyright (c) 2013 Notificare. All rights reserved.
//

#ifndef Definitions_h
#define Definitions_h

/**
 * UI STUFF
 */
#define DEFAULT_FONTSIZE    15
#define LATO_FONT(s)     [UIFont fontWithName:@"Lato-Regular" size:s]
#define LATO_HAIRLINE_FONT(s)     [UIFont fontWithName:@"Lato-Hairline" size:s]
#define LATO_LIGHT_FONT(s)     [UIFont fontWithName:@"Lato-Light" size:s]
#define ARVO_FONT(s)     [UIFont fontWithName:@"Arvo" size:s]
#define MUSEO_FONT(s)    [UIFont fontWithName:@"Museo" size:s]
#define OLEO_FONT(s)     [UIFont fontWithName:@"OleoScript" size:s]
#define MONTSERRAT_FONT(s)     [UIFont fontWithName:@"Montserrat-Regular" size:s]
#define MONTSERRAT_BOLD_FONT(s)     [UIFont fontWithName:@"Montserrat-Bold" size:s]

#define DEFAULT_CELLHEIGHT  80
#define MENU_HEADER_HEIGHT 64
#define MENU_CELLHEIGHT 60
#define BEACON_HEADER_HEIGHT 64
#define BEACON_CELLHEIGHT 100
#define EMPTY_BEACONS_CELLHEIGHT 480

#define USER_HEADER_HEIGHT 60
#define USER_CELLHEIGHT 80
#define EMPTY_USER_CELLHEIGHT 480

#define SEGMENT_HEADER_HEIGHT 60
#define SEGMENT_CELLHEIGHT 60
#define EMPTY_SEGMENT_CELLHEIGHT 480

#define PRODUCT_HEADER_HEIGHT 0
#define PRODUCT_CELLHEIGHT 100
#define EMPTY_PRODUCT_CELLHEIGHT 480

#define LOG_HEADER_HEIGHT 0
#define LOG_CELLHEIGHT 80
#define EMPTY_LOG_CELLHEIGHT 480

#define MAIN_COLOR [UIColor colorWithRed:61.0/255.0 green:59.0/255 blue:55.0/255.0 alpha:1.0]
#define ALTO_COLOR [UIColor colorWithRed:218.0/255.0 green:218.0/255 blue:218.0/255.0 alpha:1.0]
#define FACEBOOK_COLOR [UIColor colorWithRed:59.0/255.0 green:89.0/255 blue:152.0/255.0 alpha:1.0]
#define WILD_SAND_COLOR [UIColor colorWithRed:246.0/255.0 green:246.0/255 blue:246.0/255.0 alpha:1.0]
#define MANTIS_COLOR [UIColor colorWithRed:64.0/255.0 green:202.0/255 blue:171.0/255.0 alpha:1.0]
#define ICONS_COLOR [UIColor colorWithRed:255.0/255.0 green:255.0/255 blue:255.0/255.0 alpha:1.0]


#define FIELD_BACKGROUND_COLOR [UIColor whiteColor]
#define FIELD_TEXT_COLOR MAIN_COLOR
#define FIELD_BORDER_COLOR ALTO_COLOR
#define FIELD_BORDER_WIDTH 1.0f
#define FIELD_CORNER_RADIUS 0.0f
#define FIELD_TEXT [UIFont fontWithName:@"Lato-Light" size:20]

#define BUTTON_TEXT [UIFont fontWithName:@"Lato-Light" size:20]
#define BUTTON_TEXT_COLOR [UIColor whiteColor]
#define BUTTON_BACKGROUND_COLOR MANTIS_COLOR
#define BUTTON_BORDER_COLOR MANTIS_COLOR
#define BUTTON_BORDER_WIDTH 0.0f
#define BUTTON_CORNER_RADIUS 0.0f

#define BUTTON_TRANSPARENT_TEXT [UIFont fontWithName:@"Lato-Light" size:16]
#define BUTTON_TRANSPARENT_TEXT_COLOR ALTO_COLOR
#define BUTTON_TRANSPARENT_BACKGROUND_COLOR [UIColor clearColor]
#define BUTTON_TRANSPARENT_BORDER_COLOR [UIColor clearColor]
#define BUTTON_TRANSPARENT_BORDER_WIDTH 0.0f
#define BUTTON_TRANSPARENT_CORNER_RADIUS 0.0f

#define LABEL_TEXT [UIFont fontWithName:@"Lato-Regular" size:12]
#define LABEL_TEXT_COLOR [UIColor colorWithRed:61.0/255.0 green:59.0/255 blue:56.0/255.0 alpha:1.0]
#define LABEL_BACKGROUND_COLOR [UIColor clearColor]
#define LABEL_BORDER_COLOR [UIColor clearColor]
#define LABEL_BORDER_WIDTH 1.0f
#define LABEL_CORNER_RADIUS 5.0f

#define BADGE_TEXT [UIFont fontWithName:@"Lato-Regular" size:10]
#define BADGE_TEXT_COLOR [UIColor whiteColor]
#define BADGE_BACKGROUND_COLOR [UIColor colorWithRed:255.0/255.0 green:59.0/255 blue:48.0/255.0 alpha:1.0]
#define BADGE_BORDER_COLOR [UIColor whiteColor]
#define BADGE_BORDER_WIDTH 0.0f
#define BADGE_CORNER_RADIUS 10.0f

#define CLCOORDINATES_EQUALS( coord1, coord2 ) (coord1.latitude == coord2.latitude && coord1.longitude == coord2.longitude)

/**
 * LOC STRINGS
 */
#define LSSTRING(str) NSLocalizedString(str, str)

/**
 * DIALOGS
 */
#define ALERT_DIALOG(__title__,__message__) \
do\
{\
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:(__title__) message:(__message__) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];\
[alert show];\
} while ( 0 )

#define APP_ALERT_DIALOG(__message__) \
do\
{\
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"] message:(__message__) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];\
[alert show];\
} while ( 0 )


#define CONFIRM_DIALOG(__title__,__message__) \
do\
{\
UIAlertView *confirm = [[UIAlertView alloc] initWithTitle:(__title__) message:(__message__) delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];\
[confirm show];\
} while ( 0 )


/**
 * DEBUG
 */
#ifdef DEBUG
#   define XLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define XLog(...)
#endif

#define ZLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)




#endif
