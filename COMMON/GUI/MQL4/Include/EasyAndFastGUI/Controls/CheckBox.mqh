//+------------------------------------------------------------------+
//|                                                     CheckBox.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Element.mqh"
#include "Window.mqh"
//+------------------------------------------------------------------+
//| Class for creating a checkbox                                    |
//+------------------------------------------------------------------+
class CCheckBox : public CElement
  {
private:
   //--- Pointer to the form to which the element is attached
   CWindow          *m_wnd;
   //--- Objects for creating a checkbox
   CRectLabel        m_area;
   CBmpLabel         m_check;
   CLabel            m_label;
   //--- Color of the checkbox background
   color             m_area_color;
   //--- Checkbox icons in the active and blocked states
   string            m_check_bmp_file_on;
   string            m_check_bmp_file_off;
   string            m_check_bmp_file_on_locked;
   string            m_check_bmp_file_off_locked;
   //--- State of the checkbox button
   bool              m_check_button_state;
   //--- Text of the checkbox
   string            m_label_text;
   //--- Text label margins
   int               m_label_x_gap;
   int               m_label_y_gap;
   //--- Colors of the text label in different states
   color             m_label_color;
   color             m_label_color_off;
   color             m_label_color_hover;
   color             m_label_color_locked;
   color             m_label_color_array[];
   //--- Priorities of the left mouse button press
   int               m_zorder;
   int               m_area_zorder;
   //--- Checkbox state (available/blocked)
   bool              m_checkbox_state;
   //---
public:
                     CCheckBox(void);
                    ~CCheckBox(void);
   //--- Methods for creating a checkbox
   bool              CreateCheckBox(const long chart_id,const int subwin,const string text,const int x,const int y);
   //---
private:
   bool              CreateArea(void);
   bool              CreateCheck(void);
   bool              CreateLabel(void);
   //---
public:
   //--- (1) Stores the form pointer, (2) return/set the state of the checkbox
   void              WindowPointer(CWindow &object)                 { m_wnd=::GetPointer(object);            }
   bool              CheckBoxState(void)                      const { return(m_checkbox_state);              }
   void              CheckBoxState(const bool state);
   //--- Setting labels for the button in the active and blocked states
   void              CheckFileOn(const string file_path)            { m_check_bmp_file_on=file_path;         }
   void              CheckFileOff(const string file_path)           { m_check_bmp_file_off=file_path;        }
   void              CheckFileOnLocked(const string file_path)      { m_check_bmp_file_on_locked=file_path;  }
   void              CheckFileOffLocked(const string file_path)     { m_check_bmp_file_off_locked=file_path; }
   //--- (1) Background color, (2) margins for the text label
   void              AreaColor(const color clr)                     { m_area_color=clr;                      }
   void              LabelXGap(const int x_gap)                     { m_label_x_gap=x_gap;                   }
   void              LabelYGap(const int y_gap)                     { m_label_y_gap=y_gap;                   }
   //--- Color of the text in different states
   void              LabelColor(const color clr)                    { m_label_color=clr;                     }
   void              LabelColorOff(const color clr)                 { m_label_color_off=clr;                 }
   void              LabelColorHover(const color clr)               { m_label_color_hover=clr;               }
   void              LabelColorLocked(const color clr)              { m_label_color_locked=clr;              }
   //--- (1) Description of the checkbox, (2) return/set the state of the checkbox button
   string            LabelText(void)                          const { return(m_label.Description());         }
   bool              CheckButtonState(void)                   const { return(m_check.State());               }
   void              CheckButtonState(const bool state);
   bool              fState(void)                   const { return m_check_button_state; }
   void              forceCheckButtonState(const bool state);
   //--- Changing the color
   void              ChangeObjectsColor(void);
   //---
public:
   //--- Chart event handler
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Timer
   virtual void      OnEventTimer(void);
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
   virtual void      ResetColors(void);
   //---
   virtual void      Save(int handle);
   virtual void      Load(int handle);
   
   virtual void      Lock();
   virtual void      UnLock();

   virtual void      fLock();
   virtual void      fUnLock();
private:
   //--- Handling of the press on the element
   bool              OnClickLabel(const string clicked_object);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CCheckBox::CCheckBox(void) : m_checkbox_state(true),
                             m_check_button_state(false),
                             m_area_color(clrNONE),
                             m_label_x_gap(20),
                             m_label_y_gap(2),
                             m_label_color(clrBlack),
                             m_label_color_off(clrBlack),
                             m_label_color_locked(clrSilver),
                             m_label_color_hover(C'85,170,255'),
                             m_check_bmp_file_on(""),
                             m_check_bmp_file_off(""),
                             m_check_bmp_file_on_locked(""),
                             m_check_bmp_file_off_locked("")

  {
//--- Store the name of the element class in the base class
   CElement::ClassName(CLASS_NAME);
//--- Set priorities of the left mouse button click
   m_zorder      =0;
   m_area_zorder =1;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CCheckBox::~CCheckBox(void)
  {
  }
//+------------------------------------------------------------------+
//| Event handling                                                |
//+------------------------------------------------------------------+
void CCheckBox::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Handling of the cursor movement event
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Leave, if the element is hidden
      if(!CElement::IsVisible())
         return;
      //--- Leave, if numbers of subwindows do not match
      if(CElement::m_subwin!=CElement::m_mouse.SubWindowNumber())
         return;
      //--- Checking the focus over element
      CElement::MouseFocus(m_mouse.X()>X() && m_mouse.X()<X2() && m_mouse.Y()>Y() && m_mouse.Y()<Y2());
      return;
     }
//--- Handling the left mouse button click on the object
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      //--- Pressing on the checkbox
      if(OnClickLabel(sparam))
         return;
     }
  }
//+------------------------------------------------------------------+
//| Timer                                                            |
//+------------------------------------------------------------------+
void CCheckBox::OnEventTimer(void)
  {
//--- If the form is not blocked
   if(!m_wnd.IsLocked())
      //--- Changing the color of the element objects
      ChangeObjectsColor();
  }
//+------------------------------------------------------------------+
//| Creates a group of the checkbox objects                          |
//+------------------------------------------------------------------+
bool CCheckBox::CreateCheckBox(const long chart_id,const int subwin,const string text,const int x,const int y)
  {
//--- Leave, if there is no form pointer
   if(!CElement::CheckWindowPointer(::CheckPointer(m_wnd)))
      return(false);
//--- Initializing variables
   m_id         =m_wnd.LastId()+1;
   m_chart_id   =chart_id;
   m_subwin     =subwin;
   m_x          =x;
   m_y          =y;
   m_label_text =text;
   m_area_color =(m_area_color!=clrNONE)? m_area_color : m_wnd.WindowBgColor();
//--- Margins from the edge
   CElement::XGap(CElement::X()-m_wnd.X());
   CElement::YGap(CElement::Y()-m_wnd.Y());
//--- Creating an element
   if(!CreateArea())
      return(false);
   if(!CreateCheck())
      return(false);
   if(!CreateLabel())
      return(false);
//--- Hide the element if the window is a dialog one or is minimized
   if(m_wnd.WindowType()==W_DIALOG || m_wnd.IsMinimized())
      Hide();
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates checkbox area                                            |
//+------------------------------------------------------------------+
bool CCheckBox::CreateArea(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_checkbox_area_"+(string)CElement::Id();
//--- Set the object
   if(!m_area.Create(m_chart_id,name,m_subwin,m_x,m_y,m_x_size,m_y_size))
      return(false);
//--- set properties
   m_area.BackColor(m_area_color);
   m_area.Color(m_area_color);
   m_area.BorderType(BORDER_FLAT);
   m_area.Corner(m_corner);
   m_area.Selectable(false);
   m_area.Z_Order(m_area_zorder);
   m_area.Tooltip("\n");
//--- Margins from the edge
   m_area.XGap(CElement::X()-m_wnd.X());
   m_area.YGap(CElement::Y()-m_wnd.Y());
//--- Store the object pointer
   CElement::AddToArray(m_area);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates checkbox                                                 |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Controls\\CheckBoxOn.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\CheckBoxOff.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\CheckBoxOn_locked.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\CheckBoxOff_locked.bmp"
//---
bool CCheckBox::CreateCheck(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_checkbox_bmp_"+(string)CElement::Id();
//--- Coordinates
   int x=CElement::X()+2;
   int y=CElement::Y()+2;
//--- If the icon for the checkbox button is not specified, then set the default one
   if(m_check_bmp_file_on=="")
      m_check_bmp_file_on="Images\\EasyAndFastGUI\\Controls\\CheckBoxOn.bmp";
   if(m_check_bmp_file_off=="")
      m_check_bmp_file_off="Images\\EasyAndFastGUI\\Controls\\CheckBoxOff.bmp";
//---
   if(m_check_bmp_file_on_locked=="")
      m_check_bmp_file_on_locked="Images\\EasyAndFastGUI\\Controls\\CheckBoxOn_locked.bmp";
   if(m_check_bmp_file_off_locked=="")
      m_check_bmp_file_off_locked="Images\\EasyAndFastGUI\\Controls\\CheckBoxOff_locked.bmp";
//--- Set the object
   if(!m_check.Create(m_chart_id,name,m_subwin,x,y))
      return(false);
//--- set properties
   m_check.BmpFileOn("::"+m_check_bmp_file_on);
   m_check.BmpFileOff("::"+m_check_bmp_file_off);
   m_check.State(m_check_button_state);
   m_check.Corner(m_corner);
   m_check.Selectable(false);
   m_check.Z_Order(m_zorder);
   m_check.Tooltip("\n");
//--- Margins from the edge
   m_check.XGap(x-m_wnd.X());
   m_check.YGap(y-m_wnd.Y());
//--- Store the object pointer
   CElement::AddToArray(m_check);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates checkbox label                                           |
//+------------------------------------------------------------------+
bool CCheckBox::CreateLabel(void)
  {
//--- Forming the object name
   string name=CElement::ProgramName()+"_checkbox_lable_"+(string)CElement::Id();
//--- Coordinates
   int x =CElement::X()+m_label_x_gap;
   int y =CElement::Y()+m_label_y_gap;
//--- Text color according to the state
   color label_color=(m_check_button_state) ? m_label_color : m_label_color_off;
//--- Set the object
   if(!m_label.Create(m_chart_id,name,m_subwin,x,y))
      return(false);
//--- set properties
   m_label.Description(m_label_text);
   m_label.Font(FONT);
   m_label.FontSize(FONT_SIZE);
   m_label.Color(label_color);
   m_label.Corner(m_corner);
   m_label.Anchor(m_anchor);
   m_label.Selectable(false);
   m_label.Z_Order(m_zorder);
   m_label.Tooltip("\n");
//--- Margins from the edge
   m_label.XGap(x-m_wnd.X());
   m_label.YGap(y-m_wnd.Y());
//--- Initializing gradient array
   CElement::InitColorArray(label_color,m_label_color_hover,m_label_color_array);
//--- Store the object pointer
   CElement::AddToArray(m_label);
   return(true);
  }
//+------------------------------------------------------------------+
//| Moving elements                                                  |
//+------------------------------------------------------------------+
void CCheckBox::Moving(const int x,const int y)
  {
//--- Leave, if the element is hidden
   if(!CElement::IsVisible())
      return;
//--- Storing indents in the element fields
   CElement::X(x+XGap());
   CElement::Y(y+YGap());
//--- Storing coordinates in the fields of the objects
   m_area.X(x+m_area.XGap());
   m_area.Y(y+m_area.YGap());
   m_check.X(x+m_check.XGap());
   m_check.Y(y+m_check.YGap());
   m_label.X(x+m_label.XGap());
   m_label.Y(y+m_label.YGap());
//--- Updating coordinates of graphical objects
   m_area.X_Distance(m_area.X());
   m_area.Y_Distance(m_area.Y());
   m_check.X_Distance(m_check.X());
   m_check.Y_Distance(m_check.Y());
   m_label.X_Distance(m_label.X());
   m_label.Y_Distance(m_label.Y());
  }
//+------------------------------------------------------------------+
//| Changing the object color when the cursor is hovering over it    |
//+------------------------------------------------------------------+
void CCheckBox::ChangeObjectsColor(void)
  {
//--- Leave, if the element is blocked
   if(!m_checkbox_state)
      return;
//---
   color label_color=(m_check_button_state) ? m_label_color : m_label_color_off;
   CElement::ChangeObjectColor(m_label.Name(),CElement::MouseFocus(),OBJPROP_COLOR,label_color,m_label_color_hover,m_label_color_array);
  }
//+------------------------------------------------------------------+
//| Shows combobox                                                   |
//+------------------------------------------------------------------+
void CCheckBox::Show(void)
  {
//--- Leave, if the element is already visible
   if(CElement::IsVisible())
      return;
//--- Make all objects visible
   for(int i=0; i<CElement::ObjectsElementTotal(); i++)
      CElement::Object(i).Timeframes(OBJ_ALL_PERIODS);
//--- State of visibility
   CElement::IsVisible(true);
  }
//+------------------------------------------------------------------+
//| Hides combobox                                                   |
//+------------------------------------------------------------------+
void CCheckBox::Hide(void)
  {
//--- Leave, if the element is already visible
   if(!CElement::IsVisible())
      return;
//--- Hide all objects
   for(int i=0; i<CElement::ObjectsElementTotal(); i++)
      CElement::Object(i).Timeframes(OBJ_NO_PERIODS);
//--- State of visibility
   CElement::IsVisible(false);
  }
//+------------------------------------------------------------------+
//| Redrawing                                                        |
//+------------------------------------------------------------------+
void CCheckBox::Reset(void)
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
void CCheckBox::Delete(void)
  {
//--- Removing objects
   m_area.Delete();
   m_check.Delete();
   m_label.Delete();
//--- Emptying the array of the objects
   CElement::FreeObjectsArray();
//--- Initializing of variables by default values
   CElement::MouseFocus(false);
   CElement::IsVisible(true);
  }
//+------------------------------------------------------------------+
//| Seth the priorities                                              |
//+------------------------------------------------------------------+
void CCheckBox::SetZorders(void)
  {
   m_area.Z_Order(m_area_zorder);
   m_check.Z_Order(m_zorder);
   m_label.Z_Order(m_zorder);
  }
//+------------------------------------------------------------------+
//| Reset the priorities                                             |
//+------------------------------------------------------------------+
void CCheckBox::ResetZorders(void)
  {
   m_area.Z_Order(0);
   m_check.Z_Order(-1);
   m_label.Z_Order(0);
  }
//+------------------------------------------------------------------+
//| Reset the color of the element objects                           |
//+------------------------------------------------------------------+
void CCheckBox::ResetColors(void)
  {
//--- Leave, if the element is blocked
   if(!m_checkbox_state)
      return;
//--- Reset the color
   m_label.Color((m_check_button_state)? m_label_color : m_label_color_off);
//--- Zero the focus
   CElement::MouseFocus(false);
  }
//+------------------------------------------------------------------+
//| Setting the state of the checkbox button                         |
//+------------------------------------------------------------------+
void CCheckBox::CheckButtonState(const bool state)
  {
//--- Leave, if the element is blocked
   if(!m_checkbox_state)
      return;
//--- Set the button state
   m_check.State(state);
   m_check_button_state=state;
//--- Change colors according to the current state
   m_label.Color((state)? m_label_color : m_label_color_off);
   CElement::InitColorArray((state)? m_label_color : m_label_color_off,m_label_color_hover,m_label_color_array);
  }
void CCheckBox::forceCheckButtonState(const bool state)
  {
//--- Set the button state
   m_check.State(state);
  }
  
//+------------------------------------------------------------------+
//| Setting the state of the control                                 |
//+------------------------------------------------------------------+
void CCheckBox::CheckBoxState(const bool state)
  {
//--- Control state
   m_checkbox_state=state;
//--- Icon
   m_check.BmpFileOn((state)? "::"+m_check_bmp_file_on : "::"+m_check_bmp_file_on_locked);
   m_check.BmpFileOff((state)? "::"+m_check_bmp_file_off : "::"+m_check_bmp_file_off_locked);
//--- Color of the text label
   m_label.Color((state)? m_label_color : m_label_color_locked);
  }
//+------------------------------------------------------------------+
//| Clicking on the element header                                   |
//+------------------------------------------------------------------+
bool CCheckBox::OnClickLabel(const string clicked_object)
  {
//--- Leave, if the object name is different
   if(m_area.Name()!=clicked_object)
      return(false);
//--- Leave, if the element is blocked
   if(!m_checkbox_state)
      return(false);
//--- Switch to the opposite state
   CheckButtonState(!m_check.State());
//--- The mouse cursor is currently over the element
   m_label.Color(m_label_color_hover);
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CLICK_LABEL,CElement::Id(),0,m_label.Description());
   return(true);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Save                                                             |
//+------------------------------------------------------------------+
void CCheckBox::Save(int handle)
 {
   CElement::WriteInteger(handle , (int)(m_checkbox_state));       //Checkbox state (available/blocked)
   CElement::WriteInteger(handle , (int)(m_check_button_state));   //State of the checkbox button
   CElement::Save(handle);
 }
//+------------------------------------------------------------------+
//| Load                                                             |
//+------------------------------------------------------------------+
void CCheckBox::Load(int handle)
 {
   int var1 = CElement::ReadInteger(handle); //Checkbox state (available/blocked)
   int var2 = CElement::ReadInteger(handle); //State of the checkbox button   
   CElement::Load(handle);
   
   CheckBoxState(true);
   CheckButtonState(var2);
   CheckBoxState(var1);   
 } 
//+------------------------------------------------------------------+
//| Lock                                                             |
//+------------------------------------------------------------------+
void CCheckBox::Lock()
 {
   CheckButtonState(false);
   CheckBoxState(false);
 }
//+------------------------------------------------------------------+
//| UnLock                                                           |
//+------------------------------------------------------------------+
void CCheckBox::UnLock()
 {
   if(!CheckBoxState()) CheckBoxState(true);
 }
//+-----------------------------------------------------------------+
void CCheckBox::fLock()
 {
   m_foriginState = CheckBoxState();
   CheckBoxState(false);
 }
void CCheckBox::fUnLock()
 {
   CheckBoxState(m_foriginState);
 }