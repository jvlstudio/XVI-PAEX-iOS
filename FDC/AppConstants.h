//
//  AppConstants.h
//  FDC
//
//  Created by Felipe Ricieri on 08/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#ifndef FDC_AppConstants_h
#define FDC_AppConstants_h

/* numbers */

#define ZERO                        0
#define ONE                         1
#define DELAY                       0.5

/* nibs */

#define NIB_OPENING                 @"Opening"
#define NIB_HOME                    @"Home"
#define NIB_HOME_CONTENT            @"HomeContent"
#define NIB_AGENDA                  @"Agenda"
#define NIB_SPEECH                  @"Speech"
#define NIB_PANELIST                @"Panelist"
#define NIB_PANELIST_SINGLE         @"PanelistSingle"
#define NIB_PASSES                  @"Passes"
#define NIB_PASSES_FORM             @"PassForm"
#define NIB_PASSES_END              @"PassEnd"
#define NIB_PASSES_ADD              @"PassAdd"
#define NIB_NETWORK                 @"Network"
#define NIB_NETWORK_THANKS          @"NetworkThanks"
#define NIB_NETWORK_PIN             @"NetworkPIN"
#define NIB_NETWORK_FORM            @"NetworkForm"
#define NIB_AVAL                    @"Aval"
#define NIB_AVAL_SINGLE             @"AvalSingle"
#define NIB_AVAL_EVENT              @"AvalEvent"

/* resources */

#define XIB_RESOURCES               @"AppResources"

/* plist */

#define PLIST_AGENDA                @"FDC-Agenda"
#define PLIST_AGENDA_SCORES         @"FDC-Agenda-Scores"
#define PLIST_AVAL                  @"FDC-Aval"
#define PLIST_PANELISTS             @"FDC-Panelists"
#define PLIST_LOGS                  @"FDC-Logs"
#define PLIST_NETWORK               @"FDC-Network"

/* urls */

#define URL                         @"http://apps.ikomm.com.br/fdc"
#define URL_GRAPH                   [NSString stringWithFormat:@"%@/%@", URL, @"graph"]
#define URL_AGENDA                  [NSString stringWithFormat:@"%@/%@", URL_GRAPH, @"agenda.php"]
#define URL_AGENDA_SCORES           [NSString stringWithFormat:@"%@/%@", URL_GRAPH, @"agenda-scores.php"]
#define URL_AGENDA_VERSION          [NSString stringWithFormat:@"%@/%@", URL_GRAPH, @"agenda-version.php"]
#define URL_LECTURES_EVALUATE       [NSString stringWithFormat:@"%@/%@", URL_GRAPH, @"lectures-evaluate.php"]
#define URL_PANELISTS               [NSString stringWithFormat:@"%@/%@", URL_GRAPH, @"panelists.php"]
#define URL_PANELISTS_VERSION       [NSString stringWithFormat:@"%@/%@", URL_GRAPH, @"panelists-version.php"]
#define URL_NETWORK                 [NSString stringWithFormat:@"%@/%@", URL_GRAPH, @"network.php"]
#define URL_NETWORK_ADD             [NSString stringWithFormat:@"%@/%@", URL_GRAPH, @"network-add.php"]
#define URL_NETWORK_PIN             [NSString stringWithFormat:@"%@/%@", URL_GRAPH, @"network-pin.php"]
#define URL_AVAL_EVENT              [NSString stringWithFormat:@"%@/%@", URL_GRAPH, @"aval-event.php"]

/* questions */

#define IS_IPHONE5                  (([[UIScreen mainScreen] bounds].size.height-568) ? NO : YES)
#define IPHONE5_OFFSET              88
#define IPHONE5_COEF                IS_IPHONE5 ? ZERO : IPHONE5_OFFSET

/* third-part app ids */

#define FACEBOOK_APP_ID             @""
#define FACEBOOK_APP_SECRET         @""
#define FACEBOOK_APP_PERMS          @[@"publish_stream", @"publish_actions", @"email"]
#define PARSE_APP_ID                @"ulQucjzXd6GfEXHGnS321HtTHlKFcv0fIIbTk66A"
#define PARSE_APP_SECRET            @"w2kteutEvB6VpAuzkrWh0UaSz2ISjMKxiM5eQguR"
#define GOOGLE_ANALYTICS_TRACKER    @""

/* frames > widths */

#define WINDOW_WIDTH                [[UIScreen mainScreen] bounds].size.width

/* frames > heights */

#define WINDOW_HEIGHT               [[UIScreen mainScreen] bounds].size.height
#define STATUSBAR_HEIGHT            20
#define NAVIGATIONBAR_HEIGHT        44
#define KEYBOARD_HEIGHT             216
#define SIDE_MENU_OFFSET            60

/* fonts & colors */

#define FONT_FAMILY                 @"Roboto"
#define FONT_REGULAR                @"Roboto-Medium"
#define FONT_LIGHT                  @"Roboto-Light"
#define FONT_BOLD                   @"Roboto-Bold"

#define COLOR_DEFAULT               [UIColor colorWithRed:30.0/255.0 green:129.0/255.0 blue:184.0/255.0 alpha:1]
#define COLOR_BACKGROUND            [UIColor colorWithRed:237.0/255.0 green:242.0/255.0 blue:245.0/255.0 alpha:1]
#define COLOR_WHITE                 [UIColor whiteColor]
#define COLOR_BLACK                 [UIColor blackColor]
#define COLOR_GREY                  [UIColor greyColor]
#define COLOR_CLEAR                 [UIColor clearColor]

/* types */

typedef enum CellIndex : NSInteger
{
    kCellAgenda         = 0,
    kCellAgendaBreak    = 4,
    kCellPanelist       = 1,
    kCellSpeechHead     = 2,
    kCellSpeechFoot     = 3,
    kCellAval           = 5,
    kCellAvalStruct     = 8,
    kCellAvalFormPart   = 6,
    kCellNetwork        = 7,
}
CellIndex;

typedef enum EvaluateOption : NSInteger
{
    kOptionLectures     = 0,
    kOptionStruct       = 1,
    kOptionEvent        = 2
}
EvaluateOption;

/* tab bar */

#define TAB_HOME_ON                 @"tabbar_home_on.png"
#define TAB_HOME_OFF                @"tabbar_home_off.png"
#define TAB_AGENDA_ON               @"tabbar_agenda_on.png"
#define TAB_AGENDA_OFF              @"tabbar_agenda_off.png"
#define TAB_PANELIST_ON             @"tabbar_panelist_on.png"
#define TAB_PANELIST_OFF            @"tabbar_panelist_off.png"
#define TAB_NETWORK_ON              @"tabbar_network_on.png"
#define TAB_NETWORK_OFF             @"tabbar_network_off.png"
#define TAB_AVAL_ON                 @"tabbar_aval_on.png"
#define TAB_AVAL_OFF                @"tabbar_aval_off.png"

#endif
