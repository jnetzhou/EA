//+------------------------------------------------------------------+
//|                                                      Objects.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Enums.mqh"
#include "Defines.mqh"
#include "..\Canvas\Charts\LineChart.mqh"
#include <ChartObjects\ChartObjectsBmpControls.mqh>
#include <ChartObjects\ChartObjectsTxtControls.mqh>
//--- List of classes in file for quick navigation (Alt+G)
class CRectLabel;
class CRectCanvas;
class CEdit;
class CLabel;
class CBmpLabel;
class CButton;
class CLineChartObject;
//+------------------------------------------------------------------+
//| Class with additional properties for the Rectangle Label object  |
//+------------------------------------------------------------------+
class CRectLabel : public CChartObjectRectLabel
  {
protected:
   int               m_x;
   int               m_y;
   int               m_x2;
   int               m_y2;
   int               m_x_gap;
   int               m_y_gap;
   int               m_x_size;
   int               m_y_size;
   bool              m_mouse_focus;
   //---
public:
                     CRectLabel(void);
                    ~CRectLabel(void);
   //--- Coordinates
   int               X(void)                      { return(m_x);           }
   void              X(const int x)               { m_x=x;                 }
   int               Y(void)                      { return(m_y);           }
   void              Y(const int y)               { m_y=y;                 }
   int               X2(void)                     { return(m_x+m_x_size);  }
   int               Y2(void)                     { return(m_y+m_y_size);  }
   //--- Margins from the edge point (xy)
   int               XGap(void)                   { return(m_x_gap);       }
   void              XGap(const int x_gap)        { m_x_gap=x_gap;         }
   int               YGap(void)                   { return(m_y_gap);       }
   void              YGap(const int y_gap)        { m_y_gap=y_gap;         }
   //--- Size
   int               XSize(void)                  { return(m_x_size);      }
   void              XSize(const int x_size)      { m_x_size=x_size;       }
   int               YSize(void)                  { return(m_y_size);      }
   void              YSize(const int y_size)      { m_y_size=y_size;       }
   //--- Focus
   bool              MouseFocus(void)             { return(m_mouse_focus); }
   void              MouseFocus(const bool focus) { m_mouse_focus=focus;   }
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CRectLabel::CRectLabel(void) : m_x(0),
                               m_y(0),
                               m_x2(0),
                               m_y2(0),
                               m_x_gap(0),
                               m_y_gap(0),
                               m_x_size(0),
                               m_y_size(0),
                               m_mouse_focus(false)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CRectLabel::~CRectLabel(void)
  {
  }
//+------------------------------------------------------------------+
//| Class with additional properties for Rectangle Canvas object     |
//+------------------------------------------------------------------+
class CRectCanvas : public CCustomCanvas
  {
protected:
   int               m_x;
   int               m_y;
   int               m_x2;
   int               m_y2;
   int               m_x_gap;
   int               m_y_gap;
   int               m_x_size;
   int               m_y_size;
   bool              m_mouse_focus;
   //---
public:
                     CRectCanvas(void);
                    ~CRectCanvas(void);
   //--- Coordinates
   int               X(void)                      { return(m_x);           }
   void              X(const int x)               { m_x=x;                 }
   int               Y(void)                      { return(m_y);           }
   void              Y(const int y)               { m_y=y;                 }
   int               X2(void)                     { return(m_x+m_x_size);  }
   int               Y2(void)                     { return(m_y+m_y_size);  }
   //--- Margins from the edge point (xy)
   int               XGap(void)                   { return(m_x_gap);       }
   void              XGap(const int x_gap)        { m_x_gap=x_gap;         }
   int               YGap(void)                   { return(m_y_gap);       }
   void              YGap(const int y_gap)        { m_y_gap=y_gap;         }
   //--- Size
   int               XSize(void)                  { return(m_x_size);      }
   void              XSize(const int x_size)      { m_x_size=x_size;       }
   int               YSize(void)                  { return(m_y_size);      }
   void              YSize(const int y_size)      { m_y_size=y_size;       }
   //--- Focus
   bool              MouseFocus(void)             { return(m_mouse_focus); }
   void              MouseFocus(const bool focus) { m_mouse_focus=focus;   }
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CRectCanvas::CRectCanvas(void) : m_x(0),
                                 m_y(0),
                                 m_x2(0),
                                 m_y2(0),
                                 m_x_gap(0),
                                 m_y_gap(0),
                                 m_x_size(0),
                                 m_y_size(0),
                                 m_mouse_focus(false)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CRectCanvas::~CRectCanvas(void)
  {
  }
//+------------------------------------------------------------------+
//| Class with additional properties for the Edit object             |
//+------------------------------------------------------------------+
class CEdit : public CChartObjectEdit
  {
protected:
   int               m_x;
   int               m_y;
   int               m_x2;
   int               m_y2;
   int               m_x_gap;
   int               m_y_gap;
   int               m_x_size;
   int               m_y_size;
   bool              m_mouse_focus;
   //---
public:
                     CEdit(void);
                    ~CEdit(void);
   //--- Coordinates
   int               X(void)                      { return(m_x);           }
   void              X(const int x)               { m_x=x;                 }
   int               Y(void)                      { return(m_y);           }
   void              Y(const int y)               { m_y=y;                 }
   int               X2(void)                     { return(m_x+m_x_size);  }
   int               Y2(void)                     { return(m_y+m_y_size);  }
   //--- Margins from the edge point (xy)
   int               XGap(void)                   { return(m_x_gap);       }
   void              XGap(const int x_gap)        { m_x_gap=x_gap;         }
   int               YGap(void)                   { return(m_y_gap);       }
   void              YGap(const int y_gap)        { m_y_gap=y_gap;         }
   //--- Size
   int               XSize(void)                  { return(m_x_size);      }
   void              XSize(const int x_size)      { m_x_size=x_size;       }
   int               YSize(void)                  { return(m_y_size);      }
   void              YSize(const int y_size)      { m_y_size=y_size;       }
   //--- Focus
   bool              MouseFocus(void)             { return(m_mouse_focus); }
   void              MouseFocus(const bool focus) { m_mouse_focus=focus;   }
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CEdit::CEdit(void) : m_x(0),
                     m_y(0),
                     m_x2(0),
                     m_y2(0),
                     m_x_gap(0),
                     m_y_gap(0),
                     m_x_size(0),
                     m_y_size(0),
                     m_mouse_focus(false)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CEdit::~CEdit(void)
  {
  }
//+------------------------------------------------------------------+
//| Class with additional properties for the Label object            |
//+------------------------------------------------------------------+
class CLabel : public CChartObjectLabel
  {
protected:
   int               m_x;
   int               m_y;
   int               m_x2;
   int               m_y2;
   int               m_x_gap;
   int               m_y_gap;
   int               m_x_size;
   int               m_y_size;
   //---
public:
                     CLabel(void);
                    ~CLabel(void);
   //--- Coordinates
   int               X(void)                 { return(m_x);           }
   void              X(const int x)          { m_x=x;                 }
   int               Y(void)                 { return(m_y);           }
   void              Y(const int y)          { m_y=y;                 }
   int               X2(void)                { return(m_x+m_x_size);  }
   int               Y2(void)                { return(m_y+m_y_size);  }
   //--- Margins from the edge point (xy)
   int               XGap(void)              { return(m_x_gap);       }
   void              XGap(const int x_gap)   { m_x_gap=x_gap;         }
   int               YGap(void)              { return(m_y_gap);       }
   void              YGap(const int y_gap)   { m_y_gap=y_gap;         }
   //--- Size
   int               XSize(void)             { return(m_x_size);      }
   void              XSize(const int x_size) { m_x_size=x_size;       }
   int               YSize(void)             { return(m_y_size);      }
   void              YSize(const int y_size) { m_y_size=y_size;       }
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CLabel::CLabel(void) : m_x(0),
                       m_y(0),
                       m_x2(0),
                       m_y2(0),
                       m_x_gap(0),
                       m_y_gap(0),
                       m_x_size(0),
                       m_y_size(0)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CLabel::~CLabel(void)
  {
  }
//+------------------------------------------------------------------+
//| Class with additional properties for the Bmp Label object        |
//+------------------------------------------------------------------+
class CBmpLabel : public CChartObjectBmpLabel
  {
protected:
   int               m_x;
   int               m_y;
   int               m_x2;
   int               m_y2;
   int               m_x_gap;
   int               m_y_gap;
   int               m_x_size;
   int               m_y_size;
   bool              m_mouse_focus;
   //---
public:
                     CBmpLabel(void);
                    ~CBmpLabel(void);
   //--- Coordinates
   int               X(void)                      { return(m_x);           }
   void              X(const int x)               { m_x=x;                 }
   int               Y(void)                      { return(m_y);           }
   void              Y(const int y)               { m_y=y;                 }
   int               X2(void)                     { return(m_x+m_x_size);  }
   int               Y2(void)                     { return(m_y+m_y_size);  }
   //--- Margins from the edge point (xy)
   int               XGap(void)                   { return(m_x_gap);       }
   void              XGap(const int x_gap)        { m_x_gap=x_gap;         }
   int               YGap(void)                   { return(m_y_gap);       }
   void              YGap(const int y_gap)        { m_y_gap=y_gap;         }
   //--- Size
   int               XSize(void)                  { return(m_x_size);      }
   void              XSize(const int x_size)      { m_x_size=x_size;       }
   int               YSize(void)                  { return(m_y_size);      }
   void              YSize(const int y_size)      { m_y_size=y_size;       }
   //--- Focus
   bool              MouseFocus(void)             { return(m_mouse_focus); }
   void              MouseFocus(const bool focus) { m_mouse_focus=focus;   }
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CBmpLabel::CBmpLabel(void) : m_x(0),
                             m_y(0),
                             m_x2(0),
                             m_y2(0),
                             m_x_gap(0),
                             m_y_gap(0),
                             m_x_size(0),
                             m_y_size(0),
                             m_mouse_focus(false)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CBmpLabel::~CBmpLabel(void)
  {
  }
  
  
//+------------------------------------------------------------------+
//| Class with additional properties for the Edit object             |
//+------------------------------------------------------------------+
class CButton : public CChartObjectButton
  {
protected:
   int               m_x;
   int               m_y;
   int               m_x2;
   int               m_y2;
   int               m_x_gap;
   int               m_y_gap;
   int               m_x_size;
   int               m_y_size;
   bool              m_mouse_focus;
   //---
public:
                     CButton(void);
                    ~CButton(void);
   //--- Coordinates
   int               X(void)                      { return(m_x);           }
   void              X(const int x)               { m_x=x;                 }
   int               Y(void)                      { return(m_y);           }
   void              Y(const int y)               { m_y=y;                 }
   int               X2(void)                     { return(m_x+m_x_size);  }
   int               Y2(void)                     { return(m_y+m_y_size);  }
   //--- Margins from the edge point (xy)
   int               XGap(void)                   { return(m_x_gap);       }
   void              XGap(const int x_gap)        { m_x_gap=x_gap;         }
   int               YGap(void)                   { return(m_y_gap);       }
   void              YGap(const int y_gap)        { m_y_gap=y_gap;         }
   //--- Size
   int               XSize(void)                  { return(m_x_size);      }
   void              XSize(const int x_size)      { m_x_size=x_size;       }
   int               YSize(void)                  { return(m_y_size);      }
   void              YSize(const int y_size)      { m_y_size=y_size;       }
   //--- Focus
   bool              MouseFocus(void)             { return(m_mouse_focus); }
   void              MouseFocus(const bool focus) { m_mouse_focus=focus;   }
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CButton::CButton(void) : m_x(0),
                         m_y(0),
                         m_x2(0),
                         m_y2(0),
                         m_x_gap(0),
                         m_y_gap(0),
                         m_x_size(0),
                         m_y_size(0),
                         m_mouse_focus(false)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CButton::~CButton(void)
  {
  }
//+------------------------------------------------------------------+
//| Class with additional properties for the Line Chart object       |
//+------------------------------------------------------------------+
class CLineChartObject : public CLineChart
  {
protected:
   int               m_x;
   int               m_y;
   int               m_x2;
   int               m_y2;
   int               m_x_gap;
   int               m_y_gap;
   int               m_x_size;
   int               m_y_size;
   bool              m_mouse_focus;
public:
                     CLineChartObject(void);
                    ~CLineChartObject(void);
   //---
   int               X(void)                      { return(m_x);           }
   void              X(const int x)               { m_x=x;                 }
   int               Y(void)                      { return(m_y);           }
   void              Y(const int y)               { m_y=y;                 }
   int               X2(void)                     { return(m_x+m_x_size);  }
   int               Y2(void)                     { return(m_y+m_y_size);  }
   //--- Margins from the edge point (xy)
   int               XGap(void)                   { return(m_x_gap);       }
   void              XGap(const int x_gap)        { m_x_gap=x_gap;         }
   int               YGap(void)                   { return(m_y_gap);       }
   void              YGap(const int y_gap)        { m_y_gap=y_gap;         }
   //--- Size
   int               XSize(void)                  { return(m_x_size);      }
   void              XSize(const int x_size)      { m_x_size=x_size;       }
   int               YSize(void)                  { return(m_y_size);      }
   void              YSize(const int y_size)      { m_y_size=y_size;       }
   //---
   bool              MouseFocus(void)             { return(m_mouse_focus); }
   void              MouseFocus(const bool focus) { m_mouse_focus=focus;   }
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CLineChartObject::CLineChartObject(void) : m_x(0),
                                           m_y(0),
                                           m_x2(0),
                                           m_y2(0),
                                           m_x_gap(0),
                                           m_y_gap(0),
                                           m_x_size(0),
                                           m_y_size(0),
                                           m_mouse_focus(false)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CLineChartObject::~CLineChartObject(void)
  {
  }
//+------------------------------------------------------------------+

class CfBmpLabel : public CChartObjectBmpLabel
  {
protected:
   int               f_x;
   int               f_y;
   int               f_x2;
   int               f_y2;
   int               f_x_gap;
   int               f_y_gap;
   int               f_x_size;
   int               f_y_size;
   bool              m_mouse_focus;
   //---
public:
                     CfBmpLabel(void);
                    ~CfBmpLabel(void);
   //--- Coordinates
   int               X(void)                      { return(f_x);           }
   void              X(const int x)               { f_x=x;                 }
   int               Y(void)                      { return(f_y);           }
   void              Y(const int y)               { f_y=y;                 }
   int               X2(void)                     { return(f_x+f_x_size);  }
   int               Y2(void)                     { return(f_y+f_y_size);  }
   //--- Margins from the edge point (xy)
   int               XGap(void)                   { return(f_x_gap);       }
   void              XGap(const int x_gap)        { f_x_gap=x_gap;         }
   int               YGap(void)                   { return(f_y_gap);       }
   void              YGap(const int y_gap)        { f_y_gap=y_gap;         }
   //--- Size
   int               XSize(void)                  { return(f_x_size);      }
   void              XSize(const int x_size)      { f_x_size=x_size;       }
   int               YSize(void)                  { return(f_y_size);      }
   void              YSize(const int y_size)      { f_y_size=y_size;       }
   //--- Focus
   bool              MouseFocus(void)             { return(m_mouse_focus); }
   void              MouseFocus(const bool focus) { m_mouse_focus=focus;   }
   void              SetName(string name){this.m_name = name; m_chart_id = 0; ObjectSetString(0,name , OBJPROP_TOOLTIP , "\n");}
   string            getName(){return this.m_name;}
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CfBmpLabel::CfBmpLabel(void) : f_x(0),
                             f_y(0),
                             f_x2(0),
                             f_y2(0),
                             f_x_gap(0),
                             f_y_gap(0),
                             f_x_size(0),
                             f_y_size(0),
                             m_mouse_focus(false)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CfBmpLabel::~CfBmpLabel(void)
  {
  }