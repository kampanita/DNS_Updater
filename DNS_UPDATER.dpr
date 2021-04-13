program DNS_UPDATER;

uses
  Forms,
  DNS_UPDATER_Unit1 in 'DNS_UPDATER_Unit1.pas' {Form1},
  dns_updater_Unit2 in 'dns_updater_Unit2.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'DNS Updater by Kepa';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
