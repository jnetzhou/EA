//+------------------------------------------------------------------+
//|                                                    TextLabel.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "../Element.mqh"
#include "../Window.mqh"
//+------------------------------------------------------------------+
//| Class for creating a text label                                  |
//+------------------------------------------------------------------+
class CLineEdit : public CElement
  {
private:
   //--- Pointer to the form to which the element is attached
   CWindow          *m_wnd;
   //--- Objects for creating a text label
   CEdit             m_edit;
   //avaiable
   bool              m_edit_state;
   
   //--- Text of the description of the edit
   string            m_edit_text;
   //--- Color of the text in different states
   int               m_edit_fontsize;
   //--- Size of the edit
   int               m_edit_x_size;
   int               m_edit_y_size;
   //--- Colors of edit in different states
   color             m_edit_color;
   color             m_edit_color_locked;
   //--- Colors of the edit text in different states
   color             m_edit_text_color;
   color             m_edit_text_color_locked;
   //--- Colors of the edit frame in different states
   color             m_edit_border_color;
   color             m_edit_border_color_hover;
   color             m_edit_border_color_locked;
   color             m_edit_border_color_array[];
   //--- Priorities of the left mouse button press
   int               m_zorder;
   //---
public:
                     CLineEdit(void);
                    ~CLineEdit(void);
   //--- Methods for creating a text label
bool CLineEdit::CreateLineEdit(const long chart_id,const int subwin,const string label_text,
                               const int x_gap    ,const int y_gap,
                               const int width    ,const int height);
private:
   bool              CreateEdit(void);
   //---
   bool              OnEndEdit(const string object_name);   
public:
   //--- Store pointer to the form
   void              WindowPointer(CWindow &object)    { m_wnd=::GetPointer(object);    }
   //--- Gets/sets the text of the label
   string            LabelText(void)             const { return(m_edit.Description()); }
   void              LabelText(const string text)      { m_edit.Description(text); m_edit_text=text;   }
   //--- Setting the (1) color, (2) font and (3) font size of the text label
   void              LabelColor(const color clr)       { m_edit.Color(clr);            }
   void              LabelFont(const string font)      { m_edit.Font(font);            }
   void              LabelFontSize(const int size)     { m_edit.FontSize(size);        }
//set/get
   void              width(int width)                  { m_edit.X_Distance(width);}
   void              height(int height)                { m_edit.Y_Distance(height);}
   //---
   void              LineEditState(bool state);
   bool              LineEditState()                   { return m_edit_state;}
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
   //----
   virtual void      Save(int handle);
   virtual void      Load(int handle);
      
   virtual void      Lock();
   virtual void      UnLock();    
   
   virtual void      fLock();
   virtual void      fUnLock();         
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CLineEdit::CLineEdit(void) : m_edit_state(true),
                             m_edit_text("text_label"),
                             m_edit_color(clrWhite),
                             m_edit_fontsize(3),
                             m_edit_x_size(80),
                             m_edit_y_size(18),                  
                             m_edit_color_locked(clrWhiteSmoke),
                             m_edit_text_color(clrBlack),
                             m_edit_text_color_locked(clrSilver),
                             m_edit_border_color(clrSilver),
                             m_edit_border_color_hover(C'85,170,255'),
                             m_edit_border_color_locked(clrSilver)                             
  {
//--- Store the name of the element class in the base class
   CElement::ClassName(CLASS_NAME);
//--- Set priorities of the left mouse button click
   m_zorder=0;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CLineEdit::~CLineEdit(void)
  {
  
  }
void CLineEdit::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Handling the value change in edit event
   if(id==CHARTEVENT_OBJECT_ENDEDIT)
     {
      //--- Handling of the value entry
      if(OnEndEdit(sparam))
         return;
     }
  }  
//+------------------------------------------------------------------+
//| Creates a group of text edit box objects                         |
//+------------------------------------------------------------------+
bool CLineEdit::CreateLineEdit(const long chart_id,const int subwin,const string label_text,
                               const int x_gap    ,const int y_gap,
                               const int width    ,const int height)
  {
//--- Exit if there is no pointer to the form
   if(!CElement::CheckWindowPointer(::CheckPointer(m_wnd)))
      return(false);
//--- Initializing variables
   m_id          =m_wnd.LastId()+1;
   m_chart_id    =chart_id;
   m_subwin      =subwin;
   m_x           =m_wnd.X()+x_gap;
   m_y           =m_wnd.Y()+m_wnd.CaptionHeight()+y_gap;
   m_edit_text  =label_text;
   m_edit_x_size=width;
   m_edit_y_size=height;
   
//--- Margins from the edge
   CElement::XGap(x_gap);
   CElement::YGap(y_gap);
//--- Creating an element
   if(!CreateEdit())
      return(false);
   m_edit.Anchor(ANCHOR_UPPER);
   m_edit.Selectable(false);
   m_edit.Tooltip("\n");      
//--- Hide the element if the window is a dialog one or is minimized
   if(m_wnd.WindowType()==W_DIALOG || m_wnd.IsMinimized())
      Hide();
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Create label of editable edit control                            |
//+------------------------------------------------------------------+
bool CLineEdit::CreateEdit(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_slider_edit_"+(string)CElement::Id();
//--- Coordinates
   int x=CElement::X();
   int y=CElement::Y();
//--- Set the object
   if(!m_edit.Create(m_chart_id,name,m_subwin,x,y,m_edit_x_size,m_edit_y_size))
      return(false);
//--- set properties
   m_edit.SetString(OBJPROP_TEXT,m_edit_text);
   m_edit.FontSize(m_edit_fontsize);
   m_edit.TextAlign(ALIGN_LEFT);
   m_edit.Color(m_edit_text_color);
   m_edit.BorderColor(m_edit_border_color);
   m_edit.BackColor(m_edit_color);
   m_edit.Selectable(false);
   m_edit.Z_Order(m_zorder);
   m_edit.Tooltip("\n");
//--- Store coordinates
   m_edit.X(x);
   m_edit.Y(y);
//--- Size
   m_edit.XSize(m_edit_x_size);
   m_edit.YSize(m_edit_y_size);
//--- Margins from the edge
   m_edit.XGap(x-m_wnd.X());
   m_edit.YGap(y-m_wnd.Y());
//--- Store the object pointer
   CElement::AddToArray(m_edit);
   return(true);
  }  

//+------------------------------------------------------------------+
//| OnEndEdit                                                        |
//+------------------------------------------------------------------+
bool CLineEdit::OnEndEdit(const string object_name)
  {
//--- Leave, if the object name is different
   if(object_name!=m_edit.Name())
      return(false);
//--- Get the entered value
   m_edit_text=m_edit.Description();

//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_END_EDIT,CElement::Id(),CElement::Index(),m_edit_text);
   return(true);
  }  
//+------------------------------------------------------------------+
//| Moving elements                                                  |
//+------------------------------------------------------------------+
void CLineEdit::Moving(const int x,const int y)
  {
//--- Leave, if the element is hidden
   if(!CElement::IsVisible())
      return;
//--- If the management is delegated to the window, identify its location
   //if(!moving_mode)
   //   if(m_wnd.ClampingAreaMouse()!=PRESSED_INSIDE_HEADER)
   //      return;
//--- If the anchored to the right
      CElement::X(x+XGap());
      CElement::Y(y+YGap());
      m_edit.X(x+m_edit.XGap());
      m_edit.Y(y+m_edit.YGap());
//--- Updating coordinates of graphical objects
   m_edit.X_Distance(m_edit.X());
   m_edit.Y_Distance(m_edit.Y());
  }
//+------------------------------------------------------------------+
//| Shows combobox                                                   |
//+------------------------------------------------------------------+
void CLineEdit::Show(void)
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
void CLineEdit::Hide(void)
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
void CLineEdit::Reset(void)
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
void CLineEdit::Delete(void)
  {
//--- Removing objects
   m_edit.Delete();
//--- Emptying the array of the objects
   CElement::FreeObjectsArray();
//--- Initializing of variables by default values
   CElement::MouseFocus(false);
   CElement::IsVisible(true);
  }
//+------------------------------------------------------------------+

void CLineEdit::LineEditState(bool state)
 {
   m_edit_state = state;
   
   if(state)
   {
      m_edit.Color(m_edit_text_color);
      m_edit.BorderColor(m_edit_border_color);
      m_edit.BackColor(m_edit_color);
      m_edit.ReadOnly(false);      
   }
   else
   {
      m_edit.Color(clrGray);
      m_edit.BorderColor(clrGray);
      m_edit.Color(clrGray);
      m_edit.ReadOnly(true);
   }
 }
//+------------------------------------------------------------------+
//| Save                                                             |
//+------------------------------------------------------------------+
void CLineEdit::Save(int handle)
 {

   CElement::WriteInteger(handle , (int)(m_edit_state));      
   CElement::WriteString(handle , m_edit_text);
   CElement::Save(handle);
 }
//+------------------------------------------------------------------+
//| Load                                                             |
//+------------------------------------------------------------------+
void CLineEdit::Load(int handle)
 {
   
    int       var1 = CElement::ReadInteger(handle);    
    string    var2 = CElement::ReadString( handle);
    CElement::Load(handle);
    
    LineEditState(var1);
    LabelText(var2);    
 } 
//+------------------------------------------------------------------+
//| Lock                                                             |
//+------------------------------------------------------------------+
void CLineEdit::Lock()
 {
    LineEditState(false);
 } 
//+------------------------------------------------------------------+
//| UnLock                                                           |
//+------------------------------------------------------------------+
void CLineEdit::UnLock()
 {
   if(!LineEditState()) LineEditState(true);
 }
//+-----------------------------------------------------------------+

 void CLineEdit::fLock()
 {
   m_foriginState = LineEditState();
   LineEditState(false);
 }
void CLineEdit::fUnLock()
 {
   LineEditState(m_foriginState);
 }