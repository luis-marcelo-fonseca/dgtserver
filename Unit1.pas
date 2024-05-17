unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdCustomTCPServer, IdCustomHTTPServer,
  IdHTTPServer, IdContext, StdCtrls, unit3, MMSystem, Buttons, ExtCtrls,
  Menus, EncdDecd, IdServerIOHandler, IdSSL, IdSSLOpenSSL, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdGlobalProtocols, IniFiles, ComCtrls,
  GIFImg, pngimage, ShellApi, IdHttp, IdStack, IdGlobal, IdSocketHandle,
  IdScheduler, IdSchedulerOfThread, IdSchedulerOfThreadPool;

type
  TForm1 = class(TForm)
    IdHTTPServer1: TIdHTTPServer;
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    Fechar1: TMenuItem;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Image2: TImage;
    Image1: TImage;
    Label2: TLabel;
    Image3: TImage;
    IdServerIOHandlerSSLOpenSSL1: TIdServerIOHandlerSSLOpenSSL;
    IdSchedulerOfThreadPool1: TIdSchedulerOfThreadPool;
    procedure IdHTTPServer1CommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure FormCreate(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure Fechar1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure IdHTTPServer1QuerySSLPort(APort: Word; var VUseSSL: Boolean);
    procedure IdServerIOHandlerSSLOpenSSL1GetPassword(var Password: string);
    procedure IdHTTPServer1Connect(AContext: TIdContext);
  private
    { Private declarations }
  public
    { Public declarations }
    var ssl, forcarssl :boolean;
    senha, listadecifras, phpexe, pythonexe :string;
    portahttp, portahttps:integer;
  end;

var
  Form1: TForm1;
  auto:Boolean;

implementation

{$R *.dfm}

function ServerSide(processador, arquivo, parametros:string):string;
var
  SA: TSecurityAttributes;
  SI: TStartupInfo;
  PI: TProcessInformation;
  StdOutPipeRead, StdOutPipeWrite: THandle;
  WasOK: Boolean;
  Buffer: array[0..255] of AnsiChar;
  BytesRead: Cardinal;
  WorkDir: string;
  Handle: Boolean;
begin
  Result := '';
  with SA do begin
    nLength := SizeOf(SA);
    bInheritHandle := True;
    lpSecurityDescriptor := nil;
  end;
  CreatePipe(StdOutPipeRead, StdOutPipeWrite, @SA, 0);
  try
    with SI do
    begin
      FillChar(SI, SizeOf(SI), 0);
      cb := SizeOf(SI);
      dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
      wShowWindow := SW_HIDE;
      hStdInput := GetStdHandle(STD_INPUT_HANDLE); // don't redirect stdin
      hStdOutput := StdOutPipeWrite;
      hStdError := StdOutPipeWrite;
    end;


    Handle := CreateProcess(nil, PChar(processador+' '+arquivo+' '+parametros),
                            nil, nil, True, 0, nil,
                            PChar(ExtractFileDir(processador)), SI, PI);
    CloseHandle(StdOutPipeWrite);
    if Handle then
      try
        repeat
          WasOK := ReadFile(StdOutPipeRead, Buffer, 255, BytesRead, nil);
          if BytesRead > 0 then
          begin
            Buffer[BytesRead] := #0;
            Result := Result + Buffer;
          end;
        until not WasOK or (BytesRead = 0);
        WaitForSingleObject(PI.hProcess, INFINITE);
      finally
        CloseHandle(PI.hThread);
        CloseHandle(PI.hProcess);
      end;
  finally
    CloseHandle(StdOutPipeRead);
  end;


end;


procedure TForm1.Fechar1Click(Sender: TObject);
begin
IdHTTPServer1.Active:=false;
Application.Terminate;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
CanClose := False;
 Self.Hide();
  TrayIcon1.Visible := True;
  TrayIcon1.Animate := True;
  TrayIcon1.ShowBalloonHint;
end;

procedure TForm1.FormCreate(Sender: TObject);
var ResStream: TResourceStream;
ArquivoINI: TIniFile;
begin
CreateMutex(nil, false, 'flywer.server');
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    halt;
  end;

if ParamStr(1) = 'auto' then
begin
Application.ShowMainForm:=false;
TrayIcon1.Visible := true;
 TrayIcon1.Animate := True;
  TrayIcon1.ShowBalloonHint;
  auto:=true;
end;

if not DirectoryExists(ExtractFileDir(Application.ExeName)+'\raiz') then
    CreateDir(ExtractFileDir(Application.ExeName)+'\raiz');


if not FileExists(ExtractFileDir(Application.ExeName)+'\raiz\favicon.ico') then begin
  ResStream := TResourceStream.Create(HInstance, 'Icon_1', RT_RCDATA);
  try
    ResStream.Position := 0;
    ResStream.SaveToFile(ExtractFileDir(Application.ExeName)+'\raiz\favicon.ico');
  finally
   ResStream.Free;
  end;
end;



 if not FileExists(ExtractFileDir(Application.ExeName)+'\libeay32.dll') then begin
  ResStream := TResourceStream.Create(HInstance, 'Resource_1', RT_RCDATA);
  try
    ResStream.Position := 0;
    ResStream.SaveToFile(ExtractFileDir(Application.ExeName)+'\libeay32.dll');
  finally
   ResStream.Free;
  end;
end;

 if not FileExists(ExtractFileDir(Application.ExeName)+'\ssleay32.dll') then begin
  ResStream := TResourceStream.Create(HInstance, 'Resource_2', RT_RCDATA);
  try
    ResStream.Position := 0;
    ResStream.SaveToFile(ExtractFileDir(Application.ExeName)+'\ssleay32.dll');
  finally
   ResStream.Free;
  end;
end;


ArquivoINI := TIniFile.Create(ExtractFileDir(Application.ExeName) +
    '\configuracoes.ini');

  IdServerIOHandlerSSLOpenSSL1.SSLOptions.SSLVersions :=[];

  case ArquivoINI.ReadInteger('servidor', 'metado', 0) of
  0: IdServerIOHandlerSSLOpenSSL1.SSLOptions.SSLVersions := [sslvSSLv2, sslvSSLv23, sslvSSLv3, sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
  1: IdServerIOHandlerSSLOpenSSL1.SSLOptions.Method:= sslvSSLv2;
  2: IdServerIOHandlerSSLOpenSSL1.SSLOptions.Method:= sslvSSLv23;
  3: IdServerIOHandlerSSLOpenSSL1.SSLOptions.Method:= sslvSSLv3;
  4: IdServerIOHandlerSSLOpenSSL1.SSLOptions.Method:= sslvTLSv1;
  5: IdServerIOHandlerSSLOpenSSL1.SSLOptions.Method:= sslvTLSv1_1;
  6: IdServerIOHandlerSSLOpenSSL1.SSLOptions.Method:= sslvTLSv1_2;
  end;

  case ArquivoINI.ReadInteger('servidor', 'modo', 2) of
  0: IdServerIOHandlerSSLOpenSSL1.SSLOptions.Mode:= sslmBoth;
  1: IdServerIOHandlerSSLOpenSSL1.SSLOptions.Mode:= sslmClient;
  2: IdServerIOHandlerSSLOpenSSL1.SSLOptions.Mode:= sslmServer;
  3: IdServerIOHandlerSSLOpenSSL1.SSLOptions.Mode:= sslmUnassigned;
  end;


IdServerIOHandlerSSLOpenSSL1.SSLOptions.CertFile := ArquivoINI.ReadString('servidor', 'cert', '');
IdServerIOHandlerSSLOpenSSL1.SSLOptions.KeyFile := ArquivoINI.ReadString('servidor', 'key', '');
IdServerIOHandlerSSLOpenSSL1.SSLOptions.RootCertFile := ArquivoINI.ReadString('servidor', 'root', '');
senha := ArquivoINI.ReadString('servidor', 'senha', '');
listadecifras := ArquivoINI.ReadString('servidor', 'listadecifras', '');


if ArquivoINI.readBool('servidor', 'ssl', false) = true then begin
IdHTTPServer1.IOHandler := IdServerIOHandlerSSLOpenSSL1;
ssl:=true;
forcarssl:= ArquivoINI.readBool('servidor', 'forcessl', false);
end;

IdHTTPServer1.KeepAlive:= ArquivoINI.readBool('servidor', 'conexaopersistente', true);
IdHTTPServer1.DefaultPort := strtoint(ArquivoINI.ReadString('servidor', 'portapadrao', '80'));

IdHTTPServer1.Bindings.Clear;
IdHTTPServer1.Bindings.Add.Port := strtoint( ArquivoINI.ReadString('servidor', 'portahttp', '80') );
IdHTTPServer1.Bindings.Add.Port := strtoint( ArquivoINI.ReadString('servidor', 'portahttps', '443') );
portahttp:= strtoint( ArquivoINI.ReadString('servidor', 'portahttp', '80') );
portahttps:= strtoint( ArquivoINI.ReadString('servidor', 'portahttps', '443') );

phpexe:=ArquivoINI.ReadString('servidor', 'phpexe', '');
pythonexe:=ArquivoINI.ReadString('servidor', 'pythonexe', '');

IdHTTPServer1.Active := ArquivoINI.readBool('servidor', 'ativado', true);

if IdHTTPServer1.Active then begin
Image1.Visible:=true;
Image2.Visible:=false;
end else begin
Image1.Visible:=False;
Image2.Visible:=true;
end;



ArquivoINI.Free;




if IdHTTPServer1.Active then begin
Image2.Visible:=true;
Image1.Visible:=false;
Label2.Caption:='Ativo';
end else begin
Image2.Visible:=False;
Image1.Visible:=true;
Label2.Caption:='Desativado';
end;

end;

procedure TForm1.FormShow(Sender: TObject);
begin
Left:=(Screen.Width-Width)  div 2;
Top:=(Screen.Height-Height) div 2;
end;

procedure TForm1.IdHTTPServer1CommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
 var resposta :string;
 I:integer;
 arquivo, index, indexpython, indexphp, parametros, raiz : string;
begin


if ((ARequestInfo.Params.Values['teste'] = '1') and (ARequestInfo.Command = 'GET') ) then
begin
AResponseInfo.ContentText := 'ok';
end else begin

//forçar https
if forcarssl then
begin
if TIdSSLIOHandlerSocketBase(AContext.Connection.IOHandler).PassThrough then
begin
AResponseInfo.Redirect('https://'+ARequestInfo.Host+ARequestInfo.Document);
exit;
end;
end;


arquivo:= ExtractFileDir(Application.ExeName)+'\raiz'+StringReplace(UTF8Decode(ARequestInfo.Document), '/', '\', [rfIgnoreCase, rfReplaceAll]);

if not FileExists(arquivo) then begin

if copy(ARequestInfo.Document,length(ARequestInfo.Document),1) = '/' then index:='index.html' else
index:='\index.html';

if copy(ARequestInfo.Document,length(ARequestInfo.Document),1) = '/' then indexphp:='index.php' else
indexphp:='\index.php';

if copy(ARequestInfo.Document,length(ARequestInfo.Document),1) = '/' then indexpython:='index.py' else
indexpython:='\index.py';

if FileExists(ExtractFileDir(Application.ExeName)+'\raiz'+StringReplace(UTF8Decode(ARequestInfo.Document), '/', '\', [rfIgnoreCase, rfReplaceAll])+index) then
arquivo:= ExtractFileDir(Application.ExeName)+'\raiz'+StringReplace(UTF8Decode(ARequestInfo.Document), '/', '\', [rfIgnoreCase, rfReplaceAll])+index else

if FileExists(ExtractFileDir(Application.ExeName)+'\raiz'+StringReplace(UTF8Decode(ARequestInfo.Document), '/', '\', [rfIgnoreCase, rfReplaceAll])+indexphp) then
arquivo:= ExtractFileDir(Application.ExeName)+'\raiz'+StringReplace(UTF8Decode(ARequestInfo.Document), '/', '\', [rfIgnoreCase, rfReplaceAll])+indexphp else

if FileExists(ExtractFileDir(Application.ExeName)+'\raiz'+StringReplace(UTF8Decode(ARequestInfo.Document), '/', '\', [rfIgnoreCase, rfReplaceAll])+indexpython) then
arquivo:= ExtractFileDir(Application.ExeName)+'\raiz'+StringReplace(UTF8Decode(ARequestInfo.Document), '/', '\', [rfIgnoreCase, rfReplaceAll])+indexpython else
arquivo:= '404';
end;

if arquivo <> '404' then begin
AResponseInfo.ResponseNo := 200;
AResponseInfo.CacheControl := 'no-cache';
AResponseInfo.CharSet := 'utf-8';

if ARequestInfo.UnparsedParams = '' then raiz:= 'raiz='+ExtractFileDir(Application.ExeName)+'\raiz\' else
raiz:= '&raiz='+ExtractFileDir(Application.ExeName)+'\raiz\';

raiz:= StringReplace(raiz, ' ', '+', [rfIgnoreCase, rfReplaceAll]);

if ARequestInfo.Command = 'GET' then begin
parametros:= ARequestInfo.UnparsedParams+raiz
end;

if ARequestInfo.Command = 'POST' then begin
parametros:= ARequestInfo.UnparsedParams+raiz
end;


if ExtractFileExt(LowerCase(arquivo)) = '.php' then begin
AResponseInfo.ContentText := ServerSide(phpexe, '-q -f "'+arquivo+'"', parametros);
AResponseInfo.ContentType := 'text/html';
end
else
if ExtractFileExt(LowerCase(arquivo)) = '.py' then begin
AResponseInfo.ContentText := ServerSide(pythonexe, '"'+arquivo+'"', parametros);
AResponseInfo.ContentType := 'text/html';
end
else
begin


AResponseInfo.ContentType := GetMIMETypeFromFile(arquivo);
AResponseInfo.ContentStream := TFileStream.Create(arquivo, fmOpenRead or fmShareCompat);


end;

end else begin
AResponseInfo.CacheControl := 'no-cache';
AResponseInfo.CharSet := 'utf-8';
AResponseInfo.ResponseNo := 404;
AResponseInfo.ContentText := '<h1 align="center">Erro 404 - página não encontrada</h1>';
end;


end;

end;




procedure TForm1.IdHTTPServer1Connect(AContext: TIdContext);
begin
 {if ssl then
  TIdSSLIOHandlerSocketBase(AContext.Connection.IOHandler).PassThrough := false; }
end;

procedure TForm1.IdHTTPServer1QuerySSLPort(APort: Word; var VUseSSL: Boolean);
begin
VUseSSL := (APort = portahttps);
end;

procedure TForm1.IdServerIOHandlerSSLOpenSSL1GetPassword(var Password: string);
begin
Password := senha;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
ShellExecute(Application.HANDLE, 'open', PChar('https://github.com/luis-marcelo-fonseca/dgtserver/'),nil,nil,SW_SHOWNORMAL);
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
form3.Show;
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
IdHTTPServer1.Active:=false;
Application.Terminate;
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
ShellExecute(Application.HANDLE, 'open', PChar(ExtractFileDir(Application.ExeName)+'\raiz\'),nil,nil,SW_SHOWNORMAL);
end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
TrayIcon1.Visible := False;
  if auto then begin auto:=false; Form1.ShowModal; end else show;
  Application.BringToFront();
end;

end.
