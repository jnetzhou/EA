//+------------------------------------------------------------------+
//|                                                    TextLabel.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property strict
#include "../Element.mqh"
#include "../Window.mqh"
#include <Graphics\Graphic.mqh>

class fGraphics : public CElement
  {
   bool              m_graphic_state;
private:
   CWindow          *m_wnd;
   int               m_zorder;
public:
   CGraphic          m_graphic;   
public:
                     fGraphics(void);
                    ~fGraphics(void);   
   //--- Methods for creating a text label
   bool              CreateGraphics(const long chart_id,const int subwin,const int x_gap,const int y_gap);
   //---
private:
   bool              CreateGraphic(void);   
public:
   //--- Store pointer to the form
   void              WindowPointer(CWindow &object)    { m_wnd=::GetPointer(object);}
   //---f
   void              GraphicsState(bool state){m_graphic_state = state;}
   bool              GraphicsState(){return m_graphic_state;}
   
public:
   //--- Chart event handler
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam) {}
   //--- Timer
   virtual void      OnEventTimer(void) {}
   //--- Moving the element
   virtual void      Moving(const int x,const int y);
   //--- (1) Show, (2) hide, (3) reset, (4) delete
   virtual void      Show(void);
   virtual void      Hide(void);
   virtual void      Reset(void);
   virtual void      Delete(void);
   //---f 虚函数
   virtual void      Save(int handle){}
   virtual void      Load(int handle){}
      
   virtual void      Lock(){}
   virtual void      UnLock(){} 
   
   virtual void      fLock(){}
   virtual void      fUnLock(){}    
  };

fGraphics::fGraphics(void) 
  {
//--- Store the name of the element class in the base class
   CElement::ClassName(CLASS_NAME);
//--- Set priorities of the left mouse button click
   m_zorder=0;
   m_graphic_state = true;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
fGraphics::~fGraphics(void)
  {
   
  }
//+------------------------------------------------------------------+
//| CreateGraphics                                                   |
//+------------------------------------------------------------------+
bool fGraphics::CreateGraphics(const long chart_id,const int subwin,const int x_gap,const int y_gap)
  {
//--- Exit if there is no pointer to the form
   if(!CElement::CheckWindowPointer(::CheckPointer(m_wnd)))
      return(false);
//--- Initializing variables
   m_id          =m_wnd.LastId()+1;
   m_chart_id    =chart_id;
   m_subwin      =subwin;
   m_x           =m_wnd.X()+x_gap;
   m_y           =m_wnd.Y()+y_gap;
//--- Margins from the edge
   CElement::XGap(x_gap);
   CElement::YGap(y_gap);
   
   //printf("图表 X = %d Y = %d",CElement::X(),CElement::Y());
//--- Creating an element
   if(!CreateGraphic())
      return(false);
//--- Hide the element if the window is a dialog one or is minimized
   if(m_wnd.WindowType()==W_DIALOG || m_wnd.IsMinimized())
      Hide();
//---
   m_foriginState = true;
   return(true);
  }
//+------------------------------------------------------------------+
//| Create label of editable edit control                            |
//+------------------------------------------------------------------+
bool fGraphics::CreateGraphic(void)
  {
//--- Formation of the window name
   string name="";
   if(m_index==WRONG_VALUE)
      name=CElement::ProgramName()+"_Graphic_"+(string)CElement::Id();
   else
      name=CElement::ProgramName()+"_Graphic_"+(string)CElement::Index()+"__"+(string)CElement::Id();
//--- Coordinates
   int x=CElement::X();
   int y=CElement::Y();
   int x2=x + 630;
   int y2=y + 275;
//--- Set the object
   //printf("创建X = %d,Y = %d",x,y);
   if(!m_graphic.Create(m_chart_id,name,m_subwin,x,y , x2 , y2))
      return(false);
   m_graphic.SetName(name);
//--- Store the object pointer
   CElement::AddToArray(m_graphic);
   return(true);
  }

//+------------------------------------------------------------------+
//| Moving elements                                                  |
//+------------------------------------------------------------------+
void fGraphics::Moving(const int x,const int y)
  {
//--- Leave, if the element is hidden
   if(!CElement::IsVisible())
      return;
//--- If the anchored to the right
   CElement::X(x+XGap());
   CElement::Y(y+YGap());
   m_graphic.X(x+XGap());
   m_graphic.Y(y+YGap());

//--- Updating coordinates of graphical objects
   m_graphic.X_Distance(m_graphic.X());
   m_graphic.Y_Distance(m_graphic.Y());
  }
//+------------------------------------------------------------------+
//| Shows combobox                                                   |
//+------------------------------------------------------------------+
void fGraphics::Show(void)
  {
//--- Leave, if the element is already visible
   if(CElement::IsVisible())
      return;
//--- Make all the objects visible
   for(int i=0; i<CElement::ObjectsElementTotal(); i++)
      CElement::Object(i).Timeframes(OBJ_ALL_PERIODS);
//--- Visible state
   CElement::IsVisible(true);
//--- Update the position of objects
   Moving(m_wnd.X(),m_wnd.Y());
  }

//+------------------------------------------------------------------+
//| Hides combobox                                                   |
//+------------------------------------------------------------------+
void fGraphics::Hide(void)
  {
//--- Leave, if the element is already visible
   if(!CElement::IsVisible())
      return;
//--- Hide all objects
   for(int i=0; i<CElement::ObjectsElementTotal(); i++)
      CElement::Object(i).Timeframes(OBJ_NO_PERIODS);
//--- Visible state
   CElement::IsVisible(false);
  }
//+------------------------------------------------------------------+
//| Redrawing                                                        |
//+------------------------------------------------------------------+
void fGraphics::Reset(void)
  {
//--- Leave, if this is a drop-down element
   if(CElement::IsDropdown())
      return;
//--- Hide and show
   Hide();
   Show();
  }
//+------------------------------------------------------------------+
//| Remove                                                         |
//+------------------------------------------------------------------+
void fGraphics::Delete(void)
  {
//--- Removing objects
   m_graphic.Destroy();
   m_graphic.Delete();
//--- Emptying the array of the objects
   CElement::FreeObjectsArray();
//--- Initializing of variables by default values
   CElement::MouseFocus(false);
   CElement::IsVisible(true);
  }
//+------------------------------------------------------------------+


