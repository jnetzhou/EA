#include <EasyAndFastGUI\Controls\WndEvents.mqh>
class CProgram : public CWndEvents
  {
public:
   CWindow           window[3];
   CSpinEdit         spinedit[5];  
   CLineEdit         edit[5];
   CSimpleButton     sbutton[5];
   CTextLabel        label[5];
   CCheckBox         checkbox[5];
   CCheckBoxEdit     checkboxedit[3];
   CCheckComboBox    checkcombobox[3];
   CComboBox         combobox[3];
   CSeparateLine     sepLine[3];
   CSlider           slider[3];
   CDualSlider       dualslider[3];
   CMenuBar          menubar[2];
   CContextMenu      contextMenu[10];
   CMenuItem         menuItem[3];
   CTable            table[3];
   CTabs             tab;
   string            SaveFileName;
public:
                     CProgram(void);
                    ~CProgram(void);
   void              OnInitEvent(void);
   void              OnDeinitEvent(const int reason);
   void              OnTimerEvent(void);
protected:
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
public:
   bool              CreateExpertPanel(void);
   bool              CreateMainWindow(CWindow &m_window,int windows,string caption_text,int xa=10,int ya=10);
   bool              CreateSubWindow1(CWindow &m_window,int windows,string caption_text,int xa=10,int ya=10);
   bool              CreateSubWindow2(CWindow &m_window,int windows,string caption_text,int xa=10,int ya=10);
   bool              CreateMenuBar(CWindow &m_window,int windows,CMenuBar &menubar,const int xzhou,const int yzhou,string &items_text[],int &items_width[],int tabindex=-1);
   bool              CreateMBContextMenu(CWindow &m_window,int windows,CContextMenu &contextMenu,CMenuBar &menubar,int menubarIndex,ENUM_FIX_CONTEXT_MENU right0bottom1 ,string &items_text[],int items_width,int tabindex=-1);
   bool              CreateSimpleButton(CWindow &m_window,int windows,CSimpleButton &simple_button,string button_text,int xzhou,int yzhou,int kuan=55,color textcolor=clrBlack,color backcolor=clrMintCream,bool TwoState=false,int tabindex=-1);
   bool              CreateSpinEdit(CWindow &m_window,int windows,CSpinEdit &m_spin_edit,string text,int xzhou,int yzhou, int kuan=110,double value=200,double stepvalue=1,int digs=0,int shurukuan=40,int tabindex=-1);
   bool              CreateTextLabel(CWindow &m_window,int windows,CTextLabel &m_text_label,int xzhou,int yzhou,const string label_text,int daxiao,color yanse,int tabindex=-1);
   bool              CreateSlider(CWindow &m_window,int windows,CSlider & m_slider,const int xzhou,const int yzhou,string text , int textLength , int editLength ,double maxvalue,double minvalue,double stepvalue,int digits, int tabindex=-1);
   bool              CreateDualSlider(CWindow &m_window,int windows,CDualSlider & m_dual_slider,const int xzhou,const int yzhou,string text , int textLength , int editLength ,double maxvalue,double minvalue,double stepvalue,int digits, int tabindex=-1);
   bool              CreateCheckBox(CWindow &m_window,int windows,CCheckBox &m_checkbox,int xzhou,int yzhou,const string text,color yanse,int kuan,int tabindex=-1);
   bool              CreateCheckBoxEdit(CWindow &m_window,int windows,CCheckBoxEdit & checkBoxEdit,const int xzhou,const int yzhou,string text , int textLength , int editLength ,double maxValue , double minValue , double stepValue , int digits , double intialVar,int tabindex=-1);
   bool              CreateCheckComboBox(CWindow &m_window,int windows,CCheckComboBox &checkcombobox,const int xzhou,const int yzhou,string text , int textLength , int editLength ,string &items_text[],int tabindex=-1);
   bool              CreateComboBox(CWindow &m_window,int windows,CComboBox &m_combobox,const int xzhou,const int yzhou,const string text,int textLength,int editLength,string &items_text[],int tabindex=-1);
   bool              CreateEdit(CWindow &m_window,int windows,CLineEdit &m_edit,int xzhou,int yzhou,const string text,int kuan=100,int gao=20,int tabindex=-1);
   bool              CreateSepLine(CWindow &m_window,int windows,CSeparateLine & sepLine , const int xzhou,const int yzhou,int length ,int width , ENUM_TYPE_SEP_LINE lineMode = V_SEP_LINE,color linecolor=clrSandyBrown,int tabindex=-1);
   bool              CreateTable(CWindow &m_window,int windows,CTable &m_table,string &value[][],int xzhou,int yzhou,int kuan,int tabindex=-1);
   bool              CreateTabs(CWindow &m_window,int windows,CTabs &m_tabs,int xzhou,int yzhou,const string &tabs_text[],int &tabs_width[]);
   void              helpclick();
   void              checkboxclick(const long &lparam,const double &dparam,const string &sparam);
   void              buttonclick(const long &lparam,const double &dparam,const string &sparam);
   void              comboboxitemclick(const long &lparam,const double &dparam,const string &sparam);
   void              mousemove(const long &lparam,const double &dparam,const string &sparam);
   void              onendedit(const long &lparam,const double &dparam,const string &sparam);
   void              menuitemclick(const long &lparam,const double &dparam,const string &sparam);
   void              Save();
   void              Load();
};
CProgram::CProgram(void)
  {
    SaveFileName="GUItestEA";
  }
CProgram::~CProgram(void)
  {
  }
bool CProgram::CreateExpertPanel(void)
  {
     CreateMainWindow(window[0],0,"软件标题及版本");
     m_chart.Redraw();
     // Load();//一定要程序写好后再用
   return(true);
  }
bool CProgram::CreateMainWindow(CWindow &m_window,int windows,string caption_text,int xa=10,int ya=10)
//windows是窗口序号，0表示主窗口
  {
   CWndContainer::AddWindow(m_window);//在总容器中添加m_window窗口
   int xb=(m_window.X()>0) ? m_window.X() : xa;
   int yb=(m_window.Y()>0) ? m_window.Y() : ya;
   m_window.Movable(true);
   m_window.XSize(490);
   m_window.YSize(400);
   m_window.UseRollButton();
   m_window.UseTooltipsButton();
   m_window.RollUpSubwindowMode(true,true);
   if(windows==0) m_window.WindowType(W_MAIN);
   else m_window.WindowType(W_DIALOG);
   if(!m_window.CreateWindow(m_chart_id,m_subwin,caption_text,xb,yb)) return(false);
   int x=10,y=25;
   return(true);
  }
bool CProgram::CreateSubWindow1(CWindow &m_window,int windows,string caption_text,int xa=10,int ya=10)
//windows是窗口序号，0表示主窗口
  {
   CWndContainer::AddWindow(m_window);//在总容器中添加m_window窗口
   int xb=(m_window.X()>0) ? m_window.X() : xa;
   int yb=(m_window.Y()>0) ? m_window.Y() : ya;
   m_window.Movable(true);
   m_window.XSize(285);
   m_window.YSize(380);
   m_window.UseRollButton();
   if(windows==0) m_window.WindowType(W_MAIN);
   else m_window.WindowType(W_DIALOG);
   if(!m_window.CreateWindow(m_chart_id,m_subwin,caption_text,xb,yb)) return(false);
   int x=10,y=10;

   return(true);
  }
bool CProgram::CreateSubWindow2(CWindow &m_window,int windows,string caption_text,int xa=10,int ya=10)
//windows是窗口序号，0表示主窗口
  {
   CWndContainer::AddWindow(m_window);//在总容器中添加m_window窗口
   int xb=(m_window.X()>0) ? m_window.X() : xa;
   int yb=(m_window.Y()>0) ? m_window.Y() : ya;
   m_window.Movable(true);
   m_window.XSize(285);
   m_window.YSize(380);
   m_window.UseRollButton();
   if(windows==0) m_window.WindowType(W_MAIN);
   else m_window.WindowType(W_DIALOG);
   if(!m_window.CreateWindow(m_chart_id,m_subwin,caption_text,xb,yb)) return(false);
   int x=10,y=10;

   return(true);
  }
void CProgram::OnInitEvent(void)
  {
  }
void CProgram::OnDeinitEvent(const int reason)
  {
   //Save();
   CWndEvents::Destroy();    
  }
void CProgram::OnTimerEvent(void)
  {
   CWndEvents::OnTimerEvent();
  }
void CProgram::helpclick()
{
   if(IsDllsAllowed()==true)
    {
       ShellExecuteW( 0 , "open" ,"http://www.zhinengjiaoyi.com", NULL , NULL , 0 );
    }
   else
    {
      Alert("使用教程需要勾选允许dll");
    }
}
void CProgram::buttonclick(const long &lparam,const double &dparam,const string &sparam)
{
 /*
      if(lparam==sbutton[0].Id())//两种状态按钮，变色变文字
        {
           if(sbutton[0].IsPressed()==true)
            { 
              sbutton[0].Text("按下状态");
            }
           else
            {
              sbutton[0].Text("释放状态");
            }
        }
      if(sparam==sbutton[1].Text())//普通单击，不变色立即执行
        {
           
        }
    */
}
void CProgram::checkboxclick(const long &lparam,const double &dparam,const string &sparam)
{
  if(lparam==checkbox[0].Id())
  {
     if(checkbox[0].CheckButtonState()==false)
      {
         
      }
     else
      {
         
      }
  }
}
void CProgram::comboboxitemclick(const long &lparam,const double &dparam,const string &sparam)
{
    if(sparam==combobox[0].LabelText())
      {
         int sld=combobox[0].GetListViewPointer().SelectedItemIndex();//获取被点击的选项序号
         if(sld==0)//说明第一项被单击选中
          {
          
          }
      }
}
void CProgram::mousemove(const long &lparam,const double &dparam,const string &sparam)
{
   if(sbutton[0].MouseFocus())
     {
        //ObjectSetString(0,sbutton[0].m_button.Name(),OBJPROP_TOOLTIP,"白线开多单，红线开空单，黄线平多单，蓝线平空单");
     }
}
void CProgram::onendedit(const long &lparam,const double &dparam,const string &sparam)
{
   /*
     if(sparam==edit[0].LabelText())//edit[0]输入完成后的事件
      {
         datetime tedit0=StrToTime(edit[0].LabelText());
         if(tedit0<TimeLocal())
          {
            Alert("输入的时间格式有误或输入时间必须在将来");
            edit[0].LabelText(TimeToStr(TimeLocal()+10*60));
          }
      }
    */
}
void CProgram::menuitemclick(const long &lparam,const double &dparam,const string &sparam)
{
 /*
    if(sparam==contextMenu[0].ItemPointerByIndex(0).LabelText())
     {
       
     }
 */
}
void CProgram::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
    if(id==CHARTEVENT_CUSTOM+ON_WINDOW_CLICK_TOOLTIPS)//问号帮助事件
     {
       helpclick();
     }
    if(id==CHARTEVENT_CUSTOM+ON_CLICK_LABEL)//checkbox事件
     {
       checkboxclick(lparam,dparam,sparam);
     }
    if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)//button单击事件
     {
       buttonclick(lparam,dparam,sparam);
     }
    if(id==CHARTEVENT_CUSTOM+ON_CLICK_COMBOBOX_ITEM)//组合框中某项被单击
     {
       comboboxitemclick(lparam,dparam,sparam);
     }
    if(id==CHARTEVENT_MOUSE_MOVE)//鼠标悬停在某控件上后触发的事件
     {
       mousemove(lparam,dparam,sparam);
     }
    if(id==CHARTEVENT_CUSTOM+ON_END_EDIT)//编辑框输入确定事件
     {
       onendedit(lparam,dparam,sparam);
     }
    if(id==CHARTEVENT_CUSTOM+ON_CLICK_CONTEXTMENU_ITEM)//menu项单击事件
     {
       menuitemclick(lparam,dparam,sparam);
     } 
  }
bool CProgram::CreateSimpleButton(CWindow &m_window,int windows,CSimpleButton &simple_button,string button_text,int xzhou,int yzhou,int kuan=55,color textcolor=clrBlack,color backcolor=clrMintCream,bool TwoState=false,int tabindex=-1)
  {
      simple_button.WindowPointer(m_window);//把简单按钮控件1绑定到m_window窗口
      if(tabindex>=0) tab.AddToElementsArray(tabindex,simple_button);
      int x=m_window.X()+xzhou;
      int y=m_window.Y()+yzhou;
      simple_button.TwoState(TwoState);
      simple_button.ButtonXSize(kuan);
      simple_button.TextColor(textcolor);
      //simple_button.TextColorPressed(Blue);
      simple_button.BackColor(backcolor);
      simple_button.BackColorHover(C'255,180,180');
      simple_button.BackColorPressed(C'255,120,120');
      simple_button.BorderColor(clrSalmon);
      simple_button.BorderColorOff(C'178,195,207');
      simple_button.CreateSimpleButton(m_chart_id,m_subwin,button_text,x,y);
      CWndContainer::AddToElementsArray(windows,simple_button);
      return(true);
  }
bool CProgram::CreateSpinEdit(CWindow &m_window,int windows,CSpinEdit &m_spin_edit,string text,int xzhou,int yzhou, int kuan=110,double value=200,double stepvalue=1,int digs=0,int shurukuan=40,int tabindex=-1)
  {
//--- Store the window pointer
   m_spin_edit.WindowPointer(m_window);
    if(tabindex>=0) tab.AddToElementsArray(tabindex,m_spin_edit);
//--- Coordinates
   int x=m_window.X()+xzhou;
   int y=m_window.Y()+yzhou;
//--- Value
   double v=(m_spin_edit.GetValue()==WRONG_VALUE) ? value : m_spin_edit.GetValue();
//--- Set properties before creation
   m_spin_edit.XSize(kuan);
   m_spin_edit.YSize(20);
   m_spin_edit.EditXSize(shurukuan);
   m_spin_edit.MaxValue(999999);
   m_spin_edit.MinValue(0);
   m_spin_edit.StepValue(stepvalue);
   m_spin_edit.SetDigits(digs);
   m_spin_edit.SetValue(v);
   m_spin_edit.ResetMode(true);
   m_spin_edit.LabelColor(Blue);
//--- Create control
   if(!m_spin_edit.CreateSpinEdit(m_chart_id,m_subwin,text,x,y)) return(false);
//--- The availability will depend on the current state of the first checkbox
   m_spin_edit.SpinEditState(true);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(windows,m_spin_edit);
   return(true);
  }
bool CProgram::CreateTextLabel(CWindow &m_window,int windows,CTextLabel &m_text_label, int x, int y,const string label_text,int daxiao,color yanse,int tabindex=-1)
  {
    //--- Store the window pointer
   m_text_label.WindowPointer(m_window);
   if(tabindex>=0) tab.AddToElementsArray(tabindex,m_text_label);
   //x=m_window.X()+x;
   //y=m_window.Y()+y;
   y=y-m_window.CaptionHeight();
//--- Creating a button
   if(!m_text_label.CreateTextLabel(m_chart_id,m_subwin,label_text,x,y))
      return(false);
//--- Set the properties after creating the control
   m_text_label.LabelFont("宋体");
   m_text_label.LabelFontSize(daxiao);
   m_text_label.LabelColor(yanse);
   CWndContainer::AddToElementsArray(windows,m_text_label);
   return(true);
  }
bool CProgram::CreateEdit(CWindow &m_window,int windows,CLineEdit &m_edit,int x,int y,const string text,int kuan=100,int gao=20,int tabindex=-1)
  {
//--- Pass the panel object
   m_edit.WindowPointer(m_window);
    if(tabindex>=0) tab.AddToElementsArray(tabindex,m_edit);
   //x=m_window.X()+x;
   //y=m_window.Y()+y;
   y=y-m_window.CaptionHeight();
   if(!m_edit.CreateLineEdit(m_chart_id,m_subwin,text,x,y,kuan,gao))
      return(false);
   m_edit.LabelFontSize(10);
   m_edit.LabelText(text);
   m_edit.LabelFont("宋体");
   m_edit.LabelColor(clrBlack);
   CWndContainer::AddToElementsArray(windows,m_edit);
   return(true);
  }
bool CProgram::CreateCheckBox(CWindow &m_window,int windows,CCheckBox &m_checkbox,const int xzhou,const int yzhou,const string text,color yanse,int kuan,int tabindex=-1)
  {
   m_checkbox.WindowPointer(m_window);
   if(tabindex>=0) tab.AddToElementsArray(tabindex,m_checkbox);
   int x=m_window.X()+xzhou;
   int y=m_window.Y()+yzhou;
   m_checkbox.XSize(kuan);
   m_checkbox.YSize(20);
   m_checkbox.CheckBoxState(true);
   m_checkbox.LabelColor(yanse);
   m_checkbox.LabelColorHover(yanse);
   m_checkbox.LabelColorOff(yanse);
   if(!m_checkbox.CreateCheckBox(m_chart_id,m_subwin,text,x,y))
      return(false);
   CWndContainer::AddToElementsArray(windows,m_checkbox);
   return(true);
  }
//分界线
bool CProgram::CreateSepLine(CWindow &m_window,int windows,CSeparateLine & sepLine , const int xzhou,const int yzhou,int length ,int width , ENUM_TYPE_SEP_LINE lineMode = V_SEP_LINE,color linecolor=clrSandyBrown,int tabindex=-1)
  {
//--- Store the window pointer
   sepLine.WindowPointer(m_window);
   if(tabindex>=0) tab.AddToElementsArray(tabindex,sepLine);
//--- Coordinates  
   int x=m_window.X()+yzhou;
   int y=m_window.Y()+yzhou;
   sepLine.TypeSepLine(lineMode);
   sepLine.LightColor(linecolor);
//--- Creating an element
   if(lineMode==0) width=1;
   if(lineMode==1) length=1;
   if(!sepLine.CreateSeparateLine(m_chart_id,m_subwin,0,x,y,length,width))
      return(false);
   CWndContainer::AddToElementsArray(windows,sepLine);
   return(true);
  }  
bool CProgram::CreateSlider(CWindow &m_window,int windows,CSlider & m_slider,const int xzhou,const int yzhou,string text , int textLength , int editLength ,
                            double maxvalue,double minvalue,double stepvalue,int digits, int tabindex=-1)
  {
   m_slider.WindowPointer(m_window);
   if(tabindex>=0) tab.AddToElementsArray(tabindex,m_slider);
   int x=m_window.X()+xzhou;
   int y=m_window.Y()+yzhou;
   double v=(m_slider.GetValue()==WRONG_VALUE) ?0.84615385 : m_slider.GetValue();
   m_slider.XSize(textLength+editLength);
   m_slider.YSize(40);
   m_slider.EditXSize(editLength);
   m_slider.MaxValue(maxvalue);
   m_slider.StepValue(stepvalue);
   m_slider.MinValue(minvalue);
   m_slider.SetDigits(digits);
   m_slider.SetValue(v);
   m_slider.AreaColor(clrWhiteSmoke);
   m_slider.LabelColor(clrBlack);
   m_slider.LabelColorLocked(clrSilver);
   m_slider.EditColorLocked(clrWhiteSmoke);
   m_slider.EditBorderColor(clrSilver);
   m_slider.EditBorderColorLocked(clrSilver);
   m_slider.EditTextColorLocked(clrSilver);
   m_slider.SlotLineDarkColor(clrSilver);
   m_slider.SlotLineLightColor(clrWhite);
   m_slider.SlotYSize(4);
   m_slider.ThumbColorLocked(clrLightGray);
   m_slider.ThumbColorPressed(clrSilver);
   m_slider.SlotIndicatorColor(C'85,170,255');
   m_slider.SlotIndicatorColorLocked(clrLightGray);
   if(!m_slider.CreateSlider(m_chart_id,m_subwin,text,x,y))
      return(false);
   CWndContainer::AddToElementsArray(windows,m_slider);
   return(true);
  }
bool CProgram::CreateDualSlider(CWindow &m_window,int windows,CDualSlider & m_dual_slider,const int xzhou,const int yzhou,string text , int textLength , int editLength ,
                            double maxvalue,double minvalue,double stepvalue,int digits, int tabindex=-1)
  {
   m_dual_slider.WindowPointer(m_window);
   if(tabindex>=0) tab.AddToElementsArray(tabindex,m_dual_slider);
   int x=m_window.X()+xzhou;
   int y=m_window.Y()+yzhou;
   double v1=(m_dual_slider.GetLeftValue()==WRONG_VALUE) ?0 : m_dual_slider.GetLeftValue();
   double v2=(m_dual_slider.GetRightValue()==WRONG_VALUE) ?500 : m_dual_slider.GetRightValue();
//--- 在创建之前设置属性
   m_dual_slider.XSize(textLength+editLength*2);
   m_dual_slider.YSize(40);
   m_dual_slider.EditXSize(editLength);
   m_dual_slider.MaxValue(maxvalue);
   m_dual_slider.StepValue(stepvalue);
   m_dual_slider.MinValue(minvalue);
   m_dual_slider.SetDigits(digits);
   m_dual_slider.SetLeftValue(v1);
   m_dual_slider.SetRightValue(v2);
   m_dual_slider.AreaColor(clrWhiteSmoke);
   m_dual_slider.LabelColor(clrBlack);
   m_dual_slider.LabelColorLocked(clrSilver);
   m_dual_slider.EditColorLocked(clrWhiteSmoke);
   m_dual_slider.EditBorderColor(clrSilver);
   m_dual_slider.EditBorderColorLocked(clrSilver);
   m_dual_slider.EditTextColorLocked(clrSilver);
   m_dual_slider.SlotLineDarkColor(clrSilver);
   m_dual_slider.SlotLineLightColor(clrWhite);
   m_dual_slider.SlotYSize(4);
   m_dual_slider.ThumbColorLocked(clrLightGray);
   m_dual_slider.ThumbColorPressed(clrSilver);
   m_dual_slider.SlotIndicatorColor(C'85,170,255');
   m_dual_slider.SlotIndicatorColorLocked(clrLightGray);
   if(!m_dual_slider.CreateSlider(m_chart_id,m_subwin,text,x,y))
      return(false);
   CWndContainer::AddToElementsArray(windows,m_dual_slider);
   return(true);
  }
//ComBox
bool CProgram::CreateCheckBoxEdit(CWindow &m_window,int windows,CCheckBoxEdit & checkBoxEdit,const int xzhou,const int yzhou,string text , int textLength , int editLength ,
                                  double maxValue , double minValue , double stepValue , int digits , double intialVar,int tabindex=-1)
  {
//--- Store the window pointer
   checkBoxEdit.WindowPointer(m_window);
   if(tabindex>=0) tab.AddToElementsArray(tabindex,checkBoxEdit);
//--- Coordinates
   int x=m_window.X()+xzhou;
   int y=m_window.Y()+yzhou;
//--- Value
   double v=(checkBoxEdit.GetValue()<0) ? intialVar: checkBoxEdit.GetValue();
//--- Set properties before creation
   checkBoxEdit.XSize(textLength+editLength);
   checkBoxEdit.YSize(18);
   checkBoxEdit.EditXSize(editLength);
   checkBoxEdit.MaxValue(maxValue);
   checkBoxEdit.MinValue(minValue);
   checkBoxEdit.StepValue(stepValue);
   checkBoxEdit.SetDigits(digits);
   checkBoxEdit.SetValue(v);
   //checkBoxEdit.AreaColor(clrWhite);
//--- Create control
   if(!checkBoxEdit.CreateCheckBoxEdit(m_chart_id,m_subwin,text,x,y))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(windows,checkBoxEdit);
   return(true);
  }
bool CProgram::CreateComboBox(CWindow &m_window,int windows,CComboBox &m_combobox,const int xzhou,const int yzhou,const string text,int textLength,int editLength,string &items_text[],int tabindex=-1)
  {
   m_combobox.WindowPointer(m_window);
    if(tabindex>=0) tab.AddToElementsArray(tabindex,m_combobox);
   int x=m_window.X()+xzhou;
   int y=m_window.Y()+yzhou;
   m_combobox.XSize(textLength+editLength);
   m_combobox.YSize(18);
   m_combobox.LabelText(text);
   m_combobox.ButtonXSize(editLength);
   m_combobox.ItemsTotal(ArraySize(items_text));
   m_combobox.VisibleItemsTotal(ArraySize(items_text));
   for(int i=0; i<ArraySize(items_text); i++)
    {
      m_combobox.ValueToList(i,items_text[i]);
    }
   CListView *lv=m_combobox.GetListViewPointer();
   lv.LightsHover(true);
   lv.SelectedItemByIndex(lv.SelectedItemIndex()==WRONG_VALUE ? 1 : lv.SelectedItemIndex());
   if(!m_combobox.CreateComboBox(m_chart_id,m_subwin,x,y))
      return(false);
   CWndContainer::AddToElementsArray(windows,m_combobox);
   return(true);
  }
bool CProgram::CreateCheckComboBox(CWindow &m_window,int windows,CCheckComboBox &checkcombobox,const int xzhou,const int yzhou,string text , int textLength , int editLength ,string &items_text[],int tabindex=-1)
  {
//--- Store the window pointer
   checkcombobox.WindowPointer(m_window);
   if(tabindex>=0) tab.AddToElementsArray(tabindex,checkcombobox);
//--- Coordinates
   int x=m_window.X()+xzhou;
   int y=m_window.Y()+yzhou;

   checkcombobox.XSize(textLength+editLength);
   checkcombobox.YSize(18);
   checkcombobox.LabelText(text);
   checkcombobox.ButtonXSize(editLength);
   checkcombobox.ItemsTotal(ArraySize(items_text));
   checkcombobox.VisibleItemsTotal(ArraySize(items_text));
   for(int i=0; i<ArraySize(items_text); i++)
    {
      checkcombobox.ValueToList(i,items_text[i]);
    }
   CListView *lv=checkcombobox.GetListViewPointer();
   lv.LightsHover(true);
   lv.SelectedItemByIndex(lv.SelectedItemIndex()==WRONG_VALUE ? 1 : lv.SelectedItemIndex());
//--- Create control
   if(!checkcombobox.CreateCheckComboBox(m_chart_id,m_subwin,text,x,y))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(windows,checkcombobox);
   return(true);
  }
bool CProgram::CreateMenuBar(CWindow &m_window,int windows,CMenuBar &menubar,const int xzhou,const int yzhou,string &items_text[],int &items_width[],int tabindex=-1)
  {
//--- Store the window pointer
   menubar.WindowPointer(m_window);
   if(tabindex>=0) tab.AddToElementsArray(tabindex,menubar);
//--- Coordinates
   int x=m_window.X()+xzhou;
   int y=m_window.Y()+yzhou;
   for(int i=0; i<ArraySize(items_text); i++)
     {
       menubar.AddItem(items_width[i],items_text[i]);
     }
   if(!menubar.CreateMenuBar(m_chart_id,m_subwin,x,y))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(windows,menubar);
   return(true);
  }
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\bar_chart.bmp"
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\bar_chart_colorless.bmp"
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\coins.bmp"
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\coins_colorless.bmp"
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\line_chart.bmp"
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\line_chart_colorless.bmp"
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\safe.bmp"
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\safe_colorless.bmp"
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\pie_chart.bmp"
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\pie_chart_colorless.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\CheckBoxOn_min_black.bmp"
bool CProgram::CreateMBContextMenu(CWindow &m_window,int windows,CContextMenu &contextMenu,CMenuBar &menubar,int menubarIndex,ENUM_FIX_CONTEXT_MENU right0bottom1 ,string &items_text[],int items_width,int tabindex=-1)
  {
    contextMenu.WindowPointer(m_window);
   if(tabindex>=0) tab.AddToElementsArray(tabindex,contextMenu);
   contextMenu.PrevNodePointer(menubar.ItemPointerByIndex(menubarIndex));
   menubar.AddContextMenuPointer(menubarIndex,contextMenu); 
   int items=ArraySize(items_text);
   /*
    string items_bmp_on[]=
     {
       "Images\\EasyAndFastGUI\\Icons\\bmp16\\coins.bmp",
       "Images\\EasyAndFastGUI\\Icons\\bmp16\\line_chart.bmp",
       ""
     };
//--- Label array for the blocked mode
   string items_bmp_off[]=
     {
      "Images\\EasyAndFastGUI\\Icons\\bmp16\\coins_colorless.bmp",
      "Images\\EasyAndFastGUI\\Icons\\bmp16\\line_chart_colorless.bmp",
      "Images\\EasyAndFastGUI\\Controls\\CheckBoxOn_min_black.bmp"
     };
   ENUM_TYPE_MENU_ITEM items_type[]=
     {
      MI_SIMPLE,
      MI_SIMPLE,
      MI_CHECKBOX
     };
     */
//--- Set up properties before creation
   contextMenu.FixSide(right0bottom1);
   contextMenu.XSize(items_width);
   contextMenu.AreaBackColor(C'240,240,240');
   contextMenu.AreaBorderColor(clrSilver);
   contextMenu.ItemBackColorHover(C'240,240,240');
   contextMenu.ItemBackColorHoverOff(clrLightGray);
   contextMenu.ItemBorderColor(C'240,240,240');
   contextMenu.LabelColor(clrBlack);
   contextMenu.LabelColorHover(clrWhite);
   contextMenu.SeparateLineDarkColor(C'160,160,160');
   contextMenu.SeparateLineLightColor(clrWhite);
//--- Add items to the context menu
   for(int i=0; i<ArraySize(items_text); i++)
     {
       //contextMenu.AddItem(items_text[i],items_bmp_on[i],items_bmp_off[i],items_type[i]);
       contextMenu.AddItem(items_text[i],"","Images\\EasyAndFastGUI\\Controls\\CheckBoxOn_min_black.bmp",MI_CHECKBOX);
     }
//--- Separation line after the second item
   //contextMenu.AddSeparateLine(1);
//--- Deactivate the second item
   //contextMenu.ItemPointerByIndex(1).ItemState(false);
//--- Create a context menu
   if(!contextMenu.CreateContextMenu(m_chart_id,m_subwin))
      return(false);
//--- Add the element pointer to the base
   CWndContainer::AddToElementsArray(windows,contextMenu);
   return(true);
  }
bool CProgram::CreateTable(CWindow &m_window,int windows,CTable &m_table,string &value[][],int xzhou,int yzhou,int kuan,int tabindex=-1)
  {
   int COLUMNS1_TOTAL=ArrayRange(value,1);
   int ROWS1_TOTAL=ArrayRange(value,0);
   m_table.WindowPointer(m_window);
    if(tabindex>=0) tab.AddToElementsArray(tabindex,m_table);
   int x=m_window.X()+xzhou;
   int y=m_window.Y()+yzhou;
   int visible_columns_total =COLUMNS1_TOTAL;
   int visible_rows_total    =0;
   if(ROWS1_TOTAL<=15) visible_rows_total=ROWS1_TOTAL;
   else visible_rows_total=15;
   m_table.XSize(kuan);
   m_table.RowYSize(25);
   m_table.FixFirstRow(true);
   m_table.FixFirstColumn(false);
   m_table.LightsHover(true);
   m_table.SelectableRow(true);
   m_table.TextAlign(ALIGN_LEFT);
   m_table.HeadersColor(C'255,244,213');
   m_table.HeadersTextColor(clrBlack);
   m_table.CellColorHover(clrGold);
   m_table.TableSize(COLUMNS1_TOTAL,ROWS1_TOTAL);
   m_table.VisibleTableSize(visible_columns_total,visible_rows_total);
   if(!m_table.CreateTable(m_chart_id,m_subwin,x,y))
      return(false);
   for(int i=0;i<ROWS1_TOTAL;i++)
     {
       for(int j=0;j<COLUMNS1_TOTAL;j++)
        {
           m_table.SetValue(j,i,value[i][j]);
        }
     }
   m_table.UpdateTable();
   CWndContainer::AddToElementsArray(windows,m_table);
   return(true);
  }
bool CProgram::CreateTabs(CWindow &m_window,int windows,CTabs &m_tabs,const int xzhou,const int yzhou,const string &tabs_text[],int &tabs_width[])
  {
    //--- Store the window pointer
   m_tabs.WindowPointer(m_window);
   int x=m_window.X()+xzhou;
   int y=m_window.Y()+yzhou;
   m_tabs.XSize(m_window.XSize());
   m_tabs.YSize(m_window.YSize()-50);
   m_tabs.TabYSize(20);
   m_tabs.PositionMode(TABS_TOP);
   m_tabs.AutoXResizeMode(true);
   m_tabs.AutoXResizeRightOffset(0);
   m_tabs.SelectedTab((m_tabs.SelectedTab()==WRONG_VALUE) ? 0 : m_tabs.SelectedTab());
   m_tabs.AreaColor(clrMintCream);
   m_tabs.TabBackColor(clrLightCyan);
   m_tabs.TabBackColorHover(clrSkyBlue);
   m_tabs.TabBackColorSelected(clrMintCream);
   m_tabs.TabBorderColor(clrGray);
   m_tabs.TabTextColor(clrMidnightBlue);
   m_tabs.TabTextColorSelected(clrBlue);
//--- 使用指定属性添加页面
   for(int i=0; i<ArraySize(tabs_text); i++)
      m_tabs.AddTab(tabs_text[i],tabs_width[i]);
//--- 创建控件
   if(!m_tabs.CreateTabs(m_chart_id,m_subwin,x,y))
      return(false);
   CWndContainer::AddToElementsArray(windows,m_tabs);
   return(true);
  }
void CProgram::Save()
 {
   string name = StringFormat("%s_%s_%d.dat",SaveFileName,Symbol());
   int h = FileOpen(name,FILE_WRITE|FILE_BIN|FILE_UNICODE);
   if(h == INVALID_HANDLE) 
   {
      Alert("打开文件失败!");
   }
   else 
   {
      for(int window_index=0;window_index<ArraySize(m_wnd);window_index++)
       {
          for(int i=0;i<ArraySize(m_wnd[window_index].m_elements);i++)
          {    
             m_wnd[window_index].m_elements[i].Save(h);
          }
       }
     Print("保存面板设置成功!");
   }
   FileClose(h);
 }
void CProgram::Load()
 {
   int h = -1;
   string name = StringFormat("%s_%s_%d.dat",SaveFileName,Symbol());
   h = FileOpen(name,FILE_READ|FILE_BIN|FILE_UNICODE);
   if(h != INVALID_HANDLE)
   {
      Print("加载成功!");
      for(int window_index=0;window_index<ArraySize(m_wnd);window_index++)
       {
          for(int i=0;i<ArraySize(m_wnd[window_index].m_elements);i++)
          {
             m_wnd[window_index].m_elements[i].Load(h);
          }
       }
   }
   else 
   {
      Print("加载失败!");
   }
   FileClose(h);
 }