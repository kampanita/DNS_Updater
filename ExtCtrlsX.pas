{*******************************************************}
{                                                       }
{       CodeGear Delphi Visual Component Library        }
{                                                       }
{           Copyright (c) 1995-2007 CodeGear            }
{                                                       }
{*******************************************************}

unit ExtCtrlsX;

{$S-,W-,R-,H+,X+}
{$C PRELOAD}

{$IF CompilerVersion >= 14}
  {$DEFINE VER140_up} // Delphi 6
  {$IF CompilerVersion >= 15}
    {$DEFINE VER150_up}  // Delphi 7
    {$IF CompilerVersion >= 16}
      {$DEFINE VER160_up}  // Delphi 8
      {$IF CompilerVersion >= 17}
        {$DEFINE VER170_up}  // Delphi 9/2005
        {$DEFINE SupportsInline}
        {$IF CompilerVersion >= 18}
          {$DEFINE VER180_up}  // BDS 2006
          {$IFDEF VER185}
            {$DEFINE VER185_up}  // Delphi 2007
          {$ENDIF}
          {$IF CompilerVersion >= 19}
            {$DEFINE VER190_up}  // Delphi .NET 2007
            {$IF CompilerVersion >= 20}
              {$DEFINE VER200_up}  // RAD Studio 2009
              {$IF CompilerVersion >= 21}
                {$DEFINE VER210_up}  // RAD Studio 2010
              {$IFEND}
            {$IFEND}
          {$IFEND}
        {$IFEND}
      {$IFEND}
    {$IFEND}
  {$IFEND}
{$ELSE}
  {$Message Error 'Sorry, but this version of X does not support the IDE you are using.'}
{$IFEND}

{$IFDEF VER185_up}
  {$Message Error 'please uncomment this unit in your project of uses list.'}
{$ENDIF VER185_up}

interface

uses
  Messages, Windows, SysUtils, Classes, Contnrs,
  Controls, Forms, Menus, Graphics, StdCtrls, GraphUtil, ShellApi
  ,ExtCtrls, ImgList
{..$IFNDEF RTL2007_L3_UP}
  ,ControlsX
{..$ENDIF RTL2007_L3_UP}
  ;
  
{$if not (defined(RTL2007_L3_UP) and defined(COMPILETIMES_2ND)) }

{$IFNDEF RTL2007_L3_UP}
type
  {redefine}
  TColorBoxStyles = (cbStandardColors, // first sixteen RGBI colors
                     cbExtendedColors, // four additional reserved colors
                     cbSystemColors,   // system managed/defined colors
                     cbIncludeNone,    // include clNone color, must be used with cbSystemColors
                     cbIncludeDefault, // include clDefault color, must be used with cbSystemColors
                     cbCustomColor,    // first color is customizable
                     cbPrettyNames,
                     cbCustomColors);  // All colors are custom colors
  TColorBoxStyle = set of TColorBoxStyles;

{ TColorListBox }

  TCustomColorListBox = class;
  TLBGetColorsEvent = procedure(Sender: TCustomColorListBox; Items: TStrings) of object;

  TCustomColorListBox = class(TCustomListBox)
  private
    FStyle: TColorBoxStyle;
    FNeedToPopulate: Boolean;
    FListSelected: Boolean;
    FDefaultColorColor: TColor;
    FNoneColorColor: TColor;
    FSelectedColor: TColor;
    FOnGetColors: TLBGetColorsEvent;
    FOnMouseActivate: TMouseActivateEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    function GetColor(Index: Integer): TColor;
    function GetColorName(Index: Integer): string;
    function GetSelected: TColor;
    procedure SetSelected(const AColor: TColor);
    procedure ColorCallBack(const AName: string);
    procedure SetDefaultColorColor(const Value: TColor);
    procedure SetNoneColorColor(const Value: TColor);
  protected
    procedure CreateWnd; override;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure Loaded; override;
    function PickCustomColor: Boolean; virtual;
    procedure PopulateList;
    procedure SetStyle(AStyle: TColorBoxStyle); reintroduce;
  public
    NoUseImage: TImage;
    constructor Create(AOwner: TComponent); override;
    property Style: TColorBoxStyle read FStyle write SetStyle
      default [cbStandardColors, cbExtendedColors, cbSystemColors];
    property Colors[Index: Integer]: TColor read GetColor;
    property ColorNames[Index: Integer]: string read GetColorName;
    property Selected: TColor read GetSelected write SetSelected default clBlack;
    property DefaultColorColor: TColor read FDefaultColorColor write SetDefaultColorColor default clBlack;
    property NoneColorColor: TColor read FNoneColorColor write SetNoneColorColor default clBlack;
    property OnGetColors: TLBGetColorsEvent read FOnGetColors write FOnGetColors;

    //not effect, for compatibility only
    property OnMouseActivate: TMouseActivateEvent read FOnMouseActivate write FOnMouseActivate;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
  end;

  TColorListBox = class(TCustomColorListBox)
  published
    property Align;
    property AutoComplete;
    property DefaultColorColor;
    property NoneColorColor;
    property Selected;
    property Style;

    property Anchors;
    property BevelEdges;
    property BevelInner;
    property BevelKind;
    property BevelOuter;
    property BiDiMode;
    property Color;
    property Constraints;
    property Ctl3D;
    property Enabled;
    property Font;
    property ItemHeight;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetColors;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;
{$ENDIF RTL2007_L3_UP}

{$IFNDEF RTL2007_L1_UP}
  { from ShellAPI.pas}
type
  PNotifyIconDataA = ^TNotifyIconDataA;
  PNotifyIconDataW = ^TNotifyIconDataW;
  PNotifyIconData = PNotifyIconDataA;
  _NOTIFYICONDATAA = record
    cbSize: DWORD;
    Wnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
    szTip: array [0..127] of AnsiChar;
    dwState: DWORD;
    dwStateMask: DWORD;
    szInfo: array [0..255] of AnsiChar;
    uTimeout: UINT;
    szInfoTitle: array [0..63] of AnsiChar;
    dwInfoFlags: DWORD;
  end;
  _NOTIFYICONDATAW = record
    cbSize: DWORD;
    Wnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
    szTip: array [0..127] of WideChar;
    dwState: DWORD;
    dwStateMask: DWORD;
    szInfo: array [0..255] of WideChar;
    uTimeout: UINT;
    szInfoTitle: array [0..63] of WideChar;
    dwInfoFlags: DWORD;
  end;
  _NOTIFYICONDATA = _NOTIFYICONDATAA;
  TNotifyIconDataA = _NOTIFYICONDATAA;
  TNotifyIconDataW = _NOTIFYICONDATAW;
  TNotifyIconData = TNotifyIconDataA;
  {$EXTERNALSYM NOTIFYICONDATAA}
  NOTIFYICONDATAA = _NOTIFYICONDATAA;
  {$EXTERNALSYM NOTIFYICONDATAW}
  NOTIFYICONDATAW = _NOTIFYICONDATAW;
  {$EXTERNALSYM NOTIFYICONDATA}
  NOTIFYICONDATA = NOTIFYICONDATAA;

const
  {$EXTERNALSYM NIN_BALLOONHIDE}
  NIN_BALLOONHIDE       = $0400 + 3;
  {$EXTERNALSYM NIN_BALLOONTIMEOUT}
  NIN_BALLOONTIMEOUT    = $0400 + 4;

const
  {$EXTERNALSYM NIF_INFO}
  NIF_INFO        = $00000010;
  {$EXTERNALSYM NIIF_NONE}
  NIIF_NONE       = $00000000;
  {$EXTERNALSYM NIIF_INFO}
  NIIF_INFO       = $00000001;
  {$EXTERNALSYM NIIF_WARNING}
  NIIF_WARNING    = $00000002;
  {$EXTERNALSYM NIIF_ERROR}
  NIIF_ERROR      = $00000003;

{$ENDIF RTL2007_L1_UP}

{$IFNDEF RTL2007_L3_UP}
{ from ExtCtrls.pas}
{ TTrayIcon }
const
  WM_SYSTEM_TRAY_MESSAGE = WM_USER + 1;

var
  RM_TaskbarCreated: DWORD;

type
  TBalloonFlags = (bfNone = NIIF_NONE, bfInfo = NIIF_INFO,
    bfWarning = NIIF_WARNING, bfError = NIIF_ERROR);

  TCustomTrayIcon = class(TComponent)
  private
    FAnimate: Boolean;
    FData: TNotifyIconData;
    FIsClicked: Boolean;
    FCurrentIcon: TIcon;
    FIcon: TIcon;
    FIconList: TImageList;
    FPopupMenu: TPopupMenu;
    FTimer: TTimer;
    FHint: String;
    FIconIndex: Integer;
    FVisible: Boolean;
    FOnMouseMove: TMouseMoveEvent;
    FOnClick: TNotifyEvent;
    FOnDblClick: TNotifyEvent;
    FOnMouseDown: TMouseEvent;
    FOnMouseUp: TMouseEvent;
    FOnAnimate: TNotifyEvent;
    FBalloonHint: string;
    FBalloonTitle: string;
    FBalloonFlags: TBalloonFlags;
  protected
    procedure SetHint(const Value: string);
    function GetAnimateInterval: Cardinal;
    procedure SetAnimateInterval(Value: Cardinal);
    procedure SetAnimate(Value: Boolean);
    procedure SetBalloonHint(const Value: string);
    function GetBalloonTimeout: Integer;
    procedure SetBalloonTimeout(Value: Integer);
    procedure SetBalloonTitle(const Value: string);
    procedure SetVisible(Value: Boolean); virtual;
    procedure SetIconIndex(Value: Integer); virtual;
    procedure SetIcon(Value: TIcon);
    procedure SetIconList(Value: TImageList);
    procedure WindowProc(var Message: TMessage); virtual;
    procedure DoOnAnimate(Sender: TObject); virtual;
    property Data: TNotifyIconData read FData;
    function Refresh(Message: Integer): Boolean; overload;
  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
    procedure Refresh; overload;
    procedure SetDefaultIcon;
    procedure ShowBalloonHint; virtual;
    property Animate: Boolean read FAnimate write SetAnimate default False;
    property AnimateInterval: Cardinal read GetAnimateInterval write SetAnimateInterval default 1000;
    property Hint: string read FHint write SetHint;
    property BalloonHint: string read FBalloonHint write SetBalloonHint;
    property BalloonTitle: string read FBalloonTitle write SetBalloonTitle;
    property BalloonTimeout: Integer read GetBalloonTimeout write SetBalloonTimeout default 3000;
    property BalloonFlags: TBalloonFlags read FBalloonFlags write FBalloonFlags default bfNone;
    property Icon: TIcon read FIcon write SetIcon;
    property Icons: TImageList read FIconList write SetIconList;
    property IconIndex: Integer read FIconIndex write SetIconIndex default 0;
    property PopupMenu: TPopupMenu read FPopupMenu write FPopupMenu;
    property Visible: Boolean read FVisible write SetVisible default False;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnMouseMove: TMouseMoveEvent read FOnMouseMove write FOnMouseMove;
    property OnMouseUp: TMouseEvent read FOnMouseUp write FOnMouseUp;
    property OnMouseDown: TMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnAnimate: TNotifyEvent read FOnAnimate write FOnAnimate;
  end;

  TTrayIcon = class(TCustomTrayIcon)
  published
    property Animate;
    property AnimateInterval;
    property Hint;
    property BalloonHint;
    property BalloonTitle;
    property BalloonTimeout;
    property BalloonFlags;
    property Icon;
    property Icons;
    property IconIndex;
    property PopupMenu;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseDown;
    property OnAnimate;
  end;
{$ENDIF RTL2007_L3_UP}

{$if (defined(RTL2007_L3_UP) and (not defined(COMPILETIMES_2ND))) }
type

  TFlowStyle = (fsLeftRightTopBottom, fsRightLeftTopBottom, fsLeftRightBottomTop, fsRightLeftBottomTop,
                fsTopBottomLeftRight, fsBottomTopLeftRight, fsTopBottomRightLeft, fsBottomTopRightLeft);
  {from extctrls.pas}
  TCustomFlowPanel = class(TCustomPanel)
  private
    FControlList: TObjectList;
    FAutoWrap: Boolean;
    FFlowStyle: TFlowStyle;
    FPadding: TPadding;
    FVerticalAlignment: TVerticalAlignment;
    FOnAlignInsertBefore: TAlignInsertBeforeEvent;
    FOnAlignPosition: TAlignPositionEvent;
    FOnMouseActivate: TMouseActivateEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    procedure SetAutoWrap(const Value: Boolean);
    procedure SetFlowStyle(const Value: TFlowStyle);
{
    procedure CMControlListChanging(var Message: TCMControlListChanging); message CM_CONTROLLISTCHANGING;
}
  protected
//    procedure AlignControls(AControl: TControl; var Rect: TRect); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
//    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    function GetControlIndex(AControl: TControl): Integer;
    procedure SetControlIndex(AControl: TControl; Index: Integer);
    property AutoWrap: Boolean read FAutoWrap write SetAutoWrap default True;
    property FlowStyle: TFlowStyle read FFlowStyle write SetFlowStyle default fsLeftRightTopBottom;

    //not effect, for compatibility only
  protected
    property OnAlignInsertBefore: TAlignInsertBeforeEvent read FOnAlignInsertBefore
      write FOnAlignInsertBefore;
    property OnAlignPosition: TAlignPositionEvent read FOnAlignPosition write FOnAlignPosition;
    property VerticalAlignment: TVerticalAlignment read FVerticalAlignment write FVerticalAlignment default taVerticalCenter;
    property OnMouseActivate: TMouseActivateEvent read FOnMouseActivate write FOnMouseActivate;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
  public
    property Padding: TPadding read FPadding write FPadding;
  end;

  TFlowPanel = class(TCustomFlowPanel)
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property AutoWrap;
    property BevelEdges;
    property BevelInner;
    property BevelKind;
    property BevelOuter;
    property BevelWidth;
    property BiDiMode;
    property BorderWidth;
    property BorderStyle;
    property Caption;
    property Color;
    property Constraints;
    property Ctl3D;
    property UseDockManager default True;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FlowStyle;
    property FullRepaint;
    property Font;
    property Locked;
    property Padding;
    property ParentBiDiMode;
    property ParentBackground;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property VerticalAlignment;
    property Visible;
    property OnAlignInsertBefore;
    property OnAlignPosition;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  {TCustomGridPanel}
  {from extctrls.pas}

  TSizeStyle = (ssAbsolute, ssPercent, ssAuto);

  TCustomGridPanel = class;
  EGridPanelException = class(Exception);

  TCellItem = class(TCollectionItem)
  private
    FSizeStyle: TSizeStyle;
    FValue: Double;
    FSize: Integer;
    FAutoAdded: Boolean;
  protected
    procedure AssignTo(Dest: TPersistent); override;
    procedure SetSizeStyle(Value: TSizeStyle);
    procedure SetValue(Value: Double);
    property Size: Integer read FSize write FSize;
    property AutoAdded: Boolean read FAutoAdded write FAutoAdded;
  public
    constructor Create(Collection: TCollection); override;
  published
    property SizeStyle: TSizeStyle read FSizeStyle write SetSizeStyle default ssPercent;
    property Value: Double read FValue write SetValue;
  end;

  TRowItem = class(TCellItem);

  TColumnItem = class(TCellItem);

  TCellCollection = class(TOwnedCollection)
  protected
    function GetAttrCount: Integer; override;
    function GetAttr(Index: Integer): string; override;
    function GetItemAttr(Index, ItemIndex: Integer): string; override;
    function GetItem(Index: Integer): TCellItem;
    procedure SetItem(Index: Integer; Value: TCellItem);
    procedure Update(Item: TCollectionItem); override;
  public
    function Owner: TCustomGridPanel;
    property Items[Index: Integer]: TCellItem read GetItem write SetItem; default;
  end;

  TCellSpan = 1..MaxInt;

  TRowCollection = class(TCellCollection)
  protected
    function GetItemAttr(Index, ItemIndex: Integer): string; override;
    procedure Notify(Item: TCollectionItem; Action: TCollectionNotification); override;
  public
    constructor Create(AOwner: TPersistent);
    function Add: TRowItem;
  end;

  TColumnCollection = class(TCellCollection)
  protected
    function GetItemAttr(Index, ItemIndex: Integer): string; override;
    procedure Notify(Item: TCollectionItem; Action: TCollectionNotification); override;
  public
    constructor Create(AOwner: TPersistent);
    function Add: TColumnItem;
  end;

  TControlItem = class(TCollectionItem)
  private
    FControl: TControl;
    FColumn, FRow: Integer;
    FColumnSpan, FRowSpan: TCellSpan;
    FPushed: Integer;
    function GetGridPanel: TCustomGridPanel;
    function GetPushed: Boolean;
    procedure SetColumn(Value: Integer);
    procedure SetColumnSpan(Value: TCellSpan);
    procedure SetControl(Value: TControl);
    procedure SetRow(Value: Integer);
    procedure SetRowSpan(Value: TCellSpan);
  protected
    procedure AssignTo(Dest: TPersistent); override;
    procedure InternalSetLocation(AColumn, ARow: Integer; APushed: Boolean; MoveExisting: Boolean);
    property GridPanel: TCustomGridPanel read GetGridPanel;
    property Pushed: Boolean read GetPushed;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure SetLocation(AColumn, ARow: Integer; APushed: Boolean = False);
  published
    property Column: Integer read FColumn write SetColumn;
    property ColumnSpan: TCellSpan read FColumnSpan write SetColumnSpan default 1;
    property Control: TControl read FControl write SetControl;
    property Row: Integer read FRow write SetRow;
    property RowSpan: TCellSpan read FRowSpan write SetRowSpan default 1;
  end;

  TControlCollection = class(TOwnedCollection)
  protected
    function GetControl(AColumn, ARow: Integer): TControl;
    function GetControlItem(AColumn, ARow: Integer): TControlItem;
    function GetItem(Index: Integer): TControlItem;
    procedure SetControl(AColumn, ARow: Integer; Value: TControl);
    procedure SetItem(Index: Integer; Value: TControlItem);
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent);
    function Add: TControlItem;
    procedure AddControl(AControl: TControl; AColumn: Integer = -1; ARow: Integer = -1);
    procedure RemoveControl(AControl: TControl);
    function IndexOf(AControl: TControl): Integer;
    function Owner: TCustomGridPanel;
    property Controls[AColumn, ARow: Integer]: TControl read GetControl write SetControl;
    property ControlItems[AColumn, ARow: Integer] : TControlItem read GetControlItem;
    property Items[Index: Integer]: TControlItem read GetItem write SetItem; default;
  end;

  {....}
  TExpandStyle = (emAddRows, emAddColumns, emFixedSize);

  TCustomGridPanel = class(TCustomPanel)
  private
    FRowCollection: TRowCollection;
    FColumnCollection: TColumnCollection;
    FControlCollection: TControlCollection;
    FRecalcCellSizes: Boolean;
    FExpandStyle: TExpandStyle;
    FPadding: TPadding;
    FOnAlignInsertBefore: TAlignInsertBeforeEvent;
    FOnAlignPosition: TAlignPositionEvent;
    FOnMouseActivate: TMouseActivateEvent;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FVerticalAlignment: TVerticalAlignment;
//    procedure CMControlChange(var Message: TCMControlChange); message CM_CONTROLCHANGE;
//    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
    function GetCellCount: Integer;
    function GetCellSizes(AColumn, ARow: Integer): TPoint;
    function GetCellRect(AColumn, ARow: Integer): TRect;
    function GetColumnSpanIndex(AColumn, ARow: Integer): Integer;
    function GetRowSpanIndex(AColumn, ARow: Integer): Integer;
    procedure SetColumnCollection(const Value: TColumnCollection);
    procedure SetControlCollection(const Value: TControlCollection);
    procedure SetRowCollection(const Value: TRowCollection);
//    procedure RecalcCellDimensions(const Rect: TRect);

  protected
    function AutoAddColumn: TColumnItem;
    function AutoAddRow: TRowItem;
    function CellToCellIndex(AColumn, ARow: Integer): Integer;
    procedure CellIndexToCell(AIndex: Integer; var AColumn, ARow: Integer);
//    procedure AlignControls(AControl: TControl; var Rect: TRect); override;
//    procedure Loaded; override;
//    procedure Paint; override;
    procedure RemoveEmptyAutoAddColumns;
    procedure RemoveEmptyAutoAddRows;
    procedure UpdateControlOriginalParentSize(AControl: TControl; var AOriginalParentSize: TPoint); virtual{override};
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
//    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    function IsColumnEmpty(AColumn: Integer): Boolean;
    function IsRowEmpty(ARow: Integer): Boolean;
    property ColumnSpanIndex[AColumn, ARow: Integer]: Integer read GetColumnSpanIndex;
    property CellCount: Integer read GetCellCount;
    property CellSize[AColumn, ARow: Integer]: TPoint read GetCellSizes;
    property CellRect[AColumn, ARow: Integer]: TRect read GetCellRect;
    property ColumnCollection: TColumnCollection read FColumnCollection write SetColumnCollection;
    property ControlCollection: TControlCollection read FControlCollection write SetControlCollection;
    property ExpandStyle: TExpandStyle read FExpandStyle write FExpandStyle default emAddRows;
    property RowCollection: TRowCollection read FRowCollection write SetRowCollection;
    property RowSpanIndex[AColumn, ARow: Integer]: Integer read GetRowSpanIndex;
    //not effect, for compatibility only
  protected
    property OnAlignInsertBefore: TAlignInsertBeforeEvent read FOnAlignInsertBefore
      write FOnAlignInsertBefore;
    property OnAlignPosition: TAlignPositionEvent read FOnAlignPosition write FOnAlignPosition;
    property VerticalAlignment: TVerticalAlignment read FVerticalAlignment write FVerticalAlignment default taVerticalCenter;
    property OnMouseActivate: TMouseActivateEvent read FOnMouseActivate write FOnMouseActivate;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
  public
    property Padding: TPadding read FPadding write FPadding;
  end;

  TGridPanel = class(TCustomGridPanel)
  public
    property DockManager;
  published
    property Align;
    property Alignment;
    property Anchors;
    property BevelEdges;
    property BevelInner;
    property BevelKind;
    property BevelOuter;
    property BevelWidth;
    property BiDiMode;
    property BorderWidth;
    property BorderStyle;
    property Caption;
    property Color;
    property ColumnCollection;
    property Constraints;
    property ControlCollection;
    property Ctl3D;
    property UseDockManager default True;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ExpandStyle;
    property FullRepaint;
    property Font;
    property Locked;
    property Padding;
    property ParentBiDiMode;
    property ParentBackground;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property RowCollection;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property VerticalAlignment;
    property Visible;
    property OnAlignInsertBefore;
    property OnAlignPosition;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;
{$ifend (defined(RTL2007_L3_UP) and (not defined(COMPILETIMES_2ND))) }

{$ifend not (defined(RTL2007_L3_UP) and defined(COMPILETIMES_2ND)) }

{ TCustomLinkLabel }
type
  TSysLinkType = (sltURL, sltID);

  TSysLinkEvent = procedure(Sender: TObject; const Link: string; LinkType: TSysLinkType) of object;
  TLinkAlignment = taLeftJustify..taRightJustify;

  TCustomLinkLabel = class(TWinControl)
  private
    FAlignment: TLinkAlignment;
    FAutoSize: Boolean;
    FUseVisualStyle: Boolean;
    FOnLinkClick: TSysLinkEvent;
{$if not (defined(RTL2007_L3_UP) and defined(COMPILETIMES_2ND)) }
    FOnMouseActivate: TMouseActivateEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
{$ifend (defined(RTL2007_L3_UP) and defined(COMPILETIMES_2ND)) }
    procedure AdjustBounds;
    procedure DoOnLinkClick(const Link: string; LinkType: TSysLinkType);
    function ParseLinks: string;
    procedure SetAlignment(const Value: TLinkAlignment);
    procedure SetUseVisualStyle(const Value: Boolean);
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMNotify(var Message: TWMNotify); message CN_NOTIFY;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure SetAutoSize(Value: Boolean); override;
    function UseThemes: Boolean; virtual;
    procedure SetParent(AParent: TWinControl); override;
  public
    constructor Create(AOwner: TComponent); override;
    property Alignment: TLinkAlignment read FAlignment write SetAlignment default taLeftJustify;
    property AutoSize: Boolean read FAutoSize write SetAutoSize default True;
    property UseVisualStyle: Boolean read FUseVisualStyle write SetUseVisualStyle default False;
    property OnLinkClick: TSysLinkEvent read FOnLinkClick write FOnLinkClick;

{$if not (defined(RTL2007_L3_UP) and defined(COMPILETIMES_2ND)) }
    //not effect, for compatibility only
    property OnMouseActivate: TMouseActivateEvent read FOnMouseActivate write FOnMouseActivate;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
{$ifend (defined(RTL2007_L3_UP) and defined(COMPILETIMES_2ND)) }
  end;
  
  TLinkLabel = class(TCustomLinkLabel)
  published
    property Alignment; // Requires Windows Vista or later
    property Anchors;
    property AutoSize;
    property BevelEdges;
    property BevelInner;
    property BevelKind default bkNone;
    property BevelOuter;
    property Caption;
    property Color nodefault;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
//    property Touch;
    property UseVisualStyle;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
//    property OnGesture;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property OnLinkClick;
  end;

implementation

uses
  Consts, Dialogs, Themes, Math, UxTheme, CommCtrl;

{$if not (defined(RTL2007_L3_UP) and defined(COMPILETIMES_2ND)) }

type
  THackImage = TImage;

const
  STrayIconRemoveError = 'Cannot remove shell notification icon';
  STrayIconCreateError = 'Cannot create shell notification icon';

{$IFNDEF RTL2007_L3_UP}
  {from consts.pas}
resourcestring
  sCannotAddFixedSize = 'Cannot add columns or rows while expand style is fixed size';
  sInvalidSpan = '''%d'' is not a valid span';
  sInvalidRowIndex = 'Row index, %d, out of bounds';
  sInvalidColumnIndex = 'Column index, %d, out of bounds';
  sInvalidControlItem = 'ControlItem.Control cannot be set to owning GridPanel';
  sCannotDeleteColumn = 'Cannot delete a column that contains controls';
  sCannotDeleteRow = 'Cannot delete a row that contains controls';
  sCellMember = 'Member';
  sCellSizeType = 'Size Type';
  sCellValue = 'Value';
  sCellAutoSize = 'Auto';
  sCellPercentSize = 'Percent';
  sCellAbsoluteSize = 'Absolute';
  sCellColumn = 'Column%d';
  sCellRow = 'Row%d';
{$ENDIF RTL2007_L3_UP}

{$IFNDEF RTL2007_L3_UP}
resourcestring
  clNameBlack = 'Black';
  clNameMaroon = 'Maroon';
  clNameGreen = 'Green';
  clNameOlive = 'Olive';
  clNameNavy = 'Navy';
  clNamePurple = 'Purple';
  clNameTeal = 'Teal';
  clNameGray = 'Gray';
  clNameSilver = 'Silver';
  clNameRed = 'Red';
  clNameLime = 'Lime';
  clNameYellow = 'Yellow';
  clNameBlue = 'Blue';
  clNameFuchsia = 'Fuchsia';
  clNameAqua = 'Aqua';
  clNameWhite = 'White';
  clNameMoneyGreen = 'Money Green';
  clNameSkyBlue = 'Sky Blue';
  clNameCream = 'Cream';
  clNameMedGray = 'Medium Gray';
  clNameActiveBorder = 'Active Border';
  clNameActiveCaption = 'Active Caption';
  clNameAppWorkSpace = 'Application Workspace';
  clNameBackground = 'Background';
  clNameBtnFace = 'Button Face';
  clNameBtnHighlight = 'Button Highlight';
  clNameBtnShadow = 'Button Shadow';
  clNameBtnText = 'Button Text';
  clNameCaptionText = 'Caption Text';
  clNameDefault = 'Default';
  clNameGradientActiveCaption = 'Gradient Active Caption';
  clNameGradientInactiveCaption = 'Gradient Inactive Caption';
  clNameGrayText = 'Gray Text';
  clNameHighlight = 'Highlight Background';
  clNameHighlightText = 'Highlight Text';
  clNameHotLight = 'Hot Light';
  clNameInactiveBorder = 'Inactive Border';
  clNameInactiveCaption = 'Inactive Caption';
  clNameInactiveCaptionText = 'Inactive Caption Text';
  clNameInfoBk = 'Info Background';
  clNameInfoText = 'Info Text';
  clNameMenu = 'Menu Background';
  clNameMenuBar = 'Menu Bar';
  clNameMenuHighlight = 'Menu Highlight';
  clNameMenuText = 'Menu Text';
  clNameNone = 'None';
  clNameScrollBar = 'Scroll Bar';
  clName3DDkShadow = '3D Dark Shadow';
  clName3DLight = '3D Light';
  clNameWindow = 'Window Background';
  clNameWindowFrame = 'Window Frame';
  clNameWindowText = 'Window Text';


function ColorToPrettyName(Color: TColor; var Name: string): Boolean;
begin
  Result := True;
  case Color of
    clBlack: Name := clNameBlack;
    clMaroon: Name := clNameMaroon;
    clGreen: Name := clNameGreen;
    clOlive: Name := clNameOlive;
    clNavy: Name := clNameNavy;
    clPurple: Name := clNamePurple;
    clTeal: Name := clNameTeal;
    clGray: Name := clNameGray;
    clSilver: Name := clNameSilver;
    clRed: Name := clNameRed;
    clLime: Name := clNameLime;
    clYellow: Name := clNameYellow;
    clBlue: Name := clNameBlue;
    clFuchsia: Name := clNameFuchsia;
    clAqua: Name := clNameAqua;
    clWhite: Name := clNameWhite;
    clMoneyGreen: Name := clNameMoneyGreen;
    clSkyBlue: Name := clNameSkyBlue;
    clCream: Name := clNameCream;
    clMedGray: Name := clNameMedGray;

    clActiveBorder: Name := clNameActiveBorder;
    clActiveCaption: Name := clNameActiveCaption;
    clAppWorkSpace: Name := clNameAppWorkSpace;
    clBackground: Name := clNameBackground;
    clBtnFace: Name := clNameBtnFace;
    clBtnHighlight: Name := clNameBtnHighlight;
    clBtnShadow: Name := clNameBtnShadow;
    clBtnText: Name := clNameBtnText;
    clCaptionText: Name := clNameCaptionText;
    clDefault: Name := clNameDefault;
    clGrayText: Name := clNameGrayText;
    clGradientActiveCaption: Name := clNameGradientActiveCaption;
    clGradientInactiveCaption: Name := clNameGradientInactiveCaption;
    clHighlight: Name := clNameHighlight;
    clHighlightText: Name := clNameHighlightText;
    clHotLight: Name := clNameHotLight;
    clInactiveBorder: Name := clNameInactiveBorder;
    clInactiveCaption: Name := clNameInactiveCaption;
    clInactiveCaptionText: Name := clNameInactiveCaptionText;
    clInfoBk: Name := clNameInfoBk;
    clInfoText: Name := clNameInfoText;
    clMenu: Name := clNameMenu;
    clMenuBar: Name := clNameMenuBar;
    clMenuHighlight: Name := clNameMenuHighlight;
    clMenuText: Name := clNameMenuText;
    clNone: Name := clNameNone;
    clScrollBar: Name := clNameScrollBar;
    cl3DDkShadow: Name := clName3DDkShadow;
    cl3DLight: Name := clName3DLight;
    clWindow: Name := clNameWindow;
    clWindowFrame: Name := clNameWindowFrame;
    clWindowText: Name := clNameWindowText;
  else
    Result := False;
  end;
end;

{ TCustomColorListBox }

procedure TCustomColorListBox.ColorCallBack(const AName: String);
var
  I, LStart: Integer;
  LColor: TColor;
  LName: string;
begin
  LColor := StringToColor(AName);
  if cbPrettyNames in Style then
  begin
    if not ColorToPrettyName(LColor, LName) then
    begin
      if Copy(AName, 1, 2) = 'cl' then
        LStart := 3
      else
        LStart := 1;
      LName := '';
      for I := LStart to Length(AName) do
      begin
        case AName[I] of
          'A'..'Z':
            if LName <> '' then
              LName := LName + ' ';
        end;
        LName := LName + AName[I];
      end;
    end;
  end
  else
    LName := AName;
  Items.AddObject(LName, TObject(LColor));
end;

constructor TCustomColorListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited Style := lbOwnerDrawFixed;
  FStyle := [cbStandardColors, cbExtendedColors, cbSystemColors];
  FSelectedColor := clBlack;
  FDefaultColorColor := clBlack;
  FNoneColorColor := clBlack;
  PopulateList;
end;

procedure TCustomColorListBox.CreateWnd;
begin
  inherited CreateWnd;
  if FNeedToPopulate then
    PopulateList;
end;

procedure TCustomColorListBox.DrawItem(Index: Integer; Rect: TRect;
  State: TOwnerDrawState);

  function ColorToBorderColor(AColor: TColor): TColor;
  type
    TColorQuad = record
      Red,
      Green,
      Blue,
      Alpha: Byte;
    end;
  begin
    if (TColorQuad(AColor).Red > 192) or
       (TColorQuad(AColor).Green > 192) or
       (TColorQuad(AColor).Blue > 192) then
      Result := clBlack
    else if odSelected in State then
      Result := clWhite
    else
      Result := AColor;
  end;

var
  LRect: TRect;
  LBackground: TColor;
begin
  with Canvas do
  begin
    FillRect(Rect);
    LBackground := Brush.Color;

    LRect := Rect;
    LRect.Right := LRect.Bottom - LRect.Top + LRect.Left + 5;
    InflateRect(LRect, -1, -1);
    Brush.Color := Colors[Index];
    if Brush.Color = clDefault then
      Brush.Color := DefaultColorColor
    else if Brush.Color = clNone then
      Brush.Color := NoneColorColor;
    FillRect(LRect);
    Brush.Color := ColorToBorderColor(ColorToRGB(Brush.Color));
    FrameRect(LRect);

    Brush.Color := LBackground;
    Rect.Left := LRect.Right + 5;

    TextRect(Rect, Rect.Left,
      Rect.Top + (Rect.Bottom - Rect.Top - TextHeight(Items[Index])) div 2,
      Items[Index]);
  end;
end;

function TCustomColorListBox.GetColor(Index: Integer): TColor;
begin
  Result := TColor(Items.Objects[Index]);
end;

function TCustomColorListBox.GetColorName(Index: Integer): string;
begin
  Result := Items[Index];
end;

function TCustomColorListBox.GetSelected: TColor;
begin
  if HandleAllocated then
    if ItemIndex <> -1 then
      Result := Colors[ItemIndex]
    else
      Result := NoColorSelected
  else
    Result := FSelectedColor;
end;

procedure TCustomColorListBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  FListSelected := False;
  inherited KeyDown(Key, Shift);
end;

procedure TCustomColorListBox.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if (cbCustomColor in Style) and (Key = #13) and (ItemIndex = 0) then
  begin
    { If the user picked a custom color, force a click event to happen
      so the user can handle it }
    if PickCustomColor then
      OnClick(Self);
    Key := #0;
  end;
end;

procedure TCustomColorListBox.Loaded;
begin
  inherited;
  Selected := FSelectedColor;
end;

function TCustomColorListBox.PickCustomColor: Boolean;
var
  LColor: TColor;
begin
  with TColorDialog.Create(nil) do
    try
      LColor := ColorToRGB(TColor(Items.Objects[0]));
      Color := LColor;
      CustomColors.Text := Format('ColorA=%.8x', [LColor]);
      Result := Execute;
      if Result then
      begin
        Items.Objects[0] := TObject(Color);
        Self.Invalidate;
      end;
    finally
      Free;
    end;
end;

procedure TCustomColorListBox.PopulateList;

  procedure DeleteRange(const AMin, AMax: Integer);
  var
    I: Integer;
  begin
    for I := AMax downto AMin do
      Items.Delete(I);
  end;

  procedure DeleteColor(const AColor: TColor);
  var
    I: Integer;
  begin
    I := Items.IndexOfObject(TObject(AColor));
    if I <> -1 then
      Items.Delete(I);
  end;

var
  LSelectedColor, LCustomColor: TColor;
begin
  if HandleAllocated then
  begin
    Items.BeginUpdate;
    try
      LCustomColor := clBlack;
      if (cbCustomColor in Style) and (Items.Count > 0) then
        LCustomColor := TColor(Items.Objects[0]);
      LSelectedColor := FSelectedColor;
      Items.Clear;
      if Style <> [cbCustomColors] then
      begin
        GetColorValues(ColorCallBack);
        if not (cbIncludeNone in Style) then
          DeleteColor(clNone);
        if not (cbIncludeDefault in Style) then
          DeleteColor(clDefault);
        if not (cbSystemColors in Style) then
          DeleteRange(StandardColorsCount + ExtendedColorsCount, Items.Count - 1);
        if not (cbExtendedColors in Style) then
          DeleteRange(StandardColorsCount, StandardColorsCount + ExtendedColorsCount - 1);
        if not (cbStandardColors in Style) then
          DeleteRange(0, StandardColorsCount - 1);
        if cbCustomColor in Style then
          Items.InsertObject(0, SColorBoxCustomCaption, TObject(LCustomColor));
      end;
      if (cbCustomColors in Style) and Assigned(OnGetColors) then
        OnGetColors(Self, Items);
      Selected := LSelectedColor;
    finally
      Items.EndUpdate;
      FNeedToPopulate := False;
    end;
  end
  else
    FNeedToPopulate := True;
end;

procedure TCustomColorListBox.SetDefaultColorColor(const Value: TColor);
begin
  if Value <> FDefaultColorColor then
  begin
    FDefaultColorColor := Value;
    Invalidate;
  end;
end;

procedure TCustomColorListBox.SetNoneColorColor(const Value: TColor);
begin
  if Value <> FNoneColorColor then
  begin
    FNoneColorColor := Value;
    Invalidate;
  end;
end;

procedure TCustomColorListBox.SetSelected(const AColor: TColor);
var
  I, Index: Integer;
begin
  if HandleAllocated then
  begin
    I := Items.IndexOfObject(TObject(AColor));
    if (I = -1) and (cbCustomColor in Style) and (AColor <> NoColorSelected) then
    begin
      Items.Objects[0] := TObject(AColor);
      I := 0;
    end
    else if (cbCustomColor in Style) and (I = 0) then
    begin
      { Look for the color anywhere else but the first color before
        defaulting to selecting the "custom color". }
      for Index := 1 to Items.Count - 1 do
      begin
        if Items.Objects[Index] = TObject(AColor) then
        begin
          I := Index;
          Break;
        end;
      end;
    end;
    if (ItemIndex = 0) and (I = 0) then
      Invalidate { Refresh the color shown }
    else
      ItemIndex := I;
  end;
  FSelectedColor := AColor;
end;

procedure TCustomColorListBox.SetStyle(AStyle: TColorBoxStyle);
begin
  if AStyle <> Style then
  begin
    FStyle := AStyle;
    Enabled := ([cbStandardColors, cbExtendedColors, cbSystemColors,
      cbCustomColor, cbCustomColors] * FStyle) <> [];
    PopulateList;
    if (Items.Count > 0) and (ItemIndex = -1) then
      ItemIndex := 0;
  end;
end;
{$ENDIF RTL2007_L3_UP}

{$IFNDEF RTL2007_L3_UP}
{ TTrayIcon}

constructor TCustomTrayIcon.Create(Owner: TComponent);
begin
  inherited;
  FAnimate := False;
  FBalloonFlags := bfNone;
  BalloonTimeout := 3000;
  FIcon := TIcon.Create;
  FCurrentIcon := TIcon.Create;
  FTimer := TTimer.Create(Nil);
  FIconIndex := 0;
  FVisible := False;
  FIsClicked := False;
  FTimer.Enabled := False;
  FTimer.OnTimer := DoOnAnimate;
  FTimer.Interval := 1000;

  if not (csDesigning in ComponentState) then
  begin
    FillChar(FData, SizeOf(FData), 0);
    FData.cbSize := SizeOf(FData);
    FData.Wnd := Classes.AllocateHwnd(WindowProc);
    FData.uID := FData.Wnd;
    FData.uTimeout := 3000;
    FData.hIcon := FCurrentIcon.Handle;
    FData.uFlags := NIF_ICON or NIF_MESSAGE;
    FData.uCallbackMessage := WM_SYSTEM_TRAY_MESSAGE;
    StrPLCopy(FData.szTip, Application.Title, SizeOf(FData.szTip) - 1);

    if Length(Application.Title) > 0 then
       FData.uFlags := FData.uFlags or NIF_TIP;

    Refresh;
  end;
end;

destructor TCustomTrayIcon.Destroy;
begin
  if not (csDesigning in ComponentState) then
    Refresh(NIM_DELETE);

  FCurrentIcon.Free;
  FIcon.Free;
  FTimer.Free;
  Classes.DeallocateHWnd(FData.Wnd);
  inherited;
end;

procedure TCustomTrayIcon.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    if (not FAnimate) or (FAnimate and FCurrentIcon.Empty) then
      SetDefaultIcon;

    if not (csDesigning in ComponentState) then
    begin
      if FVisible then
      begin
        if not Refresh(NIM_ADD) then
          raise EOutOfResources.Create(STrayIconCreateError);
      end
      else if not (csLoading in ComponentState) then
      begin
        if not Refresh(NIM_DELETE) then
          raise EOutOfResources.Create(STrayIconRemoveError);
      end;
      if FAnimate then
        FTimer.Enabled := Value;
    end;
  end;
end;

procedure TCustomTrayIcon.SetIconList(Value: TImageList);
begin
  FIconList := Value;

  if FIconList = nil then
    SetDefaultIcon;
end;

procedure TCustomTrayIcon.SetHint(const Value: string);
begin
  if CompareStr(FHint, Value) <> 0 then
  begin
    FHint := Value;
    StrPLCopy(FData.szTip, FHint, SizeOf(FData.szTip) - 1);

    if Length(Hint) > 0 then
      FData.uFlags := FData.uFlags or NIF_TIP
    else
      FData.uFlags := FData.uFlags and not NIF_TIP;

    Refresh;
  end;
end;

function TCustomTrayIcon.GetAnimateInterval: Cardinal;
begin
  Result := FTimer.Interval;
end;

procedure TCustomTrayIcon.SetAnimateInterval(Value: Cardinal);
begin
  FTimer.Interval := Value;
end;

procedure TCustomTrayIcon.SetAnimate(Value: Boolean);
begin
  if FAnimate <> Value then
  begin
    FAnimate := Value;
    if not (csDesigning in ComponentState) then
    begin
      if (FIconList <> nil) and (FIconList.Count > 0) and Visible then
        FTimer.Enabled := Value;
      if (not FAnimate) and (not FCurrentIcon.Empty) then
        FIcon.Assign(FCurrentIcon);
    end;
  end;
end;

{ Message handler for the hidden shell notification window. Most messages
  use WM_SYSTEM_TRAY_MESSAGE as the Message ID, with WParam as the ID of the
  shell notify icon data. LParam is a message ID for the actual message, e.g.,
  WM_MOUSEMOVE. Another important message is WM_ENDSESSION, telling the shell
  notify icon to delete itself, so Windows can shut down.

  Send the usual events for the mouse messages. Also interpolate the OnClick
  event when the user clicks the left button, and popup the menu, if there is
  one, for right click events. }
procedure TCustomTrayIcon.WindowProc(var Message: TMessage);

  { Return the state of the shift keys. }
  function ShiftState: TShiftState;
  begin
    Result := [];

    if GetKeyState(VK_SHIFT) < 0 then
      Include(Result, ssShift);
    if GetKeyState(VK_CONTROL) < 0 then
      Include(Result, ssCtrl);
    if GetKeyState(VK_MENU) < 0 then
      Include(Result, ssAlt);
  end;

var
  Point: TPoint;
  Shift: TShiftState;
begin
  case Message.Msg of
    WM_QUERYENDSESSION:
      Message.Result := 1;

    WM_ENDSESSION:
    begin
      if TWmEndSession(Message).EndSession then
        Refresh(NIM_DELETE);
    end;

    WM_SYSTEM_TRAY_MESSAGE:
    begin
      case Message.lParam of
        WM_MOUSEMOVE:
        begin
          if Assigned(FOnMouseMove) then
          begin
            Shift := ShiftState;
            GetCursorPos(Point);
            FOnMouseMove(Self, Shift, Point.X, Point.Y);
          end;
        end;

        WM_LBUTTONDOWN:
        begin
          if Assigned(FOnMouseDown) then
          begin
            Shift := ShiftState + [ssLeft];
            GetCursorPos(Point);
            FOnMouseDown(Self, mbMiddle, Shift, Point.X, Point.Y);
          end;

          FIsClicked := True;
        end;

        WM_LBUTTONUP:
        begin
          Shift := ShiftState + [ssLeft];
          GetCursorPos(Point);
          if FIsClicked and Assigned(FOnClick) then
          begin
            FOnClick(Self);
            FIsClicked := False;
          end;
          if Assigned(FOnMouseUp) then
            FOnMouseUp(Self, mbLeft, Shift, Point.X, Point.Y);
        end;

        WM_RBUTTONDOWN:
        begin
          if Assigned(FOnMouseDown) then
          begin
            Shift := ShiftState + [ssRight];
            GetCursorPos(Point);
            FOnMouseDown(Self, mbRight, Shift, Point.X, Point.Y);
          end;
        end;

        WM_RBUTTONUP:
        begin
          Shift := ShiftState + [ssRight];
          GetCursorPos(Point);
          if Assigned(FOnMouseUp) then
            FOnMouseUp(Self, mbRight, Shift, Point.X, Point.Y);
          if Assigned(FPopupMenu) then
          begin
            SetForegroundWindow(Application.Handle);
            Application.ProcessMessages;
            FPopupMenu.AutoPopup := False;
            FPopupMenu.PopupComponent := Owner;
            FPopupMenu.Popup(Point.x, Point.y);
          end;
        end;

        WM_LBUTTONDBLCLK, WM_MBUTTONDBLCLK, WM_RBUTTONDBLCLK:
          if Assigned(FOnDblClick) then
            FOnDblClick(Self);

        WM_MBUTTONDOWN:
        begin
          if Assigned(FOnMouseDown) then
          begin
            Shift := ShiftState + [ssMiddle];
            GetCursorPos(Point);
            FOnMouseDown(Self, mbMiddle, Shift, Point.X, Point.Y);
          end;
        end;

        WM_MBUTTONUP:
        begin
          if Assigned(FOnMouseUp) then
          begin
            Shift := ShiftState + [ssMiddle];
            GetCursorPos(Point);
            FOnMouseUp(Self, mbMiddle, Shift, Point.X, Point.Y);
          end;
        end;

        NIN_BALLOONHIDE, NIN_BALLOONTIMEOUT:
        begin
          FData.uFlags := FData.uFlags and not NIF_INFO;
        end;
      end;
    end;

    else if (Message.Msg = RM_TaskBarCreated) and Visible then
      Refresh(NIM_ADD);
  end;
end;

procedure TCustomTrayIcon.Refresh;
begin
  if not (csDesigning in ComponentState) then
  begin
    FData.hIcon := FCurrentIcon.Handle;

    if Visible then
      Refresh(NIM_MODIFY);
  end;
end;

function TCustomTrayIcon.Refresh(Message: Integer): Boolean;
begin
  Result := Shell_NotifyIcon(Message, @FData);
end;

procedure TCustomTrayIcon.SetIconIndex(Value: Integer);
begin
  if FIconIndex <> Value then
  begin
    FIconIndex := Value;
    if not (csDesigning in ComponentState) then
    begin
      if Assigned(FIconList) then
        FIconList.GetIcon(FIconIndex, FCurrentIcon);
      Refresh;
    end;
  end;
end;

procedure TCustomTrayIcon.DoOnAnimate(Sender: TObject);
begin
  if Assigned(FOnAnimate) then
    FOnAnimate(Self);
  if Assigned(FIconList) and (FIconIndex < FIconList.Count - 1) then
    IconIndex := FIconIndex + 1
  else
    IconIndex := 0;
  Refresh;
end;

procedure TCustomTrayIcon.SetIcon(Value: TIcon);
begin
  FIcon.Assign(Value);
  FCurrentIcon.Assign(Value);
  Refresh;
end;

procedure TCustomTrayIcon.SetBalloonHint(const Value: string);
begin
  if CompareStr(FBalloonHint, Value) <> 0 then
  begin
    FBalloonHint := Value;
    StrPLCopy(FData.szInfo, FBalloonHint, SizeOf(FData.szInfo) - 1);
    Refresh(NIM_MODIFY);
  end;
end;

procedure TCustomTrayIcon.SetDefaultIcon;
begin
  if not FIcon.Empty then
    FCurrentIcon.Assign(FIcon)
  else
    FCurrentIcon.Assign(Application.Icon);
  Refresh;
end;

procedure TCustomTrayIcon.SetBalloonTimeout(Value: Integer);
begin
  FData.uTimeout := Value;
end;

function TCustomTrayIcon.GetBalloonTimeout: Integer;
begin
  Result := FData.uTimeout;
end;

procedure TCustomTrayIcon.ShowBalloonHint;
begin
  FData.uFlags := FData.uFlags or NIF_INFO;
  FData.dwInfoFlags := Integer(FBalloonFlags);
  Refresh(NIM_MODIFY);
end;

procedure TCustomTrayIcon.SetBalloonTitle(const Value: string);
begin
  if CompareStr(FBalloonTitle, Value) <> 0 then
  begin
    FBalloonTitle := Value;
    StrPLCopy(FData.szInfoTitle, FBalloonTitle, SizeOf(FData.szInfo) - 1);
    Refresh(NIM_MODIFY);
  end;
end;
{$ENDIF RTL2007_L3_UP}

{$if (defined(RTL2007_L3_UP) and (not defined(COMPILETIMES_2ND))) }
{ TCustomFlowPanel }

constructor TCustomFlowPanel.Create(AOwner: TComponent);
begin
  inherited;
  FPadding := TPadding.Create(Self);
  FVerticalAlignment := taVerticalCenter;

end;

destructor TCustomFlowPanel.Destroy;
begin

  FPadding.Free;
  inherited;
end;

function TCustomFlowPanel.GetControlIndex(AControl: TControl): Integer;
begin
//do nothing
end;

procedure TCustomFlowPanel.SetAutoWrap(const Value: Boolean);
begin
  FAutoWrap := Value;
end;

procedure TCustomFlowPanel.SetControlIndex(AControl: TControl;
  Index: Integer);
begin
//do nothing
end;

procedure TCustomFlowPanel.SetFlowStyle(const Value: TFlowStyle);
begin
  FFlowStyle := Value;
end;

{ TCustomGridPanel }

function TCustomGridPanel.AutoAddColumn: TColumnItem;
begin
  Result := FColumnCollection.Add;
  Result.SizeStyle := ssAuto;
  Result.AutoAdded := True;
end;

function TCustomGridPanel.AutoAddRow: TRowItem;
begin
  Result := FRowCollection.Add;
  Result.SizeStyle := ssAuto;
  Result.AutoAdded := True;
end;

procedure TCustomGridPanel.CellIndexToCell(AIndex: Integer; var AColumn,
  ARow: Integer);
begin

end;

function TCustomGridPanel.CellToCellIndex(AColumn, ARow: Integer): Integer;
begin

end;

constructor TCustomGridPanel.Create(AOwner: TComponent);
begin
  inherited;
  FPadding := TPadding.Create(Self);
  FVerticalAlignment := taVerticalCenter;

  FRowCollection := TRowCollection.Create(Self);
  FColumnCollection := TColumnCollection.Create(Self);
  FControlCollection := TControlCollection.Create(Self);
  FRecalcCellSizes := True;
  FRowCollection.Add;
  FRowCollection.Add;
  FColumnCollection.Add;
  FColumnCollection.Add;
end;

destructor TCustomGridPanel.Destroy;
begin
  FreeAndNil(FRowCollection);
  FreeAndNil(FColumnCollection);
  FreeAndNil(FControlCollection);
  FPadding.Free;
  inherited;
end;

function TCustomGridPanel.GetCellCount: Integer;
begin
  Result := FRowCollection.Count * FColumnCollection.Count;
end;

function TCustomGridPanel.GetCellRect(AColumn, ARow: Integer): TRect;
var
  I: Integer;
begin
  Result.Left := 0;
  Result.Top := 0;
  for I := 0 to AColumn - 1 do
    Inc(Result.Left, FColumnCollection[I].Size);
  for I := 0 to ARow - 1 do
    Inc(Result.Top, FRowCollection[I].Size);
  Result.BottomRight := CellSize[AColumn, ARow];
  Inc(Result.Bottom, Result.Top);
  Inc(Result.Right, Result.Left);
end;

function TCustomGridPanel.GetCellSizes(AColumn, ARow: Integer): TPoint;
begin
  Result := Point(FColumnCollection[AColumn].Size, FRowCollection[ARow].Size);
end;

function TCustomGridPanel.GetColumnSpanIndex(AColumn,
  ARow: Integer): Integer;
begin
  Result := AColumn + (ARow * FColumnCollection.Count);
end;

function TCustomGridPanel.GetRowSpanIndex(AColumn, ARow: Integer): Integer;
begin
  Result := ARow + (AColumn * FRowCollection.Count);
end;

function TCustomGridPanel.IsColumnEmpty(AColumn: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  if (AColumn > -1) and (AColumn < FColumnCollection.Count) then
  begin
    for I := 0 to FRowCollection.Count -1 do
      if ControlCollection.Controls[AColumn, I] <> nil then
        Exit;
    Result := True;
  end else
    raise EGridPanelException.CreateFmt(sInvalidColumnIndex, [AColumn]);
end;

function TCustomGridPanel.IsRowEmpty(ARow: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  if (ARow > -1) and (ARow < FRowCollection.Count) then
  begin
    for I := 0 to FColumnCollection.Count -1 do
      if ControlCollection.Controls[I, ARow] <> nil then
        Exit;
    Result := True;
  end else
    raise EGridPanelException.CreateFmt(sInvalidRowIndex, [ARow]);
end;

procedure TCustomGridPanel.RemoveEmptyAutoAddColumns;
var
  I: Integer;
begin
  for I := FColumnCollection.Count - 1 downto 0 do
    if FColumnCollection[I].AutoAdded and IsColumnEmpty(I) then
      FColumnCollection.Delete(I)
    else
      Exit;
end;

procedure TCustomGridPanel.RemoveEmptyAutoAddRows;
var
  I: Integer;
begin
  for I := FRowCollection.Count - 1 downto 0 do
    if FRowCollection[I].AutoAdded and IsRowEmpty(I) then
      FRowCollection.Delete(I)
    else
      Exit;
end;

procedure TCustomGridPanel.SetColumnCollection(
  const Value: TColumnCollection);
begin
  FColumnCollection.Assign(Value);
end;

procedure TCustomGridPanel.SetControlCollection(
  const Value: TControlCollection);
begin
  FControlCollection.Assign(Value);
end;

procedure TCustomGridPanel.SetRowCollection(const Value: TRowCollection);
begin
  FRowCollection.Assign(Value);
end;

procedure TCustomGridPanel.UpdateControlOriginalParentSize(
  AControl: TControl; var AOriginalParentSize: TPoint);
begin

end;

{ TCellItem }

procedure TCellItem.AssignTo(Dest: TPersistent);
begin
  if Dest is TCellItem then
    with TCellItem(Dest) do
    begin
      FSizeStyle := Self.FSizeStyle;
      FValue := Self.FValue;
      FSize := Self.FSize;
    end;
end;

constructor TCellItem.Create(Collection: TCollection);
begin
  inherited;
  FSizeStyle := ssPercent;
end;

procedure TCellItem.SetSizeStyle(Value: TSizeStyle);
begin
  if Value <> FSizeStyle then
  begin
    FSizeStyle := Value;
    Changed(False);
  end;
end;

procedure TCellItem.SetValue(Value: Double);
begin
  if Value <> FValue then
  begin
    if FSizeStyle = ssAbsolute then
    begin
      FSize := Trunc(Value);
      FValue := FSize;
    end else
      FValue := Value;
    Changed(False);
  end;
end;

{ TCellCollection }

function TCellCollection.GetAttr(Index: Integer): string;
begin
  case Index of
    0: Result := sCellMember;
    1: Result := sCellSizeType;
    2: Result := sCellValue;
  else
    Result := '';
  end;
end;

function TCellCollection.GetAttrCount: Integer;
begin
  Result := 3;
end;

function TCellCollection.GetItem(Index: Integer): TCellItem;
begin
  Result := TCellItem(inherited GetItem(Index));
end;

function TCellCollection.GetItemAttr(Index, ItemIndex: Integer): string;

  function GetSizeStyleString(Index: Integer): string;
  begin
    with Items[Index] do
      case SizeStyle of
        ssAbsolute: Result := sCellAbsoluteSize;
        ssPercent: Result := sCellPercentSize;
        ssAuto: Result := sCellAutoSize;
      else
        Result := '';
      end;
  end;

  function GetValueString(Index: Integer): string;
  begin
    with Items[Index] do
      if SizeStyle = ssAbsolute then
        Result := IntToStr(Trunc(Value))
      else if SizeStyle = ssPercent then
        Result := Format('%3.2f%%', [Value]) // do not localize
      else Result := sCellAutoSize;
  end;
begin
  case Index of
    1: Result := GetSizeStyleString(ItemIndex);
    2: Result := GetValueString(ItemIndex);
  else
    Result := '';
  end;
end;

function TCellCollection.Owner: TCustomGridPanel;
begin
  Result := GetOwner as TCustomGridPanel;
end;

procedure TCellCollection.SetItem(Index: Integer; Value: TCellItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TCellCollection.Update(Item: TCollectionItem);
begin
  inherited;
  if Owner <> nil then
    with Owner do
    begin
      FRecalcCellSizes := True;
      Invalidate;
      Realign;
    end;
end;

{ TRowCollection }

function TRowCollection.Add: TRowItem;
begin
  Result := TRowItem(inherited Add);
end;

constructor TRowCollection.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TRowItem);
end;

function TRowCollection.GetItemAttr(Index, ItemIndex: Integer): string;
begin
  if Index = 0 then
    Result := Format(sCellRow, [ItemIndex])
  else
    Result := inherited GetItemAttr(Index, ItemIndex);
end;

procedure TRowCollection.Notify(Item: TCollectionItem;
  Action: TCollectionNotification);
begin
  inherited;
  if (Action = cnExtracting) and not (csDestroying in Owner.ComponentState) and
     not (csUpdating in Owner.ComponentState) and
     not Owner.IsRowEmpty(Item.Index)  then
    raise EGridPanelException.Create(sCannotDeleteRow);
end;

{ TColumnCollection }

function TColumnCollection.Add: TColumnItem;
begin
  Result := TColumnItem(inherited Add);
end;

constructor TColumnCollection.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TColumnItem);
end;

function TColumnCollection.GetItemAttr(Index, ItemIndex: Integer): string;
begin
  if Index = 0 then
    Result := Format(sCellColumn, [ItemIndex])
  else
    Result := inherited GetItemAttr(Index, ItemIndex);
end;

procedure TColumnCollection.Notify(Item: TCollectionItem;
  Action: TCollectionNotification);
begin
  inherited;
  if (Action = cnExtracting) and not (csDestroying in Owner.ComponentState) and
     not (csUpdating in Owner.ComponentState) and
     not Owner.IsColumnEmpty(Item.Index) then
    raise EGridPanelException.Create(sCannotDeleteColumn);
end;

{ TControlItem }

procedure TControlItem.AssignTo(Dest: TPersistent);
begin
  if Dest is TControlItem then
    with TControlItem(Dest) do
    begin
      FControl := Self.Control;
      FRow := Self.Row;
      FColumn := Self.Column;
      Changed(False);
    end;
end;

constructor TControlItem.Create(Collection: TCollection);
begin
  inherited;
  FRowSpan := 1;
  FColumnSpan := 1;
end;

destructor TControlItem.Destroy;
var
  LControl: TControl;
begin
  if Assigned(FControl) and not (csLoading in GridPanel.ComponentState) and
     not (csUpdating in GridPanel.ComponentState) and
     not (csDestroying in GridPanel.ComponentState) then
  begin
    LControl := FControl;
    FControl := nil;
    GridPanel.RemoveControl(LControl);
    LControl.Free;
  end;

  inherited;
end;

function TControlItem.GetGridPanel: TCustomGridPanel;
var
  Owner: TControlCollection;
begin
  Owner := TControlCollection(GetOwner);
  if Owner <> nil then
    Result := Owner.Owner
  else
    Result := nil;
end;

function TControlItem.GetPushed: Boolean;
begin
  Result := FPushed > 0;
end;

procedure TControlItem.InternalSetLocation(AColumn, ARow: Integer; APushed,
  MoveExisting: Boolean);
var
  Collection: TControlCollection;
  CurrentItem: TControlItem;
begin
  if (AColumn <> FColumn) or (ARow <> FRow) then
  begin
    if MoveExisting then
    begin
      Collection := TControlCollection(GetOwner);
      if Collection <> nil then
        CurrentItem := Collection.ControlItems[AColumn, ARow]
      else
        CurrentItem := nil;
      if CurrentItem <> nil then
        CurrentItem.InternalSetLocation(FColumn, FRow, False, False);
    end;
    FColumn := AColumn;
    FRow := ARow;
    if APushed then
      Inc(FPushed)
    else if FPushed > 0 then
      Dec(FPushed);
    Changed(False);
  end;
end;

procedure TControlItem.SetColumn(Value: Integer);
begin
  if FColumn <> Value then
  begin
    if not (csLoading in GridPanel.ComponentState) then
    begin
      if (Value < 0)or (Value > GridPanel.ColumnCollection.Count - 1) then
        raise EGridPanelException.CreateFmt(sInvalidColumnIndex, [Value]);
      InternalSetLocation(Value, FRow, False, True);
    end
    else
      FColumn := Value;
  end;
end;

type
 TNewLocationRec = record
    ControlItem: TControlItem;
    NewColumn, NewRow: Integer;
    Pushed: Boolean;
  end;
  TNewLocationRecs = array of TNewLocationRec;

  TNewLocations = class
  private
    FNewLocations: TNewLocationRecs;
    FCount: Integer;
  public
    function AddNewLocation(AControlItem: TControlItem; ANewColumn, ANewRow: Integer; APushed: Boolean = False): Integer;
    procedure ApplyNewLocations;
    property Count: Integer read FCount;
    property NewLocations: TNewLocationRecs read FNewLocations;
  end;

function TNewLocations.AddNewLocation(AControlItem: TControlItem; ANewColumn, ANewRow: Integer; APushed: Boolean): Integer;
begin
  if FCount = Length(FNewLocations) then
    SetLength(FNewLocations, Length(FNewLocations) + 10);
  Result := FCount;
  Inc(FCount);
  with FNewLocations[Result] do
  begin
    ControlItem := AControlItem;
    NewColumn := ANewColumn;
    NewRow := ANewRow;
    Pushed := APushed;
  end;
end;

procedure TNewLocations.ApplyNewLocations;
var
  I: Integer;
begin
  for I := 0 to FCount - 1 do
    with FNewLocations[I] do
      if ControlItem <> nil then
        ControlItem.InternalSetLocation(NewColumn, NewRow, Pushed, False);
end;

procedure TControlItem.SetColumnSpan(Value: TCellSpan);
var
  I, Delta: Integer;
  Collection: TControlCollection;
  ControlItem: TControlItem;
  NumToAdd, NumColumns, MoveBy, LColumn, LRow, IndexDelta: Integer;
  Span: TCellSpan;
  NewLocations: TNewLocations;
begin
  if FColumnSpan <> Value then
  begin
    if Value < 1 then
      raise EGridPanelException.CreateFmt(sInvalidSpan, [Value]);
    Collection := TControlCollection(GetOwner);
    if Collection = nil then Exit;
    GridPanel.DisableAlign;
    try
      NewLocations := TNewLocations.Create;
      try
        if FColumnSpan > Value then
        begin
          Delta := FColumnSpan - Value;
          FColumnSpan := Value;
          if GridPanel.ExpandStyle in [emAddColumns, emFixedSize] then
          begin
            NumColumns := GridPanel.ColumnCollection.Count;
            // Move the controls to the right back to fill in the space.
            for I := FColumn + FColumnSpan + Delta to NumColumns - 1 do
            begin
              ControlItem := Collection.ControlItems[I, FRow];
              if ControlItem <> nil then
                if ControlItem.Pushed then
                  NewLocations.AddNewLocation(ControlItem, I - Delta, FRow, False)
                else
                  Break;
            end;
            NewLocations.ApplyNewLocations;
            GridPanel.RemoveEmptyAutoAddColumns;
          end else
          begin
            // Scan forward in column primary order, removing Delta from position of each
            // control item, unwrapping where nessesary, until the last control is reached
            // or a non "pushed" control is found.
            for I := GridPanel.ColumnSpanIndex[FColumn, FRow] to GridPanel.CellCount - 1 do
            begin
              GridPanel.CellIndexToCell(I, LColumn, LRow);
              ControlItem := Collection.ControlItems[LColumn, LRow];
              if ControlItem <> nil then
              begin
                if ControlItem.Pushed then
                begin
                  if (ControlItem.Column = LColumn) and (ControlItem.Row = LRow) then
                  begin
                    GridPanel.CellIndexToCell(I - Delta, LColumn, LRow);
                    if (LColumn > 0) and (LColumn + ControlItem.ColumnSpan > GridPanel.ColumnCollection.Count) then
                    begin
                      Inc(Delta, (LColumn + ControlItem.ColumnSpan) - GridPanel.ColumnCollection.Count);
                      GridPanel.CellIndexToCell(I - Delta, LColumn, LRow);
                    end;
                    NewLocations.AddNewLocation(ControlItem, LColumn, LRow, False);
                  end;
                end else if ControlItem <> Self then
                  Break
                else
                  NewLocations.AddNewLocation(ControlItem, LColumn, LRow, False);
              end;
            end;
            NewLocations.ApplyNewLocations;
            GridPanel.RemoveEmptyAutoAddRows;
          end;
        end else
        begin
          NumColumns := GridPanel.ColumnCollection.Count;
          Delta := Value - FColumnSpan;
          // first check if there is room to the right to expand and if so remove those
          // columns from the Delta
          for I := Min(FColumn + FColumnSpan, NumColumns) to Min(FColumn + Value - 1, NumColumns - 1) do
            if Collection.Controls[I, FRow] = nil then
              Dec(Delta)
            else
              Break;
          MoveBy := Delta;
          // Now find out how many columns to add, if any
          for I := NumColumns - 1 downto NumColumns - MoveBy do
            if Collection.Controls[I, FRow] = nil then
              Dec(Delta)
            else
              Break;
          NumToAdd := Delta;
          // Add the columns
          if GridPanel.ExpandStyle in [emAddColumns, emFixedSize] then
          begin
            if (GridPanel.ExpandStyle = emFixedSize) and (NumToAdd > 0) then
              raise EGridPanelException.Create(sCannotAddFixedSize);
            while NumToAdd > 0 do
            begin
              GridPanel.AutoAddColumn;
              Dec(NumToAdd);
            end;
            NumColumns := GridPanel.ColumnCollection.Count;
            for I := NumColumns - 1 downto NumColumns - Delta do
            begin
              ControlItem := Collection.ControlItems[I - MoveBy, FRow];
              if (ControlItem <> nil) and (ControlItem <> Self) then
                NewLocations.AddNewLocation(ControlItem, I, FRow, True);
            end;
            NewLocations.ApplyNewLocations;
          end else if (NumToAdd + MoveBy > 0) then
          begin
            IndexDelta := Max(NumToAdd, Min(MoveBy, NumColumns));
            for I := GridPanel.ColumnSpanIndex[FColumn, FRow] to GridPanel.CellCount - 1 do
            begin
              GridPanel.CellIndexToCell(I, LColumn, LRow);
              ControlItem := Collection.ControlItems[LColumn, LRow];
              if (ControlItem <> nil) and (ControlItem.Column = LColumn) and (ControlItem.Row = LRow) then
              begin
                if ControlItem = Self then
                begin
                  Span := Value;
                  LColumn := FColumn;
                  LRow := FRow;
                end else
                begin
                  Span := ControlItem.ColumnSpan;
                  GridPanel.CellIndexToCell(I + IndexDelta, LColumn, LRow);
                end;
                if LColumn + Span > GridPanel.ColumnCollection.Count then
                begin
                  if LColumn > 0 then
                  begin
                    Inc(IndexDelta, GridPanel.ColumnCollection.Count - LColumn);
                    GridPanel.CellIndexToCell(I + IndexDelta - NumToAdd, LColumn, LRow);
                  end else if ControlItem <> Self then
                  begin
                    Inc(IndexDelta, Min(Span, GridPanel.ColumnCollection.Count));
                    GridPanel.CellIndexToCell(I + IndexDelta, LColumn, LRow);
                  end else if (ControlItem = Self) and (LColumn = 0) then
                    Exit;
                end;
                NumToAdd := 0;
                NewLocations.AddNewLocation(ControlItem, LColumn, LRow, True);
              end;
            end;
            for I := 0 to NewLocations.Count - 1 do
              if NewLocations.NewLocations[I].NewRow > GridPanel.RowCollection.Count - 1 then
                GridPanel.AutoAddRow;
            NewLocations.ApplyNewLocations;
          end;
          FColumnSpan := Value;
        end;
        Changed(False);
      finally
        NewLocations.Free;
      end;
    finally
      GridPanel.EnableAlign;
    end;
  end;
end;

procedure TControlItem.SetControl(Value: TControl);
begin
  if FControl <> Value then
  begin
    if Value = GridPanel then
      raise EGridPanelException.Create(sInvalidControlItem);
    FControl := Value;
    Changed(False);
  end;
end;

procedure TControlItem.SetLocation(AColumn, ARow: Integer;
  APushed: Boolean);
begin
  InternalSetLocation(AColumn, ARow, APushed, True);
end;

procedure TControlItem.SetRow(Value: Integer);
begin
  if FRow <> Value then
  begin
    if not (csLoading in GridPanel.ComponentState) then
    begin
      if (Value < 0) or (Value > GridPanel.RowCollection.Count - 1) then
        raise EGridPanelException.CreateFmt(sInvalidRowIndex, [Value]);
      InternalSetLocation(FColumn, Value, False, True);
    end
    else
      FRow := Value;
  end;
end;

procedure TControlItem.SetRowSpan(Value: TCellSpan);
var
  I, Delta: Integer;
  Collection: TControlCollection;
  ControlItem: TControlItem;
  NumToAdd, NumRows, MoveBy, LColumn, LRow, IndexDelta: Integer;
  Span: TCellSpan;
  NewLocations: TNewLocations;
begin
  if FRowSpan <> Value then
  begin
    if Value < 1 then
      raise EGridPanelException.CreateFmt(sInvalidSpan, [Value]);
    Collection := TControlCollection(GetOwner);
    if Collection = nil then Exit;
    GridPanel.DisableAlign;
    try
      NewLocations := TNewLocations.Create;
      try
        if FRowSpan > Value then
        begin
          Delta := FRowSpan - Value;
          FRowSpan := Value;
          if GridPanel.ExpandStyle in [emAddRows, emFixedSize] then
          begin
            NumRows := GridPanel.RowCollection.Count;
            // Move the controls below up to fill in the space.
            for I := FRow + FRowSpan + Delta to NumRows - 1 do
            begin
              ControlItem := Collection.ControlItems[FColumn, I];
              if ControlItem <> nil then
                if ControlItem.Pushed then
                  NewLocations.AddNewLocation(ControlItem, FColumn, I - Delta, False)
                else
                  Break;
            end;
            NewLocations.ApplyNewLocations;
            GridPanel.RemoveEmptyAutoAddRows;
          end else
          begin
            // Scan forward in row primary order, removing Delta from position of each
            // control item, unwrapping where nessesary, until the last control is reached
            // or a non "pushed" control is found.
            for I := GridPanel.RowSpanIndex[FColumn, FRow] to GridPanel.CellCount - 1 do
            begin
              GridPanel.CellIndexToCell(I, LColumn, LRow);
              ControlItem := Collection.ControlItems[LColumn, LRow];
              if ControlItem <> nil then
              begin
                if ControlItem.Pushed then
                begin
                  if (ControlItem.Column = LColumn) and (ControlItem.Row = LRow) then
                  begin
                    GridPanel.CellIndexToCell(I - Delta, LColumn, LRow);
                    if (LRow > 0) and (LRow + ControlItem.RowSpan > GridPanel.RowCollection.Count) then
                    begin
                      Inc(Delta, (LRow + ControlItem.RowSpan) - GridPanel.RowCollection.Count);
                      GridPanel.CellIndexToCell(I - Delta, LColumn, LRow);
                    end;
                    NewLocations.AddNewLocation(ControlItem, LColumn, LRow, False);
                  end;
                end else if ControlItem <> Self then
                  Break
                else
                  NewLocations.AddNewLocation(ControlItem, LColumn, LRow, False);
              end;
            end;
            NewLocations.ApplyNewLocations;
            GridPanel.RemoveEmptyAutoAddRows;
          end;
        end else
        begin
          NumRows := GridPanel.RowCollection.Count;
          Delta := Value - FRowSpan;
          // first check if there is room down to expand and if so remove those
          // rows from the Delta
          for I := Min(FRow + FRowSpan, NumRows) to Min(FRow + Value - 1, NumRows - 1) do
            if Collection.Controls[FColumn, I] = nil then
              Dec(Delta)
            else
              Break;
          MoveBy := Delta;
          // Now find out how many rows to add, if any
          for I := NumRows - 1 downto NumRows - MoveBy do
            if Collection.Controls[FColumn, I] = nil then
              Dec(Delta)
            else
              Break;
          NumToAdd := Delta;
          // Add the rows
          if GridPanel.ExpandStyle in [emAddRows, emFixedSize] then
          begin
            if (GridPanel.ExpandStyle = emFixedSize) and (NumToAdd > 0) then
              raise EGridPanelException.Create(sCannotAddFixedSize);
            while NumToAdd > 0 do
            begin
              GridPanel.AutoAddRow;
              Dec(NumToAdd);
            end;
            NumRows := GridPanel.RowCollection.Count;
            for I := NumRows - 1 downto NumRows - Delta do
            begin
              ControlItem := Collection.ControlItems[FColumn, I - MoveBy];
              if (ControlItem <> nil) and (ControlItem <> Self) then
                NewLocations.AddNewLocation(ControlItem, FColumn, I, True);
            end;
            NewLocations.ApplyNewLocations;
          end else if (NumToAdd + MoveBy) > 0 then
          begin
            IndexDelta := Max(NumToAdd, Min(MoveBy, NumRows));
            for I := GridPanel.RowSpanIndex[FColumn, FRow] to GridPanel.CellCount - 1 do
            begin
              GridPanel.CellIndexToCell(I, LColumn, LRow);
              ControlItem := Collection.ControlItems[LColumn, LRow];
              if (ControlItem <> nil) and (ControlItem.Column = LColumn) and (ControlItem.Row = LRow) then
              begin
                if ControlItem = Self then
                begin
                  Span := Value;
                  LColumn := FColumn;
                  LRow := FRow;
                end else
                begin
                  Span := ControlItem.RowSpan;
                  GridPanel.CellIndexToCell(I + IndexDelta, LColumn, LRow);
                end;
                if LRow + Span > GridPanel.RowCollection.Count then
                begin
                  if LRow > 0 then
                  begin
                    Inc(IndexDelta, GridPanel.RowCollection.Count - LRow);
                    GridPanel.CellIndexToCell(I + IndexDelta - NumToAdd, LColumn, LRow);
                  end else if ControlItem <> Self then
                  begin
                    Inc(IndexDelta, Min(Span, GridPanel.RowCollection.Count));
                    GridPanel.CellIndexToCell(I + IndexDelta, LColumn, LRow);
                  end else if (ControlItem = Self) and (LRow = 0) then
                    Exit;
                end;
                NumToAdd := 0;
                NewLocations.AddNewLocation(ControlItem, LColumn, LRow, True);
              end;
            end;
            for I := 0 to NewLocations.Count - 1 do
              if NewLocations.NewLocations[I].NewColumn > GridPanel.ColumnCollection.Count - 1 then
                GridPanel.AutoAddColumn;
            NewLocations.ApplyNewLocations;
          end;
          FRowSpan := Value;
        end;
        Changed(False);
      finally
        NewLocations.Free;
      end;
    finally
      GridPanel.EnableAlign;
    end;
  end;
end;

{ TControlCollection }

function TControlCollection.Add: TControlItem;
begin
  Result := TControlItem(inherited Add);
end;

procedure TControlCollection.AddControl(AControl: TControl; AColumn,
  ARow: Integer);

  procedure PlaceInCell(ControlItem: TControlItem);
  var
    I, J: Integer;
  begin
    with ControlItem do
    try
      Control := AControl;
      FRow := -1;
      FColumn := -1;
      if (ARow = -1) and (AColumn > -1) then
      begin
        for I := 0 to Owner.RowCollection.Count - 1 do
          if Controls[I, AColumn] = nil then
          begin
            Row := I;
            Column := AColumn;
            Exit;
          end;
        AColumn := -1;
      end;
      if (AColumn = -1) and (ARow > -1) then
      begin
        for I := 0 to Owner.ColumnCollection.Count - 1 do
          if Controls[ARow, I] = nil then
          begin
            Column := I;
            Row := ARow;
            Exit;
          end;
        ARow := -1;
      end;
      if (ARow = -1) and (AColumn = -1) then
      begin
        for J := 0 to Owner.RowCollection.Count - 1 do
          for I := 0 to Owner.ColumnCollection.Count - 1 do
            if Controls[I, J] = nil then
            begin
              Row := J;
              Column := I;
              Exit;
            end;
      end;
      if (Row = -1) or (Column = -1) then
        if (Owner <> nil) and (Owner.ExpandStyle <> emFixedSize) then
        begin
          if Owner.ExpandStyle = emAddRows then
            Owner.AutoAddRow
          else
            Owner.AutoAddColumn;
          PlaceInCell(ControlItem);
        end else
          raise EGridPanelException.Create(sCannotAddFixedSize);
    except
      Control := nil;
      Free;
      raise;
    end;
  end;

begin
  if IndexOf(AControl) < 0 then
    PlaceInCell(Add);
end;

constructor TControlCollection.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TControlItem);
end;

function TControlCollection.GetControl(AColumn, ARow: Integer): TControl;
var
  ControlItem: TControlItem;
begin
  ControlItem := GetControlItem(AColumn, ARow);
  if ControlItem <> nil then
    Result := ControlItem.Control
  else
    Result := nil;
end;

function TControlCollection.GetControlItem(AColumn,
  ARow: Integer): TControlItem;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    Result := TControlItem(Items[I]);
    if (ARow >= Result.Row) and (ARow <= Result.Row + Result.RowSpan - 1) and
      (AColumn >= Result.Column) and (AColumn <= Result.Column + Result.ColumnSpan - 1) then
      Exit;
  end;
  Result := nil;
end;

function TControlCollection.GetItem(Index: Integer): TControlItem;
begin
  Result := TControlItem(inherited GetItem(Index));
end;

function TControlCollection.IndexOf(AControl: TControl): Integer;
begin
  for Result := 0 to Count - 1 do
    if TControlItem(Items[Result]).Control = AControl then
      Exit;
  Result := -1;
end;

function TControlCollection.Owner: TCustomGridPanel;
begin
  Result := TCustomGridPanel(GetOwner);
end;

procedure TControlCollection.RemoveControl(AControl: TControl);
var
  I: Integer;
begin
  for I := Count - 1 downto 0 do
    if Items[I].Control = AControl then
    begin
      Items[I].Control := nil;
      Delete(I);
      Exit;
    end;
end;

procedure TControlCollection.SetControl(AColumn, ARow: Integer;
  Value: TControl);
var
  Index: Integer;
  ControlItem: TControlItem;
begin
  if Owner <> nil then
  begin
    if (AColumn < 0) or (AColumn >= Owner.ColumnCollection.Count) then
      raise EGridPanelException.CreateFmt(sInvalidColumnIndex, [AColumn]);
    if (ARow < 0) or (ARow >= Owner.RowCollection.Count) then
      raise EGridPanelException.CreateFmt(sInvalidRowIndex, [ARow]);
    Index := IndexOf(Value);
    if Index > -1 then
    begin
      ControlItem := Items[Index];
      ControlItem.FColumn := AColumn;
      ControlItem.FRow := ARow;
    end else
      AddControl(Value, AColumn, ARow);
  end;
end;

procedure TControlCollection.SetItem(Index: Integer; Value: TControlItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TControlCollection.Update(Item: TCollectionItem);
begin
  inherited;
  if Owner <> nil then
  begin
    Owner.FRecalcCellSizes := True;
    Owner.Invalidate;
    Owner.Realign;
  end;
end;
{$ifend (defined(RTL2007_L3_UP) and (not defined(COMPILETIMES_2ND))) }

{$ifend not (defined(RTL2007_L3_UP) and defined(COMPILETIMES_2ND)) }

{$IFNDEF RTL2007_L2_UP}
{ TCustomLinkLabel }

{from commctrl.pas-d1010}
// ====== SysLink control =========================================

const
  { For Windows >= XP }
  {$EXTERNALSYM INVALID_LINK_INDEX}
  INVALID_LINK_INDEX  = -1;
  {$EXTERNALSYM MAX_LINKID_TEXT}
  MAX_LINKID_TEXT     = 48;
  {$EXTERNALSYM L_MAX_URL_LENGTH}
  L_MAX_URL_LENGTH    = 2048 + 32 + sizeof('://');

  { For Windows >= XP }
  {$EXTERNALSYM WC_LINK}
  WC_LINK         = 'SysLink';

  { For Windows >= XP }
  {$EXTERNALSYM LWS_TRANSPARENT}
  LWS_TRANSPARENT     = $0001;
  {$EXTERNALSYM LWS_IGNORERETURN}
  LWS_IGNORERETURN    = $0002;
  { For Windows >= Vista }
  {$EXTERNALSYM LWS_NOPREFIX}
  LWS_NOPREFIX        = $0004;
  {$EXTERNALSYM LWS_USEVISUALSTYLE}
  LWS_USEVISUALSTYLE  = $0008;
  {$EXTERNALSYM LWS_USECUSTOMTEXT}
  LWS_USECUSTOMTEXT   = $0010;
  {$EXTERNALSYM LWS_RIGHT}
  LWS_RIGHT           = $0020;

  { For Windows >= XP }
  {$EXTERNALSYM LIF_ITEMINDEX}
  LIF_ITEMINDEX    = $00000001;
  {$EXTERNALSYM LIF_STATE}
  LIF_STATE        = $00000002;
  {$EXTERNALSYM LIF_ITEMID}
  LIF_ITEMID       = $00000004;
  {$EXTERNALSYM LIF_URL}
  LIF_URL          = $00000008;

  { For Windows >= XP }
  {$EXTERNALSYM LIS_FOCUSED}
  LIS_FOCUSED         = $00000001;
  {$EXTERNALSYM LIS_ENABLED}
  LIS_ENABLED         = $00000002;
  {$EXTERNALSYM LIS_VISITED}
  LIS_VISITED         = $00000004;
  { For Windows >= Vista }
  {$EXTERNALSYM LIS_HOTTRACK}
  LIS_HOTTRACK        = $00000008;
  {$EXTERNALSYM LIS_DEFAULTCOLORS}
  LIS_DEFAULTCOLORS   = $00000010; // Don't use any custom text colors

type
  { For Windows >= XP }
  { $EXTERNALSYM tagLITEM}
  tagLITEM = record
    mask: UINT;
    iLink: Integer;
    state: UINT;
    stateMask: UINT;
    szID: packed array[0..MAX_LINKID_TEXT-1] of WCHAR;
    szUrl: packed array[0..L_MAX_URL_LENGTH-1] of WCHAR;
  end;
  PLItem = ^TLItem;
  TLItem = tagLITEM;

  { For Windows >= XP }
  { $EXTERNALSYM tagLHITTESTINFO}
  tagLHITTESTINFO = record
    pt: TPoint;
    item: TLItem;
  end;
  PLHitTestInfo = ^TLHitTestInfo;
  TLHitTestInfo = tagLHITTESTINFO;

  { For Windows >= XP }
  { $EXTERNALSYM tagNMLINK}
  tagNMLINK = record
    hdr: NMHDR;
    item: TLItem;
  end;
  PNMLink = ^TNMLink;
  TNMLink = tagNMLINK;

//  LinkWindow messages
const
  { For Windows >= XP }
  {$EXTERNALSYM LM_HITTEST}
  LM_HITTEST         = WM_USER+$300;    // wParam: n/a, lparam: PLHITTESTINFO, ret: BOOL
  {$EXTERNALSYM LM_GETIDEALHEIGHT}
  LM_GETIDEALHEIGHT  = WM_USER+$301;    // wParam: cxMaxWidth, lparam: n/a, ret: cy
  {$EXTERNALSYM LM_SETITEM}
  LM_SETITEM         = WM_USER+$302;    // wParam: n/a, lparam: LITEM*, ret: BOOL
  {$EXTERNALSYM LM_GETITEM}
  LM_GETITEM         = WM_USER+$303;    // wParam: n/a, lparam: LITEM*, ret: BOOL
  {$EXTERNALSYM LM_GETIDEALSIZE}
  LM_GETIDEALSIZE    = LM_GETIDEALHEIGHT;   // wParam: cxMaxWidth, lparam: SIZE*, ret: cy

{$ENDIF RTL2007_L2_UP}

{from windows.pas -d1010}
const
  RT_MANIFEST     = MakeIntResource(24);
  {$EXTERNALSYM RT_MANIFEST}
  CREATEPROCESS_MANIFEST_RESOURCE_ID                 = MakeIntResource(1);
  {$EXTERNALSYM CREATEPROCESS_MANIFEST_RESOURCE_ID}

{from messages.pas -d1010}

function SendGetStructMessage(Handle: HWND; Msg: UINT; WParam: WPARAM;
  var LParam; Unused: Boolean = False): LRESULT;
begin
  Result := SendMessage(Handle, Msg, WParam, Windows.LPARAM(@LParam));
end;

{from sysutils.pas-d1010}
function CharInSet(C: AnsiChar; const CharSet: TSysCharSet): Boolean;
begin
  Result := C in CharSet;
end;

{ TCustomLinkLabel }

constructor TCustomLinkLabel.Create(AOwner: TComponent);
begin
  inherited;
  FAlignment := taLeftJustify;
  FAutoSize := True;
  FUseVisualStyle := False;
  Width := 53;
  Height := 17;
end;

procedure TCustomLinkLabel.AdjustBounds;
var
  DC: HDC;
  SaveFont: HFont;
  TextSize: TSize;
  Parsed: string;
begin
  if not (csLoading in ComponentState) and FAutoSize then
  begin
    if CheckWin32Version(6) and UseThemes then
    begin
      if HandleAllocated then
      begin
        SendGetStructMessage(Handle, LM_GETIDEALSIZE, MaxInt, TextSize);
        SetBounds(Left, Top, TextSize.cx + (GetSystemMetrics(SM_CXBORDER) * 4),
          TextSize.cy + (GetSystemMetrics(SM_CYBORDER) * 4));
      end;
    end
    else
    begin
      DC := GetDC(0);
      try
        SaveFont := SelectObject(DC, Font.Handle);
        try
          if CheckWin32Version(5, 1) and UseThemes then
          begin
            Parsed := ParseLinks;
            GetTextExtentPoint32(DC, PAnsiChar(Parsed), Length(Parsed), TextSize);
          end
          else
            GetTextExtentPoint32(DC, PAnsiChar(Caption), Length(Caption), TextSize);
        finally
          SelectObject(DC, SaveFont);
        end;
      finally
        ReleaseDC(0, DC);
      end;
      SetBounds(Left, Top, TextSize.cx + (GetSystemMetrics(SM_CXBORDER) * 4),
        TextSize.cy + (GetSystemMetrics(SM_CYBORDER) * 4));
    end;
  end;
end;

procedure TCustomLinkLabel.CreateParams(var Params: TCreateParams);
const
  LinkAlignments: array[Boolean, TLinkAlignment] of DWORD =
    ((0, LWS_RIGHT), (LWS_RIGHT, 0));
  TextAlignments: array[Boolean, TLinkAlignment] of DWORD =
    ((SS_LEFT, SS_RIGHT), (SS_RIGHT, SS_LEFT));
  VisualStyles: array[Boolean] of DWORD = (0, LWS_USEVISUALSTYLE);
var
  LStyle: DWORD;
begin
  inherited CreateParams(Params);
  if (((CheckWin32Version(5, 1) and UseThemes))) then
  begin
    CreateSubClass(Params, WC_LINK);
    LStyle := LinkAlignments[UseRightToLeftAlignment, FAlignment] or
      VisualStyles[FUseVisualStyle];
  end
  else
  begin
    CreateSubClass(Params, 'STATIC');
    LStyle := TextAlignments[UseRightToLeftAlignment, FAlignment];
  end;
  with Params do
  begin
    Style := Style or LStyle;
    WindowClass.style := WindowClass.style and not CS_VREDRAW;
  end;
end;

procedure TCustomLinkLabel.CreateWnd;
begin
  inherited;
  AdjustBounds;
end;

procedure TCustomLinkLabel.CMFontChanged(var Message: TMessage);
begin
  inherited;
  AdjustBounds;
end;

procedure TCustomLinkLabel.CMTextChanged(var Message: TMessage);
begin
  inherited;
  AdjustBounds;
  Invalidate;
end;

procedure TCustomLinkLabel.CMNotify(var Message: TWMNotify);
var
  Item: TLItem;
begin
  case Message.NMHdr.code of
    NM_CLICK, NM_RETURN:
    begin
      Item := PNMLink(Message.NMHdr).item;

      if Item.szID = '' then
        DoOnLinkClick(Item.szUrl, sltURL)
      else
        DoOnLinkClick(Item.szID, sltID);
    end;
  end;
end;

procedure TCustomLinkLabel.DoOnLinkClick(const Link: string; LinkType: TSysLinkType);
begin
  if Assigned(FOnLinkClick) then
    FOnLinkClick(Self, Link, LinkType);
end;

type
  TParseSearchMode = (psmLinkStart, psmLinkEnd);

function TCustomLinkLabel.ParseLinks: string;
var
  Pos, LookAhead, Last, I: Integer;
  SearchMode: TParseSearchMode;
  Len: Integer;
begin
  if Length(Caption) = 0 then
  begin
    Result := '';
    Exit;
  end;

  SetLength(Result, Length(Caption));
  Pos := 1;
  SearchMode := psmLinkStart;
  Len := 0;
  Last := Length(Caption);

  while Pos <= Last do
  begin
    case Caption[Pos] of
      '<': //do not localize
      begin
        LookAhead := Pos;

        if Pos = Last then
        begin
          Inc(Len);
          Result[Len] := Caption[Pos];
          Break;
        end;

        Inc(LookAhead);
        if SearchMode = psmLinkStart then
        begin
          if CharInSet(Caption[LookAhead], ['a', 'A']) then //do not localize
          begin
            while (Caption[LookAhead] <> '>') and (LookAhead <= Last) do //do not localize
              Inc(LookAhead);

            if LookAhead > Last then
            begin
              for I := 0 to LookAhead - Pos - 1 do
                Result[Len + 1 + I] := Caption[Pos + I];
              Inc(Len, LookAhead - Pos);
              Break;
            end
            else //LookAhead > Last
            begin
              Pos := LookAhead + 1;
              SearchMode := psmLinkEnd;
            end;
          end
          else //CharInSet(LookAhead^, ['a', 'A'])
          begin
            Inc(Len);
            Result[Len] := Caption[Pos];
            Inc(Pos);
          end;
        end
        else //SearchMode = psmLinkStart
        begin
          //A bit of an ugly way to do this, but its fast
          if (Caption[LookAhead] = '/') and //do not localize
             (CharInSet(Caption[LookAhead + 1], ['a', 'A'])) and //do not localize
             (Caption[LookAhead + 2] = '>') then //do not localize
          begin
            Inc(Pos, 4);
            SearchMode := psmLinkStart;
          end
          else
          begin
            Inc(Len);
            Result[Len] := Caption[Pos];
            Inc(Pos);
          end;
        end;
      end
      else
      begin
        Inc(Len);
        Result[Len] := Caption[Pos];
        Inc(Pos);
      end;
    end;
  end;

  SetLength(Result, Len);
end;

procedure TCustomLinkLabel.SetAlignment(const Value: TLinkAlignment);
begin
  if Value <> FAlignment then
  begin
    FAlignment := Value;
    if HandleAllocated then
      RecreateWnd;
  end;
end;

procedure TCustomLinkLabel.SetAutoSize(Value: Boolean);
begin
  if FAutoSize <> Value then
  begin
    FAutoSize := Value;
    if Value then AdjustBounds;
  end;
end;

procedure TCustomLinkLabel.SetUseVisualStyle(const Value: Boolean);
begin
  if Value <> FUseVisualStyle then
  begin
    FUseVisualStyle := Value;
    if HandleAllocated then
      RecreateWnd;
  end;
end;

var
  ManifestResourcePresent: Boolean;
  ManifestResourceTested: Boolean = False;

function IsLinkLabelSupported: Boolean;
begin
  if not ManifestResourceTested then
  begin
    ManifestResourcePresent := FindResource(MainInstance,
      CREATEPROCESS_MANIFEST_RESOURCE_ID, RT_MANIFEST) <> 0;
    ManifestResourceTested := True;
  end;
  Result := ManifestResourcePresent and ThemeServices.ThemesAvailable;
end;

function TCustomLinkLabel.UseThemes: Boolean;
begin
  Result := IsLinkLabelSupported;
end;

procedure TCustomLinkLabel.SetParent(AParent: TWinControl);
begin
  inherited;
  if Assigned(AParent) then
    AParent.DoubleBuffered := False;
end;

initialization
{$if not (defined(RTL2007_L3_UP) and defined(COMPILETIMES_2ND)) }
{$IFNDEF RTL2007_L3_UP}
 {from forms.pas}
  RM_TaskBarCreated := RegisterWindowMessage('TaskbarCreated');
{$ENDIF RTL2007_L3_UP}

{$ifend not (defined(RTL2007_L3_UP) and defined(COMPILETIMES_2ND)) }

end.
