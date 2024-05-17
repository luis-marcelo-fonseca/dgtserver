unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Registry, StdCtrls, IniFiles, ExtCtrls, IdStack, Buttons, shellapi,
  ExtDlgs, IdSSLOpenSSL, IdServerIOHandler, IdSSL,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdHttp, IdGlobal, FileCtrl,
  Vcl.ComCtrls;

type
  Tform3 = class(TForm)
    CheckBox2: TCheckBox;
    Button1: TButton;
    CheckBox1: TCheckBox;
    Label5: TLabel;
    CheckBox3: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Button2: TButton;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    OpenDialog2: TOpenDialog;
    Edit1: TEdit;
    Edit2: TEdit;
    Label4: TLabel;
    dominio: TEdit;
    CheckBox4: TCheckBox;
    Timer1: TTimer;
    SpeedButton3: TSpeedButton;
    linkdeatualizacao: TEdit;
    Label1: TLabel;
    SpeedButton2: TSpeedButton;
    CheckBox5: TCheckBox;
    Edit3: TEdit;
    Button4: TButton;
    Edit4: TEdit;
    Label2: TLabel;
    Edit5: TEdit;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    CheckBox6: TCheckBox;
    Label8: TLabel;
    Edit6: TEdit;
    SpeedButton1: TSpeedButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Label9: TLabel;
    Label10: TLabel;
    portahttp: TEdit;
    Label11: TLabel;
    portahttps: TEdit;
    Label12: TLabel;
    Label13: TLabel;
    Edit7: TEdit;
    SpeedButton4: TSpeedButton;
    portapadrao: TEdit;
    OpenDialog3: TOpenDialog;
    OpenDialog4: TOpenDialog;
    Edit8: TEdit;
    Label14: TLabel;
    SpeedButton5: TSpeedButton;
    OpenDialog5: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Label8Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: Tform3;

implementation

uses Unit1;

{$R *.dfm}

function IsUserAnAdmin(): BOOL; external shell32;

function GetIP: String;
begin
  TIdStack.IncUsage;
  try
    Result := GStack.LocalAddress;
  finally
    TIdStack.DecUsage;
  end;
end;

function atualizaddns(url: string): string;
var
  HTTPClient: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
begin
  HTTPClient := TIdHTTP.Create;
  HTTPClient.HandleRedirects := True;
  HTTPClient.Request.UserAgent := 'Flywer Server';
  try
    SSL := TIdSSLIOHandlerSocketOpenSSL.Create(HTTPClient);
    SSL.SSLOptions.SSLVersions := [sslvSSLv2, sslvSSLv23, sslvSSLv3, sslvTLSv1,
      sslvTLSv1_1, sslvTLSv1_2];
    HTTPClient.IOHandler := SSL;
    Result := HTTPClient.Get(url);
    HTTPClient.Free;
  Except
    on E: Exception do
  end;
end;

function teste(url: string): string;
var
  HTTPClient: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
begin
  HTTPClient := TIdHTTP.Create;
  HTTPClient.HandleRedirects := True;
  HTTPClient.Request.UserAgent := 'Flywer Server';
  try
    SSL := TIdSSLIOHandlerSocketOpenSSL.Create(HTTPClient);
    SSL.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2,
      sslvSSLv2, sslvSSLv23, sslvSSLv3];
    HTTPClient.IOHandler := SSL;
    Result := HTTPClient.Get(url);
    HTTPClient.Free;
  Except
    on E: Exception do
  end;
end;

procedure Tform3.Button1Click(Sender: TObject);
var
  ArquivoINI: TIniFile;
  Reg: TRegistry;
var
  protocolo, url, lnk, porta: string;
  Splitted: TArray<String>;
  i: integer;
begin

  ArquivoINI := TIniFile.Create(ExtractFileDir(Application.ExeName) +
    '\configuracoes.ini');
  ArquivoINI.WriteString('servidor', 'portapadrao', portapadrao.Text);
  ArquivoINI.WriteString('servidor', 'portahttp', portahttp.Text);
  ArquivoINI.WriteString('servidor', 'portahttps', portahttps.Text);
  ArquivoINI.WriteBool('servidor', 'ativado', CheckBox1.Checked);
  ArquivoINI.WriteBool('servidor', 'conexaopersistente', CheckBox5.Checked);

  ArquivoINI.WriteInteger('servidor', 'metado', ComboBox1.ItemIndex);
  ArquivoINI.WriteInteger('servidor', 'modo', ComboBox2.ItemIndex);

  ArquivoINI.WriteString('servidor', 'cert', Edit1.Text);
  ArquivoINI.WriteString('servidor', 'key', Edit2.Text);
  ArquivoINI.WriteString('servidor', 'root', Edit3.Text);

  ArquivoINI.WriteString('servidor', 'senha', Edit4.Text);
  form1.senha := Edit4.Text;
  ArquivoINI.WriteString('servidor', 'listadecifras', Edit5.Text);
  form1.listadecifras := Edit5.Text;

  ArquivoINI.WriteBool('servidor', 'ssl', CheckBox3.Checked);
  ArquivoINI.WriteBool('servidor', 'forcarssl', CheckBox6.Checked);
  form1.SSL := CheckBox3.Checked;
  form1.forcarssl := CheckBox6.Checked;

  ArquivoINI.WriteBool('ddns', 'ativado', CheckBox4.Checked);
  ArquivoINI.WriteString('ddns', 'dominio', dominio.Text);
  ArquivoINI.WriteString('ddns', 'linkdeatualizacao', linkdeatualizacao.Text);

  ArquivoINI.WriteString('servidor', 'phpexe', Edit6.Text);
  form1.phpexe := Edit6.Text;

  ArquivoINI.WriteString('servidor', 'pythonexe', Edit8.Text);
  form1.pythonexe := Edit8.Text;

  ArquivoINI.WriteString('servidor', 'iniciarprograma', Edit7.Text);

  // inciar com win
  Reg := TRegistry.Create(KEY_WRITE OR KEY_WOW64_64KEY);
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg := TRegistry.Create(KEY_WRITE OR KEY_WOW64_64KEY); //
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.Access := KEY_WOW64_64KEY + KEY_ALL_ACCESS;
  try
    if CheckBox2.Checked then
    begin
      if Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', false)
      then
      begin
        Reg.WriteString('Flywer Server', Application.ExeName + ' auto');
        ArquivoINI.WriteBool('auto iniciar', 'ativado', CheckBox2.Checked);
        Reg.CloseKey;
      end;
    end
    else
    begin
      if Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', false)
      then
      begin
        Reg.DeleteValue('Flywer Server');
        ArquivoINI.WriteBool('auto iniciar', 'ativado', CheckBox2.Checked);
      end;
    end;
  Except
    ShowMessage
      ('Você precisa executar este programa como administrador para executar esta ação!');
  end;
  // fim

  if not DirectoryExists(ExtractFileDir(Application.ExeName) + '\raiz') then
    CreateDir(ExtractFileDir(Application.ExeName) + '\raiz');

  case ComboBox1.ItemIndex of
    0:
      form1.IdServerIOHandlerSSLOpenSSL1.SSLOptions.SSLVersions :=
        [sslvSSLv2, sslvSSLv23, sslvSSLv3, sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
    1:
      form1.IdServerIOHandlerSSLOpenSSL1.SSLOptions.Method := sslvSSLv2;
    2:
      form1.IdServerIOHandlerSSLOpenSSL1.SSLOptions.Method := sslvSSLv23;
    3:
      form1.IdServerIOHandlerSSLOpenSSL1.SSLOptions.Method := sslvSSLv3;
    4:
      form1.IdServerIOHandlerSSLOpenSSL1.SSLOptions.Method := sslvTLSv1;
    5:
      form1.IdServerIOHandlerSSLOpenSSL1.SSLOptions.Method := sslvTLSv1_1;
    6:
      form1.IdServerIOHandlerSSLOpenSSL1.SSLOptions.Method := sslvTLSv1_2;
  end;

  case ComboBox1.ItemIndex of
    0:
      form1.IdServerIOHandlerSSLOpenSSL1.SSLOptions.Mode := sslmBoth;
    1:
      form1.IdServerIOHandlerSSLOpenSSL1.SSLOptions.Mode := sslmClient;
    2:
      form1.IdServerIOHandlerSSLOpenSSL1.SSLOptions.Mode := sslmServer;
    3:
      form1.IdServerIOHandlerSSLOpenSSL1.SSLOptions.Mode := sslmUnassigned;
  end;

  form1.IdServerIOHandlerSSLOpenSSL1.SSLOptions.CertFile := Edit1.Text;
  form1.IdServerIOHandlerSSLOpenSSL1.SSLOptions.KeyFile := Edit2.Text;

  form1.IdHTTPServer1.Active := false;

  if CheckBox3.Checked = True then
    form1.IdHTTPServer1.IOHandler := form1.IdServerIOHandlerSSLOpenSSL1
  else
    form1.IdHTTPServer1.IOHandler := nil;

  form1.IdHTTPServer1.KeepAlive := CheckBox5.Checked;

  if CheckBox1.Checked = True then
  begin

    form1.IdHTTPServer1.DefaultPort := strtoint(portapadrao.Text);

    form1.IdHTTPServer1.Bindings.Clear;
    if portahttp.Text <> '' then
    begin
      form1.IdHTTPServer1.Bindings.Add.Port := strtoint(portahttp.Text);
      form1.portahttp := strtoint(portahttp.Text);
    end;
    if portahttps.Text <> '' then
    begin
      form1.IdHTTPServer1.Bindings.Add.Port := strtoint(portahttps.Text);
      form1.portahttps := strtoint(portahttps.Text);
    end;

    form1.IdHTTPServer1.Active := True;
  end;

  if form1.IdHTTPServer1.Active then
  begin
    form1.Image1.Visible := True;
    form1.Image2.Visible := false;
  end
  else
  begin
    form1.Image1.Visible := false;
    form1.Image2.Visible := True;
  end;

  if form1.IdHTTPServer1.Active then
  begin
    form1.Image2.Visible := True;
    form1.Image1.Visible := false;
    form1.Label2.Caption := 'Ativo';
  end
  else
  begin
    form1.Image2.Visible := false;
    form1.Image1.Visible := True;
    form1.Label2.Caption := 'Desativado';
  end;

  if (CheckBox4.Checked = True) and (form1.IdHTTPServer1.Active = True) and
    (dominio.Text <> '') then
  begin
    if CheckBox3.Checked = True then
      protocolo := 'https://'
    else
      protocolo := 'http://';
    url := dominio.Text;
    url := StringReplace(url, 'https://', '', [rfIgnoreCase, rfReplaceAll]);
    url := StringReplace(url, 'http://', '', [rfIgnoreCase, rfReplaceAll]);
    url := StringReplace(url, '/', '', [rfIgnoreCase, rfReplaceAll]);
    url := StringReplace(url, ':', '', [rfIgnoreCase, rfReplaceAll]);

    if teste(protocolo + url + '/?teste=1') <> 'ok' then
    begin

      lnk := linkdeatualizacao.Text;
      Splitted := lnk.Split([',']);
      for i := low(Splitted) to high(Splitted) do
      begin
        if Splitted[i] <> '' then
          atualizaddns(trim(Splitted[i]));
      end;

    end;

  end;

  ArquivoINI.Free;
  Reg.Free;

  ShowMessage('Salvo!');
end;

procedure Tform3.Button2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    Edit1.Text := OpenDialog1.FileName;
end;

procedure Tform3.Button3Click(Sender: TObject);
begin
  if OpenDialog2.Execute then
    Edit2.Text := OpenDialog2.FileName;
end;

procedure Tform3.Button4Click(Sender: TObject);
begin
  if OpenDialog3.Execute then
    Edit3.Text := OpenDialog3.FileName;
end;

procedure Tform3.FormCreate(Sender: TObject);
var
  ArquivoINI: TIniFile;
begin

  ArquivoINI := TIniFile.Create(ExtractFileDir(Application.ExeName) +
    '\configuracoes.ini');

  CheckBox2.Checked := ArquivoINI.ReadBool('auto iniciar', 'ativado', false);
  CheckBox1.Checked := ArquivoINI.ReadBool('servidor', 'ativado', True);
  CheckBox5.Checked := ArquivoINI.ReadBool('servidor',
    'conexaopersistente', false);

  portapadrao.Text := ArquivoINI.ReadString('servidor', 'portapadrao', '80');
  portahttp.Text := ArquivoINI.ReadString('servidor', 'portahttp', '80');
  portahttps.Text := ArquivoINI.ReadString('servidor', 'portahttps', '443');

  CheckBox3.Checked := ArquivoINI.ReadBool('servidor', 'ssl', false);
  CheckBox6.Checked := ArquivoINI.ReadBool('servidor', 'forcarssl', false);

  ComboBox1.ItemIndex := ArquivoINI.ReadInteger('servidor', 'metado', 0);
  ComboBox2.ItemIndex := ArquivoINI.ReadInteger('servidor', 'modo', 2);

  Edit1.Text := ArquivoINI.ReadString('servidor', 'cert', '');
  Edit2.Text := ArquivoINI.ReadString('servidor', 'key', '');
  Edit3.Text := ArquivoINI.ReadString('servidor', 'root', '');

  Edit4.Text := ArquivoINI.ReadString('servidor', 'senha', '');

  Edit5.Text := ArquivoINI.ReadString('servidor', 'listadecifras', '');

  CheckBox4.Checked := ArquivoINI.ReadBool('ddns', 'ativado', false);
  dominio.Text := ArquivoINI.ReadString('ddns', 'dominio', '');
  linkdeatualizacao.Text := ArquivoINI.ReadString('ddns',
    'linkdeatualizacao', '');

  CheckBox2.Checked := ArquivoINI.ReadBool('auto iniciar', 'ativado', false);
  if not IsUserAnAdmin then CheckBox2.Enabled:=false;

  Edit6.Text := ArquivoINI.ReadString('servidor', 'phpexe', '');

  Edit8.Text := ArquivoINI.ReadString('servidor', 'pythonexe', '');

  Edit7.Text := ArquivoINI.ReadString('servidor', 'iniciarprograma', '');

  if Edit7.Text <> '' then
  begin
    if FileExists(Edit7.Text) then
      ShellExecute(handle, 'runas', PChar(Edit7.Text), '', '', SW_HIDE)
    else
      ShowMessage
        ('Não foi possível iniciar um programa, verifique a localização do arquivo!');
  end;

  if CheckBox1.Checked = True then
  begin
    form1.IdHTTPServer1.DefaultPort := strtoint(portapadrao.Text);
    form1.IdHTTPServer1.Active := True;
  end;

  Label5.Caption := 'IP local: ' + GetIP();

end;

procedure Tform3.FormShow(Sender: TObject);
begin
  Left := (Screen.Width - Width) div 2;
  Top := (Screen.Height - Height) div 2;
end;

procedure Tform3.Label5Click(Sender: TObject);
var
  protocolo, porta: string;
begin
  if CheckBox3.Checked then
  begin
    protocolo := 'https://';
    porta := portahttps.Text;
  end
  else
  begin
    protocolo := 'http://';
    porta := portahttp.Text;
  end;

  ShellExecute(handle, 'open', PChar(protocolo + GetIP() + ':' + porta), nil,
    nil, SW_SHOWMAXIMIZED);

end;

procedure Tform3.Label8Click(Sender: TObject);
begin
  if Edit4.PasswordChar = #0 then
  begin
    Edit4.PasswordChar := char('*');
    Label8.Caption := 'Exibir';
  end
  else
  begin
    Edit4.PasswordChar := #0;
    Label8.Caption := 'Esconder';
  end;

end;

procedure Tform3.SpeedButton1Click(Sender: TObject);
begin
  if OpenDialog3.Execute then
    Edit6.Text := OpenDialog3.FileName;
end;

procedure Tform3.SpeedButton2Click(Sender: TObject);
var
  protocolo, url, lnk: string;
  Splitted: TArray<String>;
  i: integer;
begin
  if linkdeatualizacao.Text <> '' then
  begin
    lnk := linkdeatualizacao.Text;
    Splitted := lnk.Split([',']);
    for i := low(Splitted) to high(Splitted) do
    begin
      if Splitted[i] <> '' then
        ShowMessage('O servidor disse: ' + atualizaddns(trim(Splitted[i])));
    end;
  end
  else
    ShowMessage('Insira um link de atualização!');
end;

procedure Tform3.SpeedButton3Click(Sender: TObject);
var
  ArquivoINI: TIniFile;
var
  protocolo, url: string;
begin
  if dominio.Text <> '' then
  begin
    if form1.IdHTTPServer1.Active = True then
    begin
      ArquivoINI := TIniFile.Create(ExtractFileDir(Application.ExeName) +
        '\configuracoes.ini');
      if ArquivoINI.ReadBool('servidor', 'ssl', false) then
        protocolo := 'https://'
      else
        protocolo := 'http://';
      url := dominio.Text;
      url := StringReplace(url, 'https://', '', [rfIgnoreCase, rfReplaceAll]);
      url := StringReplace(url, 'http://', '', [rfIgnoreCase, rfReplaceAll]);
      url := StringReplace(url, '/', '', [rfIgnoreCase, rfReplaceAll]);
      url := StringReplace(url, ':', '', [rfIgnoreCase, rfReplaceAll]);
      if teste(protocolo + url + '/?teste=1') <> 'ok' then
        ShowMessage
          ('O teste falhou, o domínio não está se comunicando com este computador, verifique suas configurações!')
      else
        ShowMessage
          ('O teste foi bem sucedido, o domínio está se comunicando com este computador!');
    end
    else
      ShowMessage('Não é possível fazer este teste com o servidor desativado!');
    ArquivoINI.Free;
  end
  else
    ShowMessage('Insira um domínio!');
end;

procedure Tform3.SpeedButton4Click(Sender: TObject);
begin
  if OpenDialog4.Execute then
    Edit7.Text := OpenDialog4.FileName;
end;

procedure Tform3.SpeedButton5Click(Sender: TObject);
begin
  if OpenDialog5.Execute then
    Edit8.Text := OpenDialog5.FileName;
end;

procedure Tform3.Timer1Timer(Sender: TObject);
var
  ArquivoINI: TIniFile;
  protocolo, url, lnk: string;
  Splitted: TArray<String>;
  i: integer;
begin
  ArquivoINI := TIniFile.Create(ExtractFileDir(Application.ExeName) +
    '\configuracoes.ini');
  if (ArquivoINI.ReadBool('ddns', 'ativado', false)) and
    (form1.IdHTTPServer1.Active = True) and (dominio.Text <> '') then
  begin
    if CheckBox3.Checked = True then
      protocolo := 'https://'
    else
      protocolo := 'http://';
    url := dominio.Text;
    url := StringReplace(url, 'https://', '', [rfIgnoreCase, rfReplaceAll]);
    url := StringReplace(url, 'http://', '', [rfIgnoreCase, rfReplaceAll]);
    url := StringReplace(url, '/', '', [rfIgnoreCase, rfReplaceAll]);
    url := StringReplace(url, ':', '', [rfIgnoreCase, rfReplaceAll]);

    if teste(protocolo + url + '/?teste=1') <> 'ok' then
    begin

      lnk := linkdeatualizacao.Text;
      Splitted := lnk.Split([',']);
      for i := low(Splitted) to high(Splitted) do
      begin
        if Splitted[i] <> '' then
          atualizaddns(trim(Splitted[i]));
      end;
    end;
  end;
  ArquivoINI.Free;
end;

end.
