program DelphiZXingQRCodeTestApp;

uses
  Forms,
  DelphiZXingQRCodeTestAppMainForm in 'DelphiZXingQRCodeTestAppMainForm.pas' {frmMain},
  DelphiZXingQRCode in '..\Source\DelphiZXIngQRCode.pas',
  QRGraphics in '..\Source\QRGraphics.pas',
  QR_Win1251 in '..\Source\QR_Win1251.pas',
  QR_URL in '..\Source\QR_URL.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'DelphiZXing Demo Application';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
