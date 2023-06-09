//+------------------------------------------------------------------+
//|                                                 SeparateLine.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Element.mqh"
#include "Window.mqh"
//+------------------------------------------------------------------+
//| Class for creating a separation line                             |
//+------------------------------------------------------------------+
class CSeparateLine : public CElement
  {
private:
   //--- Pointer to the form to which the element is attached
   CWindow          *m_wnd;
   //--- Object for creating a separation line
   CRectCanvas       m_canvas;
   //--- Properties
   ENUM_TYPE_SEP_LINE m_type_sep_line;   
   color             m_dark_color;
   color             m_light_color;
   //---
public:
                     CSeparateLine(void);
                    ~CSeparateLine(void);
   //--- Stores the pointer to the passed form
   void              WindowPointer(CWindow &object) { m_wnd=::GetPointer(object); }
   //--- Creating a separation line
   bool              CreateSeparateLine(const long chart_id,const int subwin,const int index,
                                        const int x,const int y,const int x_size,const int y_size);
   //---
private:
   //--- Creates the canvas for drawing a separation line
   bool              CreateSepLine(void);
   //--- Drawing a separation line
   void              DrawSeparateLine(void);
   //---
public:
   //--- (1) Line type, (2) line colors
   void              TypeSepLine(const ENUM_TYPE_SEP_LINE type) { m_type_sep_line=type; }
   void              DarkColor(const color clr)                 { m_dark_color=clr;     }
   void              LightColor(const color clr)                { m_light_color=clr;    }
   //---
public:
   //--- Chart event handler
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Moving the element
   virtual void      Moving(const int x,const int y);
   //--- (1) Show, (2) hide, (3) reset, (4) delete
   virtual void      Show(void);
   virtual void      Hide(void);
   virtual void      Reset(void);
   virtual void      Delete(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSeparateLine::CSeparateLine(void) : m_type_sep_line(H_SEP_LINE),
                                     m_dark_color(C'160,160,160'),
                                     m_light_color(clrWhite)
  {
//--- Store the name of the element class in the base class  
   CElement::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSeparateLine::~CSeparateLine(void)
  {
  }
//+------------------------------------------------------------------+
//| Chart event handler                                              |
//+------------------------------------------------------------------+
void CSeparateLine::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
  }
//+------------------------------------------------------------------+
//| Creates a separation line                                        |
//+------------------------------------------------------------------+
bool CSeparateLine::CreateSeparateLine(const long chart_id,const int subwin,const int index,
                                       const int x,const int y,const int x_size,const int y_size)
  {
//--- Leave, if there is no form pointer
   if(!CElement::CheckWindowPointer(::CheckPointer(m_wnd)))
      return(false);
//--- Initializing variables
   m_id       =m_wnd.LastId()+1;
   m_chart_id =chart_id;
   m_subwin   =subwin;
   m_index    =index;
   m_x        =x;
   m_y        =y;
   m_x_size   =x_size;
   m_y_size   =y_size;
//--- Margins from the edge
   CElement::XGap(m_x-m_wnd.X());
   CElement::YGap(m_y-m_wnd.Y());
//--- Creating an element
   if(!CreateSepLine())
      return(false);
//--- If the form is minimized, hide the element after creation
   if(m_wnd.WindowType()==W_DIALOG || m_wnd.IsMinimized())
      Hide();
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Crates the canvas for drawing a separation line                  |
//+------------------------------------------------------------------+
bool CSeparateLine::CreateSepLine(void)
  {
//--- Forming the object name  
   string name=CElement::ProgramName()+"_separate_line_"+(string)CElement::Index()+"__"+(string)CElement::Id();
//--- Creating the object
   if(!m_canvas.CreateBitmapLabel(m_chart_id,m_subwin,name,m_x,m_y,m_x_size,m_y_size,COLOR_FORMAT_ARGB_NORMALIZE))
      return(false);
//--- Attach to the chart
   if(!m_canvas.Attach(m_chart_id,name,m_subwin,1))
      return(false);
//--- Properties
   m_canvas.Background(false);
//--- Margins from the edge
   m_canvas.XGap(m_x-m_wnd.X());
   m_canvas.YGap(m_y-m_wnd.Y());
   m_canvas.Tooltip("\n");
//--- Draw a separation line
   DrawSeparateLine();
//--- Add to array
   CElement::AddToArray(m_canvas);
   return(true);
  }
//+------------------------------------------------------------------+
//| Draws a separation line                                          |
//+------------------------------------------------------------------+
void CSeparateLine::DrawSeparateLine(void)
  {
//--- Coordinates for the lines
   int x1=0,x2=0,y1=0,y2=0;
//--- Canvas size
   int   x_size =m_canvas.X_Size()-1;
   int   y_size =m_canvas.Y_Size()-1;
//--- Clear canvas
   m_canvas.Erase(::ColorToARGB(clrNONE,0));
//--- If the line is horizontal
   if(m_type_sep_line==H_SEP_LINE)
     {
      //--- The dark line above
      x1=0;
      y1=0;
      x2=x_size;
      y2=0;
      //---
      m_canvas.Line(x1,y1,x2,y2,::ColorToARGB(m_dark_color));
      //--- The light line below
      x1=0;
      x2=x_size;
      y1=y_size;
      y2=y_size;
      //---
      m_canvas.Line(x1,y1,x2,y2,::ColorToARGB(m_light_color));
     }
//--- If the line is vertical
   else
     {
      //--- The dark line on the left
      x1=0;
      x2=0;
      y1=0;
      y2=y_size;
      //---
      m_canvas.Line(x1,y1,x2,y2,::ColorToARGB(m_dark_color));
      //--- The light line on the right
      x1=x_size;
      y1=0;
      x2=x_size;
      y2=y_size;
      //---
      m_canvas.Line(x1,y1,x2,y2,::ColorToARGB(m_light_color));
     }
//--- Refreshing canvas
   m_canvas.Update();
  }
//+------------------------------------------------------------------+
//| Moving the element                                               |
//+------------------------------------------------------------------+
void CSeparateLine::Moving(const int x,const int y)
  {
//--- Leave, if the element is hidden
   //if(!CElement::IsVisible())
   //   return;
//--- Storing coordinates in the element fields
   CElement::X(x+XGap());
   CElement::Y(y+YGap());
//--- Storing coordinates in the fields of the objects
   m_canvas.X(x+m_canvas.XGap());
   m_canvas.Y(y+m_canvas.YGap());
//--- Updating coordinates of graphical objects
   m_canvas.X_Distance(m_canvas.X());
   m_canvas.Y_Distance(m_canvas.Y());
  }
//+------------------------------------------------------------------+
//| Shows the element                                                |
//+------------------------------------------------------------------+
void CSeparateLine::Show(void)
  {
//--- Leave, if the element is already visible
   if(CElement::IsVisible())
      return;
//--- Make all objects visible  
   m_canvas.Timeframes(OBJ_ALL_PERIODS);
//--- Initializing variables
   CElement::IsVisible(true);
  }
//+------------------------------------------------------------------+
//| Hides the element                                                |
//+------------------------------------------------------------------+
void CSeparateLine::Hide(void)
  {
//--- Leave, if the element is hidden
   if(!CElement::IsVisible())
      return;
//--- Hide the objects
   m_canvas.Timeframes(OBJ_NO_PERIODS);
//--- Assign the status of a hidden element
   CElement::IsVisible(false);
  }
//+------------------------------------------------------------------+
//| Redrawing                                                        |
//+------------------------------------------------------------------+
void CSeparateLine::Reset(void)
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
void CSeparateLine::Delete(void)
  {
//--- Removing objects
   m_canvas.Delete();
//--- Emptying the array of the objects
   CElement::FreeObjectsArray();
//--- Initializing of variables by default values
   CElement::MouseFocus(false);
   CElement::IsVisible(true);
  }
//+------------------------------------------------------------------+
