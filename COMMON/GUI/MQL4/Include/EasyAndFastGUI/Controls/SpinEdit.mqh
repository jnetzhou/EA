//+------------------------------------------------------------------+
//|                                                     SpinEdit.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Element.mqh"
#include "Window.mqh"
//+------------------------------------------------------------------+
//| Class for creating the edit                                      |
//+------------------------------------------------------------------+
class CSpinEdit : public CElement
  {
public:
   //--- Pointer to the form to which the element is attached
   CWindow          *m_wnd;
   //--- Objects for creating the edit
   CRectLabel        m_area;
   CLabel            m_label;
   CEdit             m_edit;
   CBmpLabel         m_spin_inc;
   CBmpLabel         m_spin_dec;
   //--- Color of the control background
   color             m_area_color;
   //--- Text of the description of the edit
   string            m_label_text;
   //--- Text label margins
   int               m_label_x_gap;
   int               m_label_y_gap;
   //--- Color of the text in different states
   color             m_label_color;
   color             m_label_color_hover;
   color             m_label_color_locked;
   color             m_label_color_array[];
   //--- Current value of the edit
   double            m_edit_value;
   //--- Size of the edit
   int               m_edit_x_size;
   int               m_edit_y_size;
   //--- Margin of edit from the right side
   int               m_edit_x_gap;
   //--- Colors of the edit and text of the edit in different states
   color             m_edit_color;
   color             m_edit_color_locked;
   color             m_edit_text_color;
   color             m_edit_text_color_locked;
   color             m_edit_text_color_highlight;
   //--- Colors of the edit frame in different states
   color             m_edit_border_color;
   color             m_edit_border_color_hover;
   color             m_edit_border_color_locked;
   color             m_edit_border_color_array[];
   //--- Labels of switches in the active and blocked states
   string            m_inc_bmp_file_on;
   string            m_inc_bmp_file_off;
   string            m_inc_bmp_file_locked;
   string            m_dec_bmp_file_on;
   string            m_dec_bmp_file_off;
   string            m_dec_bmp_file_locked;
   //--- Button margins (from the right side)
   int               m_inc_x_gap;
   int               m_inc_y_gap;
   int               m_dec_x_gap;
   int               m_dec_y_gap;
   //--- Priorities of the left mouse button press
   int               m_area_zorder;
   int               m_label_zorder;
   int               m_edit_zorder;
   int               m_spin_zorder;
   //--- Checkbox state (available/blocked)
   bool              m_spin_edit_state;
   //--- The mode of reseting the value to the minimum
   bool              m_reset_mode;
   //--- Minimum/maximum value
   double            m_min_value;
   double            m_max_value;
   //--- Step for changing the value in edit
   double            m_step_value;
   //--- Mode of text alignment
   ENUM_ALIGN_MODE   m_align_mode;
   //--- Timer counter for fast forwarding the list view
   int               m_timer_counter;
   //--- Number of decimal places
   int               m_digits;
   //---
public:
                     CSpinEdit(void);
                    ~CSpinEdit(void);
   //--- Methods for creating the edit
   bool              CreateSpinEdit(const long chart_id,const int subwin,const string label_text,const int x,const int y);
   //---
private:
   bool              CreateArea(void);
   bool              CreateLabel(void);
   bool              CreateEdit(void);
   bool              CreateSpinInc(void);
   bool              CreateSpinDec(void);
   //---
public:
   //--- (1) Stores the form pointer, (2) return/set the state of the edit
   void              WindowPointer(CWindow &object)                 { m_wnd=::GetPointer(object);         }
   bool              SpinEditState(void)                      const { return(m_spin_edit_state);          }
   void              SpinEditState(const bool state);
   //--- (1) Background color, (2) text of edit description, (3) margins of the text label
   void              AreaColor(const color clr)                     { m_area_color=clr;                   }
   string            LabelText(void)                          const { return(m_label.Description());      }
   void              LabelXGap(const int x_gap)                     { m_label_x_gap=x_gap;                }
   void              LabelYGap(const int y_gap)                     { m_label_y_gap=y_gap;                }
   //--- Colors of the text label in different states
   void              LabelColor(const color clr)                    { m_label_color=clr;                  }
   void              LabelColorHover(const color clr)               { m_label_color_hover=clr;            }
   void              LabelColorLocked(const color clr)              { m_label_color_locked=clr;           }
   //--- (1) Edit size, (2) margin for edit from the right side
   void              EditXSize(const int x_size)                    { m_edit_x_size=x_size;               }
   void              EditYSize(const int y_size)                    { m_edit_y_size=y_size;               }
   void              EditXGap(const int x_gap)                      { m_edit_x_gap=x_gap;                 }
   //--- Colors of edit in different states
   void              EditColor(const color clr)                     { m_edit_color=clr;                   }
   void              EditColorLocked(const color clr)               { m_edit_color_locked=clr;            }
   //--- Colors of the edit text in different states
   void              EditTextColor(const color clr)                 { m_edit_text_color=clr;              }
   void              EditTextColorLocked(const color clr)           { m_edit_text_color_locked=clr;       }
   void              EditTextColorHighlight(const color clr)        { m_edit_text_color_highlight=clr;    }
   //--- Colors of the edit frame in different states
   void              EditBorderColor(const color clr)               { m_edit_border_color=clr;            }
   void              EditBorderColorHover(const color clr)          { m_edit_border_color_hover=clr;      }
   void              EditBorderColorLocked(const color clr)         { m_edit_border_color_locked=clr;     }
   //--- Setting labels for the button in the active and blocked states
   void              IncFileOn(const string file_path)              { m_inc_bmp_file_on=file_path;        }
   void              IncFileOff(const string file_path)             { m_inc_bmp_file_off=file_path;       }
   void              IncFileLocked(const string file_path)          { m_inc_bmp_file_locked=file_path;    }
   void              DecFileOn(const string file_path)              { m_dec_bmp_file_on=file_path;        }
   void              DecFileOff(const string file_path)             { m_dec_bmp_file_off=file_path;       }
   void              DecFileLocked(const string file_path)          { m_dec_bmp_file_locked=file_path;    }
   //--- Margins for edit buttons
   void              IncXGap(const int x_gap)                       { m_inc_x_gap=x_gap;                  }
   void              IncYGap(const int y_gap)                       { m_inc_y_gap=y_gap;                  }
   void              DecXGap(const int x_gap)                       { m_dec_x_gap=x_gap;                  }
   void              DecYGap(const int y_gap)                       { m_dec_y_gap=y_gap;                  }
   //--- States of the edit control buttons
   bool              StateInc(void)                           const { return(m_spin_inc.State());         }
   bool              StateDec(void)                           const { return(m_spin_dec.State());         }
   //--- Reset mode when press on the text label takes place
   bool              ResetMode(void)                                { return(m_reset_mode);               }
   void              ResetMode(const bool mode)                     { m_reset_mode=mode;                  }
   //--- Minimum value
   double            MinValue(void)                           const { return(m_min_value);                }
   void              MinValue(const double value)                   { m_min_value=value;                  }
   //--- Maximum value
   double            MaxValue(void)                           const { return(m_max_value);                }
   void              MaxValue(const double value)                   { m_max_value=value;                  }
   //--- The step of the value
   double            StepValue(void)                          const { return(m_step_value);               }
   void              StepValue(const double value)                  { m_step_value=(value<=0)? 1 : value; }
   //--- (1) The number of decimal places, (2) mode of text alignment, (3) return and set the edit value
   void              SetDigits(const int digits)                    { m_digits=::fabs(digits);            }
   void              AlignMode(ENUM_ALIGN_MODE mode)                { m_align_mode=mode;                  }
   double            GetValue(void)                           const { return(m_edit_value);               }
   bool              SetValue(const double value);
   //--- Changing the value in the edit
   void              ChangeValue(const double value);
   //--- Changing the object colors
   void              ChangeObjectsColor(void);
   //--- Flashing when the limit is reached
   void              HighlightLimit(void);
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
   //--- Handling the press on the text label
   bool              OnClickLabel(const string clicked_object);
   //--- Handling the value entering in the edit
   bool              OnEndEdit(const string edited_object);
   //--- Handling the edit button press
   bool              OnClickSpinInc(const string clicked_object);
   bool              OnClickSpinDec(const string clicked_object);
   //--- Fast scrolling of values in the edit
   void              FastSwitching(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSpinEdit::CSpinEdit(void) : m_digits(2),
                             m_edit_value(WRONG_VALUE),
                             m_min_value(DBL_MIN),
                             m_max_value(DBL_MAX),
                             m_step_value(1),
                             m_reset_mode(false),
                             m_align_mode(ALIGN_LEFT),
                             m_spin_edit_state(true),
                             m_timer_counter(SPIN_DELAY_MSC),
                             m_area_color(clrNONE),
                             m_label_x_gap(0),
                             m_label_y_gap(2),
                             m_label_color(clrBlack),
                             m_label_color_hover(C'85,170,255'),
                             m_label_color_locked(clrSilver),
                             m_edit_y_size(18),
                             m_edit_x_gap(15),
                             m_edit_color(clrWhite),
                             m_edit_color_locked(clrWhiteSmoke),
                             m_edit_text_color(clrBlack),
                             m_edit_text_color_locked(clrSilver),
                             m_edit_text_color_highlight(clrRed),
                             m_edit_border_color(clrSilver),
                             m_edit_border_color_hover(C'85,170,255'),
                             m_edit_border_color_locked(clrSilver),
                             m_inc_x_gap(16),
                             m_inc_y_gap(0),
                             m_dec_x_gap(16),
                             m_dec_y_gap(8),
                             m_inc_bmp_file_on(""),
                             m_inc_bmp_file_off(""),
                             m_inc_bmp_file_locked(""),
                             m_dec_bmp_file_on(""),
                             m_dec_bmp_file_off(""),
                             m_dec_bmp_file_locked("")

  {
//--- Store the name of the element class in the base class
   CElement::ClassName(CLASS_NAME);
//--- Set priorities of the left mouse button click
   m_area_zorder  =1;
   m_label_zorder =0;
   m_edit_zorder  =2;
   m_spin_zorder  =3;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSpinEdit::~CSpinEdit(void)
  {
  }
//+------------------------------------------------------------------+
//| Event handling                                                |
//+------------------------------------------------------------------+
void CSpinEdit::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
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
      //--- Checking the focus over elements
      CElement::MouseFocus(m_mouse.X()>X() && m_mouse.X()<X2() && m_mouse.Y()>Y() && m_mouse.Y()<Y2());
      m_spin_inc.MouseFocus(m_mouse.X()>m_spin_inc.X() && m_mouse.X()<m_spin_inc.X2() && m_mouse.Y()>m_spin_inc.Y() && m_mouse.Y()<m_spin_inc.Y2());
      m_spin_dec.MouseFocus(m_mouse.X()>m_spin_dec.X() && m_mouse.X()<m_spin_dec.X2() && m_mouse.Y()>m_spin_dec.Y() && m_mouse.Y()<m_spin_dec.Y2());
      return;
     }
//--- Handling the left mouse button click on the object
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      //--- Leave, if the element is blocked
      if(!m_spin_edit_state)
         return;
      //--- Handling the press on the text label
      if(OnClickLabel(sparam))
         return;
      //--- Handling the edit button press
      if(OnClickSpinInc(sparam))
         return;
      if(OnClickSpinDec(sparam))
         return;
      //---
      return;
     }
//--- Handling the value change in edit event
   if(id==CHARTEVENT_OBJECT_ENDEDIT)
     {
      //--- Leave, if the element is blocked
      if(!m_spin_edit_state)
         return;
      //--- Handling of the value entry
      if(OnEndEdit(sparam))
         return;
     }
  }
//+------------------------------------------------------------------+
//| Timer                                                            |
//+------------------------------------------------------------------+
void CSpinEdit::OnEventTimer(void)
  {
//--- If the element is a drop-down
   if(CElement::IsDropdown())
     {
      ChangeObjectsColor();
      FastSwitching();
     }
   else
     {
      //--- Track the change of color and the fast scrolling of values 
      //    only if the form is not blocked
      if(!m_wnd.IsLocked())
        {
         ChangeObjectsColor();
         FastSwitching();
        }
     }
  }
//+------------------------------------------------------------------+
//| Creates a group of editable edit control                         |
//+------------------------------------------------------------------+
bool CSpinEdit::CreateSpinEdit(const long chart_id,const int subwin,const string label_text,const int x,const int y)
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
   m_label_text =label_text;
   m_area_color =(m_area_color!=clrNONE)? m_area_color : m_wnd.WindowBgColor();
//--- Margins from the edge
   CElement::XGap(CElement::X()-m_wnd.X());
   CElement::YGap(CElement::Y()-m_wnd.Y());
//--- Creating an element
   if(!CreateArea())
      return(false);
   if(!CreateLabel())
      return(false);
   if(!CreateEdit())
      return(false);
   if(!CreateSpinInc())
      return(false);
   if(!CreateSpinDec())
      return(false);
//--- Hide the element if the window is a dialog one or is minimized
   if(m_wnd.WindowType()==W_DIALOG || m_wnd.IsMinimized())
      Hide();
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Create area of editable edit control                             |
//+------------------------------------------------------------------+
bool CSpinEdit::CreateArea(void)
  {
//--- Forming the object name
   string name="";
   if(m_index==WRONG_VALUE)
      name=CElement::ProgramName()+"_spinedit_area_"+(string)CElement::Id();
   else
      name=CElement::ProgramName()+"_spinedit_area_"+(string)CElement::Index()+"__"+(string)CElement::Id();
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
   m_area.XGap(m_x-m_wnd.X());
   m_area.YGap(m_y-m_wnd.Y());
//--- Store the object pointer
   CElement::AddToArray(m_area);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create label of editable edit control                            |
//+------------------------------------------------------------------+
bool CSpinEdit::CreateLabel(void)
  {
//--- Forming the object name
   string name="";
   if(m_index==WRONG_VALUE)
      name=CElement::ProgramName()+"_spinedit_lable_"+(string)CElement::Id();
   else
      name=CElement::ProgramName()+"_spinedit_lable_"+(string)CElement::Index()+"__"+(string)CElement::Id();
//--- Coordinates
   int x=CElement::X()+m_label_x_gap;
   int y=CElement::Y()+m_label_y_gap;
//--- Set the object
   if(!m_label.Create(m_chart_id,name,m_subwin,x,y))
      return(false);
//--- set properties
   m_label.Description(m_label_text);
   m_label.Font(FONT);
   m_label.FontSize(FONT_SIZE);
   m_label.Color(m_label_color);
   m_label.Corner(m_corner);
   m_label.Anchor(m_anchor);
   m_label.Selectable(false);
   m_label.Z_Order(m_label_zorder);
   m_label.Tooltip("\n");
//--- Margins from the edge
   m_label.XGap(x-m_wnd.X());
   m_label.YGap(y-m_wnd.Y());
//--- Initializing gradient array
   CElement::InitColorArray(m_label_color,m_label_color_hover,m_label_color_array);
//--- Store the object pointer
   CElement::AddToArray(m_label);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates edit control with spins                                  |
//+------------------------------------------------------------------+
bool CSpinEdit::CreateEdit(void)
  {
//--- Forming the object name
   string name="";
   if(m_index==WRONG_VALUE)
      name=CElement::ProgramName()+"_spinedit_edit_"+(string)CElement::Id();
   else
      name=CElement::ProgramName()+"_spinedit_edit_"+(string)CElement::Index()+"__"+(string)CElement::Id();
//--- Coordinates
   int x =CElement::X2()-m_edit_x_size-m_edit_x_gap;
   int y =CElement::Y()-1;
//--- Set the object
   if(!m_edit.Create(m_chart_id,name,m_subwin,x,y,m_edit_x_size,m_edit_y_size))
      return(false);
//--- set properties
   m_edit.Font(FONT);
   m_edit.FontSize(FONT_SIZE);
   m_edit.TextAlign(m_align_mode);
   m_edit.Description(::DoubleToString(m_edit_value,m_digits));
   m_edit.Color(m_edit_text_color);
   m_edit.BackColor(m_edit_color);
   m_edit.BorderColor(m_edit_border_color);
   m_edit.Corner(m_corner);
   m_edit.Anchor(m_anchor);
   m_edit.Selectable(false);
   m_edit.Z_Order(m_edit_zorder);
   m_edit.Tooltip("\n");
//--- Store coordinates
   m_edit.X(x);
   m_edit.Y(y);
//--- Margins from the edge
   m_edit.XGap(x-m_wnd.X());
   m_edit.YGap(y-m_wnd.Y());
//--- Initializing gradient array
   CElement::InitColorArray(m_edit_border_color,m_edit_border_color_hover,m_edit_border_color_array);
//--- Store the object pointer
   CElement::AddToArray(m_edit);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create spin increment                                            |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Controls\\SpinInc.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\SpinInc_blue.bmp"
//---
bool CSpinEdit::CreateSpinInc(void)
  {
//--- Forming the object name
   string name="";
   if(m_index==WRONG_VALUE)
      name=CElement::ProgramName()+"_spinedit_spin_inc_"+(string)CElement::Id();
   else
      name=CElement::ProgramName()+"_spinedit_spin_inc_"+(string)CElement::Index()+"__"+(string)CElement::Id();
//--- Coordinates
   int x =CElement::X2()-m_inc_x_gap;
   int y =CElement::Y()+m_inc_y_gap;
//--- If the icon for the spin is not specified, then set the default one
   if(m_inc_bmp_file_on=="")
      m_inc_bmp_file_on="Images\\EasyAndFastGUI\\Controls\\SpinInc_blue.bmp";
   if(m_inc_bmp_file_off=="")
      m_inc_bmp_file_off="Images\\EasyAndFastGUI\\Controls\\SpinInc.bmp";
   if(m_inc_bmp_file_locked=="")
      m_inc_bmp_file_locked="Images\\EasyAndFastGUI\\Controls\\SpinInc.bmp";
//--- Set the object
   if(!m_spin_inc.Create(m_chart_id,name,m_subwin,x,y))
      return(false);
//--- set properties
   m_spin_inc.BmpFileOn("::"+m_inc_bmp_file_on);
   m_spin_inc.BmpFileOff("::"+m_inc_bmp_file_off);
   m_spin_inc.Corner(m_corner);
   m_spin_inc.GetInteger(OBJPROP_ANCHOR,m_anchor);
   m_spin_inc.Selectable(false);
   m_spin_inc.Z_Order(m_spin_zorder);
   m_spin_inc.Tooltip("\n");
//--- Store the size (in the object)
   m_spin_inc.XSize(m_spin_inc.X_Size());
   m_spin_inc.YSize(m_spin_inc.Y_Size());
//--- Store coordinates
   m_spin_inc.X(x);
   m_spin_inc.Y(y);
//--- Margins from the edge
   m_spin_inc.XGap(x-m_wnd.X());
   m_spin_inc.YGap(y-m_wnd.Y());
//--- Store the object pointer
   CElement::AddToArray(m_spin_inc);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create spin decrement                                            |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Controls\\SpinDec.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\SpinDec_blue.bmp"
//---
bool CSpinEdit::CreateSpinDec(void)
  {
//--- Forming the object name
   string name="";
   if(m_index==WRONG_VALUE)
      name=CElement::ProgramName()+"_spinedit_spin_dec_"+(string)CElement::Id();
   else
      name=CElement::ProgramName()+"_spinedit_spin_dec_"+(string)CElement::Index()+"__"+(string)CElement::Id();
//--- Coordinates
   int x =CElement::X2()-m_dec_x_gap;
   int y =CElement::Y()+m_dec_y_gap;
//--- If the icon for the spin is not specified, then set the default one
   if(m_dec_bmp_file_on=="")
      m_dec_bmp_file_on="Images\\EasyAndFastGUI\\Controls\\SpinDec_blue.bmp";
   if(m_dec_bmp_file_off=="")
      m_dec_bmp_file_off="Images\\EasyAndFastGUI\\Controls\\SpinDec.bmp";
   if(m_dec_bmp_file_locked=="")
      m_dec_bmp_file_locked="Images\\EasyAndFastGUI\\Controls\\SpinDec.bmp";
//--- Set the object
   if(!m_spin_dec.Create(m_chart_id,name,m_subwin,x,y))
      return(false);
//--- set properties
   m_spin_dec.BmpFileOn("::"+m_dec_bmp_file_on);
   m_spin_dec.BmpFileOff("::"+m_dec_bmp_file_off);
   m_spin_dec.Corner(m_corner);
   m_spin_dec.GetInteger(OBJPROP_ANCHOR,m_anchor);
   m_spin_dec.Selectable(false);
   m_spin_dec.Z_Order(m_spin_zorder);
   m_spin_dec.Tooltip("\n");
//--- Store the size (in the object)
   m_spin_dec.XSize(m_spin_dec.X_Size());
   m_spin_dec.YSize(m_spin_dec.Y_Size());
//--- Store coordinates
   m_spin_dec.X(x);
   m_spin_dec.Y(y);
//--- Margins from the edge
   m_spin_dec.XGap(x-m_wnd.X());
   m_spin_dec.YGap(y-m_wnd.Y());
//--- Store the object pointer
   CElement::AddToArray(m_spin_dec);
   return(true);
  }
//+------------------------------------------------------------------+
//| Changing the value in the edit                                   |
//+------------------------------------------------------------------+
void CSpinEdit::ChangeValue(const double value)
  {
//--- Check, adjust and store the new value
   SetValue(value);
//--- Set the new value in the edit
   m_edit.Description(::DoubleToString(GetValue(),m_digits));
  }
//+------------------------------------------------------------------+
//| Check of the current value                                       |
//+------------------------------------------------------------------+
bool CSpinEdit::SetValue(double value)
  {
//--- For adjustment
   double corrected_value =0.0;
//--- Adjust considering the step
   corrected_value=::MathRound(value/m_step_value)*m_step_value;
//--- Check for the minimum/maximum
   if(corrected_value<m_min_value)
     {
      //--- Set the minimum value
      corrected_value=m_min_value;
      //--- Set the state to On
      m_spin_dec.State(true);
      //--- Flash to indicate that the limit has been reached
      HighlightLimit();
     }
   if(corrected_value>m_max_value)
     {
      //--- Set the maximum value
      corrected_value=m_max_value;
      //--- Set the state to On
      m_spin_inc.State(true);
      //--- Flash to indicate that the limit has been reached
      HighlightLimit();
     }
//--- If the value has been changed
   if(m_edit_value!=corrected_value)
     {
      m_edit_value=corrected_value;
      m_edit.Color(m_edit_text_color);
      return(true);
     }
//--- Value unchanged
   return(false);
  }
//+------------------------------------------------------------------+
//| Highlighting the limit                                           |
//+------------------------------------------------------------------+
void CSpinEdit::HighlightLimit(void)
  {
//--- Change the text color temporarily
   m_edit.Color(m_edit_text_color_highlight);
//--- Update
   ::ChartRedraw();
//--- Delay before returning to the initial color
   ::Sleep(100);
//--- Change the text color for the initial one
   m_edit.Color(m_edit_text_color);
  }
//+------------------------------------------------------------------+
//| Setting the state of the control                                 |
//+------------------------------------------------------------------+
void CSpinEdit::SpinEditState(const bool state)
  {
   m_spin_edit_state=state;
//--- Color of the text label
   m_label.Color((state)? m_label_color : m_label_color_locked);
//--- Color of the edit
   m_edit.Color((state)? m_edit_text_color : m_edit_text_color_locked);
   m_edit.BackColor((state)? m_edit_color : m_edit_color_locked);
   m_edit.BorderColor((state)? m_edit_border_color : m_edit_border_color_locked);
//--- Spin icons
   m_spin_inc.BmpFileOn((state)? "::"+m_inc_bmp_file_on : "::"+m_inc_bmp_file_locked);
   m_spin_dec.BmpFileOn((state)? "::"+m_dec_bmp_file_on : "::"+m_dec_bmp_file_locked);
//--- Setting in relation of the current state
   if(!m_spin_edit_state)
     {
      //--- Priorities
      m_edit.Z_Order(-1);
      m_spin_inc.Z_Order(-1);
      m_spin_dec.Z_Order(-1);
      //--- Edit in the read only mode
      m_edit.ReadOnly(true);
     }
   else
     {
      //--- Priorities
      m_edit.Z_Order(m_edit_zorder);
      m_spin_inc.Z_Order(m_spin_zorder);
      m_spin_dec.Z_Order(m_spin_zorder);
      //--- The edit control in the edit mode
      m_edit.ReadOnly(false);
     }
  }
//+------------------------------------------------------------------+
//| Changing the object color when the cursor is hovering over it    |
//+------------------------------------------------------------------+
void CSpinEdit::ChangeObjectsColor(void)
  {
//--- Leave, if the element is blocked
   if(!m_spin_edit_state)
      return;
//--- Focus on the buttons
   m_spin_inc.State(m_spin_inc.MouseFocus());
   m_spin_dec.State(m_spin_dec.MouseFocus());
//--- Focus on the text label and edit
   CElement::ChangeObjectColor(m_label.Name(),CElement::MouseFocus(),OBJPROP_COLOR,m_label_color,m_label_color_hover,m_label_color_array);
   CElement::ChangeObjectColor(m_edit.Name(),CElement::MouseFocus(),OBJPROP_BORDER_COLOR,m_edit_border_color,m_edit_border_color_hover,m_edit_border_color_array);
  }
//+------------------------------------------------------------------+
//| Moving elements                                                  |
//+------------------------------------------------------------------+
void CSpinEdit::Moving(const int x,const int y)
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
   m_label.X(x+m_label.XGap());
   m_label.Y(y+m_label.YGap());
   m_edit.X(x+m_edit.XGap());
   m_edit.Y(y+m_edit.YGap());
   m_spin_inc.X(x+m_spin_inc.XGap());
   m_spin_inc.Y(y+m_spin_inc.YGap());
   m_spin_dec.X(x+m_spin_dec.XGap());
   m_spin_dec.Y(y+m_spin_dec.YGap());
//--- Updating coordinates of graphical objects
   m_area.X_Distance(m_area.X());
   m_area.Y_Distance(m_area.Y());
   m_label.X_Distance(m_label.X());
   m_label.Y_Distance(m_label.Y());
   m_edit.X_Distance(m_edit.X());
   m_edit.Y_Distance(m_edit.Y());
   m_spin_inc.X_Distance(m_spin_inc.X());
   m_spin_inc.Y_Distance(m_spin_inc.Y());
   m_spin_dec.X_Distance(m_spin_dec.X());
   m_spin_dec.Y_Distance(m_spin_dec.Y());
  }
//+------------------------------------------------------------------+
//| Shows combobox                                                   |
//+------------------------------------------------------------------+
void CSpinEdit::Show(void)
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
void CSpinEdit::Hide(void)
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
void CSpinEdit::Reset(void)
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
void CSpinEdit::Delete(void)
  {
//--- Removing objects
   m_area.Delete();
   m_label.Delete();
   m_edit.Delete();
   m_spin_inc.Delete();
   m_spin_dec.Delete();
//--- Emptying the array of the objects
   CElement::FreeObjectsArray();
//--- Initializing of variables by default values
   CElement::MouseFocus(false);
   CElement::IsVisible(true);
  }
//+------------------------------------------------------------------+
//| Seth the priorities                                              |
//+------------------------------------------------------------------+
void CSpinEdit::SetZorders(void)
  {
//--- Leave, if the element is blocked
   if(!m_spin_edit_state)
      return;
//--- Set the priorities
   m_area.Z_Order(m_area_zorder);
   m_label.Z_Order(m_label_zorder);
   m_edit.Z_Order(m_edit_zorder);
   m_spin_inc.Z_Order(m_spin_zorder);
   m_spin_dec.Z_Order(m_spin_zorder);
//--- The edit control in the edit mode
   m_edit.ReadOnly(false);
//--- Restore the icons in spins
   m_spin_inc.BmpFileOn("::"+m_inc_bmp_file_on);
   m_spin_dec.BmpFileOn("::"+m_dec_bmp_file_on);
  }
//+------------------------------------------------------------------+
//| Reset the priorities                                             |
//+------------------------------------------------------------------+
void CSpinEdit::ResetZorders(void)
  {
//--- Leave, if the element is blocked
   if(!m_spin_edit_state)
      return;
//--- Reset the priorities
   m_area.Z_Order(-1);
   m_label.Z_Order(-1);
   m_edit.Z_Order(-1);
   m_spin_inc.Z_Order(-1);
   m_spin_dec.Z_Order(-1);
//--- Edit in the read only mode
   m_edit.ReadOnly(true);
//--- Replace the icons in spins
   m_spin_inc.BmpFileOn("::"+m_inc_bmp_file_off);
   m_spin_dec.BmpFileOn("::"+m_dec_bmp_file_off);
  }
//+------------------------------------------------------------------+
//| Reset the color of the element objects                           |
//+------------------------------------------------------------------+
void CSpinEdit::ResetColors(void)
  {
//--- Leave, if the element is blocked
   if(!m_spin_edit_state)
      return;
//--- Reset the color
   m_label.Color(m_label_color);
   m_edit.BorderColor(m_edit_border_color);
//--- Zero the focus
   CElement::MouseFocus(false);
  }
//+------------------------------------------------------------------+
//| Handling the press on the text label                             |
//+------------------------------------------------------------------+
bool CSpinEdit::OnClickLabel(const string clicked_object)
  {
//--- Leave, if the object name is different
   if(m_area.Name()!=clicked_object)
      return(false);
//--- If the mode of resetting the value is enabled
   if(m_reset_mode)
     {
      //--- Set the minimum value
      ChangeValue(MinValue());
     }
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CLICK_LABEL,CElement::Id(),CElement::Index(),m_label.Description());
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the value entering in the edit                          |
//+------------------------------------------------------------------+
bool CSpinEdit::OnEndEdit(const string edited_object)
  {
//--- Leave, if the object name is different
   if(m_edit.Name()!=edited_object)
      return(false);
//--- Get the entered value
   double entered_value=::StringToDouble(m_edit.Description());
//--- Check, adjust and store the new value
   ChangeValue(entered_value);
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_END_EDIT,CElement::Id(),CElement::Index(),m_label.Description());
   return(true);
  }
//+------------------------------------------------------------------+
//| Pressing on the increment spin                                   |
//+------------------------------------------------------------------+
bool CSpinEdit::OnClickSpinInc(const string clicked_object)
  {
//--- Leave, if the object name is different
   if(m_spin_inc.Name()!=clicked_object)
      return(false);
//--- Get the current value
   double value=GetValue();
//--- Increase by one step and check for exceeding the limit
   ChangeValue(value+m_step_value);
//--- Set the state to On
   m_spin_inc.State(true);
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CLICK_INC,CElement::Id(),CElement::Index(),m_label.Description());
   return(true);
  }
//+------------------------------------------------------------------+
//| Pressing on the decrement spin                                   |
//+------------------------------------------------------------------+
bool CSpinEdit::OnClickSpinDec(const string clicked_object)
  {
//--- Leave, if the object name is different
   if(m_spin_dec.Name()!=clicked_object)
      return(false);
//--- Get the current value
   double value=GetValue();
//--- Decrease by one step and check for exceeding the limit
   ChangeValue(value-m_step_value);
//--- Set the state to On
   m_spin_dec.State(true);
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CLICK_DEC,CElement::Id(),CElement::Index(),m_label.Description());
   return(true);
  }
//+------------------------------------------------------------------+
//| Fast scrolling of values in the edit                             |
//+------------------------------------------------------------------+
void CSpinEdit::FastSwitching(void)
  {
//--- Leave, if the focus is not on the control
   if(!CElement::MouseFocus())
      return;
//--- Return the counter to the initial value if the mouse button is released
   if(!m_mouse.LeftButtonState())
      m_timer_counter=SPIN_DELAY_MSC;
//--- If the mouse button is pressed down
   else
     {
      //--- Increase the counter by the set step
      m_timer_counter+=TIMER_STEP_MSC;
      //--- Leave, if less than zero
      if(m_timer_counter<0)
         return;
      //--- Get the current value in the edit
      double current_value =::StringToDouble(m_edit.Description());
      //--- If increase 
      if(m_spin_inc.State())
         SetValue(current_value+m_step_value);
      //--- If decrease
      else if(m_spin_dec.State())
         SetValue(current_value-m_step_value);
      //--- Change the value if the switching button is still pressed down
      if(m_spin_inc.State() || m_spin_dec.State())
         m_edit.Description(::DoubleToString(GetValue(),m_digits));
     }
  }

//+------------------------------------------------------------------+
//| Save                                                             |
//+------------------------------------------------------------------+
void CSpinEdit::Save(int handle)
 {
   CElement::WriteInteger(handle , (int)(m_spin_edit_state));
   CElement::WriteDouble(handle , m_edit_value);    
   CElement::Save(handle); 
 }
//+------------------------------------------------------------------+
//| Load                                                             |
//+------------------------------------------------------------------+
void CSpinEdit::Load(int handle)
 {
    int       var1 = CElement::ReadInteger(handle);
    double    var2 = CElement::ReadDouble(handle);
    CElement::Load(handle);
    
    SpinEditState(true);
    SetValue(var2);
    m_edit.Description(::DoubleToString(GetValue(),m_digits));
    SpinEditState(var1);
 }
//+------------------------------------------------------------------+
//| Lock                                                             |
//+------------------------------------------------------------------+
void CSpinEdit::Lock()
 {
   SpinEditState(false);
 } 
//+------------------------------------------------------------------+
//| UnLock                                                           |
//+------------------------------------------------------------------+
void CSpinEdit::UnLock()
 {
   if(!SpinEditState()) SpinEditState(true);
 }
//+-----------------------------------------------------------------+

void CSpinEdit::fLock()
 {
   m_foriginState = SpinEditState();
   SpinEditState(false);
 }
void CSpinEdit::fUnLock()
 {
   SpinEditState(m_foriginState);
 }
