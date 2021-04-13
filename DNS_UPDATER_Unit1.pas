unit DNS_UPDATER_Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, TrayIcon, trayIcon1,shellapi, NotifyIcon,
  Balloon, StdCtrls, Registry, OleCtrls, SHDocVw, Buttons, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    ttrayIcon11: ttrayIcon1;
    PopupMenu1: TPopupMenu;
    DNS1: TMenuItem;
    N1: TMenuItem;
    DNSUpdate1: TMenuItem;
    Exit1: TMenuItem;
    Edit1: TEdit;
    IdHTTP1: TIdHTTP;
    Edit2: TEdit;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    SpeedButton2: TSpeedButton;
    WebBrowser1: TWebBrowser;
    procedure Exit1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);

    procedure ttrayIcon11Click(Sender: TObject);
    procedure DNSUpdate1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure DNS1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses dns_updater_Unit2;

{$R *.dfm}

procedure TForm1.Exit1Click(Sender: TObject);
var reg:Tregistry;
begin
  reg:=TRegistry.Create;
  reg.RootKey:= HKEY_CURRENT_USER;
  reg.OpenKey('Software\Kepa\Dns_updater',true);
  reg.WriteString('url',edit1.text);
  reg.closekey;
  reg.free;
  application.terminate;

end;
procedure TForm1.FormActivate(Sender: TObject);
begin
 if form1.Visible then
   form1.Visible:=false;
 if form2.Visible then
   form2.visible:=false;
end;

procedure TForm1.FormCreate(Sender: TObject);
var reg:Tregistry;
begin
  reg:=TRegistry.Create;
  reg.RootKey:= HKEY_CURRENT_USER ;
  reg.OpenKey('Software\Kepa\Dns_updater',true) ;
  if reg.ValueExists('url') then form1.edit1.Text:=reg.ReadString('url') else reg.writeString('url','http://insert_url');
  reg.CloseKey;
  reg.Free;
  form1.windowstate:=wsminimized;
  SpeedButton1Click(Sender);
 // webbrowser1.Navigate('http://api.ipify.org/');

end;

procedure TForm1.Timer1Timer(Sender: TObject);
var purl:pansichar;
    url:string;

begin
 //https://freedns.afraid.org/dynamic/update.php?RjlVMG5XTUtuWWJhNUNXVWlqbUc6NjkxNTU3MQ==
  url:='-s '+edit1.text+'/';
  purl:=PAnsiChar(AnsiString(url));
//  shellexecute(handle,'open','curl',purl,nil,sw_hide);
  webBrowser1.Navigate(edit1.text);
  form2.show;
  form2.timer1.enabled:=true;
end;



procedure TForm1.ttrayIcon11Click(Sender: TObject);

begin
 timer1Timer(Self);
end;

procedure TForm1.DNSUpdate1Click(Sender: TObject);
begin
 timer1Timer(Self);
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 if form1.visible then
  form1.Visible:=False;
 canclose:=false;
end;

procedure TForm1.DNS1Click(Sender: TObject);
begin
 form1.WindowState:=wsnormal;
 if not form1.visible then
    form1.Visible:=true;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
var
 v_url:string;
begin
 v_url:='http://api.ipify.org/';
 edit2.Text:=idhttp1.get(v_url);
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
 Timer1Timer(Sender);
end;

end.
