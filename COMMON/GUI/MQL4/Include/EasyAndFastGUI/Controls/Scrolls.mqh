//+------------------------------------------------------------------+
//|                                                      Scrolls.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Element.mqh"
#include "Window.mqh"
//--- List of classes in file for quick navigation (Alt+G)
class CScroll;
class CScrollV;
class CScrollH;
//+------------------------------------------------------------------+
//| Base class for creating the scrollbar                            |
//+------------------------------------------------------------------+
class CScroll : public CElement
  {
protected:
   //--- Pointer to the form to which the element is attached
   CWindow          *m_wnd;
   //--- Objects for creating the scrollbar
   CRectLabel        m_area;
   CRectLabel        m_bg;
   CBmpLabel         m_inc;
   CBmpLabel         m_dec;
   CRectLabel        m_thumb;
   //--- Properties of the general area of the scrollbar
   int               m_area_width;
   int               m_area_length;
   color             m_area_color;
   color             m_area_border_color;
   //--- Properties of the slider background
   int               m_bg_length;
   color             m_bg_border_color;
   //--- Button icons
   string            m_inc_file_on;
   string            m_inc_file_off;
   string            m_dec_file_on;
   string            m_dec_file_off;
   //--- Colors of the slider in different states
   color             m_thumb_color;
   color             m_thumb_color_hover;
   color             m_thumb_color_pressed;
   color             m_thumb_border_color;
   color             m_thumb_border_color_hover;
   color             m_thumb_border_color_pressed;
   //--- (1) Total number of items and (2) visible
   int               m_items_total;
   int               m_visible_items_total;
   //--- (1) Width of the slider, (2) length of the slider (3) and its minimal length
   int               m_thumb_width;
   int               m_thumb_length;
   int               m_thumb_min_length;
   //--- (1) Step of the slider and (2) the number of steps
   double            m_thumb_step_size;
   double            m_thumb_steps_total;
   //--- Priorities of the left mouse button press
   int               m_area_zorder;
   int               m_bg_zorder;
   int               m_arrow_zorder;
   int               m_thumb_zorder;
   //--- Variables connected with the slider movement
   bool              m_scroll_state;
   int               m_thumb_size_fixing;
   int               m_thumb_point_fixing;
   //--- Current location of the slider
   int               m_current_pos;
   //--- To identify the area of pressing down the left mouse button
   ENUM_MOUSE_STATE  m_clamping_area_mouse;
   //---
public:
                     CScroll(void);
                    ~CScroll(void);
   //--- Methods for creating the scrollbar
   bool              CreateScroll(const long chart_id,const int subwin,const int x,const int y,const int items_total,const int visible_items_total);
   //---
private:
   bool              CreateArea(void);
   bool              CreateBg(void);
   bool              CreateInc(void);
   bool              CreateDec(void);
   bool              CreateThumb(void);
   //---
public:
   //--- (1) Stores the form pointer, (2) slider width
   void              WindowPointer(CWindow &object)           { m_wnd=::GetPointer(object);       }
   void              ScrollWidth(const int width)             { m_area_width=width;               }
   int               ScrollWidth(void)                  const { return(m_area_width);             }
   //--- (1) Color of the background, (2) of the background frame and (3) the internal frame of the background
   void              AreaColor(const color clr)               { m_area_color=clr;                 }
   void              AreaBorderColor(const color clr)         { m_area_border_color=clr;          }
   void              BgBorderColor(const color clr)           { m_bg_border_color=clr;            }
   //--- Setting icons for buttons
   void              IncFileOn(const string file_path)        { m_inc_file_on=file_path;          }
   void              IncFileOff(const string file_path)       { m_inc_file_off=file_path;         }
   void              DecFileOn(const string file_path)        { m_dec_file_on=file_path;          }
   void              DecFileOff(const string file_path)       { m_dec_file_off=file_path;         }
   //--- (1) Color of the slider background and (2) the frame of the slider background
   void              ThumbColor(const color clr)              { m_thumb_border_color=clr;         }
   void              ThumbColorHover(const color clr)         { m_thumb_border_color_hover=clr;   }
   void              ThumbColorPressed(const color clr)       { m_thumb_border_color_pressed=clr; }
   void              ThumbBorderColor(const color clr)        { m_thumb_border_color=clr;         }
   void              ThumbBorderColorHover(const color clr)   { m_thumb_border_color_hover=clr;   }
   void              ThumbBorderColorPressed(const color clr) { m_thumb_border_color_pressed=clr; }
   //--- Names of button objects
   string            ScrollIncName(void)                const { return(m_inc.Name());             }
   string            ScrollDecName(void)                const { return(m_dec.Name());             }
   //--- State of buttons
   bool              ScrollIncState(void)               const { return(m_inc.State());            }
   bool              ScrollDecState(void)               const { return(m_dec.State());            }
   //--- State of the scrollbar (free/moving the slider)
   void              ScrollState(const bool scroll_state)     { m_scroll_state=scroll_state;      }
   bool              ScrollState(void)                  const { return(m_scroll_state);           }
   //--- Current location of the slider
   void              CurrentPos(const int pos)                { m_current_pos=pos;                }
   int               CurrentPos(void)                   const { return(m_current_pos);            }
   //--- Identifies the area of pressing down the left mouse button
   void              CheckMouseButtonState(const bool mouse_state);
   //--- Zeroing variables
   void              ZeroThumbVariables(void);
   //--- Change the size of the slider on new conditions
   void              ChangeThumbSize(const int items_total,const int visible_items_total);
   //--- Calculation of the length of the scrollbar slider
   bool              CalculateThumbSize(void);
   //--- Changing the color of the scrollbar objects
   void              ChangeObjectsColor(void);
   //--- Initialize with the new values
   void              Reinit(const int items_total,const int visible_items_total);
   //---
public:
   //--- Chart event handler
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Timer
   virtual void      OnEventTimer(void) {}
   //--- Moving the element
   virtual void      Moving(const int x,const int y);
   //--- (1) Show, (2) hide, (3) reset, (4) delete
   virtual void      Show(void);
   virtual void      Hide(void);
   virtual void      Reset(void);
   virtual void      Delete(void);
   //--- (1) Set, (2) reset priorities of the left mouse button press
   virtual void      SetZorders(void);
   virtual void      ResetZorders(void);
   //--- Reset the color
   virtual void      ResetColors(void) {}
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CScroll::CScroll(void) : m_current_pos(0),
                         m_area_width(15),
                         m_area_length(0),
                         m_inc_file_on(""),
                         m_inc_file_off(""),
                         m_dec_file_on(""),
                         m_dec_file_off(""),
                         m_thumb_width(0),
                         m_thumb_length(0),
                         m_thumb_min_length(15),
                         m_thumb_size_fixing(0),
                         m_thumb_point_fixing(0),
                         m_area_color(C'210,210,210'),
                         m_area_border_color(C'240,240,240'),
                         m_bg_border_color(C'210,210,210'),
                         m_thumb_color(C'190,190,190'),
                         m_thumb_color_hover(C'180,180,180'),
                         m_thumb_color_pressed(C'160,160,160'),
                         m_thumb_border_color(C'170,170,170'),
                         m_thumb_border_color_hover(C'160,160,160'),
                         m_thumb_border_color_pressed(C'140,140,140')
  {
//--- Set priorities of the left mouse button click
   m_area_zorder  =8;
   m_bg_zorder    =9;
   m_arrow_zorder =10;
   m_thumb_zorder =11;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CScroll::~CScroll(void)
  {
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CScroll::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Leave, if the form pointer is incorrect
      if(::CheckPointer(m_wnd)==POINTER_INVALID)
         return;
      //--- Leave, if the element is hidden
      if(!CElement::IsVisible())
         return;
      //--- Leave, if numbers of subwindows do not match
      if(CElement::m_subwin!=CElement::m_mouse.SubWindowNumber())
         return;
      //--- Checking the focus over the buttons
      m_inc.MouseFocus(m_mouse.X()>m_inc.X() && m_mouse.X()<m_inc.X2() && m_mouse.Y()>m_inc.Y() && m_mouse.Y()<m_inc.Y2());
      m_dec.MouseFocus(m_mouse.X()>m_dec.X() && m_mouse.X()<m_dec.X2() && m_mouse.Y()>m_dec.Y() && m_mouse.Y()<m_dec.Y2());
     }
  }
//+------------------------------------------------------------------+
//| Creates the scrollbar                                            |
//+------------------------------------------------------------------+
bool CScroll::CreateScroll(const long chart_id,const int subwin,const int x,const int y,const int items_total,const int visible_items_total)
  {
//--- Leave, if there is no form pointer
   if(!CElement::CheckWindowPointer(::CheckPointer(m_wnd)))
      return(false);
//--- Leave, if there is an attempt to use the base class of the scrollbar
   if(CElement::ClassName()=="")
     {
      ::Print(__FUNCTION__," > Use derived classes of the scrollbar (CScrollV or CScrollH).");
      return(false);
     }
//--- Initializing variables
   m_chart_id            =chart_id;
   m_subwin              =subwin;
   m_x                   =x;
   m_y                   =y;
   m_area_width          =(CElement::ClassName()=="CScrollV")? CElement::XSize() : CElement::YSize();
   m_area_length         =(CElement::ClassName()=="CScrollV")? CElement::YSize() : CElement::XSize();
   m_items_total         =(items_total>0)? items_total : 1;
   m_visible_items_total =(visible_items_total>items_total)? items_total : visible_items_total;
   m_thumb_width         =m_area_width-2;
   m_thumb_steps_total   =m_items_total-m_visible_items_total+1;
//--- Margins from the edge
   CElement::XGap(m_x-m_wnd.X());
   CElement::YGap(m_y-m_wnd.Y());
//--- Creating a button
   if(!CreateArea())
      return(false);
   if(!CreateBg())
      return(false);
   if(!CreateInc())
      return(false);
   if(!CreateDec())
      return(false);
   if(!CreateThumb())
      return(false);
//--- Hide the element if the window is a dialog one or is minimized
   if(m_wnd.WindowType()==W_DIALOG || m_wnd.IsMinimized())
      Hide();
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the common area of the scrollbar                         |
//+------------------------------------------------------------------+
bool CScroll::CreateArea(void)
  {
//--- Forming the object name
   string name      ="";
   string name_part =(CElement::ClassName()=="CScrollV")? "_scrollv_area_" : "_scrollh_area_";
//--- If the index has not been specified
   if(CElement::Index()==WRONG_VALUE)
      name=CElement::ProgramName()+name_part+(string)CElement::Id();
//--- If the index has been specified
   else
      name=CElement::ProgramName()+name_part+(string)CElement::Index()+"__"+(string)CElement::Id();
//--- Creating the object
   if(!m_area.Create(m_chart_id,name,m_subwin,m_x,m_y,m_x_size,m_y_size))
      return(false);
//--- Setting the properties
   m_area.BackColor(m_area_color);
   m_area.Color(m_area_border_color);
   m_area.BorderType(BORDER_FLAT);
   m_area.Corner(m_corner);
   m_area.Selectable(false);
   m_area.Z_Order(m_area_zorder);
   m_area.Tooltip("\n");
//--- Size
   m_area.XSize(m_x_size);
   m_area.YSize(m_y_size);
//--- Margins from the edge
   m_area.XGap(m_x-m_wnd.X());
   m_area.YGap(m_y-m_wnd.Y());
//--- Store the object pointer
   CElement::AddToArray(m_area);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the scrollbar background                                 |
//+------------------------------------------------------------------+
bool CScroll::CreateBg(void)
  {
//--- Forming the object name
   string name      ="";
   string name_part =(CElement::ClassName()=="CScrollV")? "_scrollv_bg_" : "_scrollh_bg_";
//--- If the index has not been specified
   if(CElement::Index()==WRONG_VALUE)
      name=CElement::ProgramName()+name_part+(string)CElement::Id();
//--- If the index has been specified
   else
      name=CElement::ProgramName()+name_part+(string)CElement::Index()+"__"+(string)CElement::Id();
//--- Coordinates
   int x=0;
   int y=0;
//--- Size
   int x_size=0;
   int y_size=0;
//--- Setting properties considering the scrollbar type
   if(CElement::ClassName()=="CScrollV")
     {
      m_bg_length =CElement::YSize()-(m_thumb_width*2)-2;
      x           =CElement::X()+1;
      y           =CElement::Y()+m_thumb_width+1;
      x_size      =m_thumb_width;
      y_size      =m_bg_length;
     }
   else
     {
      m_bg_length =CElement::XSize()-(m_thumb_width*2)-2;
      x           =CElement::X()+m_thumb_width+1;
      y           =CElement::Y()+1;
      x_size      =m_bg_length;
      y_size      =m_thumb_width;
     }
//--- Creating the object
   if(!m_bg.Create(m_chart_id,name,m_subwin,x,y,x_size,y_size))
      return(false);
//--- Setting the properties
   m_bg.BackColor(m_area_color);
   m_bg.Color(m_bg_border_color);
   m_bg.BorderType(BORDER_FLAT);
   m_bg.Corner(m_corner);
   m_bg.Selectable(false);
   m_bg.Z_Order(m_bg_zorder);
   m_bg.Tooltip("\n");
//--- Store coordinates
   m_bg.X(x);
   m_bg.Y(y);
//--- Store margins
   m_bg.XGap(x-m_wnd.X());
   m_bg.YGap(y-m_wnd.Y());
//--- Store the size
   m_bg.XSize(x_size);
   m_bg.YSize(y_size);
//--- Store the object pointer
   CElement::AddToArray(m_bg);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create scrollbar spin up or left                                 |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Controls\\UArrow_min.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\UArrow_min_dark.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\LArrow_min.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\LArrow_min_dark.bmp"
//---
bool CScroll::CreateInc(void)
  {
//--- Forming the object name
   string name      ="";
   string name_part =(CElement::ClassName()=="CScrollV")? "_scrollv_inc_" : "_scrollh_inc_";
//--- If the index has not been specified
   if(CElement::Index()==WRONG_VALUE)
      name=CElement::ProgramName()+name_part+(string)CElement::Id();
//--- If the index has been specified
   else
      name=CElement::ProgramName()+name_part+(string)CElement::Index()+"__"+(string)CElement::Id();
//--- Coordinates
   int x=m_x+1;
   int y=m_y+1;
//--- Setting properties considering the scrollbar type
   if(CElement::ClassName()=="CScrollV")
     {
      if(m_inc_file_on=="")
         m_inc_file_on="::Images\\EasyAndFastGUI\\Controls\\UArrow_min_dark.bmp";
      if(m_inc_file_off=="")
         m_inc_file_off="::Images\\EasyAndFastGUI\\Controls\\UArrow_min.bmp";
     }
   else
     {
      if(m_inc_file_on=="")
         m_inc_file_on="::Images\\EasyAndFastGUI\\Controls\\LArrow_min_dark.bmp";
      if(m_inc_file_off=="")
         m_inc_file_off="::Images\\EasyAndFastGUI\\Controls\\LArrow_min.bmp";
     }
//--- Creating the object
   if(!m_inc.Create(m_chart_id,name,m_subwin,x,y))
      return(false);
//--- Setting the properties
   m_inc.BmpFileOn(m_inc_file_on);
   m_inc.BmpFileOff(m_inc_file_off);
   m_inc.Corner(m_corner);
   m_inc.GetInteger(OBJPROP_ANCHOR,m_anchor);
   m_inc.Selectable(false);
   m_inc.Z_Order(m_arrow_zorder);
   m_inc.Tooltip("\n");
//--- Store coordinates
   m_inc.X(x);
   m_inc.Y(y);
//--- Store margins
   m_inc.XGap(x-m_wnd.X());
   m_inc.YGap(y-m_wnd.Y());
//--- Store the size
   m_inc.XSize(m_inc.X_Size());
   m_inc.YSize(m_inc.Y_Size());
//--- Store the object pointer
   CElement::AddToArray(m_inc);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create scrollbar spin down or right                              |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Controls\\DArrow_min.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\DArrow_min_dark.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\RArrow_min.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\RArrow_min_dark.bmp"
//---
bool CScroll::CreateDec(void)
  {
//--- Forming the object name
   string name      ="";
   string name_part =(CElement::ClassName()=="CScrollV")? "_scrollv_dec_" : "_scrollh_dec_";
//--- If the index has not been specified
   if(CElement::Index()==WRONG_VALUE)
      name=CElement::ProgramName()+name_part+(string)CElement::Id();
//--- If the index has been specified
   else
      name=CElement::ProgramName()+name_part+(string)CElement::Index()+"__"+(string)CElement::Id();
//--- Coordinates
   int x=m_x+1;
   int y=m_y+m_bg.YSize()+m_thumb_width+1;
//--- Setting properties considering the scrollbar type
   if(CElement::ClassName()=="CScrollV")
     {
      x =m_x+1;
      y =m_y+m_bg.YSize()+m_thumb_width+1;
      //--- If the icon is not defined, set the default one
      if(m_dec_file_on=="")
         m_dec_file_on="Images\\EasyAndFastGUI\\Controls\\DArrow_min_dark.bmp";
      if(m_dec_file_off=="")
         m_dec_file_off="Images\\EasyAndFastGUI\\Controls\\DArrow_min.bmp";
     }
   else
     {
      x =m_x+m_bg.XSize()+m_thumb_width+1;
      y =m_y+1;
      //--- If the icon is not defined, set the default one
      if(m_dec_file_on=="")
         m_dec_file_on="Images\\EasyAndFastGUI\\Controls\\RArrow_min_dark.bmp";
      if(m_dec_file_off=="")
         m_dec_file_off="Images\\EasyAndFastGUI\\Controls\\RArrow_min.bmp";
     }
//--- Creating the object
   if(!m_dec.Create(m_chart_id,name,m_subwin,x,y))
      return(false);
//--- Setting the properties
   m_dec.BmpFileOn("::"+m_dec_file_on);
   m_dec.BmpFileOff("::"+m_dec_file_off);
   m_dec.Corner(m_corner);
   m_dec.GetInteger(OBJPROP_ANCHOR,m_anchor);
   m_dec.Selectable(false);
   m_dec.Z_Order(m_arrow_zorder);
   m_dec.Tooltip("\n");
//--- Store coordinates
   m_dec.X(x);
   m_dec.Y(y);
//--- Store margins
   m_dec.XGap(x-m_wnd.X());
   m_dec.YGap(y-m_wnd.Y());
//--- Store the size
   m_dec.XSize(m_dec.X_Size());
   m_dec.YSize(m_dec.Y_Size());
//--- Store the object pointer
   CElement::AddToArray(m_dec);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the slider of the scrollbar                              |
//+------------------------------------------------------------------+
bool CScroll::CreateThumb(void)
  {
//--- Forming the object name  
   string name      ="";
   string name_part =(CElement::ClassName()=="CScrollV")? "_scrollv_thumb_" : "_scrollh_thumb_";
//--- If the index has not been specified
   if(CElement::Index()==WRONG_VALUE)
      name=CElement::ProgramName()+name_part+(string)CElement::Id();
//--- If the index has been specified
   else
      name=CElement::ProgramName()+name_part+(string)CElement::Index()+"__"+(string)CElement::Id();
//--- Coordinates
   int x=0;
   int y=0;
//--- Size
   int x_size=0;
   int y_size=0;
//--- Calculate the size of the scrollbar
   if(!CalculateThumbSize())
      return(true);
//--- Setting the property considering the scrollbar type
   if(CElement::ClassName()=="CScrollV")
     {
      x      =(m_thumb.X()>0) ? m_thumb.X() : m_x+1;
      y      =(m_thumb.Y()>0) ? m_thumb.Y() : m_y+m_thumb_width+1;
      x_size =m_thumb_width;
      y_size =m_thumb_length;
     }
   else
     {
      x      =(m_thumb.X()>0) ? m_thumb.X() : m_x+m_thumb_width+1;
      y      =(m_thumb.Y()>0) ? m_thumb.Y() : m_y+1;
      x_size =m_thumb_length;
      y_size =m_thumb_width;
     }
//--- Creating the object
   if(!m_thumb.Create(m_chart_id,name,m_subwin,x,y,x_size,y_size))
      return(false);
//--- Setting the properties
   m_thumb.BackColor(m_thumb_color);
   m_thumb.Color(m_thumb_border_color);
   m_thumb.BorderType(BORDER_FLAT);
   m_thumb.Corner(m_corner);
   m_thumb.Selectable(false);
   m_thumb.Z_Order(m_thumb_zorder);
   m_thumb.Tooltip("\n");
//--- Store coordinates
   m_thumb.X(x);
   m_thumb.Y(y);
//--- Store margins
   m_thumb.XGap(x-m_wnd.X());
   m_thumb.YGap(y-m_wnd.Y());
//--- Store the size
   m_thumb.XSize(x_size);
   m_thumb.YSize(y_size);
//--- Store the object pointer
   CElement::AddToArray(m_thumb);
   return(true);
  }
//+------------------------------------------------------------------+
//| Calculation of the length of the scrollbar slider                |
//+------------------------------------------------------------------+
bool CScroll::CalculateThumbSize(void)
  {
//--- Calculation is not required if the length of the area for moving the slider is less than the minimal length of the slider
   if(m_bg_length<m_thumb_min_length)
      return(false);
//--- Percentage of difference between the total number of items and visible ones
   double percentage_difference=1-(double)(m_items_total-m_visible_items_total)/m_items_total;
//--- Calculate the size of the slider step
   m_thumb_step_size=(double)(m_bg_length-(m_bg_length*percentage_difference))/m_thumb_steps_total;
//--- Calculate the size of the working area for moving the slider
   double work_area=m_thumb_step_size*m_thumb_steps_total;
//--- If the size of the working area is less than the size of the whole area, get the size of the slider otherwise set the minimal size
   double thumb_size=(work_area<m_bg_length)? m_bg_length-work_area+m_thumb_step_size : m_thumb_min_length;
//--- Check of the slider size using the type casting
   m_thumb_length=((int)thumb_size<m_thumb_min_length)? m_thumb_min_length :(int)thumb_size;
   return(true);
  }
//+------------------------------------------------------------------+
//| Identifies the area of pressing the left mouse button            |
//+------------------------------------------------------------------+
void CScroll::CheckMouseButtonState(const bool mouse_state)
  {
//--- If the left mouse button is released
   if(!mouse_state)
     {
      //--- Zero variables
      ZeroThumbVariables();
      return;
     }
//--- If pressed down
   if(mouse_state)
     {
      //--- Leave, if the button is pressed down in another area
      if(m_clamping_area_mouse!=NOT_PRESSED)
         return;
      //--- Outside of the slider area
      if(!m_thumb.MouseFocus())
         m_clamping_area_mouse=PRESSED_OUTSIDE;
      //--- Inside the slider area
      else
        {
         m_clamping_area_mouse=PRESSED_INSIDE;
         //--- If this is not a drop-down element
         if(!CElement::IsDropdown())
           {
            //--- Block the form and store the active element identifier
            m_wnd.IsLocked(true);
            m_wnd.IdActivatedElement(CElement::Id());
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Zeroing variables connected with the slider movement             |
//+------------------------------------------------------------------+
void CScroll::ZeroThumbVariables(void)
  {
//--- Leave, if there is no form pointer
   if(::CheckPointer(m_wnd)==POINTER_INVALID)
      return;
//--- If this is not a drop-down element
   if(!CElement::IsDropdown() && m_clamping_area_mouse==PRESSED_INSIDE)
     {
      //--- Unblock the form and reset the active element identifier
      m_wnd.IsLocked(false);
      m_wnd.IdActivatedElement(WRONG_VALUE);
     }
//--- Zero variables
   m_thumb_size_fixing   =0;
   m_clamping_area_mouse =NOT_PRESSED;
  }
//+------------------------------------------------------------------+
//| Changes the color of objects of the list view scrollbar          |
//+------------------------------------------------------------------+
void CScroll::ChangeObjectsColor(void)
  {
//--- Leave, if the form is blocked and the identifier of the currently active element differs
   if(m_wnd.IsLocked() && m_wnd.IdActivatedElement()!=CElement::Id())
      return;
//--- Color of the buttons of the list view scrollbar
   if(!m_scroll_state)
     {
      m_inc.State(m_inc.MouseFocus());
      m_dec.State(m_dec.MouseFocus());
     }
//--- If the cursor is in the scrollbar area
   if(m_thumb.MouseFocus())
     {
      //--- If the left mouse button is released
      if(m_clamping_area_mouse==NOT_PRESSED)
        {
         m_scroll_state=false;
         m_thumb.BackColor(m_thumb_color_hover);
         m_thumb.Color(m_thumb_border_color_hover);
        }
      //--- The left mouse button is pressed down on the slider
      else if(m_clamping_area_mouse==PRESSED_INSIDE)
        {
         m_scroll_state=true;
         m_thumb.BackColor(m_thumb_color_pressed);
         m_thumb.Color(m_thumb_border_color_pressed);
        }
     }
//--- If the cursor is outside of the scrollbar area
   else
     {
      //--- Left mouse button is released
      if(m_clamping_area_mouse==NOT_PRESSED)
        {
         m_scroll_state=false;
         m_thumb.BackColor(m_thumb_color);
         m_thumb.Color(m_thumb_border_color);
        }
     }
  }
//+------------------------------------------------------------------+
//| Initialize with the new values                                   |
//+------------------------------------------------------------------+
void CScroll::Reinit(const int items_total,const int visible_items_total)
  {
   m_items_total         =(items_total>0)? items_total : 1;
   m_visible_items_total =(visible_items_total>items_total)? items_total : visible_items_total;
   m_thumb_steps_total   =m_items_total-m_visible_items_total+1;
  }
//+------------------------------------------------------------------+
//| Change the size of the slider on new conditions                  |
//+------------------------------------------------------------------+
void CScroll::ChangeThumbSize(const int items_total,const int visible_items_total)
  {
   m_items_total         =items_total;
   m_visible_items_total =visible_items_total;
//--- Leave, if the number of the list view items is not greater than the size of its visible part
   if(items_total<=visible_items_total)
      return;
//--- Get the number of steps for the slider
   m_thumb_steps_total=items_total-visible_items_total+1;
//--- Get the size of the scrollbar
   if(!CalculateThumbSize())
      return;
//--- Store the size
   if(CElement::ClassName()=="CScrollV")
     {
      CElement::YSize(m_thumb_length);
      m_thumb.YSize(m_thumb_length);
      m_thumb.Y_Size(m_thumb_length);
     }
   else
     {
      CElement::XSize(m_thumb_length);
      m_thumb.XSize(m_thumb_length);
      m_thumb.X_Size(m_thumb_length);
     }
  }
//+------------------------------------------------------------------+
//| Moving elements                                                  |
//+------------------------------------------------------------------+
void CScroll::Moving(const int x,const int y)
  {
//--- Leave, if the element is hidden
   if(!CElement::IsVisible())
      return;
//--- Storing coordinates in the element fields
   CElement::X(x+XGap());
   CElement::Y(y+YGap());
//--- Storing coordinates in the fields of the objects
   m_area.X(x+m_area.XGap());
   m_area.Y(y+m_area.YGap());
   m_bg.X(x+m_bg.XGap());
   m_bg.Y(y+m_bg.YGap());
   m_inc.X(x+m_inc.XGap());
   m_inc.Y(y+m_inc.YGap());
   m_dec.X(x+m_dec.XGap());
   m_dec.Y(y+m_dec.YGap());
   m_thumb.X(x+m_thumb.XGap());
   m_thumb.Y(y+m_thumb.YGap());
//--- Updating coordinates of graphical objects
   m_area.X_Distance(m_area.X());
   m_area.Y_Distance(m_area.Y());
   m_bg.X_Distance(m_bg.X());
   m_bg.Y_Distance(m_bg.Y());
   m_inc.X_Distance(m_inc.X());
   m_inc.Y_Distance(m_inc.Y());
   m_dec.X_Distance(m_dec.X());
   m_dec.Y_Distance(m_dec.Y());
   m_thumb.X_Distance(m_thumb.X());
   m_thumb.Y_Distance(m_thumb.Y());
  }
//+------------------------------------------------------------------+
//| Shows a menu item                                                |
//+------------------------------------------------------------------+
void CScroll::Show(void)
  {
//--- Leave, if the number of the list view items is not greater than the size of its visible part
   if(m_items_total<=m_visible_items_total)
      return;
//---
   m_area.Timeframes(OBJ_ALL_PERIODS);
   m_bg.Timeframes(OBJ_ALL_PERIODS);
   m_inc.Timeframes(OBJ_ALL_PERIODS);
   m_dec.Timeframes(OBJ_ALL_PERIODS);
   m_thumb.Timeframes(OBJ_ALL_PERIODS);
  }
//+------------------------------------------------------------------+
//| Hides a menu item                                                |
//+------------------------------------------------------------------+
void CScroll::Hide(void)
  {
   m_area.Timeframes(OBJ_NO_PERIODS);
   m_bg.Timeframes(OBJ_NO_PERIODS);
   m_inc.Timeframes(OBJ_NO_PERIODS);
   m_dec.Timeframes(OBJ_NO_PERIODS);
   m_thumb.Timeframes(OBJ_NO_PERIODS);
  }
//+------------------------------------------------------------------+
//| Redrawing                                                        |
//+------------------------------------------------------------------+
void CScroll::Reset(void)
  {
//--- Leave, if this is a drop-down element
   if(CElement::IsDropdown())
      return;
//--- Hide and show
   Hide();
   Show();
  }
//+------------------------------------------------------------------+
//| Deletion                                                         |
//+------------------------------------------------------------------+
void CScroll::Delete(void)
  {
//--- Removing objects
   m_area.Delete();
   m_bg.Delete();
   m_inc.Delete();
   m_dec.Delete();
   m_thumb.Delete();
//--- Emptying the array of the objects
   CElement::FreeObjectsArray();
//--- Initializing of variables by default values
   m_thumb.X(0);
   m_thumb.Y(0);
   CurrentPos(0);
   CElement::IsVisible(true);
   CElement::MouseFocus(false);
  }
//+------------------------------------------------------------------+
//| Seth the priorities                                              |
//+------------------------------------------------------------------+
void CScroll::SetZorders(void)
  {
   m_area.Z_Order(m_area_zorder);
   m_bg.Z_Order(m_bg_zorder);
   m_inc.Z_Order(m_arrow_zorder);
   m_dec.Z_Order(m_arrow_zorder);
   m_thumb.Z_Order(m_thumb_zorder);
//--- If this is a vertical scroll bar
   if(CElement::ClassName()=="CScrollV")
     {
      m_inc.BmpFileOn(m_inc_file_on);
      m_dec.BmpFileOn(m_dec_file_on);
      return;
     }
//--- If this is a horizontal scroll bar
   if(CElement::ClassName()=="CScrollH")
     {
      m_inc.BmpFileOn(m_inc_file_on);
      m_dec.BmpFileOn(m_dec_file_on);
      return;
     }
  }
//+------------------------------------------------------------------+
//| Reset the priorities                                             |
//+------------------------------------------------------------------+
void CScroll::ResetZorders(void)
  {
   m_area.Z_Order(0);
   m_bg.Z_Order(0);
   m_inc.Z_Order(0);
   m_dec.Z_Order(0);
   m_thumb.Z_Order(0);
//--- If this is a vertical scroll bar
   if(CElement::ClassName()=="CScrollV")
     {
      m_inc.BmpFileOn(m_inc_file_off);
      m_dec.BmpFileOn(m_dec_file_off);
      return;
     }
//--- If this is a horizontal scroll bar
   if(CElement::ClassName()=="CScrollH")
     {
      m_inc.BmpFileOn(m_inc_file_off);
      m_dec.BmpFileOn(m_dec_file_off);
      return;
     }
  }
//+------------------------------------------------------------------+
//| Class for managing the vertical scrollbar                        |
//+------------------------------------------------------------------+
class CScrollV : public CScroll
  {
public:
                     CScrollV(void);
                    ~CScrollV(void);
   //--- Managing the scrollbar
   bool              ScrollBarControl(const int x,const int y,const bool mouse_state);
   //--- Calculation of the Y coordinate of the scrollbar
   void              CalculateThumbY(void);
   //--- Set the new coordinate for the scrollbar
   void              XDistance(const int x);
   //--- Change the length of the scrollbar
   void              ChangeYSize(const int height);
   //--- Handling the pressing on the scrollbar buttons
   bool              OnClickScrollInc(const string clicked_object);
   bool              OnClickScrollDec(const string clicked_object);
   //---
private:
   //--- Process of the slider movement
   void              OnDragThumb(const int y);
   //--- Updating the location of the slider
   void              UpdateThumb(const int new_y_point);
   //--- Corrects the value of the slider position
   void              CalculateThumbPos(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CScrollV::CScrollV(void)
  {
//--- Store the name of the element class in the base class
   CElement::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CScrollV::~CScrollV(void)
  {
  }
//+------------------------------------------------------------------+
//| Managing the slider                                              |
//+------------------------------------------------------------------+
bool CScrollV::ScrollBarControl(const int x,const int y,const bool mouse_state)
  {
//--- Leave, if there is no form pointer
   if(::CheckPointer(m_wnd)==POINTER_INVALID)
      return(false);
//--- If the form is not blocked and identifiers match
   if(m_wnd.IsLocked() && m_wnd.IdActivatedElement()!=CElement::Id())
      return(false);
//--- Checking the focus over the slider
   m_thumb.MouseFocus(x>m_thumb.X() && x<m_thumb.X2() && 
                      y>m_thumb.Y() && y<m_thumb.Y2());
//--- Check and store the state of the mouse button
   CScroll::CheckMouseButtonState(mouse_state);
//--- Change the color of the scrollbar
   CScroll::ChangeObjectsColor();
//--- If the management is passed to the scrollbar, identify the location of the scrollbar
   if(CScroll::ScrollState())
     {
      //--- Moving the slider
      OnDragThumb(y);
      //--- Changes the value of the scrollbar location
      CalculateThumbPos();
      return(true);
     }
//---
   return(false);
  }
//+------------------------------------------------------------------+
//| Calculation of the Y coordinate of the scrollbar slider          |
//+------------------------------------------------------------------+
void CScrollV::CalculateThumbY(void)
  {
//--- Leave, if there is no form pointer
   if(::CheckPointer(m_wnd)==POINTER_INVALID)
      return;
//--- Identify current Y coordinate of the scrollbar
   int scroll_thumb_y=int(m_bg.Y()+(CScroll::CurrentPos()*CScroll::m_thumb_step_size));
//--- If the working area is exceeded upwards
   if(scroll_thumb_y<=m_bg.Y())
      scroll_thumb_y=m_bg.Y();
//--- If the working area is exceeded downwards
   if(scroll_thumb_y+CScroll::m_thumb_length>=m_bg.Y2() || 
      CScroll::CurrentPos()>=CScroll::m_thumb_steps_total-1)
     {
      scroll_thumb_y=int(m_bg.Y2()-CScroll::m_thumb_length);
     }
//--- Update the coordinate and margin along the Y axis
   m_thumb.Y(scroll_thumb_y);
   m_thumb.Y_Distance(scroll_thumb_y);
   m_thumb.YGap(m_thumb.Y()-m_wnd.Y());
  }
//+------------------------------------------------------------------+
//| Change the X coordinate of the element                           |
//+------------------------------------------------------------------+
void CScrollV::XDistance(const int x)
  {
//--- Leave, if there is no form pointer
   if(::CheckPointer(m_wnd)==POINTER_INVALID)
      return;
//--- Update the X coordinate of the element ...
   int l_x=x+1;
   CElement::X(x);
//--- ...and all the objects of the scroll bar
   m_area.X(CElement::X());
   m_bg.X(l_x);
   m_thumb.X(l_x);
   m_inc.X(l_x);
   m_dec.X(l_x);
//--- Set the coordinates to the objects
   m_area.X_Distance(CElement::X());
   m_bg.X_Distance(l_x);
   m_thumb.X_Distance(l_x);
   m_inc.X_Distance(l_x);
   m_dec.X_Distance(l_x);
//--- Update the indents of all element objects
   l_x=l_x-m_wnd.X();
   m_area.XGap(CElement::X()-m_wnd.X());
   m_bg.XGap(l_x);
   m_thumb.XGap(l_x);
   m_inc.XGap(l_x);
   m_dec.XGap(l_x);
  }
//+------------------------------------------------------------------+
//| Change the length of the scrollbar                               |
//+------------------------------------------------------------------+
void CScrollV::ChangeYSize(const int height)
  {
//--- Coordinates
   int y=0;
//--- Size
   int y_size=0;
//--- Change the width of the control and the background
   CElement::YSize(height);
   m_area.YSize(height);
   m_area.Y_Size(height);
//--- Calculate the width of the slider workspace
   y_size=CElement::YSize()-(m_thumb_width*2)-2;
   m_bg_length=y_size;
   m_bg.YSize(y_size);
   m_bg.Y_Size(y_size);
//--- Calculate coordinate for the decrement button
   y=CElement::Y()+m_bg.YSize()+m_thumb_width+1;
   m_dec.Y(y);
   m_dec.Y_Distance(y);
   m_dec.YGap(y-m_wnd.Y());
//--- Calculate and set the sizes of the scrollbar objects
   CalculateThumbSize();
   m_thumb.YSize(m_thumb_length);
   m_thumb.Y_Size(m_thumb_length);
//--- Adjust the slider position
   CalculateThumbY();
   CalculateThumbPos();
  }
//+------------------------------------------------------------------+
//| Handling the pressing on the upwards/to the left button          |
//+------------------------------------------------------------------+
bool CScrollV::OnClickScrollInc(const string clicked_object)
  {
//--- Leave, if the pressing was not on this object or the scrollbar is inactive or the number of steps is undefined
   if(m_inc.Name()!=clicked_object || CScroll::ScrollState() || CScroll::m_thumb_steps_total<1)
      return(false);
//--- Decrease the value of the scrollbar position
   if(CScroll::CurrentPos()>0)
      CScroll::m_current_pos--;
//--- Calculation of the Y coordinate of the scrollbar
   CalculateThumbY();
//--- Set the state to On
   m_inc.State(true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the pressing on the downwards/to the left right         |
//+------------------------------------------------------------------+
bool CScrollV::OnClickScrollDec(const string clicked_object)
  {
//--- Leave, if the pressing was not on this object or the scrollbar is inactive or the number of steps is undefined
   if(m_dec.Name()!=clicked_object || CScroll::ScrollState() || CScroll::m_thumb_steps_total<1)
      return(false);
//--- Increase the value of the scrollbar position
   if(CScroll::CurrentPos()<CScroll::m_thumb_steps_total-1)
      CScroll::m_current_pos++;
//--- Calculation of the Y coordinate of the scrollbar
   CalculateThumbY();
//--- Set the state to On
   m_dec.State(true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Moving the slider                                                |
//+------------------------------------------------------------------+
void CScrollV::OnDragThumb(const int y)
  {
//--- To identify the new Y coordinate
   int new_y_point=0;
//--- If the scrollbar is inactive, ...
   if(!CScroll::ScrollState())
     {
      //--- ...zero auxiliary variables for moving the slider
      CScroll::m_thumb_size_fixing  =0;
      CScroll::m_thumb_point_fixing =0;
      return;
     }
//--- If the fixation point is zero, store current coordinates of the cursor
   if(CScroll::m_thumb_point_fixing==0)
      CScroll::m_thumb_point_fixing=y;
//--- If the distance from the edge of the slider to the current coordinate of the cursor is zero, calculate it
   if(CScroll::m_thumb_size_fixing==0)
      CScroll::m_thumb_size_fixing=m_thumb.Y()-y;
//--- If the threshold is passed downwards in the pressed down state
   if(y-CScroll::m_thumb_point_fixing>0)
     {
      //--- Calculate the Y coordinate
      new_y_point=y+CScroll::m_thumb_size_fixing;
      //--- Update location of the slider
      UpdateThumb(new_y_point);
      return;
     }
//--- If the threshold is passed upwards in the pressed down state
   if(y-CScroll::m_thumb_point_fixing<0)
     {
      //--- Calculate the Y coordinate
      new_y_point=y-::fabs(CScroll::m_thumb_size_fixing);
      //--- Update location of the slider
      UpdateThumb(new_y_point);
      return;
     }
  }
//+------------------------------------------------------------------+
//| Updating of the location of the slider                           |
//+------------------------------------------------------------------+
void CScrollV::UpdateThumb(const int new_y_point)
  {
   int y=new_y_point;
//--- Zeroing the fixation point
   CScroll::m_thumb_point_fixing=0;
//--- Checking for exceeding the working area downwards and adjusting values
   if(new_y_point>m_bg.Y2()-CScroll::m_thumb_length)
     {
      y=m_bg.Y2()-CScroll::m_thumb_length;
      CScroll::CurrentPos(int(CScroll::m_thumb_steps_total));
     }
//--- Checking for exceeding the working area upwards and adjusting values
   if(new_y_point<=m_bg.Y())
     {
      y=m_bg.Y();
      CScroll::CurrentPos(0);
     }
//--- Update coordinates and margins
   m_thumb.Y(y);
   m_thumb.Y_Distance(y);
   m_thumb.YGap(m_thumb.Y()-(CElement::Y()-CElement::YGap()));
  }
//+------------------------------------------------------------------+
//| Corrects the value of the slider position                        |
//+------------------------------------------------------------------+
void CScrollV::CalculateThumbPos(void)
  {
//--- Leave, if the step is zero
   if(CScroll::m_thumb_step_size==0)
      return;
//--- Corrects the value of the position of the scrollbar
   CScroll::CurrentPos(int((m_thumb.Y()-m_bg.Y())/CScroll::m_thumb_step_size));
//--- Check for exceeding the working area downwards/upwards
   if(m_thumb.Y2()>=m_bg.Y2()-1)
      CScroll::CurrentPos(int(CScroll::m_thumb_steps_total-1));
   if(m_thumb.Y()<m_bg.Y())
      CScroll::CurrentPos(0);
  }
//+------------------------------------------------------------------+
//| Class for managing the horizontal scrollbar                      |
//+------------------------------------------------------------------+
class CScrollH : public CScroll
  {
public:
                     CScrollH(void);
                    ~CScrollH(void);
   //--- Managing the scrollbar
   bool              ScrollBarControl(const int x,const int y,const bool mouse_state);
   //--- Calculation of the X coordinate of the slider
   void              CalculateThumbX(void);
   //--- Change the length of the scrollbar
   void              ChangeXSize(const int width);
   //--- Handling the pressing on the scrollbar buttons
   bool              OnClickScrollInc(const string clicked_object);
   bool              OnClickScrollDec(const string clicked_object);
   //---
private:
   //--- Moving the slider
   void              OnDragThumb(const int x);
   //--- Updating the location of the slider
   void              UpdateThumb(const int new_x_point);
   //--- Corrects the value of the slider position
   void              CalculateThumbPos(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CScrollH::CScrollH(void)
  {
//--- Store the name of the element class in the base class
   CElement::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CScrollH::~CScrollH(void)
  {
  }
//+------------------------------------------------------------------+
//| Managing the scrollbar                                           |
//+------------------------------------------------------------------+
bool CScrollH::ScrollBarControl(const int x,const int y,const bool mouse_state)
  {
//--- Leave, if there is no form pointer
   if(::CheckPointer(m_wnd)==POINTER_INVALID)
      return(false);
   if(m_wnd.IsLocked() && m_wnd.IdActivatedElement()!=CElement::Id())
      return(false);
//--- Checking the focus over the slider
   m_thumb.MouseFocus(x>m_thumb.X() && x<m_thumb.X2() && 
                      y>m_thumb.Y() && y<m_thumb.Y2());
//--- Check and store the state of the mouse button
   CScroll::CheckMouseButtonState(mouse_state);
//--- Change the color of the list view scrollbar
   CScroll::ChangeObjectsColor();
//--- If the management is passed to the scrollbar, identify the location of the scrollbar
   if(CScroll::ScrollState())
     {
      //--- Moving the slider
      OnDragThumb(x);
      //--- Changes the value of the scrollbar location
      CalculateThumbPos();
      return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+
//| Calculation of the X coordinate of the slider                    |
//+------------------------------------------------------------------+
void CScrollH::CalculateThumbX(void)
  {
//--- Identify current X coordinate of the scrollbar
   int scroll_thumb_x=int(m_bg.X()+(CScroll::CurrentPos()*CScroll::m_thumb_step_size));
//--- If the working area is exceeded on the left
   if(scroll_thumb_x<=m_bg.X())
      scroll_thumb_x=m_bg.X();
//--- If the working area is exceeded on the right
   if(scroll_thumb_x+CScroll::m_thumb_length>=m_bg.X2() || 
      CScroll::CurrentPos()>=CScroll::m_thumb_steps_total-1)
     {
      scroll_thumb_x=int(m_bg.X2()-CScroll::m_thumb_length);
     }
//--- Update the coordinate and margin along the X axis
   m_thumb.X(scroll_thumb_x);
   m_thumb.X_Distance(scroll_thumb_x);
   m_thumb.XGap(m_thumb.X()-(m_x-CElement::XGap()));
  }
//+------------------------------------------------------------------+
//| Change the length of the scrollbar                               |
//+------------------------------------------------------------------+
void CScrollH::ChangeXSize(const int width)
  {
//--- Coordinates
   int x=0;
//--- Size
   int x_size=0;
//--- Change the width of the control and the background
   CElement::XSize(width);
   m_area.XSize(width);
   m_area.X_Size(width);
//--- Calculate the width of the slider workspace
   x_size=CElement::XSize()-(m_thumb_width*2)-2;
   m_bg_length=x_size;
   m_bg.XSize(x_size);
   m_bg.X_Size(x_size);
//--- Calculate coordinate for the decrement button
   x=CElement::X()+m_bg.XSize()+m_thumb_width+1;
   m_dec.X(x);
   m_dec.X_Distance(x);
   m_dec.XGap(x-m_wnd.X());
//--- Calculate and set the sizes of the scrollbar objects
   CalculateThumbSize();
   m_thumb.XSize(m_thumb_length);
   m_thumb.X_Size(m_thumb_length);
//--- Adjust the slider position
   CalculateThumbX();
   CalculateThumbPos();
  }
//+------------------------------------------------------------------+
//| Pressing on the left spin                                        |
//+------------------------------------------------------------------+
bool CScrollH::OnClickScrollInc(const string clicked_object)
  {
//--- Leave, if the pressing was not on this object or the scrollbar is inactive or the number of steps is undefined
   if(m_inc.Name()!=clicked_object || CScroll::ScrollState() || CScroll::m_thumb_steps_total<0)
      return(false);
//--- Decrease the value of the scrollbar position
   if(CScroll::CurrentPos()>0)
      CScroll::m_current_pos--;
//--- Calculation of the X coordinate of the scrollbar
   CalculateThumbX();
//--- Set the state to On
   m_inc.State(true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Pressing on the right spin                                       |
//+------------------------------------------------------------------+
bool CScrollH::OnClickScrollDec(const string clicked_object)
  {
//--- Leave, if the pressing was not on this object or the scrollbar is inactive or the number of steps is undefined
   if(m_dec.Name()!=clicked_object || CScroll::ScrollState() || CScroll::m_thumb_steps_total<0)
      return(false);
//--- Increase the value of the scrollbar position
   if(CScroll::CurrentPos()<CScroll::m_thumb_steps_total-1)
      CScroll::m_current_pos++;
//--- Calculation of the X coordinate of the scrollbar
   CalculateThumbX();
//--- Set the state to On
   m_dec.State(true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Moving the slider                                                |
//+------------------------------------------------------------------+
void CScrollH::OnDragThumb(const int x)
  {
//--- To identify the new X coordinate
   int new_x_point=0;
//--- If the scrollbar is inactive, ...
   if(!CScroll::ScrollState())
     {
      //--- ...zero auxiliary variables for moving the slider
      CScroll::m_thumb_size_fixing  =0;
      CScroll::m_thumb_point_fixing =0;
      return;
     }
//--- If the fixation point is zero, store current coordinates of the cursor
   if(CScroll::m_thumb_point_fixing==0)
      CScroll::m_thumb_point_fixing=x;
//--- If the distance from the edge of the slider to the current coordinate of the cursor is zero, calculate it
   if(CScroll::m_thumb_size_fixing==0)
      CScroll::m_thumb_size_fixing=m_thumb.X()-x;
//--- If the threshold is passed to the right in the pressed down state
   if(x-CScroll::m_thumb_point_fixing>0)
     {
      //--- Calculate the X coordinate
      new_x_point=x+CScroll::m_thumb_size_fixing;
      //--- Updating the scrollbar location
      UpdateThumb(new_x_point);
      return;
     }
//--- If the threshold is passed to the left in the pressed down state
   if(x-CScroll::m_thumb_point_fixing<0)
     {
      //--- Calculate the X coordinate
      new_x_point=x-::fabs(CScroll::m_thumb_size_fixing);
      //--- Updating the scrollbar location
      UpdateThumb(new_x_point);
      return;
     }
  }
//+------------------------------------------------------------------+
//| Updating the scrollbar location                                  |
//+------------------------------------------------------------------+
void CScrollH::UpdateThumb(const int new_x_point)
  {
   int x=new_x_point;
//--- Zeroing the fixation point
   CScroll::m_thumb_point_fixing=0;
//--- Checking for exceeding the working area to the right and adjusting values
   if(new_x_point>m_bg.X2()-CScroll::m_thumb_length)
     {
      x=m_bg.X2()-CScroll::m_thumb_length;
      CScroll::CurrentPos(0);
     }
//--- Checking for exceeding the working area to the left and adjusting values
   if(new_x_point<=m_bg.X())
     {
      x=m_bg.X();
      CScroll::CurrentPos(int(CScroll::m_thumb_steps_total));
     }
//--- Update coordinates and margins
   m_thumb.X(x);
   m_thumb.X_Distance(x);
   m_thumb.XGap(m_thumb.X()-(m_x-CElement::XGap()));
  }
//+------------------------------------------------------------------+
//| Corrects the value of the slider position                        |
//+------------------------------------------------------------------+
void CScrollH::CalculateThumbPos(void)
  {
//--- Leave, if the step is zero
   if(CScroll::m_thumb_step_size==0)
      return;
//--- Corrects the value of the position of the scrollbar
   CScroll::CurrentPos(int((m_thumb.X()-m_bg.X())/CScroll::m_thumb_step_size));
//--- Check for exceeding the working area on the left/right
   if(m_thumb.X2()>=m_bg.X2()-1)
      CScroll::CurrentPos(int(CScroll::m_thumb_steps_total-1));
   if(m_thumb.X()<m_bg.X())
      CScroll::CurrentPos(0);
  }
//+------------------------------------------------------------------+
