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
class CTextLabel : public CElement
  {
   bool              m_textLable_state;
private:
   //--- Pointer to the form to which the element is attached
   CWindow          *m_wnd;
   //--- Objects for creating a text label
   CLabel            m_label;
   
   //--- Text of the description of the edit
   string            m_label_text;
   //--- Color of the text in different states
   color             m_label_color;
   //--- Priorities of the left mouse button press
   int               m_zorder;
   //---
public:
                     CTextLabel(void);
                    ~CTextLabel(void);
   //--- Methods for creating a text label
   bool              CreateTextLabel(const long chart_id,const int subwin,const string label_text,const int x_gap,const int y_gap);
   //---
private:
   bool              CreateLabel(void);
   
   //---
public:
   //--- Store pointer to the form
   void              WindowPointer(CWindow &object)    { m_wnd=::GetPointer(object);    }
   //--- Gets/sets the text of the label
   string            LabelText(void)             const { return(m_label.Description()); }
   void              LabelText(const string text)      { m_label_text  =text; m_label.Description(text);     }
   //--- Setting the (1) color, (2) font and (3) font size of the text label
   void              LabelColor(const color clr)       { m_label.Color(clr);     m_label_color = clr; }
   void              LabelFont(const string font)      { m_label.Font(font);            }
   void              LabelFontSize(const int size)     { m_label.FontSize(size);        }
   //---
   void              Anchor(ENUM_ANCHOR_POINT anchor)  { m_anchor = anchor; m_label.Anchor(anchor); }
   //---f
   void              TextLabelState(bool state);
   bool              TextLabelState(){return m_textLable_state;}
   
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
   //--f 虚函数
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
CTextLabel::CTextLabel(void) : m_label_text("text_label"),
                               m_label_color(clrYellow)

  {
//--- Store the name of the element class in the base class
   CElement::ClassName(CLASS_NAME);
//--- Set priorities of the left mouse button click
   m_zorder=0;
   m_textLable_state = true;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTextLabel::~CTextLabel(void)
  {
  }
//+------------------------------------------------------------------+
//| Creates a group of text edit box objects                         |
//+------------------------------------------------------------------+
bool CTextLabel::CreateTextLabel(const long chart_id,const int subwin,const string label_text,const int x_gap,const int y_gap)
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
   m_label_text  =label_text;
//--- Margins from the edge
   CElement::XGap(x_gap);
   CElement::YGap(y_gap);
//--- Creating an element
   if(!CreateLabel())
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
bool CTextLabel::CreateLabel(void)
  {
//--- Formation of the window name
   string name="";
   if(m_index==WRONG_VALUE)
      name=CElement::ProgramName()+"_textlabel_lable_"+(string)CElement::Id();
   else
      name=CElement::ProgramName()+"_textlabel_lable_"+(string)CElement::Index()+"__"+(string)CElement::Id();
//--- Coordinates
   int x=CElement::X();
   int y=CElement::Y();
//--- Set the object
   if(!m_label.Create(m_chart_id,name,m_subwin,x,y))
      return(false);
//--- Set properties
   m_label.Description(m_label_text);
   m_label.Color(m_label_color);
   m_label.Corner(m_corner);
   m_label.Anchor(m_anchor);
   m_label.Selectable(false);
   m_label.Z_Order(m_zorder);
   m_label.Tooltip("\n");
//--- Margins from the edge
   m_label.XGap(x-m_wnd.X());
   m_label.YGap(y-m_wnd.Y());
//--- Store the object pointer
   CElement::AddToArray(m_label);
   return(true);
  }
//+------------------------------------------------------------------+
//| Moving elements                                                  |
//+------------------------------------------------------------------+
void CTextLabel::Moving(const int x,const int y)
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
      m_label.X(x+m_label.XGap());
      m_label.Y(y+m_label.YGap());
//--- Updating coordinates of graphical objects
   m_label.X_Distance(m_label.X());
   m_label.Y_Distance(m_label.Y());
  }
//+------------------------------------------------------------------+
//| Shows combobox                                                   |
//+------------------------------------------------------------------+
void CTextLabel::Show(void)
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
void CTextLabel::Hide(void)
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
void CTextLabel::Reset(void)
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
void CTextLabel::Delete(void)
  {
//--- Removing objects
   m_label.Delete();
//--- Emptying the array of the objects
   CElement::FreeObjectsArray();
//--- Initializing of variables by default values
   CElement::MouseFocus(false);
   CElement::IsVisible(true);
  }
//+------------------------------------------------------------------+
void CTextLabel::TextLabelState(bool state)
 {
   if(state) m_label.Color(m_label_color);
   else m_label.Color(clrGray);
   m_textLable_state = state;
 }
//---
//+------------------------------------------------------------------+
//| Save                                                             |
//+------------------------------------------------------------------+
void CTextLabel::Save(int handle)
 {
   CElement::WriteInteger(handle , (int)(m_textLable_state)); 
   CElement::Save(handle); 
   
 }
//+------------------------------------------------------------------+
//| Load                                                             |
//+------------------------------------------------------------------+
void CTextLabel::Load(int handle)
 {
    int       var1 = CElement::ReadInteger(handle);
    CElement::Load(handle);
    
    TextLabelState(var1);
    
 }
//+------------------------------------------------------------------+
//| Lock                                                             |
//+------------------------------------------------------------------+
void CTextLabel::Lock()
 {
    TextLabelState(false);
 } 
//+------------------------------------------------------------------+
//| UnLock                                                           |
//+------------------------------------------------------------------+
void CTextLabel::UnLock()
 {
   if(!TextLabelState()) TextLabelState(true);
 }
//+------------------------------------------------------------------+
 void CTextLabel::fLock()
 {
   m_foriginState = TextLabelState();
   TextLabelState(false);
 }
void CTextLabel::fUnLock()
 {
   TextLabelState(m_foriginState);
 }