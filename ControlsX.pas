unit ControlsX;
{$P+,S-,W-,R-,T-,H+,X+}
{ WARN SYMBOL_PLATFORM OFF}
{$C PRELOAD}

interface

uses
  Messages, Windows, MultiMon, Classes, SysUtils, Graphics, Menus, CommCtrl,
  Imm, ImgList, ActnList
  ,Controls
  ;

{$if not (defined(RTL2007_L3_UP) and defined(COMPILETIMES_2ND)) }
  {from controls.pas}
type
  TMouseActivate = (maDefault, maActivate, maActivateAndEat, maNoActivate, maNoActivateAndEat);
  TMouseActivateEvent = procedure(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer; HitTest: Integer; var MouseActivate: TMouseActivate) of object;

  TAlignInsertBeforeEvent = function(Sender: TWinControl; C1, C2: TControl): Boolean of object;
  TAlignPositionEvent = procedure(Sender: TWinControl; Control: TControl;
    var NewLeft, NewTop, NewWidth, NewHeight: Integer;
    var AlignRect: TRect; AlignInfo: TAlignInfo) of Object;

  TMarginSize = 0..MaxInt;
  TMargins = class(TPersistent)
  private
    FControl: TControl;
    FLeft, FTop, FRight, FBottom: TMarginSize;
    FOnChange: TNotifyEvent;
    procedure SetMargin(Index: Integer; Value: TMarginSize);
  protected
    procedure Change; virtual;
    procedure AssignTo(Dest: TPersistent); override;
    function GetControlBound(Index: Integer): Integer; virtual;
    procedure InitDefaults(Margins: TMargins); virtual;
    property Control: TControl read FControl;
  public
    constructor Create(Control: TControl); virtual;
    procedure SetControlBounds(ALeft, ATop, AWidth, AHeight: Integer; Aligning: Boolean = False); overload;
    procedure SetControlBounds(const ARect: TRect; Aligning: Boolean = False); overload;
    procedure SetBounds(ALeft, ATop, ARight, ABottom: Integer);
    property ControlLeft: Integer index 0 read GetControlBound;
    property ControlTop: Integer index 1 read GetControlBound;
    property ControlWidth: Integer index 2 read GetControlBound;
    property ControlHeight: Integer index 3 read GetControlBound;
    property ExplicitLeft: Integer index 4 read GetControlBound;
    property ExplicitTop: Integer index 5 read GetControlBound;
    property ExplicitWidth: Integer index 6 read GetControlBound;
    property ExplicitHeight: Integer index 7 read GetControlBound;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property Left: TMarginSize index 0 read FLeft write SetMargin default 3;
    property Top: TMarginSize index 1 read FTop write SetMargin default 3;
    property Right: TMarginSize index 2 read FRight write SetMargin default 3;
    property Bottom: TMarginSize index 3 read FBottom write SetMargin default 3;
  end;

  TPadding = class(TMargins)
  protected
    procedure InitDefaults(Margins: TMargins); override;
  published
    property Left default 0;
    property Top default 0;
    property Right default 0;
    property Bottom default 0;
  end;

  TCustomTransparentControl = class(TCustomControl)
  private
    FInterceptMouse: Boolean;
  protected
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure InvalidateControlsUnderneath;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Invalidate; override;
    property InterceptMouse: Boolean read FInterceptMouse write FInterceptMouse default False;
  end;
{$ifend not (defined(RTL2007_L3_UP) and defined(COMPILETIMES_2ND)) }

{$IFNDEF RTL2007_L3_UP}
type
  PControlListItem = ^TControlListItem;
  TControlListItem = record
    Control: TControl;
    Parent: TWinControl;
  end;

  TCMControlListChanging = record
    Msg: Cardinal;
    ControlListItem: PControlListItem;
    Inserting: LongBool;
    Result: Longint;
  end;
const
  CM_CONTROLLISTCHANGING    = CM_BASE + 76;

{$ENDIF RTL2007_L3_UP}

implementation

{$if not (defined(RTL2007_L3_UP) and defined(COMPILETIMES_2ND)) }

uses
  Consts, Forms, ActiveX, Math, Themes, UxTheme;

{ TMargins }

procedure TMargins.AssignTo(Dest: TPersistent);
begin
  if Dest is TMargins then
    with TMargins(Dest) do
    begin
      FLeft := Self.FLeft;
      FTop := Self.FTop;
      FRight := Self.FRight;
      FBottom := Self.FBottom;
      Change;
    end
  else
    inherited;
end;

procedure TMargins.Change;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

constructor TMargins.Create(Control: TControl);
begin
  FControl := Control;
  InitDefaults(Self);
end;

function TMargins.GetControlBound(Index: Integer): Integer;
begin
//do nothing
end;

procedure TMargins.InitDefaults(Margins: TMargins);
begin
  with Margins do
  begin
    FLeft := 3;
    FRight := 3;
    FTop := 3;
    FBottom := 3;
  end;
end;

procedure TMargins.SetBounds(ALeft, ATop, ARight, ABottom: Integer);
begin
  if (FLeft <> ALeft) or (FTop <> ATop) or (FRight <> ARight) or (FBottom <> ABottom) then
  begin
    FLeft := ALeft;
    FTop := ATop;
    FRight := ARight;
    FBottom := ABottom;
    Change;
  end;
end;

procedure TMargins.SetControlBounds(const ARect: TRect; Aligning: Boolean);
begin
  SetControlBounds(ARect.Left, ARect.Top, ARect.Right - ARect.Left, ARect.Bottom - ARect.Top, Aligning);
end;

procedure TMargins.SetControlBounds(ALeft, ATop, AWidth, AHeight: Integer;
  Aligning: Boolean);
begin
//do nothing
end;

procedure TMargins.SetMargin(Index: Integer; Value: TMarginSize);
begin
  case Index of
    0:
      if Value <> FLeft then
      begin
        FLeft := Value;
        Change;
      end;
    1:
      if Value <> FTop then
      begin
        FTop := Value;
        Change;
      end;
    2:
      if Value <> FRight then
      begin
        FRight := Value;
        Change;
      end;
    3:
      if Value <> FBottom then
      begin
        FBottom := Value;
        Change;
      end;
  end;
end;
{ TPadding }

procedure TPadding.InitDefaults(Margins: TMargins);
begin
  { Zero initialization is sufficient here }
end;


{ TCustomTransparentControl }

constructor TCustomTransparentControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csOpaque];
  Brush.Style := bsClear;
end;

procedure TCustomTransparentControl.InvalidateControlsUnderneath;
var
  I: Integer;
  Invalidating: Boolean;
  Control: TControl;

  procedure DoInvalidate(AControl: TControl);
  var
    I: Integer;
    Control: TControl;
  begin
    if AControl is TWinControl then
    begin
      if TWinControl(AControl).HandleAllocated then
        with TWinControl(AControl) do
        begin
          RedrawWindow(Handle, nil, 0, RDW_INVALIDATE or RDW_FRAME);
          InvalidateRect(Handle, nil, True);
        end;
      if (csAcceptsControls in AControl.ControlStyle) then
        for I := 0 to TWinControl(AControl).ControlCount - 1 do
        begin
          Control := TWinControl(AControl).Controls[I];
          DoInvalidate(Control);
        end;
    end else
      AControl.Invalidate;
  end;

begin
  Invalidating := False;
  if HandleAllocated then
  begin
    for I := Parent.ControlCount - 1 downto 0 do
    begin
      Control := Parent.Controls[I];
      if Invalidating then
        DoInvalidate(Control)
      else if Control = Self then
        Invalidating := True;
    end;
    InvalidateRect(Parent.Handle, nil, True);
  end;
end;

procedure TCustomTransparentControl.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_TRANSPARENT;
end;

procedure TCustomTransparentControl.WMNCHitTest(var Message: TWMNCHitTest);
begin
  if not FInterceptMouse then
    Message.Result := HTTRANSPARENT
  else
    inherited;
end;

procedure TCustomTransparentControl.Invalidate;
begin
  InvalidateControlsUnderneath;
  inherited Invalidate;
end;
{$ifend not (defined(RTL2007_L3_UP) and defined(COMPILETIMES_2ND)) }

end.

