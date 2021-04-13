{ ***************************************************** }
{                                                       }
{       Delphi Visual Component Library                 }
{       Notification icon taskbar component             }
{                                                       }
{       Copyright (c) 2006, eCat                        }
{                                                       }
{ ***************************************************** }

unit NotifyIcon;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, ImgList, Menus;

{ API definitions }

type
  PNotifyIconData = ^TNotifyIconData;
  TNotifyIconData = record
    cbSize: DWORD;
    hWnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
    szTip: array[0..127] of AnsiChar;
    dwState: DWORD;
    dwStateMask: DWORD;
    szInfo: array[0..255] of AnsiChar;
  case Integer of
  1: (
    uTimeout: UINT);
  2: (
    uVersion: UINT;
    szInfoTitle: array[0..63] of AnsiChar;
    dwInfoFlags: DWORD;
    guidItem: TGUID);
  end;

  TNotifyIconMessage = (nimAdd, nimModify, nimDelete, nimSetFocus, nimSetVersion);

  TNotifyIconFlag = (nifMessage, nifIcon, nifTip, nifState, nifInfo, nifGUID);
  TNotifyIconFlags = set of TNotifyIconFlag;

  TNotifyIconStateFlag = (nisHidden, nisSharedIcon);
  TNotifyIconState = set of TNotifyIconStateFlag;

  TBalloonTimeoutSecs = 10..30;

  TBalloonIconType = (biNone, biInfo, biWarning, biError, biUser);

  TWMNAreaNotify = packed record
    Msg: Cardinal;
    IconID: Cardinal;
    NotifyMsg: Cardinal;
    Result: Longint;
  end;

const
  NOTIFYICON_VERSION = 3;

  NIN_SELECT           = WM_USER + 0;
  NINF_KEY             = $1;
  NIN_KEYSELECT        = NIN_SELECT or NINF_KEY;
  NIN_BALLOONSHOW      = WM_USER + 2;
  NIN_BALLOONHIDE      = WM_USER + 3;
  NIN_BALLOONTIMEOUT   = WM_USER + 4;
  NIN_BALLOONUSERCLICK = WM_USER + 5;

  NIIF_IconBitsOffset   = 0;
  NIIF_NoSoundBitOffset = 4;

function Shell_NotifyIcon(dwMessage: DWORD; lpData: PNotifyIconData): BOOL; stdcall;

{ TNotifyIcon component }

const
  WM_NAREANOTIFY = WM_USER + 0;

type

{ Exception class for unsuccessful attempts to operate on icon }

  ENotifyIconError = class(Exception);

  TNotifyIcon = class;

{ Balloon ToolTip for icon }

  TInfoBalloon = class(TPersistent)
  private
    FControl: TNotifyIcon;
    FText: string;
    FTimeout: TBalloonTimeoutSecs;
    FTitle: string;
    FIcon: TBalloonIconType;
    FSound: Boolean;
    procedure SetIcon(const Value: TBalloonIconType);
    procedure SetSound(const Value: Boolean);
    procedure SetText(const Value: string);
    procedure SetTimeout(const Value: TBalloonTimeoutSecs);
    procedure SetTitle(const Value: string);
  protected
    procedure AssignTo(Dest: TPersistent); override;
    procedure Update(UpdateText: Boolean); virtual;
  public
    constructor Create(AControl: TNotifyIcon);
    procedure SetTo(const AText: string; const ATitle: string = '';
      AIcon: TBalloonIconType = biNone);
  published
    property Icon: TBalloonIconType read FIcon write SetIcon default biNone;
    property Sound: Boolean read FSound write SetSound default True;
    property Text: string read FText write SetText;
    property Timeout: TBalloonTimeoutSecs read FTimeout write SetTimeout default 20;
    property Title: string read FTitle write SetTitle;
  end;

  TMouseButtons = set of TMouseButton;

  TTimerEvent = procedure(Sender: TObject; TimerID: Cardinal) of object;

  TNotifyIcon = class(TComponent)
  private
    FWindowHandle: HWND;
    FIcon: TIcon;
    FTitle: string;
    FState: TNotifyIconState;
    FStateMask: TNotifyIconState;
    FInfoBalloon: TInfoBalloon;
    FGUID: PGUID;
    FInstalled: Boolean;
    FUpdateCount: Integer;
    FUpdateFlags: TNotifyIconFlags;
    FVisible: Boolean;
    FDesignPreview: Boolean;
    FImages: TCustomImageList;
    FImageChangeLink: TChangeLink;
    FImageIndex: TImageIndex;
    FImageAssigning: Boolean;
    FEnabled: Boolean;
    FDblClicks: TMouseButtons;
    FClickedButtons: TMouseButtons;
    FMouseDownTime: Cardinal;
    FPopupMenu: TPopupMenu;
    FLPopupMenu: TPopupMenu;
    FPopupPos: TPoint;
    FPendingPopup: TPopupMenu;
    FMinimizeTo: Boolean;
    FDblToRestore: Boolean;
    FOnClick: TNotifyEvent;
    FOnDblClick: TNotifyEvent;
    FOnMouseDown: TMouseEvent;
    FOnMouseMove: TMouseMoveEvent;
    FOnMouseUp: TMouseEvent;
    FOnContextPopup: TContextPopupEvent;
    FOnSelect: TNotifyEvent;
    FOnKeySelect: TNotifyEvent;
    FOnBalloonHide: TNotifyEvent;
    FOnBalloonDismiss: TNotifyEvent;
    FOnBalloonClick: TNotifyEvent;
    FOnBalloonShow: TNotifyEvent;
    FOnMinimizeTo: TNotifyEvent;
    FOnTimer: TTimerEvent;
    procedure ApplicationMinimize(Sender: TObject);
    procedure DoSetImage;
    function GetGUID: string;
    function GetHidden: Boolean;
    function GetShared: Boolean;
    procedure IconChanged(Sender: TObject);
    procedure ImageListChange(Sender: TObject);
    procedure Install;
    procedure Perform(Message: TNotifyIconMessage; Flags: TNotifyIconFlags = []);
    procedure SetDesignPreview(const Value: Boolean);
    procedure SetGUID(const Value: string);
    procedure SetHidden(const Value: Boolean);
    procedure SetIcon(const Value: TIcon);
    procedure SetImageIndex(const Value: TImageIndex);
    procedure SetImages(const Value: TCustomImageList);
    procedure SetInfoBalloon(const Value: TInfoBalloon);
    procedure SetInstalled(const Value: Boolean);
    procedure SetMinimizeTo(const Value: Boolean);
    procedure SetPopupMenu(const Index: Integer; const Value: TPopupMenu);
    procedure SetShared(const Value: Boolean);
    procedure SetStateFlag(Flag: TNotifyIconStateFlag; Value: Boolean);
    procedure SetTitle(const Value: string);
    procedure SetVisible(const Value: Boolean);
    procedure Uninstall;
    procedure UpdateBalloon(UpdateText: Boolean);
    procedure WMNAreaNotify(var Message: TWMNAreaNotify); message WM_NAREANOTIFY;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
    procedure WndProc(var Message: TMessage);
  protected
    procedure BalloonClick; dynamic;
    procedure BalloonDismiss; dynamic;
    procedure BalloonHide; dynamic;
    procedure BalloonShow; dynamic;
    procedure Click; dynamic;
    procedure ContextPopup(MousePos: TPoint; var Handled: Boolean); dynamic;
    procedure DblClick; dynamic;
    procedure KeySelect; dynamic;
    procedure Loaded; override;
    procedure MenuAutoPopup(MouseButton: TMouseButton = mbRight);
    procedure MenuPopup(APopupMenu: TPopupMenu);
    procedure MenuSmartPopup(APopupMenu: TPopupMenu);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); dynamic;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); dynamic;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); dynamic;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Select; dynamic;
    procedure Update(Flags: TNotifyIconFlags);
    property Installed: Boolean read FInstalled write SetInstalled;
    property WindowHandle: HWND read FWindowHandle;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginUpdate;
    procedure DefaultHandler(var Message); override;
    procedure EndUpdate;
    procedure RestoreFrom;
    procedure SetFocus;
    procedure Timer(ID: Cardinal; Elapse: Integer);
    property Shared: Boolean read GetShared write SetShared default False;
  published
    property DblClicks: TMouseButtons read FDblClicks write FDblClicks default [mbLeft];
    property DblToRestore: Boolean read FDblToRestore write FDblToRestore default False;
    property DesignPreview: Boolean read FDesignPreview write SetDesignPreview default False;
    property Enabled: Boolean read FEnabled write FEnabled default True;
    property GUID: string read GetGUID write SetGUID;
    property Hidden: Boolean read GetHidden write SetHidden default False;
    property Icon: TIcon read FIcon write SetIcon;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
    property Images: TCustomImageList read FImages write SetImages;
    property InfoBalloon: TInfoBalloon read FInfoBalloon write SetInfoBalloon;
    property LPopupMenu: TPopupMenu index 1 read FLPopupMenu write SetPopupMenu;
    property MinimizeTo: Boolean read FMinimizeTo write SetMinimizeTo default False;
    property PopupMenu: TPopupMenu index 0 read FPopupMenu write SetPopupMenu;
    property Title: string read FTitle write SetTitle;
    property Visible: Boolean read FVisible write SetVisible default False;
    property OnBalloonClick: TNotifyEvent read FOnBalloonClick write FOnBalloonClick;
    property OnBalloonDismiss: TNotifyEvent read FOnBalloonDismiss write FOnBalloonDismiss;
    property OnBalloonHide: TNotifyEvent read FOnBalloonHide write FOnBalloonHide;
    property OnBalloonShow: TNotifyEvent read FOnBalloonShow write FOnBalloonShow;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnContextPopup: TContextPopupEvent read FOnContextPopup write FOnContextPopup;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnKeySelect: TNotifyEvent read FOnKeySelect write FOnKeySelect;
    property OnMinimizeTo: TNotifyEvent read FOnMinimizeTo write FOnMinimizeTo;
    property OnMouseDown: TMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnMouseMove: TMouseMoveEvent read FOnMouseMove write FOnMouseMove;
    property OnMouseUp: TMouseEvent read FOnMouseUp write FOnMouseUp;
    property OnSelect: TNotifyEvent read FOnSelect write FOnSelect;
    property OnTimer: TTimerEvent read FOnTimer write FOnTimer;
  end;

{ DllGetVersion }

type
  TDllVersionInfo = record
    cbSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformID: DWORD;
  end;

  TDllGetVersionProc = function(var dvi: TDllVersionInfo): HRESULT; stdcall;

function GetDllVersion(const DllName: string): Cardinal;

{ Utility routines }

function DivRem(Dividend, Divisor: Integer; var Remainder: Integer): Integer;
function GetShiftState: TShiftState;
function MenuExecDefItem(PopupMenu: TPopupMenu): Boolean;

procedure Register;

implementation

uses
  Forms;

var
  ShellVersion: Cardinal;

{ Shell_NotifyIcon }

const
  shell32 = 'shell32.dll';

function Shell_NotifyIcon; external shell32 name 'Shell_NotifyIconA';

{ DllGetVersion }

function GetDllVersion(const DllName: string): Cardinal;
var
  hDll: HMODULE;
  DllGetVersion: TDllGetVersionProc;
  dvi: TDllVersionInfo;
begin
  Result := 0;
  hDll := LoadLibrary(PChar(DllName));
  if hDll <> 0 then
    try
      DllGetVersion := GetProcAddress(hDll, 'DllGetVersion');
      if @DllGetVersion <> nil then
      begin
        dvi.cbSize := SizeOf(TDllVersionInfo);
        if DllGetVersion(dvi) = NOERROR then
          Result := dvi.dwMajorVersion shl 16 or dvi.dwMinorVersion;
      end;
    finally
      FreeLibrary(hDll);
    end;
end;

{ Utility routines }

function DivRem(Dividend, Divisor: Integer; var Remainder: Integer): Integer;
asm
  PUSH ECX
  MOV ECX,EDX
  CDQ
  IDIV ECX
  POP ECX
  MOV [ECX],EDX
end;

function GetShiftState: TShiftState;
begin
  Result := [];
  if GetAsyncKeyState(VK_SHIFT) < 0 then Include(Result, ssShift);
  if GetAsyncKeyState(VK_CONTROL) < 0 then Include(Result, ssCtrl);
  if GetAsyncKeyState(VK_MENU) < 0 then Include(Result, ssAlt);
  if BOOL(GetSystemMetrics(SM_SWAPBUTTON)) then
  begin
    if GetAsyncKeyState(VK_RBUTTON) < 0 then Include(Result, ssLeft);
    if GetAsyncKeyState(VK_LBUTTON) < 0 then Include(Result, ssRight);
  end else
  begin
    if GetAsyncKeyState(VK_LBUTTON) < 0 then Include(Result, ssLeft);
    if GetAsyncKeyState(VK_RBUTTON) < 0 then Include(Result, ssRight);
  end;
  if GetAsyncKeyState(VK_MBUTTON) < 0 then Include(Result, ssMiddle);
end;

function MenuExecDefItem(PopupMenu: TPopupMenu): Boolean;
var
  I: Integer;
begin
  if Assigned(PopupMenu) and PopupMenu.AutoPopup then
    with PopupMenu.Items do
      for I := 0 to Count - 1 do
        with Items[I] do
          if Default then
          begin
            Click;
            Result := True;
            Exit;
          end;
  Result := False;
end;

{ TInfoBalloon }

procedure TInfoBalloon.AssignTo(Dest: TPersistent);
begin
  if Dest is TInfoBalloon then
    with TInfoBalloon(Dest) do
    begin
      FText := Self.FText;
      FTimeout := Self.FTimeout;
      FTitle := Self.FTitle;
      FIcon := Self.FIcon;
      FSound := Self.FSound;
      Update(True);
    end
  else
    inherited AssignTo(Dest);
end;

constructor TInfoBalloon.Create(AControl: TNotifyIcon);
begin
  FControl := AControl;
  FTimeout := 20;
  FSound := True;
end;

procedure TInfoBalloon.SetIcon(const Value: TBalloonIconType);
begin
  if Value <> FIcon then
  begin
    FIcon := Value;
    Update(False);
  end;
end;

procedure TInfoBalloon.SetSound(const Value: Boolean);
begin
  if Value <> FSound then
  begin
    FSound := Value;
    Update(False);
  end;
end;

procedure TInfoBalloon.SetText(const Value: string);
begin
  if Value <> FText then
  begin
    FText := Value;
    Update(True);
  end;
end;

procedure TInfoBalloon.SetTimeout(const Value: TBalloonTimeoutSecs);
begin
  if Value <> FTimeout then
  begin
    FTimeout := Value;
    Update(False);
  end;
end;

procedure TInfoBalloon.SetTitle(const Value: string);
begin
  if Value <> FTitle then
  begin
    FTitle := Value;
    Update(False);
  end;
end;

procedure TInfoBalloon.SetTo(const AText, ATitle: string;
  AIcon: TBalloonIconType);
begin
  FText := AText;
  FTitle := ATitle;
  FIcon := AIcon;
  Update(True);
end;

procedure TInfoBalloon.Update(UpdateText: Boolean);
begin
  if FControl <> nil then
    FControl.UpdateBalloon(UpdateText);
end;

{ TNotifyIcon }

resourcestring
  SNotifyIconError = 'Failed to %s notify icon';
  SAdd = 'add';
  SModify = 'modify';
  SDelete = 'delete';
  SSetFocus = 'set focus to';
  SSetVersion = 'set version of';
  
const
  PopupTimerID = $2000;
  
procedure TNotifyIcon.ApplicationMinimize(Sender: TObject);
begin
  if FMinimizeTo and (not (csDesigning in ComponentState)
    or FDesignPreview) then
  begin
    ShowWindow(Application.Handle, SW_HIDE);
    if FIcon.Empty then
      SetIcon(Application.Icon);
    if FTitle = '' then
      SetTitle(Application.Title);
    if csDesigning in ComponentState then
      SetDesignPreview(True)
    else
      SetVisible(True);
    if Assigned(FOnMinimizeTo) then
      FOnMinimizeTo(Self);
  end;
end;

procedure TNotifyIcon.BalloonClick;
begin
  if Assigned(FOnBalloonClick) then FOnBalloonClick(Self);
end;

procedure TNotifyIcon.BalloonDismiss;
begin
  if Assigned(FOnBalloonDismiss) then FOnBalloonDismiss(Self);
end;

procedure TNotifyIcon.BalloonHide;
begin
  if Assigned(FOnBalloonHide) then FOnBalloonHide(Self);
end;

procedure TNotifyIcon.BalloonShow;
begin
  if Assigned(FOnBalloonShow) then FOnBalloonShow(Self);
end;

procedure TNotifyIcon.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TNotifyIcon.Click;
begin
  if Assigned(FOnClick) then FOnClick(Self);
end;

procedure TNotifyIcon.ContextPopup(MousePos: TPoint; var Handled: Boolean);
begin
  if Assigned(FOnContextPopup) then
    FOnContextPopup(Self, MousePos, Handled);
end;

constructor TNotifyIcon.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$WARN SYMBOL_DEPRECATED OFF}
  FWindowHandle := AllocateHWnd(WndProc);
{$WARN SYMBOL_DEPRECATED ON}
  FIcon := TIcon.Create;
  FIcon.OnChange := IconChanged;
  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;
  FInfoBalloon := TInfoBalloon.Create(Self);
  FImageIndex := -1;
  FEnabled := True;
  FDblClicks := [mbLeft];      
end;

procedure TNotifyIcon.DblClick;
begin
  if Assigned(FOnDblClick) then FOnDblClick(Self);
end;

procedure TNotifyIcon.DefaultHandler(var Message);
begin
  with TMessage(Message) do
    Result := DefWindowProc(FWindowHandle, Msg, wParam, lParam);
end;

destructor TNotifyIcon.Destroy;
begin                          
  if FMinimizeTo then
    Application.OnMinimize := nil;
  if FInstalled then
    Perform(nimDelete);
  FIcon.Free;
  FImageChangeLink.Free;
  FInfoBalloon.Free;
{$WARN SYMBOL_DEPRECATED OFF}
  DeallocateHWnd(FWindowHandle);
{$WARN SYMBOL_DEPRECATED ON}
  inherited Destroy;
end;

procedure TNotifyIcon.DoSetImage;
begin
  if Assigned(FImages) and (FImageIndex >= 0)
    and (FImageIndex < FImages.Count) then
  begin
    FImageAssigning := True;
    try
      FImages.GetIcon(FImageIndex, FIcon);
    finally
      FImageAssigning := False;
    end;
  end;
end;

procedure TNotifyIcon.EndUpdate;
begin
  Dec(FUpdateCount);
  if FUpdateCount = 0 then
  begin
    Update(FUpdateFlags);
    FUpdateFlags := [];
  end;
end;

function TNotifyIcon.GetGUID: string;
begin
  if FGUID <> nil then
    Result := GUIDToString(FGUID^);
end;

function TNotifyIcon.GetHidden: Boolean;
begin
  Result := nisHidden in FState;
end;

function TNotifyIcon.GetShared: Boolean;
begin
  Result := nisSharedIcon in FState;
end;

procedure TNotifyIcon.IconChanged(Sender: TObject);
begin
  if not FImageAssigning then
    FImageIndex := -1;
  Update([nifIcon]);
end;

procedure TNotifyIcon.ImageListChange(Sender: TObject);
begin
  DoSetImage;
end;

procedure TNotifyIcon.Install;
var
  Flags: TNotifyIconFlags;
begin
  Flags := [nifMessage];
  if not FIcon.Empty then
    Include(Flags, nifIcon);
  if FTitle <> '' then
    Include(Flags, nifTip);
  if ShellVersion >= $050000 then
  begin
    FStateMask := FState;
    Exclude(FStateMask, nisSharedIcon);
    if FStateMask <> [] then
      Include(Flags, nifState);
    if FInfoBalloon.FText <> '' then
      Include(Flags, nifInfo);
    if ShellVersion >= $060000 then
      if FGUID <> nil then
        Include(Flags, nifGUID);
  end;
  Perform(nimAdd, Flags);
  if ShellVersion >= $050000 then
    Perform(nimSetVersion);
  FInstalled := True;
  FUpdateFlags := [];
end;

procedure TNotifyIcon.KeySelect;
begin
  if Assigned(FOnKeySelect) then FOnKeySelect(Self);
end;

procedure TNotifyIcon.Loaded;
var
  FVisibleProperty: PBoolean;
begin
  inherited;
  if csDesigning in ComponentState then
    FVisibleProperty := @FDesignPreview               
  else
    FVisibleProperty := @FVisible;
  try
    if FVisibleProperty^ then Install;
  finally
    FVisibleProperty^ := FInstalled;
  end;
end;

procedure TNotifyIcon.MenuAutoPopup(MouseButton: TMouseButton);
var
  PopupMenu: TPopupMenu;
begin
  PopupMenu := nil;
  case MouseButton of
    mbLeft: PopupMenu := FLPopupMenu;
    mbRight: PopupMenu := FPopupMenu;
  end;
  if (PopupMenu <> nil) and PopupMenu.AutoPopup then
    if MouseButton in FDblClicks then
      MenuSmartPopup(PopupMenu)
    else
      MenuPopup(PopupMenu);
end;

procedure TNotifyIcon.MenuPopup(APopupMenu: TPopupMenu);
begin
  SetForegroundWindow(FWindowHandle);
  APopupMenu.PopupComponent := Self;
  APopupMenu.Popup(FPopupPos.X, FPopupPos.Y);          
  PostMessage(FWindowHandle, WM_NULL, 0, 0);
end;

procedure TNotifyIcon.MenuSmartPopup(APopupMenu: TPopupMenu);
var
  Delay: Integer;
begin
  Delay := GetDoubleClickTime - (GetTickCount - FMouseDownTime);
  if Delay > 0 then
  begin
    Timer(PopupTimerID, Delay);
    FPendingPopup := APopupMenu;
  end else
    MenuPopup(APopupMenu);
end;

procedure TNotifyIcon.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if Assigned(FOnMouseDown) then
    FOnMouseDown(Self, Button, Shift, X, Y);
end;

procedure TNotifyIcon.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FOnMouseMove) then
    FOnMouseMove(Self, Shift, X, Y);
end;

procedure TNotifyIcon.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if Assigned(FOnMouseUp) then
    FOnMouseUp(Self, Button, Shift, X, Y);
end;

procedure TNotifyIcon.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent = FImages then FImages := nil;
    if AComponent = FPopupMenu then FPopupMenu := nil;
    if AComponent = FLPopupMenu then FLPopupMenu := nil;
    if AComponent = FPendingPopup then FPendingPopup := nil;
  end;
end;

procedure TNotifyIcon.Perform(Message: TNotifyIconMessage;
  Flags: TNotifyIconFlags);
const
  NotifyIconOperationNames: array[TNotifyIconMessage] of string =
    (SAdd, SModify, SDelete, SSetFocus, SSetVersion);
var
  nid: TNotifyIconData;
  Size, MaxTipLen: Cardinal;
begin
  Size := $0058;
  MaxTipLen := $003F;
  if ShellVersion >= $050000 then
  begin
    Inc(Size, $0190);
    Inc(MaxTipLen, $0040);
  end;
  if ShellVersion >= $060000 then
    Inc(Size, SizeOf(TGUID));
  with nid do
  begin
    cbSize := Size;
    hWnd := FWindowHandle;
    uID := 0;
    case Message of
      nimAdd, nimModify:
        begin                                       
          uFlags := Byte(Flags);
          uCallbackMessage := WM_NAREANOTIFY;
          if nifIcon in Flags then
            hIcon := FIcon.Handle;
          if nifTip in Flags then
            StrPLCopy(szTip, FTitle, MaxTipLen);
          dwState := Byte(FState);
          dwStateMask := Byte(FStateMask);
          if nifInfo in Flags then
            with FInfoBalloon do
            begin
              StrPLCopy(szInfo, FText, SizeOf(szInfo) - 1);
              uTimeout := FTimeout * 1000;
              StrPLCopy(szInfoTitle, FTitle, SizeOf(szInfoTitle) - 1);
              dwInfoFlags := Ord(FIcon) shl NIIF_IconBitsOffset
                or Ord(not FSound) shl NIIF_NoSoundBitOffset;
            end;
          if nifGUID in Flags then
            guidItem := FGUID^;
        end;
      nimSetVersion:
        uVersion := NOTIFYICON_VERSION;
    end;
  end;
  if not Shell_NotifyIcon(Ord(Message), @nid) then
    raise ENotifyIconError.CreateResFmt(@SNotifyIconError,
      [NotifyIconOperationNames[Message]]);
end;

procedure TNotifyIcon.RestoreFrom;
begin
  if FMinimizeTo and FInstalled and
    not IsWindowVisible(Application.Handle) then
  begin
    ShowWindow(Application.Handle, SW_SHOW);
    Application.Restore;
    if not (csDesigning in ComponentState) then
      SetVisible(False);
  end;
end;

procedure TNotifyIcon.Select;
begin
  if Assigned(FOnSelect) then FOnSelect(Self);
end;

procedure TNotifyIcon.SetDesignPreview(const Value: Boolean);
begin
  if csDesigning in ComponentState then
    SetInstalled(Value);
  FDesignPreview := Value;
end;

procedure TNotifyIcon.SetFocus;
begin
  if FInstalled then
    Perform(nimSetFocus);
end;

procedure TNotifyIcon.SetGUID(const Value: string);
var
  Temp: TGUID;
begin
  Temp := StringToGUID(Value);
  if FGUID = nil then
    New(FGUID);
  FGUID^ := Temp;
  Update([nifGUID]);
end;

procedure TNotifyIcon.SetHidden(const Value: Boolean);
begin
  SetStateFlag(nisHidden, Value);
end;

procedure TNotifyIcon.SetIcon(const Value: TIcon);
begin
  FIcon.Assign(Value);
end;

procedure TNotifyIcon.SetImageIndex(const Value: TImageIndex);
begin
  if Value <> FImageIndex then
  begin
    FImageIndex := Value;
    DoSetImage;
  end;
end;

procedure TNotifyIcon.SetImages(const Value: TCustomImageList);
begin
  if FImages <> nil then
    FImages.UnRegisterChanges(FImageChangeLink);
  FImages := Value;
  if FImages <> nil then
  begin
    FImages.RegisterChanges(FImageChangeLink);
    FImages.FreeNotification(Self);
  end;
  DoSetImage;
end;

procedure TNotifyIcon.SetInfoBalloon(const Value: TInfoBalloon);
begin
  FInfoBalloon.Assign(Value);
end;

procedure TNotifyIcon.SetInstalled(const Value: Boolean);
begin
  if not (csLoading in ComponentState) and (Value <> FInstalled) then
    if Value then Install else Uninstall;
end;

procedure TNotifyIcon.SetMinimizeTo(const Value: Boolean);
begin
  if Value <> FMinimizeTo then
  begin
    if Value then
      Application.OnMinimize := ApplicationMinimize; 
    FMinimizeTo := Value;
  end;
end;

procedure TNotifyIcon.SetPopupMenu(const Index: Integer;
  const Value: TPopupMenu);
begin
  case Index of
    0: FPopupMenu := Value;
    1: FLPopupMenu := Value;
  end;
  if Value <> nil then
    Value.FreeNotification(Self);
end;

procedure TNotifyIcon.SetShared(const Value: Boolean);
begin
  if FInstalled then
    SetStateFlag(nisSharedIcon, Value);
end;

procedure TNotifyIcon.SetStateFlag(Flag: TNotifyIconStateFlag;
  Value: Boolean);
var
  UpdateFlags: TNotifyIconFlags;
begin
  if Value <> (Flag in FState) then
  begin
    Exclude(FState, Flag);
    if Value then
      Include(FState, Flag);
    FStateMask := [Flag];
    UpdateFlags := [nifState];
    if (Flag = nisSharedIcon) and not (Value or FIcon.Empty) then
      Include(UpdateFlags, nifIcon);
    Update(UpdateFlags);
  end;
end;

procedure TNotifyIcon.SetTitle(const Value: string);
begin
  if Value <> FTitle then
  begin
    FTitle := Value;
    Update([nifTip]);
  end;
end;

procedure TNotifyIcon.SetVisible(const Value: Boolean);
begin
  if not (csDesigning in ComponentState) then
    SetInstalled(Value);
  FVisible := Value;
end;

procedure TNotifyIcon.Timer(ID: Cardinal; Elapse: Integer);
begin
  if Elapse >= 0 then
    SetTimer(FWindowHandle, ID, Elapse, nil)
  else
    KillTimer(FWindowHandle, ID);
end;

procedure TNotifyIcon.Uninstall;
begin
  Perform(nimDelete);
  Exclude(FState, nisSharedIcon);
  FInstalled := False;
end;

procedure TNotifyIcon.Update(Flags: TNotifyIconFlags);
begin
  if FInstalled then
  begin
    if ShellVersion < $050000 then
      Flags := Flags - [nifState, nifInfo];
    if ShellVersion < $060000 then
      Exclude(Flags, nifGUID);
    if Flags <> [] then
      if FUpdateCount = 0 then
        Perform(nimModify, Flags)
      else
        FUpdateFlags := FUpdateFlags + Flags;
  end;
end;

procedure TNotifyIcon.UpdateBalloon(UpdateText: Boolean);
begin
  if UpdateText or (csDesigning in ComponentState) then
    Update([nifInfo]);
end;

procedure TNotifyIcon.WMNAreaNotify(var Message: TWMNAreaNotify);
const
  BtnDown = 0;
  BtnUp = 1;
  BtnDblClk = 2;
var
  ShiftState: TShiftState;
  MousePos: TPoint;
  ContextPopupHandled: Boolean;
  MouseEventTag, MouseActn: Integer;
  MouseButton: TMouseButton;
  Clicked, DblClicked: Boolean;
begin
  GetCursorPos(MousePos);
  with Message, MousePos do
    if FEnabled or (NotifyMsg > NIN_KEYSELECT) then
    begin
      if (NotifyMsg >= WM_MOUSEFIRST) and (NotifyMsg <= WM_MOUSELAST) then
        ShiftState := GetShiftState;
      case NotifyMsg of
        WM_CONTEXTMENU:
          begin
            FPopupPos := MousePos;
            ContextPopupHandled := False;
            ContextPopup(MousePos, ContextPopupHandled);
            if not ContextPopupHandled then
              MenuAutoPopup;
          end;
        WM_MOUSEMOVE: MouseMove(ShiftState, X, Y);
        WM_LBUTTONDOWN..WM_MBUTTONDBLCLK:
          begin
            MouseEventTag := NotifyMsg - WM_LBUTTONDOWN;
            MouseButton := TMouseButton(DivRem(MouseEventTag, 3, MouseActn));
            case MouseActn of
              BtnDown: FMouseDownTime := GetTickCount;
              BtnDblClk: Include(ShiftState, ssDouble);
            end;
            FPopupPos := MousePos;
            case MouseActn of
              BtnDown, BtnDblClk:
                begin
                  Timer(PopupTimerID, -1);
                  DblClicked := False;
                  if (MouseActn = BtnDown) or not (MouseButton in FDblClicks) then
                    Include(FClickedButtons, MouseButton)
                  else
                    if MouseButton = mbLeft then
                    begin
                      DblClicked := True;
                      if not MenuExecDefItem(FLPopupMenu) then
                        MenuExecDefItem(FPopupMenu);
                      DblClick;
                    end;
                  MouseDown(MouseButton, ShiftState, X, Y);
                  if FMinimizeTo and FDblToRestore and DblClicked then
                    RestoreFrom;
                end;
              BtnUp:
                begin
                  Clicked := MouseButton in FClickedButtons;
                  Exclude(FClickedButtons, MouseButton);
                  if Clicked and (MouseButton = mbLeft) then
                    Click;
                  MouseUp(MouseButton, ShiftState, X, Y);
                  if Clicked then
                  begin
                    if FMinimizeTo and (MouseButton = mbLeft) and
                      not FDblToRestore and not Assigned(FLPopupMenu) then
                      RestoreFrom;
                    if (MouseButton <> mbRight) or (ShellVersion < $050000) then
                      MenuAutoPopup(MouseButton);
                  end;
                end;
            end;
          end;
        NIN_SELECT: Select;
        NIN_KEYSELECT:
          begin
            KeySelect;
            if FMinimizeTo then
              RestoreFrom;
          end;
        NIN_BALLOONSHOW: BalloonShow;
        NIN_BALLOONHIDE: BalloonHide;
        NIN_BALLOONTIMEOUT: BalloonDismiss;
        NIN_BALLOONUSERCLICK: BalloonClick;
      end;
    end;
end;

procedure TNotifyIcon.WMTimer(var Message: TWMTimer);
begin
  with Message do
  begin
    if TimerID = PopupTimerID then
    begin
      Timer(TimerID, -1);
      if FEnabled and (FPendingPopup <> nil) then
        MenuPopup(FPendingPopup);
    end else
      if Assigned(FOnTimer) then
        FOnTimer(Self, TimerID)
      else
        Exit;
    Result := 0;
  end;
end;

procedure TNotifyIcon.WndProc(var Message: TMessage);
begin
  try
    Dispatch(Message);
  except
    if Assigned(ApplicationHandleException) then
      ApplicationHandleException(Self);
  end;
end;

procedure Register;
begin
  RegisterComponents('Win32', [TNotifyIcon]);
end;

initialization
  ShellVersion := GetDllVersion(shell32);

end.
