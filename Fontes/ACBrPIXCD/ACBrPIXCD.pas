{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}

(*

  Documenta��o:
  https://github.com/bacen/pix-api

*)
{$I ACBr.inc}

unit ACBrPIXCD;

interface

uses
  Classes, SysUtils,
  httpsend, ssl_openssl, ACBrOpenSSLUtils,
  ACBrBase,
  ACBrPIXBase, ACBrPIXBRCode,
  ACBrPIXSchemasProblema,
  ACBrPIXSchemasPixConsultados, ACBrPIXSchemasPix, ACBrPIXSchemasDevolucao,
  ACBrPIXSchemasCobsConsultadas, ACBrPIXSchemasCob;

const
  ChttpTimeOutDef = 90000;

  ChttpMethodGET = 'GET';
  ChttpMethodPOST = 'POST';
  ChttpMethodPUT = 'PUT';
  ChttpMethodPATCH = 'PATCH';
  ChttpMethodDELETE = 'DELETE';

  CContentTypeUTF8 = 'charset=utf-8';
  CContentTypeTextPlain = 'text/plain';
  CContentTypeApplicationJSon = 'application/json';
  CContentTypeApplicationWwwFormUrlEncoded = 'application/x-www-form-urlencoded';

  ChttpHeaderAuthorization = 'Authorization:';
  ChttpHeaderContentType = 'Content-Type:';
  ChttpHeaderContentEncoding = 'Content-Encoding:';
  ChhtpHeaderAcceptEncoding = 'Accept-Encoding:';
  ChttpContentEncodingCompress: array[0..2] of String = ('gzip', 'compress', 'deflate');

  HTTP_CONTINUE                     = 100;
  HTTP_SWITCHING_PROTOCOLS          = 101;
  HTTP_PROCESSING                   = 102;
  HTTP_OK                           = 200;
  HTTP_CREATED                      = 201;
  HTTP_ACCEPTED                     = 202;
  HTTP_NON_AUTHORITATIVE            = 203;
  HTTP_NO_CONTENT                   = 204;
  HTTP_RESET_CONTENT                = 205;
  HTTP_PARTIAL_CONTENT              = 206;
  HTTP_MULTI_STATUS                 = 207;
  HTTP_MULTIPLE_CHOICES             = 300;
  HTTP_MOVED_PERMANENTLY            = 301;
  HTTP_MOVED_TEMPORARILY            = 302;
  HTTP_SEE_OTHER                    = 303;
  HTTP_NOT_MODIFIED                 = 304;
  HTTP_USE_PROXY                    = 305;
  HTTP_TEMPORARY_REDIRECT           = 307;
  HTTP_BAD_REQUEST                  = 400;
  HTTP_UNAUTHORIZED                 = 401;
  HTTP_PAYMENT_REQUIRED             = 402;
  HTTP_FORBIDDEN                    = 403;
  HTTP_NOT_FOUND                    = 404;
  HTTP_METHOD_NOT_ALLOWED           = 405;
  HTTP_NOT_ACCEPTABLE               = 406;
  HTTP_PROXY_AUTHENTICATION_REQUIRED= 407;
  HTTP_REQUEST_TIME_OUT             = 408;
  HTTP_CONFLICT                     = 409;
  HTTP_GONE                         = 410;
  HTTP_LENGTH_REQUIRED              = 411;
  HTTP_PRECONDITION_FAILED          = 412;
  HTTP_REQUEST_ENTITY_TOO_LARGE     = 413;
  HTTP_REQUEST_URI_TOO_LARGE        = 414;
  HTTP_UNSUPPORTED_MEDIA_TYPE       = 415;
  HTTP_RANGE_NOT_SATISFIABLE        = 416;
  HTTP_EXPECTATION_FAILED           = 417;
  HTTP_UNPROCESSABLE_ENTITY         = 422;
  HTTP_LOCKED                       = 423;
  HTTP_FAILED_DEPENDENCY            = 424;
  HTTP_INTERNAL_SERVER_ERROR        = 500;
  HTTP_NOT_IMPLEMENTED              = 501;
  HTTP_BAD_GATEWAY                  = 502;
  HTTP_SERVICE_UNAVAILABLE          = 503;
  HTTP_GATEWAY_TIME_OUT             = 504;
  HTTP_VERSION_NOT_SUPPORTED        = 505;
  HTTP_VARIANT_ALSO_VARIES          = 506;
  HTTP_INSUFFICIENT_STORAGE         = 507;
  HTTP_NOT_EXTENDED                 = 510;

resourcestring
  sErroMetodoNaoImplementado = 'M�todo %s n�o implementado na Classe %s';
  sErroParametroInvalido = 'Par�metros %s inv�lido ou n�o informado';
  sErroObjetoNaoPrenchido = 'Objeto %s n�o preenchido';
  sErroRecebedorNome = 'Nome do Recebedor n�o informado';
  sErroRecebedorCidade = 'Cidade do Recebedor n�o informada';
  sErroPSPNaoAtribuido = 'Componente ACBrPSP n�o atribuido';
  sErroPSPChavePIX = 'Chave Pix n�o informada';
  sErroPSPTipoChave = 'Chave Pix inv�lida';
  sErroHttp = 'Erro HTTP: %d, Metodo: %s, URL: %s';
  sErroPropriedadeNaoDefinida = 'Propriedade %s n�o atribuida';


type

  TACBrPixCD = class;
  TACBrPSP = class;

  EACBrPixHttpException = class(EACBrPixException);
  EACBrPSPException = class(EACBrPixException);

  TACBrPixCDAmbiente = (ambTeste, ambProducao, ambPreProducao);

  { TACBrPixEndPoint - Classe com comandos b�sicos, para EndPoints}

  TACBrPixEndPoint = class
  private
    fPSP: TACBrPSP;
    fHTTP: THTTPSend;
    fProblema: TACBrPIXProblema;
  protected
    fpEndPoint: String;
  public
    constructor Create(AOwner: TACBrPSP);
    destructor Destroy; override;
    procedure Clear;

    property Problema: TACBrPIXProblema read fProblema;
    property EndPoint: String read fpEndPoint;
  end;

  { TACBrPixEndPointPix - EndPoint /pix }

  TACBrPixEndPointPix = class(TACBrPixEndPoint)
  private
    fDevolucao: TACBrPIXDevolucao;
    fDevolucaoSolicitada: TACBrPIXDevolucaoSolicitada;
    fPix: TACBrPIX;
    fPixConsultados: TACBrPIXConsultados;
  public
    constructor Create(AOwner: TACBrPSP);
    destructor Destroy; override;
    procedure Clear;

    function ConsultarPix(const e2eid: String): Boolean;
    function ConsultarPixRecebidos(Inicio: TDateTime; Fim: TDateTime;
      const TxId: String = ''; const CpfCnpj: String = '';
      PagAtual: Integer = 0; ItensPorPagina: Integer = 100): Boolean;
    function SolicitarDevolucaoPix(const e2eid, idDevolucao: String): Boolean;
    function ConsultarDevolucaoPix(const e2eid, idDevolucao: String): Boolean;

    property PixConsultados: TACBrPIXConsultados read fPixConsultados;
    property Pix: TACBrPIX read fPix;
    property Devolucao: TACBrPIXDevolucao read fDevolucao;
    property DevolucaoSolicitada: TACBrPIXDevolucaoSolicitada read fDevolucaoSolicitada;
  end;

  { TACBrPixEndPointCob - EndPoint /cob }

  TACBrPixEndPointCob = class(TACBrPixEndPoint)
  private
    fCobCompleta: TACBrPIXCobCompleta;
    fCobRevisada: TACBrPIXCobRevisada;
    fCobsConsultadas: TACBrPIXCobsConsultadas;
    fCobSolicitada: TACBrPIXCobSolicitada;
    fCobGerada: TACBrPIXCobGerada;
  public
    constructor Create(AOwner: TACBrPSP);
    destructor Destroy; override;
    procedure Clear;

    function CriarCobrancaImediata: Boolean; overload;
    function CriarCobrancaImediata(const TxId: String) : Boolean; overload;
    function RevisarCobrancaImediata(const TxId: String) : Boolean;
    function ConsultarCobrancaImediata(const TxId: String; Revisao: Integer = 0) : Boolean;
    function ConsultarCobrancas(Inicio: TDateTime; Fim: TDateTime;
      const CpfCnpj: String = ''; LocationPresente: Boolean = False;
      const Status: String = ''; PagAtual: Integer = 0; ItensPorPagina: Integer = 100): Boolean;

    property CobsConsultadas: TACBrPIXCobsConsultadas read fCobsConsultadas;
    property CobSolicitada: TACBrPIXCobSolicitada read fCobSolicitada;
    property CobGerada: TACBrPIXCobGerada read fCobGerada;
    property CobRevisada: TACBrPIXCobRevisada read fCobRevisada;
    property CobCompleta: TACBrPIXCobCompleta read fCobCompleta;
  end;

  TACBrQuandoTransmitirHttp = procedure(var AURL: String; var AMethod: String;
    var HttpBody: AnsiString) of object;

  TACBrQuandoReceberRespostaHttp = procedure(const AURL: String; const AMethod: String;
    const HttpResponse: AnsiString) of object;

  TACBrQuandoNecessitarCredencial = procedure(const TipoCredencial: TACBrOpenSSLCredential;
    var Resposta: AnsiString) of object;


  { TACBrQueryParams }

  TACBrQueryParams = class(TStringList)
  private
    function GetAsURL: String;
  public
    property AsURL: String read GetAsURL;
  end;


  { TACBrPSP - O Componente Base, para os PSPs, deve ser conectado em TACBrPixCD}

  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrPSP = class(TACBrComponent)
  private
    fAPIVersion: TACBrPIXAPIVersion;
    fChavePIX: String;
    fURLPathParams: TStringList;
    fURLQueryParams: TACBrQueryParams;
    fQuandoReceberRespostaHttp: TACBrQuandoReceberRespostaHttp;
    fQuandoTransmitirHttp: TACBrQuandoTransmitirHttp;
    fClientID: AnsiString;
    fClientSecret: AnsiString;
    fk1, fk2: String;
    fTipoChave: TACBrPIXTipoChave;

    fepPix: TACBrPixEndPointPix;
    fepCob: TACBrPixEndPointCob;
    fPixCD: TACBrPixCD;
    fHttpSend: THTTPSend;

    function GetClientID: String;
    procedure SetClientID(AValue: String);
    function GetClientSecret: String;
    procedure SetClientSecret(AValue: String);
    procedure SetTipoChave(AValue: TACBrPIXTipoChave);
    procedure SetChavePIX(AValue: String);
    procedure SetACBrPixCD(AValue: TACBrPixCD);
  protected
    fpAutenticado: Boolean;
    fpToken: String;
    fpRefereshToken: String;
    fpValidadeToken: TDateTime;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure VerificarPIXCDAtribuido;

    function ObterURLAmbiente(const Ambiente: TACBrPixCDAmbiente): String; virtual;
    procedure ConfigurarHTTP; virtual;
    procedure ConfigurarProxy; virtual;
    procedure ConfigurarTimeOut; virtual;
    procedure ConfigurarHeaders(const Method, AURL: String); virtual;
    procedure ConfigurarAutenticacao(const Method, EndPoint: String); virtual;
    procedure ConfigurarPathParameters(const Method, EndPoint: String); virtual;
    procedure ConfigurarQueryParameters(const Method, EndPoint: String); virtual;

    procedure LimparHTTP; virtual;
    procedure PrepararHTTP; virtual;
    function AcessarEndPoint(const Method, EndPoind: String;
      out ResultCode: Integer; out RespostaHttp: AnsiString): Boolean; virtual;
    function CalcularURLEndPoint(const Method, EndPoint: String): String; virtual;
    function CalcularEndPointPath(const Method, EndPoint: String): String; virtual;

    function TransmitirHttp(const Method, URL: String; out ResultCode: Integer; out
      RespostaHttp: AnsiString): Boolean; virtual;
    procedure TratarRetornoComErro(ResultCode: Integer; const RespostaHttp: AnsiString;
      Problema: TACBrPIXProblema); virtual;
    procedure AtribuirErroHTTPProblema(Problema: TACBrPIXProblema); virtual;

    property URLQueryParams: TACBrQueryParams read fURLQueryParams;
    property URLPathParams: TStringList read fURLPathParams;
  protected
    property ClientID: String read GetClientID write SetClientID;
    property ClientSecret: String read GetClientSecret write SetClientSecret;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;

    procedure Autenticar; virtual;
    procedure VerificarValidadeToken; virtual;
    procedure RenovarToken; virtual;
    procedure VerificarAutenticacao; virtual;
    property Autenticado: Boolean read fpAutenticado;
    property ValidadeToken: TDateTime read fpValidadeToken;

    property epPix: TACBrPixEndPointPix read fepPix;
    property epCob: TACBrPixEndPointCob read fepCob;

    property Http: THTTPSend read fHttpSend;
  published
    property APIVersion: TACBrPIXAPIVersion read fAPIVersion write fAPIVersion default ver262;
    property ChavePIX: String read fChavePIX write SetChavePIX;
    property TipoChave: TACBrPIXTipoChave read fTipoChave write SetTipoChave stored false;

    property ACBrPixCD: TACBrPixCD read fPixCD write SetACBrPixCD;

    property QuandoTransmitirHttp : TACBrQuandoTransmitirHttp
      read fQuandoTransmitirHttp write fQuandoTransmitirHttp;
    property QuandoReceberRespostaHttp: TACBrQuandoReceberRespostaHttp
      read fQuandoReceberRespostaHttp write fQuandoReceberRespostaHttp;
  end;

  { TACBrPixRecebedor }

  TACBrPixRecebedor = class(TPersistent)
  private
    fCEP: String;
    fCidade: String;
    fCodCategoriaComerciante: Integer;
    fNome: String;
    fUF: String;

    procedure SetCEP(AValue: String);
    procedure SetCidade(AValue: String);
    procedure SetCodCategoriaComerciante(AValue: Integer);
    procedure SetNome(AValue: String);
    procedure SetUF(AValue: String);
  public
    constructor Create;
    procedure Clear;
    procedure Assign(Source: TACBrPixRecebedor); reintroduce;
  published
    property Nome: String read fNome write SetNome;
    property Cidade: String read fCidade write SetCidade;
    property UF: String read fUF write SetUF;
    property CEP: String read fCEP write SetCEP;
    property CodCategoriaComerciante: Integer read fCodCategoriaComerciante  // https://classification.codes/classifications/industry/mcc/
      write SetCodCategoriaComerciante;
  end;

  { TACBrPixDadosAutomacao }

  TACBrPixDadosAutomacao = class(TPersistent)
  private
    fCNPJSoftwareHouse: String;
    fNomeAplicacao: String;
    fNomeSoftwareHouse: String;
    fVersaoAplicacao: String;
  public
    constructor Create;
    procedure Clear;
    procedure Assign(Source: TACBrPixDadosAutomacao); reintroduce;
  published
    property NomeSoftwareHouse: String read fNomeSoftwareHouse write fNomeSoftwareHouse;
    property CNPJSoftwareHouse: String read fCNPJSoftwareHouse write fCNPJSoftwareHouse;
    property NomeAplicacao: String read fNomeAplicacao write fNomeAplicacao ;
    property VersaoAplicacao: String read fVersaoAplicacao write fVersaoAplicacao ;
  end;


  { TACBrHttpProxy }

  TACBrHttpProxy = class(TPersistent)
  private
    fHost: String;
    fPass: String;
    fPort: String;
    fUser: String;
  public
    constructor Create;
    procedure Clear;
    procedure Assign(Source: TACBrHttpProxy); reintroduce;
  published
    property Host: String read fHost write fHost;
    property Port: String read fPort write fPort;
    property User: String read fUser write fUser;
    property Pass: String read fPass write fPass;
  end;

  { TACBrPixCD - O Componente em si...}

  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrPixCD = class(TACBrComponent)
  private
    fAmbiente: TACBrPixCDAmbiente;
    fArqLOG: String;
    fDadosAutomacao: TACBrPixDadosAutomacao;
    fNivelLog: Byte;
    fProxy: TACBrHttpProxy;
    fPSP: TACBrPSP;
    fQuandoGravarLog: TACBrGravarLog;
    fRecebedor: TACBrPixRecebedor;
    fTimeOut: Integer;

    procedure SetACBrPSP(AValue: TACBrPSP);
    procedure SetDadosAutomacao(AValue: TACBrPixDadosAutomacao);
    procedure SetProxy(AValue: TACBrHttpProxy);
    procedure SetRecebedor(AValue: TACBrPixRecebedor);

    procedure VerificarPSPAtribuido;
    procedure GravarLogEmArquivo(const ALinha: String) ;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure RegistrarLog(const ALinha: String; NivelLog: Byte = 0);
    procedure DispararExcecao(E: Exception);

    function GerarQRCodeEstatico(Valor: Currency; const infoAdicional: String = '';
      const TxId: String = ''): String; overload;
    function GerarQRCodeEstatico(const ChavePix: String; Valor: Currency;
      const infoAdicional: String = ''; const TxId: String = ''): String; overload;
    function GerarQRCodeDinamico(const Location: String): String;

  published
    property Recebedor: TACBrPixRecebedor read fRecebedor write SetRecebedor;
    property DadosAutomacao: TACBrPixDadosAutomacao read fDadosAutomacao write SetDadosAutomacao;
    property Proxy: TACBrHttpProxy read fProxy write SetProxy;
    property TimeOut: Integer read fTimeOut write fTimeOut default ChttpTimeOutDef;
    property Ambiente: TACBrPixCDAmbiente read fAmbiente write fAmbiente default ambTeste;

    property PSP: TACBrPSP read fPSP write SetACBrPSP;

    property ArqLOG: String read fArqLOG write fArqLOG;
    property NivelLog: Byte read fNivelLog write fNivelLog default 1;
    property QuandoGravarLog: TACBrGravarLog read fQuandoGravarLog write fQuandoGravarLog;
  end;

function URLComDelimitador(AURL: String): String;
function URLSemDelimitador(AURL: String): String;
function GetHeaderValue(const AValue : String; AStringList: TStringList) : String ;
function ContentIsCompressed(AHeader: TStringList): Boolean;
function DecompressStream(AStream: TStream): AnsiString;

implementation

uses
  StrUtils,
  synacode, synautil,
  ACBrUtil, ACBrCompress, ACBrValidador,
  ACBrPIXUtil;

function URLComDelimitador(AURL: String): String;
begin
  Result := Trim(AURL);
  if (RightStr(Result, 1) <> '/') then
    Result := Result + '/'
end;

function URLSemDelimitador(AURL: String): String;
begin
  Result := Trim(AURL);
  while (Result <> '') and (RightStr(Result, 1) = '/') do
    Delete(Result, Length(Result), 1);
end;

function GetHeaderValue(const AValue : String; AStringList: TStringList) : String ;
var
  i: Integer;
  u, LinhaHeader: String;
begin
  Result := '';
  u := UpperCase(Trim(AValue));
  if (u = '') then
    Exit;

  i := 0;
  while (Result = '') and (i < AStringList.Count) do
  begin
    LinhaHeader := AStringList[i];
    if (pos(u, UpperCase(LinhaHeader)) = 1) then
      Result := Trim(copy(LinhaHeader, Length(u)+1, Length(LinhaHeader)));
    Inc(i);
  end;
end;

function ContentIsCompressed(AHeader: TStringList): Boolean;
var
  ce: String;
  i: Integer;
begin
  ce := GetHeaderValue(ChttpHeaderContentEncoding, AHeader);
  i := Low(ChttpContentEncodingCompress);
  Result := False;
  while (not Result) and (i <= High(ChttpContentEncodingCompress)) do
  begin
    Result := (pos(ChttpContentEncodingCompress[i], ce) > 0);
    Inc(i);
  end;
end;

function DecompressStream(AStream: TStream): AnsiString;
var
  zt: TCompressType;
begin
  zt := DetectCompressType(AStream);
  if (zt = ctUnknown) then  // Not compressed...
  begin
    AStream.Position := 0;
    Result := ReadStrFromStream(AStream, AStream.Size);
  end
  else
    Result := UnZip(AStream);
end;

{ TACBrPixEndPoint }

constructor TACBrPixEndPoint.Create(AOwner: TACBrPSP);
begin
  inherited Create;
  fPSP := AOwner;
  fHTTP := fPSP.Http;
  fpEndPoint := '';
  fProblema := TACBrPIXProblema.Create;
end;

destructor TACBrPixEndPoint.Destroy;
begin
  fProblema.Free;
  inherited Destroy;
end;

procedure TACBrPixEndPoint.Clear;
begin
  fProblema.Clear;
end;

{ TACBrPixEndPointPix }

constructor TACBrPixEndPointPix.Create(AOwner: TACBrPSP);
begin
  if (AOwner = nil) then
    raise EACBrPixException.Create(ACBrStr(sErroPSPNaoAtribuido));

  inherited Create(AOwner);
  fpEndPoint := '/pix';

  fPixConsultados := TACBrPIXConsultados.Create;
  fPix := TACBrPIX.Create('');
  fDevolucao := TACBrPIXDevolucao.Create('');
  fDevolucaoSolicitada := TACBrPIXDevolucaoSolicitada.Create('');
end;

destructor TACBrPixEndPointPix.Destroy;
begin
  fPixConsultados.Free;
  fPix.Free;
  fDevolucao.Free;
  fDevolucaoSolicitada.Free;
  inherited Destroy;
end;

procedure TACBrPixEndPointPix.Clear;
begin
  inherited Clear;
  fPixConsultados.Clear;
  fPix.Clear;
  fDevolucao.Clear;
  fDevolucaoSolicitada.Clear;
end;

function TACBrPixEndPointPix.ConsultarPix(const e2eid: String): Boolean;
var
  e: String;
  RespostaHttp: AnsiString;
  ResultCode: Integer;
begin
  if (Trim(e2eid) = '') then
    raise EACBrPixException.CreateFmt(ACBrStr(sErroParametroInvalido), ['e2eid']);
  e := ValidarEndToEndId(e2eid);
  if (e <> '') then
    raise EACBrPixException.Create(ACBrStr(e));

  Clear;
  fPSP.PrepararHTTP;
  fPSP.URLPathParams.Add(e2eid);
  fPSP.AcessarEndPoint(ChttpMethodGET, EndPoint, ResultCode, RespostaHttp);
  Result := (ResultCode = HTTP_OK);

  if Result then
    fPix.AsJSON := String(RespostaHttp)
  else
    fPSP.TratarRetornoComErro(ResultCode, RespostaHttp, Problema);
end;

function TACBrPixEndPointPix.ConsultarPixRecebidos(Inicio: TDateTime;
  Fim: TDateTime; const TxId: String; const CpfCnpj: String; PagAtual: Integer;
  ItensPorPagina: Integer): Boolean;
var
  s, e: String;
  RespostaHttp: AnsiString;
  ResultCode: Integer;
begin
  Clear;
  fPSP.PrepararHTTP;

  with fPSP.URLQueryParams do
  begin
    Values['inicio'] := DateTimeToIso8601(Inicio);
    Values['fim'] := DateTimeToIso8601(Fim);

    s := Trim(TxId);
    if (s <> '') then
    begin
      Values['txid'] := s;
      Values['txIdPresente'] := 'true';
    end;

    s := OnlyNumber(CpfCnpj);
    if (s <> '') then
    begin
      e := ValidarCNPJouCPF(s);
      if (e <> '') then
        raise EACBrPixException.Create(ACBrStr(e));

      if Length(s) < 12 then
        Values['cpf'] := s
      else
        Values['cnpj'] := s;
    end;

    if (PagAtual > 0) then
      Values['paginacao.paginaAtual'] := IntToStr(PagAtual);

    if (ItensPorPagina > 0) then
      Values['paginacao.itensPorPagina'] := IntToStr(ItensPorPagina);
  end;

  fPSP.AcessarEndPoint(ChttpMethodGET, EndPoint, ResultCode, RespostaHttp);
  Result := (ResultCode = HTTP_OK);

  if Result then
    fPixConsultados.AsJSON := String(RespostaHttp)
  else
    fPSP.TratarRetornoComErro(ResultCode, RespostaHttp, Problema);
end;

function TACBrPixEndPointPix.SolicitarDevolucaoPix(const e2eid,
  idDevolucao: String): Boolean;
var
  Body: String;
  RespostaHttp: AnsiString;
  ResultCode: Integer;
begin
  if (Trim(e2eid) = '') then
    raise EACBrPixException.CreateFmt(ACBrStr(sErroParametroInvalido), ['e2eid']);

  if (Trim(idDevolucao) = '') then
    raise EACBrPixException.CreateFmt(ACBrStr(sErroParametroInvalido), ['idDevolucao']);

  Body := Trim(fDevolucaoSolicitada.AsJSON);
  if (Body = '') then
    raise EACBrPixException.CreateFmt(ACBrStr(sErroObjetoNaoPrenchido), ['DevolucaoSolicitada']);

  Clear;
  fPSP.PrepararHTTP;
  fPSP.URLPathParams.Add(e2eid);
  fPSP.URLPathParams.Add('devolucao');
  fPSP.URLPathParams.Add(idDevolucao);
  WriteStrToStream(fPSP.Http.Document, Body);
  fPSP.Http.MimeType := CContentTypeApplicationJSon;
  fPSP.AcessarEndPoint(ChttpMethodPUT, EndPoint, ResultCode, RespostaHttp);
  Result := (ResultCode = HTTP_CREATED);

  if Result then
    fDevolucao.AsJSON := String(RespostaHttp)
  else
    fPSP.TratarRetornoComErro(ResultCode, RespostaHttp, Problema);
end;

function TACBrPixEndPointPix.ConsultarDevolucaoPix(const e2eid,
  idDevolucao: String): Boolean;
var
  RespostaHttp: AnsiString;
  ResultCode: Integer;
begin
  if (Trim(e2eid) = '') then
    raise EACBrPixException.CreateFmt(ACBrStr(sErroParametroInvalido), ['e2eid']);

  if (Trim(idDevolucao) = '') then
    raise EACBrPixException.CreateFmt(ACBrStr(sErroParametroInvalido), ['idDevolucao']);

  Clear;
  fPSP.PrepararHTTP;
  fPSP.URLPathParams.Add(e2eid);
  fPSP.URLPathParams.Add('devolucao');
  fPSP.URLPathParams.Add(idDevolucao);
  fPSP.AcessarEndPoint(ChttpMethodGET, EndPoint, ResultCode, RespostaHttp);
  Result := (ResultCode = HTTP_OK);

  if Result then
    fDevolucao.AsJSON := String(RespostaHttp)
  else
    fPSP.TratarRetornoComErro(ResultCode, RespostaHttp, Problema);
end;

{ TACBrPixEndPointCob }

constructor TACBrPixEndPointCob.Create(AOwner: TACBrPSP);
begin
  if (AOwner = nil) then
    raise EACBrPixException.Create(ACBrStr(sErroPSPNaoAtribuido));

  inherited Create(AOwner);
  fpEndPoint := '/cob';

  fCobsConsultadas := TACBrPIXCobsConsultadas.Create('');
  fCobSolicitada := TACBrPIXCobSolicitada.Create('');
  fCobGerada := TACBrPIXCobGerada.Create('');
  fCobRevisada := TACBrPIXCobRevisada.Create('');
  fCobCompleta := TACBrPIXCobCompleta.Create('');
end;

destructor TACBrPixEndPointCob.Destroy;
begin
  fCobsConsultadas.Free;
  fCobSolicitada.Free;
  fCobGerada.Free;
  fCobRevisada.Free;
  fCobCompleta.Free;
  inherited Destroy;
end;

procedure TACBrPixEndPointCob.Clear;
begin
  inherited Clear;
  fCobsConsultadas.Clear;
  fCobSolicitada.Clear;
  fCobGerada.Clear;
  fCobRevisada.Clear;
  fCobCompleta.Clear;
end;

function TACBrPixEndPointCob.CriarCobrancaImediata: Boolean;
var
  Body: String;
  RespostaHttp: AnsiString;
  ResultCode: Integer;
begin
  Body := Trim(fCobSolicitada.AsJSON);
  if (Body = '') then
    raise EACBrPixException.CreateFmt(ACBrStr(sErroObjetoNaoPrenchido), ['CobSolicitada']);

  Clear;
  fPSP.PrepararHTTP;
  WriteStrToStream(fPSP.Http.Document, Body);
  fPSP.Http.MimeType := CContentTypeApplicationJSon;
  fPSP.AcessarEndPoint(ChttpMethodPOST, EndPoint, ResultCode, RespostaHttp);
  Result := (ResultCode = HTTP_CREATED);

  if Result then
    fCobGerada.AsJSON := String(RespostaHttp)
  else
    fPSP.TratarRetornoComErro(ResultCode, RespostaHttp, Problema);
end;

function TACBrPixEndPointCob.CriarCobrancaImediata(const TxId: String): Boolean;
var
  Body: String;
  RespostaHttp: AnsiString;
  ResultCode: Integer;
begin
  if (Trim(TxId) = '') then
    raise EACBrPixException.CreateFmt(ACBrStr(sErroParametroInvalido), ['txid']);

  Body := Trim(fCobSolicitada.AsJSON);
  if (Body = '') then
    raise EACBrPixException.CreateFmt(ACBrStr(sErroObjetoNaoPrenchido), ['CobSolicitada']);

  Clear;
  fPSP.PrepararHTTP;
  fPSP.URLPathParams.Add(TxId);
  WriteStrToStream(fPSP.Http.Document, Body);
  fPSP.Http.MimeType := CContentTypeApplicationJSon;
  fPSP.AcessarEndPoint(ChttpMethodPUT, EndPoint, ResultCode, RespostaHttp);
  Result := (ResultCode = HTTP_CREATED);

  if Result then
    fCobGerada.AsJSON := String(RespostaHttp)
  else
    fPSP.TratarRetornoComErro(ResultCode, RespostaHttp, Problema);
end;

function TACBrPixEndPointCob.RevisarCobrancaImediata(const TxId: String): Boolean;
var
  Body: String;
  RespostaHttp: AnsiString;
  ResultCode: Integer;
begin
  if (Trim(TxId) = '') then
    raise EACBrPixException.CreateFmt(ACBrStr(sErroParametroInvalido), ['txid']);

  Body := Trim(fCobRevisada.AsJSON);
  if (Body = '') then
    raise EACBrPixException.CreateFmt(ACBrStr(sErroObjetoNaoPrenchido), ['CobRevisada']);

  Clear;
  fPSP.PrepararHTTP;
  fPSP.URLPathParams.Add(TxId);
  WriteStrToStream(fPSP.Http.Document, Body);
  fPSP.Http.MimeType := CContentTypeApplicationJSon;
  fPSP.AcessarEndPoint(ChttpMethodPATCH, EndPoint, ResultCode, RespostaHttp);
  Result := (ResultCode = HTTP_OK);

  if Result then
    fCobGerada.AsJSON := String(RespostaHttp)
  else
    fPSP.TratarRetornoComErro(ResultCode, RespostaHttp, Problema);
end;

function TACBrPixEndPointCob.ConsultarCobrancaImediata(const TxId: String;
  Revisao: Integer): Boolean;
var
  RespostaHttp: AnsiString;
  ResultCode: Integer;
begin
  if (Trim(TxId) = '') then
    raise EACBrPixException.CreateFmt(ACBrStr(sErroParametroInvalido), ['txid']);

  Clear;
  fPSP.PrepararHTTP;
  fPSP.URLPathParams.Add(TxId);
  if (Revisao <> 0) then
    fPSP.URLQueryParams.Values['revisao'] := IntToStr(Revisao);

  fPSP.AcessarEndPoint(ChttpMethodGET, EndPoint, ResultCode, RespostaHttp);
  Result := (ResultCode = HTTP_OK);

  if Result then
    fCobCompleta.AsJSON := String(RespostaHttp)
  else
    fPSP.TratarRetornoComErro(ResultCode, RespostaHttp, Problema);
end;

function TACBrPixEndPointCob.ConsultarCobrancas(Inicio: TDateTime;
  Fim: TDateTime; const CpfCnpj: String; LocationPresente: Boolean;
  const Status: String; PagAtual: Integer; ItensPorPagina: Integer): Boolean;
var
  s, e: String;
  RespostaHttp: AnsiString;
  ResultCode: Integer;
begin
  Clear;
  fPSP.PrepararHTTP;

  with fPSP.URLQueryParams do
  begin
    Values['inicio'] := DateTimeToIso8601(Inicio);
    Values['fim'] := DateTimeToIso8601(Fim);

    s := OnlyNumber(CpfCnpj);
    if (s <> '') then
    begin
      e := ValidarCNPJouCPF(s);
      if (e <> '') then
        raise EACBrPixException.Create(ACBrStr(e));

      if Length(s) < 12 then
        Values['cpf'] := s
      else
        Values['cnpj'] := s;
    end;

    Values['locationPresente'] := ifthen(LocationPresente, 'true', 'false');
    s := Trim(Status);
    if (s <> '') then
      Values['status'] := s;

    if (PagAtual > 0) then
      Values['paginacao.paginaAtual'] := IntToStr(PagAtual);

    if (ItensPorPagina > 0) then
      Values['paginacao.itensPorPagina'] := IntToStr(ItensPorPagina);
  end;

  fPSP.AcessarEndPoint(ChttpMethodGET, EndPoint, ResultCode, RespostaHttp);
  Result := (ResultCode = HTTP_OK);

  if Result then
    fCobsConsultadas.AsJSON := String(RespostaHttp)
  else
    fPSP.TratarRetornoComErro(ResultCode, RespostaHttp, Problema);
end;

{ TACBrQueryParams }

function TACBrQueryParams.GetAsURL: String;
var
  i: Integer;
  AName, AValue: String;
begin
  Result := '';
  if (Count = 0) then
    Exit;

  for i := 0 to Count-1 do
  begin
    AName := Names[i];
    if (AName <> '') then
    begin
      if (Result <> '') then
        Result := Result + '&';
      AValue := Values[AName];
      Result := Result + EncodeURLElement(AName)+'='+EncodeURLElement(AValue);
    end;
  end;
end;

{ TACBrPSP }

constructor TACBrPSP.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fAPIVersion := ver262;
  fChavePIX := '';
  fTipoChave := tchNenhuma;
  fpAutenticado := False;
  fpValidadeToken := 0;
  fpToken := '';
  fpRefereshToken := '';

  fHttpSend := THTTPSend.Create;
  fepPix := TACBrPixEndPointPix.Create(Self);
  fepCob := TACBrPixEndPointCob.Create(Self);
  fURLQueryParams := TACBrQueryParams.Create;
  fURLPathParams := TStringList.Create;

  fQuandoTransmitirHttp := Nil;
  fQuandoReceberRespostaHttp := Nil;
end;

destructor TACBrPSP.Destroy;
begin
  fHttpSend.Free;
  fepPix.Free;
  fepCob.Free;
  fURLQueryParams.Free;
  fURLPathParams.Free;

  inherited Destroy;
end;

procedure TACBrPSP.Clear;
begin
  fHttpSend.Clear;
  fURLQueryParams.Clear;
  fepPix.Clear;
  fepCob.Clear;
end;

procedure TACBrPSP.SetACBrPixCD(AValue: TACBrPixCD);
var
  va: TACBrPixCD;
  //s: String;
begin
  //DEBUG
  //s := 'Nil';
  //if AValue <> Nil then
  //  s := IfEmptyThen(AValue.Name, AValue.ClassName);
  //WriteLog('c:\temp\debug.log', 'TACBrPSP.SetACBrPixCD( '+s+' )');

  if (AValue = fPixCD) then
    Exit;

  if Assigned(fPixCD) then
    fPixCD.RemoveFreeNotification(Self);

  va := fPixCD;       // Usa outra variavel para evitar Loop Infinito,
  fPixCD := AValue;   // na remo��o da associa��o dos componentes

  if Assigned(va) then
    if Assigned(va.PSP) then
      va.PSP := Nil;

  if (AValue <> Nil) then
  begin
    AValue.FreeNotification(Self);
    AValue.PSP := Self;
  end ;
end;

procedure TACBrPSP.Notification(AComponent: TComponent; Operation: TOperation);
begin
  //DEBUG
  //WriteLog('c:\temp\debug.log', 'TACBrPSP.Notification('+
  //  IfEmptyThen(AComponent.Name, AComponent.ClassName)+', '+
  //  GetEnumName(TypeInfo(TOperation), integer(Operation) ) +' )' );

  inherited Notification(AComponent, Operation) ;
  if (Operation = opRemove) and (fPixCD <> Nil) and (AComponent is TACBrPixCD) then
    fPixCD := Nil
end;

procedure TACBrPSP.VerificarPIXCDAtribuido;
begin
  if not Assigned(fPixCD) then
    raise EACBrPixException.Create(ACBrStr(sErroPSPNaoAtribuido));
end;

function TACBrPSP.GetClientID: String;
begin
  Result := StrCrypt(fClientID, fk1);
end;

procedure TACBrPSP.SetClientID(AValue: String);
begin
  if (fk1 <> '') and (fClientID = StrCrypt(AValue, fk1)) then
    Exit;

  fk1 := FormatDateTime('hhnnsszzz',Now);
  fClientID := StrCrypt(AValue, fk1);  // Salva de forma Criptografada, para evitar "Inspect"
end;

function TACBrPSP.GetClientSecret: String;
begin
  Result := StrCrypt(fClientSecret, fk2);
end;

procedure TACBrPSP.SetClientSecret(AValue: String);
begin
  if (fk2 <> '') and (fClientSecret = StrCrypt(AValue, fk2)) then
    Exit;

  fk2 := FormatDateTime('hhnnsszzz',Now);
  fClientSecret := StrCrypt(AValue, fk2);  // Salva de forma Criptografada, para evitar "Inspect"
end;

procedure TACBrPSP.SetTipoChave(AValue: TACBrPIXTipoChave);
begin
  {}
end;

procedure TACBrPSP.SetChavePIX(AValue: String);
var
  TipoChave: TACBrPIXTipoChave;
begin
  if (fChavePix = AValue) then
    Exit;

  TipoChave := DetectarTipoChave(AValue);
  if (TipoChave = tchNenhuma) then
    raise EACBrPixException.CreateFmt(ACBrStr(sErroChaveInvalida), [AValue]);

  fChavePix := Trim(AValue);
  fTipoChave := TipoChave;
end;

function TACBrPSP.ObterURLAmbiente(const Ambiente: TACBrPixCDAmbiente): String;
begin
  Result := '';
  raise EACBrPixHttpException.Create(
    ACBrStr(Format(sErroMetodoNaoImplementado,['ObterURLAmbiente',ClassName])));
end;

procedure TACBrPSP.ConfigurarHTTP;
begin
  ConfigurarProxy;
  ConfigurarTimeOut;
end;

procedure TACBrPSP.ConfigurarProxy;
begin
  VerificarPIXCDAtribuido;
  fHttpSend.ProxyHost := fPixCD.Proxy.Host;
  fHttpSend.ProxyPort := fPixCD.Proxy.Port;
  fHttpSend.ProxyUser := fPixCD.Proxy.User;
  fHttpSend.ProxyPass := fPixCD.Proxy.Pass;
end;

procedure TACBrPSP.ConfigurarTimeOut;
begin
  VerificarPIXCDAtribuido;
  if (fPixCD.TimeOut = 0) then
    Exit;

  fHttpSend.Timeout := fPixCD.TimeOut;
  with fHttpSend.Sock do
  begin
    ConnectionTimeout := fPixCD.TimeOut;
    InterPacketTimeout := False;
    NonblockSendTimeout := fPixCD.TimeOut;
    SocksTimeout := fPixCD.TimeOut;
    HTTPTunnelTimeout := fPixCD.TimeOut;
  end;
end;

procedure TACBrPSP.ConfigurarHeaders(const Method, AURL: String);
var
  i: Integer;
  ae: String;
begin
   { Sobreescrever no PSP, se necess�rio }

  // Adicionando Header de compacta��o
  ae := '';
  for i := Low(ChttpContentEncodingCompress) to High(ChttpContentEncodingCompress) do
    ae := ae + ', '+ChttpContentEncodingCompress[i];
  Delete(ae,1,1);
  
  fHttpSend.Headers.Add(ChhtpHeaderAcceptEncoding + ae);
end;

procedure TACBrPSP.ConfigurarAutenticacao(const Method, EndPoint: String);
begin
  { Sobreescrever no PSP, se necess�rio }
  if (fpToken <> '') then
    fHttpSend.Headers.Insert(0, ChttpHeaderAuthorization + 'Bearer '+fpToken);
end;

procedure TACBrPSP.ConfigurarPathParameters(const Method, EndPoint: String);
begin
  { Sobreescrever no PSP, se necess�rio }
end;

procedure TACBrPSP.ConfigurarQueryParameters(const Method, EndPoint: String);
begin
  { Sobreescrever no PSP, se necess�rio }
end;

function TACBrPSP.AcessarEndPoint(const Method, EndPoind: String; out
  ResultCode: Integer; out RespostaHttp: AnsiString): Boolean;
var
  AURL: String;
begin
  ConfigurarAutenticacao(Method, EndPoind);
  AURL := CalcularURLEndPoint(Method, EndPoind);

  Result := TransmitirHttp(Method, AURL, ResultCode, RespostaHttp);
end;

function TACBrPSP.CalcularURLEndPoint(const Method, EndPoint: String): String;
var
  AEndPointPath, p: String;
  i: Integer;
begin
  AEndPointPath := CalcularEndPointPath(Method, EndPoint);
  Result := URLSemDelimitador(ObterURLAmbiente(fPixCD.Ambiente));

  if (AEndPointPath <> '') then
    Result := Result + URLSemDelimitador(AEndPointPath);

  ConfigurarQueryParameters(Method, EndPoint);
  if (fURLPathParams.Count > 0) then
  begin
    for i := 0 to fURLPathParams.Count-1 do
      Result := Result + '/' + URLSemDelimitador(EncodeURLElement(fURLPathParams[i]));
  end;

  p := fURLQueryParams.AsURL;
  if (p <> '') then
    Result := Result + '?' + p;
end;

function TACBrPSP.CalcularEndPointPath(const Method, EndPoint: String): String;
begin
  { Sobreescreva em PSPs que usem Nomes de EndPoint, fora do padr�o da API do BC }
  Result := Trim(EndPoint);
end;

procedure TACBrPSP.LimparHTTP;
begin
  fHttpSend.Clear;
  fURLPathParams.Clear;
  fURLQueryParams.Clear;
end;

procedure TACBrPSP.PrepararHTTP;
begin
  VerificarPIXCDAtribuido;
  VerificarAutenticacao;
  LimparHTTP;
end;

function TACBrPSP.TransmitirHttp(const Method, URL: String; out
  ResultCode: Integer; out RespostaHttp: AnsiString): Boolean;

  function GetHttpBody: AnsiString;
  begin
    fHttpSend.Document.Position := 0;
    Result := ReadStrFromStream(fHttpSend.Document, fHttpSend.Document.Size);
  end;

var
  AMethod, AURL: String;
  HttpBody, VarBody: AnsiString;
begin
  VerificarPIXCDAtribuido;
  HttpBody := '';
  AMethod := Method;
  AURL := URL;

  ConfigurarHTTP;
  ConfigurarHeaders(Method, AURL);

  if Assigned(fQuandoTransmitirHttp) then
  begin
    HttpBody := GetHttpBody;
    VarBody := HttpBody;
    fQuandoTransmitirHttp(AURL, AMethod, VarBody);
    if (HttpBody <> VarBody) then
    begin
      HttpBody := VarBody;
      WriteStrToStream(fHttpSend.Document, HttpBody);
    end;
  end;

  fPixCD.RegistrarLog(sLineBreak+'---'+sLineBreak+'TransmitirHttp( '+AMethod+', '+AURL+' )'+sLineBreak+'---');
  if (fPixCD.NivelLog > 2) then
    fPixCD.RegistrarLog('Request Headers:'+ sLineBreak + fHttpSend.Headers.Text);

  if (fPixCD.NivelLog > 1) then
  begin
    if (HttpBody = '') then
      HttpBody := GetHttpBody;

    fPixCD.RegistrarLog('Request Body:'+ sLineBreak + TranslateUnprintable(HttpBody));
  end;

  Result := fHttpSend.HTTPMethod(AMethod, AURL);
  ResultCode := fHttpSend.ResultCode;
  if ContentIsCompressed(fHttpSend.Headers) then
    RespostaHttp := DecompressStream(fHttpSend.Document)
  else
    RespostaHttp := ReadStrFromStream(fHttpSend.Document, fHttpSend.Document.Size);

  fPixCD.RegistrarLog('Result Code: '+IntToStr(ResultCode)+' - '+fHttpSend.ResultString);
  if (fPixCD.NivelLog > 2) then
    fPixCD.RegistrarLog('Response Headers:'+ sLineBreak + fHttpSend.Headers.Text);

  if (fPixCD.NivelLog > 1) then
    fPixCD.RegistrarLog('Response Body:'+ sLineBreak + TranslateUnprintable(RespostaHttp));

  if Assigned(fQuandoReceberRespostaHttp) then
    fQuandoReceberRespostaHttp(AURL, AMethod, RespostaHttp);
end;

procedure TACBrPSP.TratarRetornoComErro(ResultCode: Integer;
  const RespostaHttp: AnsiString; Problema: TACBrPIXProblema);
begin
  Problema.Clear;
  if (Trim(RespostaHttp) = '') then
    AtribuirErroHTTPProblema(Problema)
  else
  begin
    try
      Problema.AsJSON := String(RespostaHttp);
    except
    end;

    if (Problema.detail = '') then
      AtribuirErroHTTPProblema(Problema);
  end;
end;

procedure TACBrPSP.AtribuirErroHTTPProblema(Problema: TACBrPIXProblema);
begin
  if (Problema.status = 0) then
    Problema.status := HTTP.ResultCode;

  if (Problema.title = '') then
    Problema.title := HTTP.ResultString;

  if (Problema.detail = '') then
  begin
    Http.Document.Position := 0;
    Problema.detail := ReadStrFromStream(HTTP.Document, HTTP.Document.Size);
  end;
end;

procedure TACBrPSP.Autenticar;
begin
  fpAutenticado := True;
end;

procedure TACBrPSP.VerificarValidadeToken;
begin
  if (ValidadeToken <> 0) and (ValidadeToken < Now) then
    RenovarToken;
end;

procedure TACBrPSP.RenovarToken;
begin
  Autenticar;
end;

procedure TACBrPSP.VerificarAutenticacao;
begin
  if not Autenticado then
    Autenticar;

  VerificarValidadeToken;
end;

{ TACBrPixRecebedor }

constructor TACBrPixRecebedor.Create;
begin
  inherited Create;
  Clear;
end;

procedure TACBrPixRecebedor.Clear;
begin
  fNome := '';
  fCidade := '';
  fCEP := '';
  fCodCategoriaComerciante := 0;
end;

procedure TACBrPixRecebedor.Assign(Source: TACBrPixRecebedor);
begin
  fNome := Source.Nome;
  fCidade := Source.Cidade;
  fCEP := Source.CEP;
  fCodCategoriaComerciante := Source.CodCategoriaComerciante;
end;

procedure TACBrPixRecebedor.SetCEP(AValue: String);
begin
  if (fCEP = AValue) then
    Exit;

  fCEP := OnlyNumber(AValue);
end;

procedure TACBrPixRecebedor.SetCidade(AValue: String);
begin
  if (fCidade = AValue) then
    Exit;

  fCidade := TiraAcentos(copy(Trim(AValue),1,15));
end;

procedure TACBrPixRecebedor.SetNome(AValue: String);
begin
  if (fNome = AValue) then
    Exit;

  fNome := TiraAcentos(copy(Trim(AValue),1,25));
end;

procedure TACBrPixRecebedor.SetUF(AValue: String);
var
  s, e: String;
begin
  if fUF = AValue then
    Exit;

  s := Trim(AValue);
  if (s <> '') then
  begin
    e := ValidarUF(s);
    if (e <> '') then
      raise EACBrPixException.Create(ACBrStr(e));
  end;

  fUF := s;
end;

procedure TACBrPixRecebedor.SetCodCategoriaComerciante(AValue: Integer);
begin
  if (fCodCategoriaComerciante = AValue) then
    Exit;

  if (AValue <> 0) and (AValue < cMCCMinimo) or (AValue > cMCCMaximo) then
    raise EACBrPixException.Create(ACBrStr(sErrMCCOutOfRange));

  fCodCategoriaComerciante := AValue;
end;

{ TACBrPixDadosAutomacao }

constructor TACBrPixDadosAutomacao.Create;
begin
  inherited Create;
  Clear;
end;

procedure TACBrPixDadosAutomacao.Clear;
begin
  fCNPJSoftwareHouse := '';
  fNomeAplicacao := '';
  fNomeSoftwareHouse := '';
  fVersaoAplicacao := '';
end;

procedure TACBrPixDadosAutomacao.Assign(Source: TACBrPixDadosAutomacao);
begin
  fCNPJSoftwareHouse := Source.CNPJSoftwareHouse;
  fNomeSoftwareHouse := Source.NomeSoftwareHouse;
  fNomeAplicacao := Source.NomeAplicacao;
  fVersaoAplicacao := Source.VersaoAplicacao;
end;

{ TACBrHttpProxy }

constructor TACBrHttpProxy.Create;
begin
  inherited Create;
  Clear;
end;

procedure TACBrHttpProxy.Clear;
begin
  fHost := '';
  fPass := '';
  fPort := '';
  fUser := '';
end;

procedure TACBrHttpProxy.Assign(Source: TACBrHttpProxy);
begin
  fHost := Source.Host;
  fPass := Source.Pass;
  fPort := Source.Port;
  fUser := Source.User;
end;

{ TACBrPixCD }

constructor TACBrPixCD.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fRecebedor := TACBrPixRecebedor.Create;
  fDadosAutomacao := TACBrPixDadosAutomacao.Create;
  fProxy := TACBrHttpProxy.Create;

  fTimeOut := ChttpTimeOutDef;
  fArqLOG := '';
  fNivelLog := 1;
  fAmbiente := ambTeste;
  fQuandoGravarLog := Nil;
end;

destructor TACBrPixCD.Destroy;
begin
  fRecebedor.Free;
  fDadosAutomacao.Free;
  fProxy.Free;

  inherited Destroy;
end;

procedure TACBrPixCD.RegistrarLog(const ALinha: String; NivelLog: Byte);
var
  Tratado: Boolean;
begin
  Tratado := False;
  if Assigned(fQuandoGravarLog) then
    fQuandoGravarLog(ALinha, Tratado);

  if not Tratado then
    GravarLogEmArquivo(ALinha);
end;

procedure TACBrPixCD.DispararExcecao(E: Exception);
begin
  if not Assigned(E) then
    Exit;

  RegistrarLog(E.ClassName + ': ' + E.Message);
  raise E;
end;

procedure TACBrPixCD.GravarLogEmArquivo(const ALinha: String);
begin
  if (fArqLOG = '') then
    Exit;

  WriteLog( fArqLOG, FormatDateTime('dd/mm/yy hh:nn:ss:zzz',now) + ' - ' + ALinha);
end;

procedure TACBrPixCD.SetACBrPSP(AValue: TACBrPSP);
var
  va: TACBrPSP ;
  //s: String;
begin
  //DEBUG
  //s := 'Nil';
  //if AValue <> Nil then
  //  s := IfEmptyThen(AValue.Name, AValue.ClassName);
  //WriteLog('c:\temp\debug.log', 'TACBrPixCD.SetACBrPSP( '+s+' )');

  if (AValue = fPSP) then
    Exit;

  if (AValue <> Nil) then
    RegistrarLog('Atribuindo PSP: '+AValue.ClassName+', Nome: '+AValue.Name)
  else
    RegistrarLog('Atribuindo PSP: Nil');

  if Assigned(fPSP) then
    fPSP.RemoveFreeNotification(Self);

  va := fPSP;       // Usa outra variavel para evitar Loop Infinito,
  fPSP := AValue;   // na remo��o da associa��o dos componentes

  if Assigned(va) then
    if Assigned(va.ACBrPixCD) then
      va.ACBrPixCD := Nil;

  if (AValue <> Nil) then
  begin
    AValue.FreeNotification(Self);
    AValue.ACBrPixCD := Self;
  end ;
end;

procedure TACBrPixCD.SetDadosAutomacao(AValue: TACBrPixDadosAutomacao);
begin
  if (fDadosAutomacao <> AValue) then
    fDadosAutomacao.Assign(AValue);
end;

procedure TACBrPixCD.SetProxy(AValue: TACBrHttpProxy);
begin
  if (fProxy <> AValue) then
    fProxy.Assign(AValue);
end;

procedure TACBrPixCD.SetRecebedor(AValue: TACBrPixRecebedor);
begin
  if (fRecebedor <> AValue) then
    fRecebedor.Assign(AValue);
end;

procedure TACBrPixCD.VerificarPSPAtribuido;
begin
  if not Assigned(fPSP) then
    DispararExcecao(EACBrPixException.Create(ACBrStr(sErroPSPNaoAtribuido)));
end;

procedure TACBrPixCD.Notification(AComponent: TComponent; Operation: TOperation);
begin
  //DEBUG
  //WriteLog('c:\temp\debug.log', 'TACBrPixCD.Notification('+
  //  IfEmptyThen(AComponent.Name, AComponent.ClassName)+', '+
  //  GetEnumName(TypeInfo(TOperation), integer(Operation) ) +' )');

  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (fPSP <> nil) and (AComponent is TACBrPSP) then
  begin
    RegistrarLog('Removendo PSP: '+fPSP.ClassName+', Nome: '+fPSP.Name);
    fPSP := nil ;
  end;
end;

function TACBrPixCD.GerarQRCodeEstatico(Valor: Currency;
  const infoAdicional: String; const TxId: String): String;
begin
  VerificarPSPAtribuido;
  Result := GerarQRCodeEstatico(fPSP.ChavePIX, Valor, infoAdicional, TxId);
end;

function TACBrPixCD.GerarQRCodeEstatico(const ChavePix: String;
  Valor: Currency; const infoAdicional: String; const TxId: String): String;
var
  Erros: String;
  QRCodeEstatico: TACBrPIXQRCodeEstatico;
  TipoChave: TACBrPIXTipoChave;
begin
  RegistrarLog('GerarQRCodeEstatico( '+FloatToString(Valor)+', '+
    ChavePix+', '+infoAdicional+', '+TxId+' )');

  Erros := '';
  if (fRecebedor.Nome = '') then
    Erros := Erros + sErroRecebedorNome + sLineBreak;

  if (fRecebedor.Cidade = '') then
    Erros := Erros + sErroRecebedorCidade + sLineBreak;

  if (ChavePix = '') then
    Erros := Erros + sErroPSPChavePIX + sLineBreak;

  TipoChave := DetectarTipoChave(ChavePix);
  if (TipoChave = tchNenhuma) then
    Erros := Erros + sErroPSPTipoChave + sLineBreak;

  if (Erros <> '') then
    DispararExcecao(EACBrPixException.Create(ACBrStr(Erros)));

  QRCodeEstatico := TACBrPIXQRCodeEstatico.Create;
  try
    QRCodeEstatico.Clear;
    QRCodeEstatico.MerchantName := fRecebedor.Nome;
    QRCodeEstatico.MerchantCity := fRecebedor.Cidade;
    QRCodeEstatico.PostalCode := fRecebedor.CEP;
    QRCodeEstatico.PixKey := ChavePix;
    QRCodeEstatico.TransactionAmount := Valor;
    QRCodeEstatico.AdditionalInfo := infoAdicional;
    QRCodeEstatico.TxId := TxId;

    Result := QRCodeEstatico.AsString;
    RegistrarLog('   '+Result);
  finally
    QRCodeEstatico.Free;
  end;
end;

function TACBrPixCD.GerarQRCodeDinamico(const Location: String): String;
var
  Erros: String;
  QRCodeDinamico: TACBrPIXQRCodeDinamico;
begin
  RegistrarLog('GerarQRCodeDinamico( '+Location+' )');

  Erros := '';
  if (fRecebedor.Nome = '') then
    Erros := Erros + sErroRecebedorNome + sLineBreak;

  if (fRecebedor.Cidade = '') then
    Erros := Erros + sErroRecebedorCidade + sLineBreak;

  if (Erros <> '') then
    DispararExcecao(EACBrPixException.Create(ACBrStr(Erros)));

  QRCodeDinamico := TACBrPIXQRCodeDinamico.Create;
  try
    QRCodeDinamico.Clear;
    QRCodeDinamico.MerchantName := fRecebedor.Nome;
    QRCodeDinamico.MerchantCity := fRecebedor.Cidade;
    QRCodeDinamico.PostalCode := fRecebedor.CEP;
    QRCodeDinamico.URL := Location;

    Result := QRCodeDinamico.AsString;
    RegistrarLog('   '+Result);
  finally
    QRCodeDinamico.Free;
  end;
end;

end.

