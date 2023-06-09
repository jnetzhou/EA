//+------------------------------------------------------------------+
//|                                                      Defines.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
//--- Class name
#define CLASS_NAME ::StringSubstr(__FUNCTION__,0,::StringFind(__FUNCTION__,"::"))
//--- Program name
#define PROGRAM_NAME ::MQLInfoString(MQL_PROGRAM_NAME)
//--- Program type
#define PROGRAM_TYPE (ENUM_PROGRAM_TYPE)::MQLInfoInteger(MQL_PROGRAM_TYPE)
//--- Prevention of exceeding the range
#define PREVENTING_OUT_OF_RANGE __FUNCTION__," > Prevention of exceeding the array size."

//--- Font
#define FONT      ("Calibri")
#define FONT_SIZE (8)

//--- Timer step (milliseconds)
#define TIMER_STEP_MSC (16)
//--- Delay before enabling the fast forward of the counter (milliseconds)
#define SPIN_DELAY_MSC (-450)

//--- Event identifiers
#define ON_WINDOW_UNROLL          (1)  // Maximizing the form
#define ON_WINDOW_ROLLUP          (2)  // Minimizing the form
#define ON_WINDOW_CHANGE_SIZE     (3)  // Changing the window size
#define ON_CLICK_MENU_ITEM        (4)  // Clicking on the menu item
#define ON_CLICK_CONTEXTMENU_ITEM (5)  // Clicking on the menu item in a context menu
#define ON_HIDE_CONTEXTMENUS      (6)  // Hide all context menus
#define ON_HIDE_BACK_CONTEXTMENUS (7)  // Hide context menus below the current menu item
#define ON_CLICK_BUTTON           (8)  // Pressing the button
#define ON_CLICK_FREEMENU_ITEM    (9)  // Clicking on the item of a detached context menu
#define ON_CLICK_LABEL            (10) // Pressing of the text label
#define ON_OPEN_DIALOG_BOX        (11) // The opening of a dialog box event
#define ON_CLOSE_DIALOG_BOX       (12) // Closing of a dialog box event
#define ON_RESET_WINDOW_COLORS    (13) // Resetting the window color
#define ON_ZERO_PRIORITIES        (14) // Resetting priorities of the left mouse button
#define ON_SET_PRIORITIES         (15) // Restoring priorities of the left mouse click
#define ON_CLICK_LIST_ITEM        (16) // Selecting the list view item
#define ON_CLICK_COMBOBOX_ITEM    (17) // Selecting an item in the combobox list view
#define ON_END_EDIT               (18) // Final editing of the value in the edit
#define ON_CLICK_INC              (19) // Changing the counter up
#define ON_CLICK_DEC              (20) // Changing the counter down
#define ON_CLICK_COMBOBOX_BUTTON  (21) // Clicking on the button of combo box
#define ON_CHANGE_DATE            (22) // Changing the date in the calendar<
#define ON_CHANGE_TREE_PATH       (23) // The path in the tree view changed
#define ON_CHANGE_COLOR           (24) // Changing the color using the color picker
//f
#define ON_WINDOW_CLICK_TOOLTIPS  (25) // 点击ToolTips
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| 文件操作                                                         |
//+------------------------------------------------------------------+

#define GENERIC_READ                0x80000000
#define GENERIC_WRITE               0x40000000
#define FILE_SHARE_READ_            0x00000001
#define FILE_SHARE_WRITE_           0x00000002
#define FILE_ATTRIBUTE_NORMAL       0x80
#define INVALID_SET_FILE_POINTER    -1
#define INVALID_FILE_SIZE           -1
#define INVALID_FILE_ATTRIBUTES     -1
#define FORMAT_MESSAGE_FROM_SYSTEM  0x00001000
//---
#define OPEN_EXISTING               3
#define WinNULL                     0x00000000

//+------------------------------------------------------------------+
//|   Import                                                         |
//+------------------------------------------------------------------+
#import "kernel32.dll"
   int CreateFileW(string, uint, int, int, int, int, int);
   int GetFileSize(int, int);
   int ReadFile(int, int &[], int, int&[], int);
   int ReadFile(int, ushort &[], int, int&[], int);
   int WriteFile(int , int &[], int, int&[], int );
   int CloseHandle(int);
#import "msvcrt.dll"
  int memcpy(double &dst,  int& [], int cnt);
  int memcpy(int    &dst,  int& [], int cnt);
#import

int fReadInteger(int h)
 {
   int size = 4;
   int buffer[];
   ArrayResize(buffer, 1);
   int read[1];
   ReadFile(h, buffer, size, read, 0);
   
	int x = 0;
	memcpy(x, buffer, sizeof(int));
   return x;
 }

double fReadDouble(int h)
 {
   int size = 8;
   int buffer[];
   ArrayResize(buffer, 2);
   int read[1];
   ReadFile(h, buffer, size, read, 0);

	double x = 0;
	memcpy(x, buffer, sizeof(double));
	
   return x;
 }

string fReadString(int h )
 {
   
   int length = fReadInteger(h);
   if(length == 0) return "";
   int size = length*2;
   ushort buffer[];
   ArrayResize(buffer, length);
   int read[1];
   ReadFile(h, buffer, size, read, 0);
   string ch = ShortToString(buffer[0]);
   
   ushort shortArray[]; ArrayResize(shortArray,length);
   for(int i=0;i<length;i++)
      shortArray[i] = buffer[i];
   
   return ShortArrayToString(shortArray);
 }

//+------------------------------------------------------------------+
//| 打开网页                                                         |
//+------------------------------------------------------------------+
#import  "shell32.dll"
//--- x64
long ShellExecuteW(long hwnd,string lpOperation,string lpFile,string lpParameters,string lpDirectory,int nShowCmd);
//--- x32
int ShellExecuteW(int hwnd,string lpOperation,string lpFile,string lpParameters,string lpDirectory,int nShowCmd);

#import
