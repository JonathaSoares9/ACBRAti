{******************************************************************************}
{ Projeto: Componente ACBrCTe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Conhecimen-}
{ to de Transporte eletr�nico - CTe - http://www.cte.fazenda.gov.br            }
{                                                                              }
{ Direitos Autorais Reservados (c) 2008 Wiliam Zacarias da Silva Rosa          }
{                                       Wemerson Souto                         }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{                                                                              }
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
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{ Wiliam Zacarias da Silva Rosa  -  wrosa2009@yahoo.com.br -  www.motta.com.br }
{                                                                              }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrCTeWebServices;

interface

uses
  Classes, SysUtils,
  ACBrDFe, ACBrDFeWebService,
  pcteCTe,
  pcteRetConsReciCTe, pcteRetConsCad, pcnAuxiliar, pcnConversao, pcteConversaoCTe,
  pcteProcCte, pcteRetCancCTe, pcteEnvEventoCTe, pcteRetEnvEventoCTe,
  pcteRetConsSitCTe, pcteRetEnvCTe, pcteDistDFeInt, pcteRetDistDFeInt,
  ACBrCteConhecimentos, ACBrCTeConfiguracoes;

//const
//  CURL_WSDL = 'http://www.portalfiscal.inf.br/cte/wsdl/';
//  INTERNET_OPTION_CLIENT_CERT_CONTEXT = 84;

type

  { TCTeWebService }

  TCTeWebService = class(TDFeWebService)
  private
  protected
    FPStatus: TStatusACBrCTe;
    FPLayout: TLayOutCTe;
    FPConfiguracoesCTe: TConfiguracoesCTe;

  protected
    procedure InicializarServico; override;
    procedure DefinirURL; override;
    function GerarVersaoDadosSoap: String; override;
    procedure FinalizarServico; override;

  public
    constructor Create(AOwner: TACBrDFe); override;
    procedure Clear; override;

    property Status: TStatusACBrCTe read FPStatus;
    property Layout: TLayOutCTe read FPLayout;
  end;

  { TCTeStatusServico }

  TCTeStatusServico = Class(TCTeWebService)
  private
    Fversao: String;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FcStat: Integer;
    FxMotivo: String;
    FcUF: Integer;
    FdhRecbto: TDateTime;
    FTMed: Integer;
    FdhRetorno: TDateTime;
    FxObs: String;
  protected
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;

    function GerarMsgLog: String; override;
    function GerarMsgErro(E: Exception): String; override;
  public
    procedure Clear; override;

    property versao: String          read Fversao;
    property tpAmb: TpcnTipoAmbiente read FtpAmb;
    property verAplic: String        read FverAplic;
    property cStat: Integer          read FcStat;
    property xMotivo: String         read FxMotivo;
    property cUF: Integer            read FcUF;
    property dhRecbto: TDateTime     read FdhRecbto;
    property TMed: Integer           read FTMed;
    property dhRetorno: TDateTime    read FdhRetorno;
    property xObs: String            read FxObs;
  end;

  { TCTeRecepcao }

  TCTeRecepcao = class(TCTeWebService)
  private
    FLote: String;
    FRecibo: String;
    FConhecimentos: TConhecimentos;
    Fversao: String;
    FTpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FcStat: Integer;
    FcUF: Integer;
    FxMotivo: String;
    FdhRecbto: TDateTime;
    FTMed: Integer;
    FVersaoDF: TVersaoCTe;

    FCTeRetorno: TretEnvCTe;
    FCTeRetornoOS: TRetConsSitCTe;

    function GetLote: String;
    function GetRecibo: String;
  protected
    procedure InicializarServico; override;
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;

    function GerarMsgLog: String; override;
    function GerarPrefixoArquivo: String; override;
  public
    constructor Create(AOwner: TACBrDFe; AConhecimentos: TConhecimentos);
      reintroduce; overload;
    destructor Destroy; override;
    procedure Clear; override;

    property Recibo: String read GetRecibo;
    property versao: String read Fversao;
    property TpAmb: TpcnTipoAmbiente read FTpAmb;
    property verAplic: String read FverAplic;
    property cStat: Integer read FcStat;
    property cUF: Integer read FcUF;
    property xMotivo: String read FxMotivo;
    property dhRecbto: TDateTime read FdhRecbto;
    property TMed: Integer read FTMed;
    property Lote: String read GetLote write FLote;
    
    property CTeRetornoOS: TRetConsSitCTe read FCTeRetornoOS;
  end;

  { TCTeRetRecepcao }

  TCTeRetRecepcao = class(TCTeWebService)
  private
    FRecibo: String;
    FProtocolo: String;
    FChaveCTe: String;
    FConhecimentos: TConhecimentos;
    Fversao: String;
    FTpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FcStat: Integer;
    FcUF: Integer;
    FxMotivo: String;
    FcMsg: Integer;
    FxMsg: String;
    FVersaoDF: TVersaoCTe;

    FCTeRetorno: TRetConsReciCTe;

    function GetRecibo: String;
    function TratarRespostaFinal: Boolean;
  protected
    procedure InicializarServico; override;
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;
    procedure FinalizarServico; override;

    function GerarMsgLog: String; override;
    function GerarPrefixoArquivo: String; override;
  public
    constructor Create(AOwner: TACBrDFe; AConhecimentos: TConhecimentos);
      reintroduce; overload;
    destructor Destroy; override;
    procedure Clear; override;

    function Executar: Boolean; override;

    property versao: String read Fversao;
    property TpAmb: TpcnTipoAmbiente read FTpAmb;
    property verAplic: String read FverAplic;
    property cStat: Integer read FcStat;
    property cUF: Integer read FcUF;
    property xMotivo: String read FxMotivo;
    property cMsg: Integer read FcMsg;
    property xMsg: String read FxMsg;
    property Recibo: String read GetRecibo write FRecibo;
    property Protocolo: String read FProtocolo write FProtocolo;
    property ChaveCTe: String read FChaveCTe write FChaveCTe;

    property CTeRetorno: TRetConsReciCTe read FCTeRetorno;
  end;

  { TCTeRecibo }

  TCTeRecibo = class(TCTeWebService)
  private
    FConhecimentos: TConhecimentos;
    FRecibo: String;
    Fversao: String;
    FTpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FcStat: Integer;
    FxMotivo: String;
    FcUF: Integer;
    FxMsg: String;
    FcMsg: Integer;
    FVersaoDF: TVersaoCTe;

    FCTeRetorno: TRetConsReciCTe;
  protected
    procedure InicializarServico; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirURL; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;

    function GerarMsgLog: String; override;
  public
    constructor Create(AOwner: TACBrDFe; AConhecimentos: TConhecimentos);
      reintroduce; overload;
    destructor Destroy; override;
    procedure Clear; override;

    property versao: String read Fversao;
    property TpAmb: TpcnTipoAmbiente read FTpAmb;
    property verAplic: String read FverAplic;
    property cStat: Integer read FcStat;
    property xMotivo: String read FxMotivo;
    property cUF: Integer read FcUF;
    property xMsg: String read FxMsg;
    property cMsg: Integer read FcMsg;
    property Recibo: String read FRecibo write FRecibo;

    property CTeRetorno: TRetConsReciCTe read FCTeRetorno;
  end;

  { TCTeConsulta }

  TCTeConsulta = class(TCTeWebService)
  private
    FOwner: TACBrDFe;
    FConhecimentos: TConhecimentos;
    FCTeChave: String;
    FProtocolo: String;
    FDhRecbto: TDateTime;
    FXMotivo: String;
    Fversao: String;
    FTpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FcStat: Integer;
    FcUF: Integer;
    FRetCTeDFe: String;

    FprotCTe: TProcCTe;
    FretCancCTe: TRetCancCTe;
    FprocEventoCTe: TRetEventoCTeCollection;
    procedure SetCTeChave(AValue: String);
  protected
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function GerarUFSoap: String; override;
    function TratarResposta: Boolean; override;

    function GerarMsgLog: String; override;
    function GerarPrefixoArquivo: String; override;
  public
    constructor Create(AOwner: TACBrDFe; AConhecimentos: TConhecimentos);
      reintroduce; overload;
    destructor Destroy; override;
    procedure Clear; override;

    property CTeChave: String read FCTeChave write SetCTeChave;
    property Protocolo: String read FProtocolo;
    property DhRecbto: TDateTime read FDhRecbto;
    property XMotivo: String read FXMotivo;
    property versao: String read Fversao;
    property TpAmb: TpcnTipoAmbiente read FTpAmb;
    property verAplic: String read FverAplic;
    property cStat: Integer read FcStat;
    property cUF: Integer read FcUF;
    property RetCTeDFe: String read FRetCTeDFe;

    property protCTe: TProcCTe read FprotCTe;
    property retCancCTe: TRetCancCTe read FretCancCTe;
    property procEventoCTe: TRetEventoCTeCollection read FprocEventoCTe;
  end;

  { TCTeInutilizacao }

  TCTeInutilizacao = class(TCTeWebService)
  private
    FID: String;
    FProtocolo: String;
    FModelo: Integer;
    FSerie: Integer;
    FCNPJ: String;
    FAno: Integer;
    FNumeroInicial: Integer;
    FNumeroFinal: Integer;
    FJustificativa: String;
    Fversao: String;
    FTpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FcStat: Integer;
    FxMotivo: String;
    FcUF: Integer;
    FdhRecbto: TDateTime;
    FNomeArquivo: String;

    FXML_ProcInutCTe: String;

    procedure SetJustificativa(AValue: String);
    function GerarPathPorCNPJ: String;
  protected
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    procedure SalvarEnvio; override;
    function TratarResposta: Boolean; override;
    procedure SalvarResposta; override;

    function GerarMsgLog: String; override;
    function GerarPrefixoArquivo: String; override;
  public
    procedure Clear; override;

    property ID: String read FID write FID;
    property Protocolo: String read FProtocolo write FProtocolo;
    property Modelo: Integer read FModelo write FModelo;
    property Serie: Integer read FSerie write FSerie;
    property CNPJ: String read FCNPJ write FCNPJ;
    property Ano: Integer read FAno write FAno;
    property NumeroInicial: Integer read FNumeroInicial write FNumeroInicial;
    property NumeroFinal: Integer read FNumeroFinal write FNumeroFinal;
    property Justificativa: String read FJustificativa write SetJustificativa;
    property versao: String read Fversao;
    property TpAmb: TpcnTipoAmbiente read FTpAmb;
    property verAplic: String read FverAplic;
    property cStat: Integer read FcStat;
    property xMotivo: String read FxMotivo;
    property cUF: Integer read FcUF;
    property dhRecbto: TDateTime read FdhRecbto;
    property XML_procInutCTe: String read FXML_ProcInutCTe write FXML_ProcInutCTe;
    property NomeArquivo: String read FNomeArquivo write FNomeArquivo;
  end;

  { TCTeConsultaCadastro }

  TCTeConsultaCadastro = class(TCTeWebService)
  private
    FOldBodyElement: String;

    Fversao: String;
    FverAplic: String;
    FcStat: Integer;
    FxMotivo: String;
    FUF: String;
    FIE: String;
    FCNPJ: String;
    FCPF: String;
    FcUF: Integer;
    FdhCons: TDateTime;

    FRetConsCad: TRetConsCad;

    procedure SetCNPJ(const Value: String);
    procedure SetCPF(const Value: String);
    procedure SetIE(const Value: String);
  protected
    procedure InicializarServico; override;
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    procedure DefinirEnvelopeSoap; override;
    function TratarResposta: Boolean; override;
    procedure FinalizarServico; override;

    function GerarMsgLog: String; override;
    function GerarUFSoap: String; override;
  public
    constructor Create(AOwner: TACBrDFe); override;
    destructor Destroy; override;
    procedure Clear; override;

    property versao: String read Fversao;
    property verAplic: String read FverAplic;
    property cStat: Integer read FcStat;
    property xMotivo: String read FxMotivo;
    property DhCons: TDateTime read FdhCons;
    property cUF: Integer read FcUF;
    property UF: String read FUF write FUF;
    property IE: String read FIE write SetIE;
    property CNPJ: String read FCNPJ write SetCNPJ;
    property CPF: String read FCPF write SetCPF;

    property RetConsCad: TRetConsCad read FRetConsCad;
  end;

  { TCTeEnvEvento }

  TCTeEnvEvento = class(TCTeWebService)
  private
    FidLote: Integer;
    FEvento: TEventoCTe;
    FcStat: Integer;
    FxMotivo: String;
    FTpAmb: TpcnTipoAmbiente;
    FCNPJ: String;

    FEventoRetorno: TRetEventoCTe;

    function GerarPathEvento(const ACNPJ: String = ''): String;
  protected
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    procedure DefinirEnvelopeSoap; override;
    procedure SalvarEnvio; override;
    function TratarResposta: Boolean; override;
    procedure SalvarResposta; override;

    function GerarMsgLog: String; override;
    function GerarPrefixoArquivo: String; override;
  public
    constructor Create(AOwner: TACBrDFe; AEvento: TEventoCTe);
      reintroduce; overload;
    destructor Destroy; override;
    procedure Clear; override;

    property idLote: Integer read FidLote write FidLote;
    property cStat: Integer read FcStat;
    property xMotivo: String read FxMotivo;
    property TpAmb: TpcnTipoAmbiente read FTpAmb;

    property EventoRetorno: TRetEventoCTe read FEventoRetorno;
  end;

  { TDistribuicaoDFe }

  TDistribuicaoDFe = class(TCTeWebService)
  private
    FcUFAutor: Integer;
    FCNPJCPF: String;
    FultNSU: String;
    FNSU: String;
    FchCTe: String;
    FNomeArq: String;
    FlistaArqs: TStringList;

    FretDistDFeInt: TretDistDFeInt;

    function GerarPathDistribuicao(AItem: TdocZipCollectionItem): String;
  protected
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;

    function GerarMsgLog: String; override;
    function GerarMsgErro(E: Exception): String; override;
  public
    constructor Create(AOwner: TACBrDFe); override;
    destructor Destroy; override;
    procedure Clear; override;

    property cUFAutor: Integer read FcUFAutor write FcUFAutor;
    property CNPJCPF: String read FCNPJCPF write FCNPJCPF;
    property ultNSU: String read FultNSU write FultNSU;
    property NSU: String read FNSU write FNSU;
    property chCTe: String read FchCTe write FchCTe;
    property NomeArq: String read FNomeArq;
    property ListaArqs: TStringList read FlistaArqs;

    property retDistDFeInt: TretDistDFeInt read FretDistDFeInt;
  end;

  { TCTeEnvioWebService }

  TCTeEnvioWebService = class(TCTeWebService)
  private
    FXMLEnvio: String;
    FPURLEnvio: String;
    FVersao: String;
    FSoapActionEnvio: String;
  protected
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;

    function GerarMsgErro(E: Exception): String; override;
    function GerarVersaoDadosSoap: String; override;
  public
    constructor Create(AOwner: TACBrDFe); override;
    destructor Destroy; override;
    procedure Clear; override;

    function Executar: Boolean; override;

    property Versao: String read FVersao;
    property XMLEnvio: String read FXMLEnvio write FXMLEnvio;
    property URLEnvio: String read FPURLEnvio write FPURLEnvio;
    property SoapActionEnvio: String read FSoapActionEnvio write FSoapActionEnvio;
  end;

  { TWebServices }

  TWebServices = class
  private
    FACBrCTe: TACBrDFe;
    FStatusServico: TCTeStatusServico;
    FEnviar: TCTeRecepcao;
    FRetorno: TCTeRetRecepcao;
    FRecibo: TCTeRecibo;
    FConsulta: TCTeConsulta;
    FInutilizacao: TCTeInutilizacao;
    FConsultaCadastro: TCTeConsultaCadastro;
    FEnvEvento: TCTeEnvEvento;
    FDistribuicaoDFe: TDistribuicaoDFe;
    FEnvioWebService: TCTeEnvioWebService;
  public
    constructor Create(AOwner: TACBrDFe); overload;
    destructor Destroy; override;

    function Envia(ALote: Integer): Boolean; overload;
    function Envia(ALote: String): Boolean; overload;
    function EnviaOS(ALote: Integer): Boolean; overload;
    function EnviaOS(ALote: String): Boolean; overload;
    procedure Inutiliza(CNPJ, AJustificativa: String;
      Ano, Modelo, Serie, NumeroInicial, NumeroFinal: Integer);

    property ACBrCTe: TACBrDFe read FACBrCTe write FACBrCTe;
    property StatusServico: TCTeStatusServico read FStatusServico write FStatusServico;
    property Enviar: TCTeRecepcao read FEnviar write FEnviar;
    property Retorno: TCTeRetRecepcao read FRetorno write FRetorno;
    property Recibo: TCTeRecibo read FRecibo write FRecibo;
    property Consulta: TCTeConsulta read FConsulta write FConsulta;
    property Inutilizacao: TCTeInutilizacao read FInutilizacao write FInutilizacao;
    property ConsultaCadastro: TCTeConsultaCadastro read FConsultaCadastro write FConsultaCadastro;
    property EnvEvento: TCTeEnvEvento read FEnvEvento write FEnvEvento;
    property DistribuicaoDFe: TDistribuicaoDFe read FDistribuicaoDFe write FDistribuicaoDFe;
    property EnvioWebService: TCTeEnvioWebService read FEnvioWebService write FEnvioWebService;
  end;

implementation

uses
  StrUtils, Math,
  ACBrUtil, ACBrCTe, pcteCTeW,
  pcnGerador, pcteConsStatServ, pcteRetConsStatServ,
  pcteConsSitCTe, pcteInutCTe, pcteRetInutCTe, pcteConsReciCTe,
  pcteConsCad, pcnLeitor;

{ TCTeWebService }

constructor TCTeWebService.Create(AOwner: TACBrDFe);
begin
  inherited Create(AOwner);

  FPConfiguracoesCTe := TConfiguracoesCTe(FPConfiguracoes);
  FPLayout := LayCTeStatusServico;

  FPHeaderElement := 'cteCabecMsg';
  FPBodyElement := 'cteDadosMsg';
end;

procedure TCTeWebService.Clear;
begin
  inherited Clear;

  FPStatus := stCTeIdle;
  FPDFeOwner.SSL.UseCertificateHTTP := True;
end;

procedure TCTeWebService.InicializarServico;
begin
  { Sobrescrever apenas se necess�rio }
  inherited InicializarServico;

  TACBrCTe(FPDFeOwner).SetStatus(FPStatus);
end;

procedure TCTeWebService.DefinirURL;
var
  Versao: Double;
begin
  { sobrescrever apenas se necess�rio.
    Voc� tamb�m pode mudar apenas o valor de "FLayoutServico" na classe
    filha e chamar: Inherited;     }

  Versao := 0;
  FPVersaoServico := '';
  FPURL := '';

  TACBrCTe(FPDFeOwner).LerServicoDeParams(FPLayout, Versao, FPURL);
  FPVersaoServico := FloatToString(Versao, '.', '0.00');
end;

function TCTeWebService.GerarVersaoDadosSoap: String;
begin
  { Sobrescrever apenas se necess�rio }

  if EstaVazio(FPVersaoServico) then
    FPVersaoServico := TACBrCTe(FPDFeOwner).LerVersaoDeParams(FPLayout);

  Result := '<versaoDados>' + FPVersaoServico + '</versaoDados>';
end;

procedure TCTeWebService.FinalizarServico;
begin
  { Sobrescrever apenas se necess�rio }

  TACBrCTe(FPDFeOwner).SetStatus(stCTeIdle);
end;

{ TCTeStatusServico }

procedure TCTeStatusServico.Clear;
begin
  inherited Clear;

  FPStatus := stCTeStatusServico;
  FPLayout := LayCTeStatusServico;
  FPArqEnv := 'ped-sta';
  FPArqResp := 'sta';

  Fversao := '';
  FverAplic := '';
  FcStat := 0;
  FxMotivo := '';
  FdhRecbto := 0;
  FTMed := 0;
  FdhRetorno := 0;
  FxObs := '';

  if Assigned(FPConfiguracoesCTe) then
  begin
    FtpAmb := FPConfiguracoesCTe.WebServices.Ambiente;
    FcUF := FPConfiguracoesCTe.WebServices.UFCodigo;
  end
end;

procedure TCTeStatusServico.DefinirServicoEAction;
begin
  FPServico    := GetUrlWsd + 'CteStatusServico';
  FPSoapAction := FPServico + '/cteStatusServicoCT';
end;

procedure TCTeStatusServico.DefinirDadosMsg;
var
  ConsStatServ: TConsStatServ;
begin
  ConsStatServ := TConsStatServ.Create;
  try
    ConsStatServ.TpAmb := FPConfiguracoesCTe.WebServices.Ambiente;
    ConsStatServ.CUF := FPConfiguracoesCTe.WebServices.UFCodigo;
    ConsStatServ.Versao := FPVersaoServico;

    AjustarOpcoes( ConsStatServ.Gerador.Opcoes );

    ConsStatServ.GerarXML;

    // Atribuindo o XML para propriedade interna //
    FPDadosMsg := ConsStatServ.Gerador.ArquivoFormatoXML;
  finally
    ConsStatServ.Free;
  end;
end;

function TCTeStatusServico.TratarResposta: Boolean;
var
  CTeRetorno: TRetConsStatServ;
begin
  FPRetWS := SeparaDados(FPRetornoWS, 'cteStatusServicoCTResult');

  CTeRetorno := TRetConsStatServ.Create;
  try
    CTeRetorno.Leitor.Arquivo := ParseText(FPRetWS);
    CTeRetorno.LerXml;

    Fversao := CTeRetorno.versao;
    FtpAmb := CTeRetorno.tpAmb;
    FverAplic := CTeRetorno.verAplic;
    FcStat := CTeRetorno.cStat;
    FxMotivo := CTeRetorno.xMotivo;
    FcUF := CTeRetorno.cUF;
    FdhRecbto := CTeRetorno.dhRecbto;
    FTMed := CTeRetorno.TMed;
    FdhRetorno := CTeRetorno.dhRetorno;
    FxObs := CTeRetorno.xObs;
    FPMsg := FxMotivo + LineBreak + FxObs;

    if FPConfiguracoesCTe.WebServices.AjustaAguardaConsultaRet then
      FPConfiguracoesCTe.WebServices.AguardarConsultaRet := FTMed * 1000;

    Result := (FcStat = 107);

  finally
    CTeRetorno.Free;
  end;
end;

function TCTeStatusServico.GerarMsgLog: String;
begin
  Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                           'Ambiente: %s' + LineBreak +
                           'Vers�o Aplicativo: %s ' + LineBreak +
                           'Status C�digo: %s' + LineBreak +
                           'Status Descri��o: %s' + LineBreak +
                           'UF: %s' + LineBreak +
                           'Recebimento: %s' + LineBreak +
                           'Tempo M�dio: %s' + LineBreak +
                           'Retorno: %s' + LineBreak +
                           'Observa��o: %s' + LineBreak),
                   [Fversao, TpAmbToStr(FtpAmb), FverAplic, IntToStr(FcStat),
                    FxMotivo, CodigoParaUF(FcUF),
                    IfThen(FdhRecbto = 0, '', FormatDateTimeBr(FdhRecbto)),
                    IntToStr(FTMed),
                    IfThen(FdhRetorno = 0, '', FormatDateTimeBr(FdhRetorno)),
                    FxObs]);
end;

function TCTeStatusServico.GerarMsgErro(E: Exception): String;
begin
  Result := ACBrStr('WebService Consulta Status servi�o:' + LineBreak +
                    '- Inativo ou Inoperante tente novamente.');
end;

{ TCTeRecepcao }

constructor TCTeRecepcao.Create(AOwner: TACBrDFe; AConhecimentos: TConhecimentos);
begin
  inherited Create(AOwner);

  FConhecimentos := AConhecimentos;
end;

destructor TCTeRecepcao.Destroy;
begin
  FCTeRetorno.Free;
  FCTeRetornoOS.Free;
  inherited Destroy;
end;

procedure TCTeRecepcao.Clear;
begin
  inherited Clear;

  FPStatus := stCTeRecepcao;
  FPLayout := LayCTeRecepcao;
  FPArqEnv := 'env-lot';
  FPArqResp := 'rec';

  Fversao := '';
  FTMed := 0;
  FverAplic := '';
  FcStat    := 0;
  FxMotivo  := '';
  FRecibo   := '';
  FdhRecbto := 0;

  if Assigned(FPConfiguracoesCTe) then
  begin
    FtpAmb := FPConfiguracoesCTe.WebServices.Ambiente;
    FcUF := FPConfiguracoesCTe.WebServices.UFCodigo;
  end;

  if Assigned(FCTeRetorno) then
    FCTeRetorno.Free;

  if Assigned(FCTeRetornoOS) then
    FCTeRetornoOS.Free;

  FCTeRetorno := TretEnvCTe.Create;
  FCTeRetornoOS := TRetConsSitCTe.Create;
end;

function TCTeRecepcao.GetLote: String;
begin
  Result := Trim(FLote);
end;

function TCTeRecepcao.GetRecibo: String;
begin
  Result := Trim(FRecibo);
end;

procedure TCTeRecepcao.InicializarServico;
var
  ok: Boolean;
begin
  if FConhecimentos.Count > 0 then    // Tem CTe ? Se SIM, use as informa��es do XML
    FVersaoDF := DblToVersaoCTe(ok, FConhecimentos.Items[0].CTe.infCTe.Versao)
  else
    FVersaoDF := FPConfiguracoesCTe.Geral.VersaoDF;

  inherited InicializarServico;
end;

procedure TCTeRecepcao.DefinirURL;
var
  xUF: String;
  VerServ: Double;
  Modelo: TModeloCTe;
  Ok: Boolean;
begin
  if FPConfiguracoesCTe.Geral.ModeloDF = moCTe then
    FPLayout := LayCTeRecepcao
  else
    FPLayout := LayCTeRecepcaoOS;

  if FConhecimentos.Count > 0 then    // Tem CTe ? Se SIM, use as informa��es do XML
  begin
    Modelo := StrToModeloCTe(ok, IntToStr(FConhecimentos.Items[0].CTe.Ide.modelo));
    FcUF   := FConhecimentos.Items[0].CTe.Ide.cUF;

    if FPConfiguracoesCTe.WebServices.Ambiente <> FConhecimentos.Items[0].CTe.Ide.tpAmb then
      raise EACBrCTeException.Create( ACBRCTE_CErroAmbDiferente );
  end
  else
  begin                              // Se n�o tem CTe, use as configura��es do componente
    Modelo := FPConfiguracoesCTe.Geral.ModeloDF;
    FcUF   := FPConfiguracoesCTe.WebServices.UFCodigo;
  end;

  VerServ := VersaoCTeToDbl(FVersaoDF);
  FTpAmb := FPConfiguracoesCTe.WebServices.Ambiente;
  FPVersaoServico := '';
  FPURL := '';

  case FPConfiguracoesCTe.Geral.FormaEmissao of
    teSVCRS: xUF := 'SVC-RS';
    teSVCSP: xUF := 'SVC-SP';
  else
    xUF := CUFtoUF(FcUF);
  end;

  TACBrCTe(FPDFeOwner).LerServicoDeParams(
    ModeloCTeToPrefixo(Modelo),
    xUF,
    FTpAmb,
    LayOutToServico(FPLayout),
    VerServ,
    FPURL
  );

  FPVersaoServico := FloatToString(VerServ, '.', '0.00');
end;

procedure TCTeRecepcao.DefinirServicoEAction;
begin
  if FPConfiguracoesCTe.Geral.ModeloDF = moCTe then
  begin
    FPServico    := GetUrlWsd + 'CteRecepcao';
    FPSoapAction := FPServico + '/cteRecepcaoLote';
  end
  else
  begin
    FPServico    := GetUrlWsd + 'CteRecepcaoOS';
    FPSoapAction := FPServico + '/cteOSRecepcao';
  end;
end;

procedure TCTeRecepcao.DefinirDadosMsg;
var
  I: Integer;
  vCTe: String;
begin
  vCTe := '';

  if FPConfiguracoesCTe.Geral.ModeloDF = moCTe then
  begin
    // No modelo 57 podemos ter um lote contendo de 1 at� 50 CT-e
    for I := 0 to FConhecimentos.Count - 1 do
      vCTe := vCTe + '<CTe' + RetornarConteudoEntre(
                FConhecimentos.Items[I].XMLAssinado, '<CTe', '</CTe>') + '</CTe>';

    FPDadosMsg := '<enviCTe xmlns="' + ACBRCTE_NAMESPACE + '" versao="' +
                     FPVersaoServico + '">' + '<idLote>' + FLote + '</idLote>' +
                     vCTe + '</enviCTe>';
  end
  else
  begin
    // No modelo 67 s� podemos ter apena UM CT-e OS, pois o seu processamento �
    // s�ncrono
    if FConhecimentos.Count > 1 then
      GerarException(ACBrStr('ERRO: Conjunto de CT-e OS transmitidos (m�ximo de 1 CT-e OS)' +
             ' excedido. Quantidade atual: ' + IntToStr(FConhecimentos.Count)));

    if FConhecimentos.Count > 0 then
      FPDadosMsg := '<CTeOS' + RetornarConteudoEntre(
              FConhecimentos.Items[0].XMLAssinado, '<CTeOS', '</CTeOS>') + '</CTeOS>';
  end;

  // Lote tem mais de 500kb ? //
  if Length(FPDadosMsg) > (500 * 1024) then
    GerarException(ACBrStr('Tamanho do XML de Dados superior a 500 Kbytes. Tamanho atual: ' +
      IntToStr(trunc(Length(FPDadosMsg) / 1024)) + ' Kbytes'));

  FRecibo := '';
end;

function TCTeRecepcao.TratarResposta: Boolean;
var
  I: integer;
  chCTe, AXML, NomeXMLSalvo: String;
  AProcCTe: TProcCTe;
  SalvarXML: Boolean;
begin
  FPRetWS := SeparaDadosArray(['cteRecepcaoLoteResult'
                              ,'cteRecepcaoOSResult'
                              ,'cteOSRecepcaoResult'
                              ,'cteRecepcaoOSCTResult'
                              ]
                             , FPRetornoWS);

  if (FPConfiguracoesCTe.Geral.ModeloDF = moCTeOS) then
  begin
    if pos('retCTeOS', FPRetWS) > 0 then
      AXML := StringReplace(FPRetWS, 'retCTeOS', 'retConsSitCTe',
                                     [rfReplaceAll, rfIgnoreCase])
    else if pos('retEnviOS', FPRetWS) > 0 then
      AXML := StringReplace(FPRetWS, 'retEnviOS', 'retConsSitCTe',
                                     [rfReplaceAll, rfIgnoreCase])
    else if pos('retConsReciCTe', FPRetWS) > 0 then
      AXML := StringReplace(FPRetWS, 'retConsReciCTe', 'retConsSitCTe',
                                     [rfReplaceAll, rfIgnoreCase])
    else
      AXML := FPRetWS;

    FCTeRetornoOS.Leitor.Arquivo := ParseText(AXML);
    FCTeRetornoOS.LerXml;

    Fversao := FCTeRetornoOS.versao;
    FTpAmb := FCTeRetornoOS.TpAmb;
    FverAplic := FCTeRetornoOS.verAplic;

    // Consta no Retorno da CT-eOS
    FRecibo := ''; // FCTeRetornoOS.nRec;
    FcUF := FCTeRetornoOS.cUF;
    chCTe := FCTeRetornoOS.ProtCTe.chCTe;

    if (FCTeRetornoOS.protCTe.cStat > 0) then
      FcStat := FCTeRetornoOS.protCTe.cStat
    else
      FcStat := FCTeRetornoOS.cStat;

    if (FCTeRetornoOS.protCTe.xMotivo <> '') then
    begin
      FPMsg := FCTeRetornoOS.protCTe.xMotivo;
      FxMotivo := FCTeRetornoOS.protCTe.xMotivo;
    end
    else
    begin
      FPMsg := FCTeRetornoOS.xMotivo;
      FxMotivo := FCTeRetornoOS.xMotivo;
    end;

    // Verificar se a CT-eOS foi autorizada com sucesso
    Result := (TACBrCTe(FPDFeOwner).CstatProcessado(FCTeRetornoOS.protCTe.cStat));

    if Result then
    begin
      for I := 0 to TACBrCTe(FPDFeOwner).Conhecimentos.Count - 1 do
      begin
        with TACBrCTe(FPDFeOwner).Conhecimentos.Items[I] do
        begin
          if OnlyNumber(chCTe) = NumID then
          begin
            if (FPConfiguracoesCTe.Geral.ValidarDigest) and
               (FCTeRetornoOS.protCTe.digVal <> '') and
               (CTe.signature.DigestValue <> FCTeRetornoOS.protCTe.digVal) then
            begin
              raise EACBrCTeException.Create('DigestValue do documento ' + NumID + ' n�o confere.');
            end;

            CTe.procCTe.cStat := FCTeRetornoOS.protCTe.cStat;
            CTe.procCTe.tpAmb := FCTeRetornoOS.tpAmb;
            CTe.procCTe.verAplic := FCTeRetornoOS.verAplic;
            CTe.procCTe.chCTe := FCTeRetornoOS.ProtCTe.chCTe;
            CTe.procCTe.dhRecbto := FCTeRetornoOS.protCTe.dhRecbto;
            CTe.procCTe.nProt := FCTeRetornoOS.ProtCTe.nProt;
            CTe.procCTe.digVal := FCTeRetornoOS.protCTe.digVal;
            CTe.procCTe.xMotivo := FCTeRetornoOS.protCTe.xMotivo;

            AProcCTe := TProcCTe.Create;
            try
              // Processando em UTF8, para poder gravar arquivo corretamente //
              AProcCTe.XML_CTe := RemoverDeclaracaoXML(XMLAssinado);
              AProcCTe.XML_Prot := FCTeRetornoOS.XMLprotCTe;
              AProcCTe.Versao := FPVersaoServico;
              AjustarOpcoes( AProcCTe.Gerador.Opcoes );
              AProcCTe.GerarXML;

              XMLOriginal := AProcCTe.Gerador.ArquivoFormatoXML;

              if FPConfiguracoesCTe.Arquivos.Salvar then
              begin
                SalvarXML := (not FPConfiguracoesCTe.Arquivos.SalvarApenasCTeProcessados) or
                             Processado;

                // Salva o XML da NF-e assinado e protocolado
                if SalvarXML then
                begin
                  NomeXMLSalvo := '';
                  if NaoEstaVazio(NomeArq) and FileExists(NomeArq) then
                  begin
                    FPDFeOwner.Gravar( NomeArq, XMLOriginal ); // Atualiza o XML carregado
                    NomeXMLSalvo := NomeArq;
                  end;

                  if (NomeXMLSalvo <> CalcularNomeArquivoCompleto()) then
                    GravarXML; // Salva na pasta baseado nas configura��es do PathCTe
                end;
              end ;
            finally
              AProcCTe.Free;
            end;

            Break;
          end;
        end;
      end;
    end;
  end
  else
  begin
    FCTeRetorno.Leitor.Arquivo := ParseText(FPRetWS);
    FCTeRetorno.LerXml;

    Fversao := FCTeRetorno.versao;
    FTpAmb := FCTeRetorno.TpAmb;
    FverAplic := FCTeRetorno.verAplic;
    FcStat := FCTeRetorno.cStat;
    FxMotivo := FCTeRetorno.xMotivo;
    FdhRecbto := FCTeRetorno.infRec.dhRecbto;
    FTMed := FCTeRetorno.infRec.tMed;
    FcUF := FCTeRetorno.cUF;
    FPMsg := FCTeRetorno.xMotivo;
    FRecibo := FCTeRetorno.infRec.nRec;

    Result := (FCTeRetorno.CStat = 103);
  end;
end;

function TCTeRecepcao.GerarMsgLog: String;
begin
  {(*}
  if FPConfiguracoesCTe.Geral.ModeloDF = moCTe then
    Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                             'Ambiente: %s ' + LineBreak +
                             'Vers�o Aplicativo: %s ' + LineBreak +
                             'Status C�digo: %s ' + LineBreak +
                             'Status Descri��o: %s ' + LineBreak +
                             'UF: %s ' + sLineBreak +
                             'Recibo: %s ' + LineBreak +
                             'Recebimento: %s ' + LineBreak +
                             'Tempo M�dio: %s ' + LineBreak),
                     [FCTeRetorno.versao,
                      TpAmbToStr(FCTeRetorno.TpAmb),
                      FCTeRetorno.verAplic,
                      IntToStr(FCTeRetorno.cStat),
                      FCTeRetorno.xMotivo,
                      CodigoParaUF(FCTeRetorno.cUF),
                      FCTeRetorno.infRec.nRec,
                      IfThen(FCTeRetorno.InfRec.dhRecbto = 0, '',
                             FormatDateTimeBr(FCTeRetorno.InfRec.dhRecbto)),
                      IntToStr(FCTeRetorno.InfRec.TMed)])
  else
    Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                             'Ambiente: %s ' + LineBreak +
                             'Vers�o Aplicativo: %s ' + LineBreak +
                             'Status C�digo: %s ' + LineBreak +
                             'Status Descri��o: %s ' + LineBreak +
                             'UF: %s ' + sLineBreak +
                             'dhRecbto: %s ' + sLineBreak +
                             'chCTe: %s ' + LineBreak),
                     [FCTeRetornoOS.versao,
                      TpAmbToStr(FCTeRetornoOS.TpAmb),
                      FCTeRetornoOS.verAplic,
                      IntToStr(FCTeRetornoOS.cStat),
                      FCTeRetornoOS.xMotivo,
                      CodigoParaUF(FCTeRetornoOS.cUF),
                      IfThen(FCTeRetornoOS.protCTe.dhRecbto = 0, '',
                             FormatDateTimeBr(FCTeRetornoOS.protCTe.dhRecbto)),
                      FCTeRetornoOS.chCTe]);
  {*)}
end;

function TCTeRecepcao.GerarPrefixoArquivo: String;
begin
  if FPConfiguracoesCTe.Geral.ModeloDF = moCTeOS then  // Esta procesando nome do Retorno Sincrono ?
  begin
    if FRecibo <> '' then
    begin
      Result := Recibo;
      FPArqResp := 'pro-rec';
    end
    else
    begin
      Result := Lote;
      FPArqResp := 'pro-lot';
    end;
  end
  else
    Result := Lote;
end;

{ TCTeRetRecepcao }

constructor TCTeRetRecepcao.Create(AOwner: TACBrDFe; AConhecimentos: TConhecimentos);
begin
  inherited Create(AOwner);

  FConhecimentos := AConhecimentos;
end;

destructor TCTeRetRecepcao.Destroy;
begin
  FCTeRetorno.Free;

  inherited Destroy;
end;

procedure TCTeRetRecepcao.InicializarServico;
var
  ok: Boolean;
begin
  if FConhecimentos.Count > 0 then    // Tem CTe ? Se SIM, use as informa��es do XML
    FVersaoDF := DblToVersaoCTe(ok, FConhecimentos.Items[0].CTe.infCTe.Versao)
  else
    FVersaoDF := FPConfiguracoesCTe.Geral.VersaoDF;

  inherited InicializarServico;
end;

procedure TCTeRetRecepcao.Clear;
var
  i, j: Integer;
begin
  inherited Clear;

  FPStatus := stCTeRetRecepcao;
  FPLayout := LayCTeRetRecepcao;
  FPArqEnv := 'ped-rec';
  FPArqResp := 'pro-rec';

  FverAplic := '';
  FcStat := 0;
  FxMotivo := '';
  Fversao := '';
  FxMsg := '';
  FcMsg := 0;

  if Assigned(FPConfiguracoesCTe) then
  begin
    FtpAmb := FPConfiguracoesCTe.WebServices.Ambiente;
    FcUF := FPConfiguracoesCTe.WebServices.UFCodigo;
  end;

  if Assigned(FCTeRetorno) and Assigned(FConhecimentos) then
  begin
    // Limpa Dados dos retornos dos conhecimentos
    for i := 0 to FCTeRetorno.ProtCTe.Count - 1 do
    begin
      for j := 0 to FConhecimentos.Count - 1 do
      begin
        if OnlyNumber(FCTeRetorno.ProtCTe.Items[i].chCTe) = FConhecimentos.Items[J].NumID then
        begin
          FConhecimentos.Items[j].CTe.procCTe.verAplic := '';
          FConhecimentos.Items[j].CTe.procCTe.chCTe    := '';
          FConhecimentos.Items[j].CTe.procCTe.dhRecbto := 0;
          FConhecimentos.Items[j].CTe.procCTe.nProt    := '';
          FConhecimentos.Items[j].CTe.procCTe.digVal   := '';
          FConhecimentos.Items[j].CTe.procCTe.cStat    := 0;
          FConhecimentos.Items[j].CTe.procCTe.xMotivo  := '';
        end;
      end;
    end;

    FreeAndNil(FCTeRetorno);
  end;

  FCTeRetorno := TRetConsReciCTe.Create;
end;

function TCTeRetRecepcao.GetRecibo: String;
begin
  Result := Trim(FRecibo);
end;

function TCTeRetRecepcao.Executar: Boolean;
var
  IntervaloTentativas, Tentativas: Integer;
begin
  Result := False;

  TACBrCTe(FPDFeOwner).SetStatus(stCTeRetRecepcao);
  try
    Sleep(FPConfiguracoesCTe.WebServices.AguardarConsultaRet);

    Tentativas := 0; // Inicializa o contador de tentativas
    IntervaloTentativas := max(FPConfiguracoesCTe.WebServices.IntervaloTentativas, 1000);

    while (inherited Executar) and
      (Tentativas < FPConfiguracoesCTe.WebServices.Tentativas) do
    begin
      Inc(Tentativas);
      sleep(IntervaloTentativas);
    end;
  finally
    TACBrCTe(FPDFeOwner).SetStatus(stCTeIdle);
  end;

  if FCTeRetorno.CStat = 104 then  // Lote processado ?
    Result := TratarRespostaFinal;
end;

procedure TCTeRetRecepcao.DefinirURL;
var
  xUF: String;
  VerServ: Double;
  Modelo: TModeloCTe;
  Ok: Boolean;
begin
  FPLayout := LayCTeRetRecepcao;

  if FConhecimentos.Count > 0 then    // Tem CTe ? Se SIM, use as informa��es do XML
  begin
    Modelo := StrToModeloCTe(ok, IntToStr(FConhecimentos.Items[0].CTe.Ide.modelo));
    FcUF   := FConhecimentos.Items[0].CTe.Ide.cUF;

    if FPConfiguracoesCTe.WebServices.Ambiente <> FConhecimentos.Items[0].CTe.Ide.tpAmb then
      raise EACBrCTeException.Create( ACBRCTE_CErroAmbDiferente );
  end
  else
  begin       // Se n�o tem CTe, use as configura��es do componente
    Modelo := FPConfiguracoesCTe.Geral.ModeloDF;
    FcUF   := FPConfiguracoesCTe.WebServices.UFCodigo;
  end;

  VerServ := VersaoCTeToDbl(FVersaoDF);
  FTpAmb := FPConfiguracoesCTe.WebServices.Ambiente;
  FPVersaoServico := '';
  FPURL := '';

  case FPConfiguracoesCTe.Geral.FormaEmissao of
    teSVCRS: xUF := 'SVC-RS';
    teSVCSP: xUF := 'SVC-SP';
  else
    xUF := CUFtoUF(FcUF);
  end;

  TACBrCTe(FPDFeOwner).LerServicoDeParams(
    ModeloCTeToPrefixo(Modelo),
    xUF,
    FTpAmb,
    LayOutToServico(FPLayout),
    VerServ,
    FPURL
  );

  FPVersaoServico := FloatToString(VerServ, '.', '0.00');
end;

procedure TCTeRetRecepcao.DefinirServicoEAction;
begin
  FPServico    := GetUrlWsd + 'CteRetRecepcao';
  FPSoapAction := FPServico + '/cteRetRecepcao';
end;

procedure TCTeRetRecepcao.DefinirDadosMsg;
var
  ConsReciCTe: TConsReciCTe;
begin
  ConsReciCTe := TConsReciCTe.Create;
  try
    ConsReciCTe.tpAmb := FPConfiguracoesCTe.WebServices.Ambiente;
    ConsReciCTe.nRec := FRecibo;
    ConsReciCTe.Versao := FPVersaoServico;

    AjustarOpcoes( ConsReciCTe.Gerador.Opcoes );

    ConsReciCTe.GerarXML;

    FPDadosMsg := ConsReciCTe.Gerador.ArquivoFormatoXML;
  finally
    ConsReciCTe.Free;
  end;
end;

function TCTeRetRecepcao.TratarResposta: Boolean;
begin
  FPRetWS := SeparaDados(FPRetornoWS, 'cteRetRecepcaoResult');

  FCTeRetorno.Leitor.Arquivo := ParseText(FPRetWS);
  FCTeRetorno.LerXML;

  Fversao := FCTeRetorno.versao;
  FTpAmb := FCTeRetorno.TpAmb;
  FverAplic := FCTeRetorno.verAplic;
  FcStat := FCTeRetorno.cStat;
  FcUF := FCTeRetorno.cUF;
  FPMsg := FCTeRetorno.xMotivo;
  FxMotivo := FCTeRetorno.xMotivo;
  FcMsg := FCTeRetorno.cMsg;
  FxMsg := FCTeRetorno.xMsg;

  Result := (FCTeRetorno.CStat = 105); // Lote em Processamento
end;

function TCTeRetRecepcao.TratarRespostaFinal: Boolean;
var
  I, J: Integer;
  AProcCTe: TProcCTe;
  AInfProt: TProtCTeCollection;
//  NomeXML: String;
  SalvarXML: Boolean;
  NomeXMLSalvo: String;
begin
  Result := False;

  AInfProt := FCTeRetorno.ProtCTe;

  if (AInfProt.Count > 0) then
  begin
    FPMsg := FCTeRetorno.ProtCTe.Items[0].xMotivo;
    FxMotivo := FCTeRetorno.ProtCTe.Items[0].xMotivo;
  end;

  //Setando os retornos dos Conhecimentos;
  for I := 0 to AInfProt.Count - 1 do
  begin
    for J := 0 to FConhecimentos.Count - 1 do
    begin
      if OnlyNumber(AInfProt.Items[I].chCTe) = FConhecimentos.Items[J].NumID then
      begin
        if (TACBrCTe(FPDFeOwner).Configuracoes.Geral.ValidarDigest) and
          (FConhecimentos.Items[J].CTe.signature.DigestValue <>
          AInfProt.Items[I].digVal) and (AInfProt.Items[I].digVal <> '') then
        begin
          raise EACBrCTeException.Create('DigestValue do documento ' +
            FConhecimentos.Items[J].NumID + ' n�o confere.');
        end;

        with FConhecimentos.Items[J] do
        begin
          CTe.procCTe.tpAmb := AInfProt.Items[I].tpAmb;
          CTe.procCTe.verAplic := AInfProt.Items[I].verAplic;
          CTe.procCTe.chCTe := AInfProt.Items[I].chCTe;
          CTe.procCTe.dhRecbto := AInfProt.Items[I].dhRecbto;
          CTe.procCTe.nProt := AInfProt.Items[I].nProt;
          CTe.procCTe.digVal := AInfProt.Items[I].digVal;
          CTe.procCTe.cStat := AInfProt.Items[I].cStat;
          CTe.procCTe.xMotivo := AInfProt.Items[I].xMotivo;
        end;

//        NomeXML := '-cte.xml';

//        if (AInfProt.Items[I].cStat = 110) or (AInfProt.Items[I].cStat = 301) then
//          NomeXML := '-den.xml';

        // Monta o XML do CT-e assinado e com o protocolo de Autoriza��o ou Denega��o
        if (AInfProt.Items[I].cStat = 100) or (AInfProt.Items[I].cStat = 110) or
           (AInfProt.Items[I].cStat = 150) or (AInfProt.Items[I].cStat = 301) then
        begin
          AProcCTe := TProcCTe.Create;
          try
            AProcCTe.XML_CTe := RemoverDeclaracaoXML(FConhecimentos.Items[J].XMLAssinado);
            AProcCTe.XML_Prot := AInfProt.Items[I].XMLprotCTe;
            AProcCTe.Versao := FPVersaoServico;
            AProcCTe.GerarXML;

            with FConhecimentos.Items[J] do
            begin
              XMLOriginal := AProcCTe.Gerador.ArquivoFormatoXML;

              if FPConfiguracoesCTe.Arquivos.Salvar then
              begin
                SalvarXML := (not FPConfiguracoesCTe.Arquivos.SalvarApenasCTeProcessados) or
                             Processado;

                // Salva o XML do CT-e assinado e protocolado
                if SalvarXML then
                begin
                  NomeXMLSalvo := '';
                  if NaoEstaVazio(NomeArq) and FileExists(NomeArq) then
                  begin
                    FPDFeOwner.Gravar( NomeArq, XMLOriginal );  // Atualiza o XML carregado
                    NomeXMLSalvo := NomeArq;
                  end;

                  if (NomeXMLSalvo <> CalcularNomeArquivoCompleto()) then
                    GravarXML; // Salva na pasta baseado nas configura��es do PathCTe
                end;
              end;
            end;
          finally
            AProcCTe.Free;
          end;
        end;

        break;
      end;
    end;
  end;

  //Verificando se existe algum Conhecimento confirmado
  for I := 0 to FConhecimentos.Count - 1 do
  begin
    if FConhecimentos.Items[I].Confirmado then
    begin
      Result := True;
      break;
    end;
  end;

  //Verificando se existe algum Conhecimento nao confirmado
  for I := 0 to FConhecimentos.Count - 1 do
  begin
    if not FConhecimentos.Items[I].Confirmado then
    begin
      FPMsg := ACBrStr('Conhecimento(s) n�o confirmados:') + LineBreak;
      break;
    end;
  end;

  //Montando a mensagem de retorno para os Conhecimentos nao confirmados
  for I := 0 to FConhecimentos.Count - 1 do
  begin
    if not FConhecimentos.Items[I].Confirmado then
      FPMsg := FPMsg + IntToStr(FConhecimentos.Items[I].CTe.Ide.nCT) +
        '->' + IntToStr(FConhecimentos.Items[I].cStat) + '-' + FConhecimentos.Items[I].Msg + LineBreak;
  end;

  if AInfProt.Count > 0 then
  begin
    FChaveCTe := AInfProt.Items[0].chCTe;
    FProtocolo := AInfProt.Items[0].nProt;
    FcStat := AInfProt.Items[0].cStat;
  end;
end;

procedure TCTeRetRecepcao.FinalizarServico;
begin
  // Sobrescrito, para n�o liberar para stIdle... n�o ainda...;
end;

function TCTeRetRecepcao.GerarMsgLog: String;
begin
  Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                           'Ambiente: %s ' + LineBreak +
                           'Vers�o Aplicativo: %s ' + LineBreak +
                           'Recibo: %s ' + LineBreak +
                           'Status C�digo: %s ' + LineBreak +
                           'Status Descri��o: %s ' + LineBreak +
                           'UF: %s ' + LineBreak +
                           'cMsg: %s ' + LineBreak +
                           'xMsg: %s ' + LineBreak),
                   [FCTeRetorno.versao, TpAmbToStr(FCTeRetorno.tpAmb),
                    FCTeRetorno.verAplic, FCTeRetorno.nRec,
                    IntToStr(FCTeRetorno.cStat), FCTeRetorno.xMotivo,
                    CodigoParaUF(FCTeRetorno.cUF), IntToStr(FCTeRetorno.cMsg),
                    FCTeRetorno.xMsg]);
end;

function TCTeRetRecepcao.GerarPrefixoArquivo: String;
begin
  Result := Recibo;
end;

{ TCTeRecibo }

constructor TCTeRecibo.Create(AOwner: TACBrDFe; AConhecimentos: TConhecimentos);
begin
  inherited Create(AOwner);

  FConhecimentos := AConhecimentos;
end;

destructor TCTeRecibo.Destroy;
begin
  FCTeRetorno.Free;

  inherited Destroy;
end;

procedure TCTeRecibo.Clear;
begin
  inherited Clear;

  FPStatus := stCTeRecibo;
  FPLayout := LayCTeRetRecepcao;
  FPArqEnv := 'ped-rec';
  FPArqResp := 'pro-rec';

  Fversao := '';
  FxMsg := '';
  FcMsg := 0;
  FverAplic := '';
  FcStat    := 0;
  FxMotivo  := '';

  if Assigned(FPConfiguracoesCTe) then
  begin
    FtpAmb := FPConfiguracoesCTe.WebServices.Ambiente;
    FcUF := FPConfiguracoesCTe.WebServices.UFCodigo;
  end;

  if Assigned(FCTeRetorno) then
    FCTeRetorno.Free;

  FCTeRetorno := TRetConsReciCTe.Create;
end;

procedure TCTeRecibo.InicializarServico;
var
  ok: Boolean;
begin
  if FConhecimentos.Count > 0 then    // Tem CTe ? Se SIM, use as informa��es do XML
    FVersaoDF := DblToVersaoCTe(ok, FConhecimentos.Items[0].CTe.infCTe.Versao)
  else
    FVersaoDF := FPConfiguracoesCTe.Geral.VersaoDF;

  inherited InicializarServico;
end;

procedure TCTeRecibo.DefinirServicoEAction;
begin
  FPServico    := GetUrlWsd + 'CteRetRecepcao';
  FPSoapAction := FPServico + '/cteRetRecepcao';
end;

procedure TCTeRecibo.DefinirURL;
var
  xUF: String;
  VerServ: Double;
  Modelo: TModeloCTe;
  Ok: Boolean;
begin
  FPLayout := LayCTeRetRecepcao;

  if FConhecimentos.Count > 0 then    // Tem CTe ? Se SIM, use as informa��es do XML
  begin
    Modelo := StrToModeloCTe(ok, IntToStr(FConhecimentos.Items[0].CTe.Ide.modelo));
    FcUF   := FConhecimentos.Items[0].CTe.Ide.cUF;

    if FPConfiguracoesCTe.WebServices.Ambiente <> FConhecimentos.Items[0].CTe.Ide.tpAmb then
      raise EACBrCTeException.Create( ACBRCTE_CErroAmbDiferente );
  end
  else
  begin       // Se n�o tem CTe, use as configura��es do componente
    Modelo := FPConfiguracoesCTe.Geral.ModeloDF;
    FcUF   := FPConfiguracoesCTe.WebServices.UFCodigo;
  end;

  VerServ := VersaoCTeToDbl(FVersaoDF);
  FTpAmb := FPConfiguracoesCTe.WebServices.Ambiente;
  FPVersaoServico := '';
  FPURL := '';

  case FPConfiguracoesCTe.Geral.FormaEmissao of
    teSVCRS: xUF := 'SVC-RS';
    teSVCSP: xUF := 'SVC-SP';
  else
    xUF := CUFtoUF(FcUF);
  end;

  TACBrCTe(FPDFeOwner).LerServicoDeParams(
    ModeloCTeToPrefixo(Modelo),
    xUF,
    FTpAmb,
    LayOutToServico(FPLayout),
    VerServ,
    FPURL
  );

  FPVersaoServico := FloatToString(VerServ, '.', '0.00');
end;

procedure TCTeRecibo.DefinirDadosMsg;
var
  ConsReciCTe: TConsReciCTe;
begin
  ConsReciCTe := TConsReciCTe.Create;
  try
    ConsReciCTe.tpAmb := FTpAmb;
    ConsReciCTe.nRec := FRecibo;
    ConsReciCTe.Versao := FPVersaoServico;

    AjustarOpcoes( ConsReciCTe.Gerador.Opcoes );

    ConsReciCTe.GerarXML;

    FPDadosMsg := ConsReciCTe.Gerador.ArquivoFormatoXML;
  finally
    ConsReciCTe.Free;
  end;
end;

function TCTeRecibo.TratarResposta: Boolean;
begin
  FPRetWS := SeparaDados(FPRetornoWS, 'cteRetRecepcaoResult');

  FCTeRetorno.Leitor.Arquivo := ParseText(FPRetWS);
  FCTeRetorno.LerXML;

  Fversao := FCTeRetorno.versao;
  FTpAmb := FCTeRetorno.TpAmb;
  FverAplic := FCTeRetorno.verAplic;
  FcStat := FCTeRetorno.cStat;
  FxMotivo := FCTeRetorno.xMotivo;
  FcUF := FCTeRetorno.cUF;
  FxMsg := FCTeRetorno.xMsg;
  FcMsg := FCTeRetorno.cMsg;
  FPMsg := FxMotivo;

  Result := (FCTeRetorno.CStat = 104);
end;

function TCTeRecibo.GerarMsgLog: String;
begin
  Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                           'Ambiente: %s ' + LineBreak +
                           'Vers�o Aplicativo: %s ' + LineBreak +
                           'Recibo: %s ' + LineBreak +
                           'Status C�digo: %s ' + LineBreak +
                           'Status Descri��o: %s ' + LineBreak +
                           'UF: %s ' + LineBreak),
                   [FCTeRetorno.versao, TpAmbToStr(FCTeRetorno.TpAmb),
                   FCTeRetorno.verAplic, FCTeRetorno.nRec,
                   IntToStr(FCTeRetorno.cStat),
                   FCTeRetorno.xMotivo,
                   CodigoParaUF(FCTeRetorno.cUF)]);
end;

{ TCTeConsulta }

constructor TCTeConsulta.Create(AOwner: TACBrDFe; AConhecimentos: TConhecimentos);
begin
  inherited Create(AOwner);

  FOwner := AOwner;
  FConhecimentos := AConhecimentos;
end;

destructor TCTeConsulta.Destroy;
begin
  FprotCTe.Free;
  FretCancCTe.Free;
  FprocEventoCTe.Free;

  inherited Destroy;
end;

procedure TCTeConsulta.Clear;
begin
  inherited Clear;

  FPStatus := stCTeConsulta;
  FPLayout := LayCTeConsulta;
  FPArqEnv := 'ped-sit';
  FPArqResp := 'sit';

  FverAplic := '';
  FcStat := 0;
  FxMotivo := '';
  FProtocolo := '';
  FDhRecbto := 0;
  Fversao := '';
  FRetCTeDFe := '';

  if Assigned(FPConfiguracoesCTe) then
  begin
    FtpAmb := FPConfiguracoesCTe.WebServices.Ambiente;
    FcUF := FPConfiguracoesCTe.WebServices.UFCodigo;
  end;

  if Assigned(FprotCTe) then
    FprotCTe.Free;

  if Assigned(FretCancCTe) then
    FretCancCTe.Free;

  if Assigned(FprocEventoCTe) then
    FprocEventoCTe.Free;

  FprotCTe := TProcCTe.Create;
  FretCancCTe := TRetCancCTe.Create;
  FprocEventoCTe := TRetEventoCTeCollection.Create(FOwner);
end;

procedure TCTeConsulta.SetCTeChave(AValue: String);
var
  NumChave: String;
begin
  if FCTeChave = AValue then Exit;
  NumChave := OnlyNumber(AValue);

  if not ValidarChave(NumChave) then
     raise EACBrCTeException.Create('Chave "'+AValue+'" inv�lida.');

  FCTeChave := NumChave;
end;

procedure TCTeConsulta.DefinirURL;
var
  VerServ: Double;
  Modelo, xUF: String;
  Ok: Boolean;
begin
  FPVersaoServico := '';
  FPURL   := '';
  Modelo  := ModeloCTeToPrefixo( StrToModeloCTe(ok, ExtrairModeloChaveAcesso(FCTeChave) ));
  FcUF    := ExtrairUFChaveAcesso(FCTeChave);
  VerServ := VersaoCTeToDbl(FPConfiguracoesCTe.Geral.VersaoDF);

  if FConhecimentos.Count > 0 then
    FTpAmb := FConhecimentos.Items[0].CTe.Ide.tpAmb
  else
    FTpAmb := FPConfiguracoesCTe.WebServices.Ambiente;

  case FPConfiguracoesCTe.Geral.FormaEmissao of
    teSVCRS: xUF := 'SVC-RS';
    teSVCSP: xUF := 'SVC-SP';
  else
    xUF := CUFtoUF(FcUF);
  end;

  TACBrCTe(FPDFeOwner).LerServicoDeParams(
    Modelo,
    xUF,
    FTpAmb,
    LayOutToServico(FPLayout),
    VerServ,
    FPURL
  );

  FPVersaoServico := FloatToString(VerServ, '.', '0.00');
end;

procedure TCTeConsulta.DefinirServicoEAction;
begin
  FPServico    := GetUrlWsd + 'CteConsulta';
  FPSoapAction := FPServico + '/cteConsultaCT';
end;

procedure TCTeConsulta.DefinirDadosMsg;
var
  ConsSitCTe: TConsSitCTe;
begin
  ConsSitCTe := TConsSitCTe.Create;
  try
    ConsSitCTe.TpAmb := FTpAmb;
    ConsSitCTe.chCTe := FCTeChave;
    ConsSitCTe.Versao := FPVersaoServico;

    AjustarOpcoes( ConsSitCTe.Gerador.Opcoes );

    ConsSitCTe.GerarXML;

    FPDadosMsg := ConsSitCTe.Gerador.ArquivoFormatoXML;
  finally
    ConsSitCTe.Free;
  end;
end;

function TCTeConsulta.GerarUFSoap: String;
begin
  Result := '<cUF>' + IntToStr(FcUF) + '</cUF>';
end;

function TCTeConsulta.TratarResposta: Boolean;
var
  CTeRetorno: TRetConsSitCTe;
  SalvarXML, CTCancelado, Atualiza: Boolean;
  aEventos, sPathCTe, NomeXMLSalvo, aEvento, aProcEvento, aIDEvento: String;
  AProcCTe: TProcCTe;
  I, J, K, Inicio, Fim: Integer;
  dhEmissao: TDateTime;
begin
  CTeRetorno := TRetConsSitCTe.Create;

  try
    FPRetWS := SeparaDados(FPRetornoWS, 'cteConsultaCTResult');

    CTeRetorno.Leitor.Arquivo := ParseText(FPRetWS);
    CTeRetorno.LerXML;

    CTCancelado := False;
    aEventos := '';

    // <retConsSitCTe> - Retorno da consulta da situa��o do CT-e
    // Este � o status oficial do CT-e
    Fversao := CTeRetorno.versao;
    FTpAmb := CTeRetorno.tpAmb;
    FverAplic := CTeRetorno.verAplic;
    FcStat := CTeRetorno.cStat;
    FXMotivo := CTeRetorno.xMotivo;
    FcUF := CTeRetorno.cUF;
    FPMsg := FXMotivo;

    // Verifica se o Conhecimento est� cancelado pelo m�todo antigo. Se estiver,
    // ent�o CTCancelado ser� True e j� atribui Protocolo, Data e Mensagem
    if CTeRetorno.retCancCTe.cStat > 0 then
    begin
      FRetCancCTe.versao := CTeRetorno.retCancCTe.versao;
      FretCancCTe.tpAmb := CTeRetorno.retCancCTe.tpAmb;
      FretCancCTe.verAplic := CTeRetorno.retCancCTe.verAplic;
      FretCancCTe.cStat := CTeRetorno.retCancCTe.cStat;
      FretCancCTe.xMotivo := CTeRetorno.retCancCTe.xMotivo;
      FretCancCTe.cUF := CTeRetorno.retCancCTe.cUF;
      FretCancCTe.chCTe := CTeRetorno.retCancCTe.chCTe;
      FretCancCTe.dhRecbto := CTeRetorno.retCancCTe.dhRecbto;
      FretCancCTe.nProt := CTeRetorno.retCancCTe.nProt;

      CTCancelado := True;
      FProtocolo := CTeRetorno.retCancCTe.nProt;
      FDhRecbto := CTeRetorno.retCancCTe.dhRecbto;
      FPMsg := CTeRetorno.xMotivo;
    end;

    // <protCTe> - Retorno dos dados do ENVIO da CT-e
    // Consider�-los apenas se n�o existir nenhum evento de cancelamento (110111)
    FprotCTe.PathCTe := CTeRetorno.protCTe.PathCTe;
    FprotCTe.PathRetConsReciCTe := CTeRetorno.protCTe.PathRetConsReciCTe;
    FprotCTe.PathRetConsSitCTe := CTeRetorno.protCTe.PathRetConsSitCTe;
    FprotCTe.tpAmb := CTeRetorno.protCTe.tpAmb;
    FprotCTe.verAplic := CTeRetorno.protCTe.verAplic;
    FprotCTe.chCTe := CTeRetorno.protCTe.chCTe;
    FprotCTe.dhRecbto := CTeRetorno.protCTe.dhRecbto;
    FprotCTe.nProt := CTeRetorno.protCTe.nProt;
    FprotCTe.digVal := CTeRetorno.protCTe.digVal;
    FprotCTe.cStat := CTeRetorno.protCTe.cStat;
    FprotCTe.xMotivo := CTeRetorno.protCTe.xMotivo;

    if Assigned(CTeRetorno.procEventoCTe) and (CTeRetorno.procEventoCTe.Count > 0) then
    begin
      aEventos := '=====================================================' +
        LineBreak + '================== Eventos da CT-e ==================' +
        LineBreak + '=====================================================' +
        LineBreak + '' + LineBreak + 'Quantidade total de eventos: ' +
        IntToStr(CTeRetorno.procEventoCTe.Count);

      FprocEventoCTe.Clear;
      for I := 0 to CTeRetorno.procEventoCTe.Count - 1 do
      begin
        with FprocEventoCTe.Add.RetEventoCTe do
        begin
          idLote := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.idLote;
          tpAmb := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.tpAmb;
          verAplic := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.verAplic;
          cOrgao := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.cOrgao;
          cStat := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.cStat;
          xMotivo := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.xMotivo;
          XML := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.XML;

          InfEvento.ID := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.InfEvento.ID;
          InfEvento.tpAmb := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.InfEvento.tpAmb;
          InfEvento.CNPJ := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.InfEvento.CNPJ;
          InfEvento.chCTe := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.InfEvento.chCTe;
          InfEvento.dhEvento := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.InfEvento.dhEvento;
          InfEvento.TpEvento := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.InfEvento.TpEvento;
          InfEvento.nSeqEvento := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.InfEvento.nSeqEvento;
          InfEvento.VersaoEvento := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.InfEvento.VersaoEvento;
          InfEvento.DetEvento.nProt := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.InfEvento.DetEvento.nProt;
          InfEvento.DetEvento.xJust := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.InfEvento.DetEvento.xJust;
          InfEvento.DetEvento.xCondUso := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.InfEvento.DetEvento.xCondUso;

          InfEvento.DetEvento.infCorrecao.Clear;
          for k := 0 to CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.InfEvento.detEvento.infCorrecao.Count -1 do
          begin
            InfEvento.DetEvento.infCorrecao.Add;
            InfEvento.DetEvento.infCorrecao.Items[k].grupoAlterado   := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.InfEvento.DetEvento.infCorrecao.Items[k].grupoAlterado;
            InfEvento.DetEvento.infCorrecao.Items[k].campoAlterado   := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.InfEvento.DetEvento.infCorrecao.Items[k].campoAlterado;
            InfEvento.DetEvento.infCorrecao.Items[k].valorAlterado   := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.InfEvento.DetEvento.infCorrecao.Items[k].valorAlterado;
            InfEvento.DetEvento.infCorrecao.Items[k].nroItemAlterado := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.InfEvento.DetEvento.infCorrecao.Items[k].nroItemAlterado;
          end;

          retEvento.Clear;
          for J := 0 to CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.retEvento.Count-1 do
          begin
            with retEvento.Add.RetInfEvento do
            begin
              Id := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.retEvento.Items[J].RetInfEvento.Id;
              tpAmb := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.retEvento.Items[J].RetInfEvento.tpAmb;
              verAplic := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.retEvento.Items[J].RetInfEvento.verAplic;
              cOrgao := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.retEvento.Items[J].RetInfEvento.cOrgao;
              cStat := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.retEvento.Items[J].RetInfEvento.cStat;
              xMotivo := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.retEvento.Items[J].RetInfEvento.xMotivo;
              chCTe := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.retEvento.Items[J].RetInfEvento.chCTe;
              tpEvento := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.retEvento.Items[J].RetInfEvento.tpEvento;
              xEvento := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.retEvento.Items[J].RetInfEvento.xEvento;
              nSeqEvento := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.retEvento.Items[J].RetInfEvento.nSeqEvento;
              CNPJDest := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.retEvento.Items[J].RetInfEvento.CNPJDest;
              emailDest := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.retEvento.Items[J].RetInfEvento.emailDest;
              dhRegEvento := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.retEvento.Items[J].RetInfEvento.dhRegEvento;
              nProt := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.retEvento.Items[J].RetInfEvento.nProt;
              XML := CTeRetorno.procEventoCTe.Items[I].RetEventoCTe.retEvento.Items[J].RetInfEvento.XML;
            end;
          end;
        end;

        with CTeRetorno.procEventoCTe.Items[I].RetEventoCTe do
        begin
          for j := 0 to retEvento.Count -1 do
          begin
            aEventos := aEventos + LineBreak + LineBreak +
              Format(ACBrStr('N�mero de sequ�ncia: %s ' + LineBreak +
                             'C�digo do evento: %s ' + LineBreak +
                             'Descri��o do evento: %s ' + LineBreak +
                             'Status do evento: %s ' + LineBreak +
                             'Descri��o do status: %s ' + LineBreak +
                             'Protocolo: %s ' + LineBreak +
                             'Data/Hora do registro: %s '),
                     [IntToStr(retEvento.Items[J].RetInfEvento.nSeqEvento),
                      TpEventoToStr(retEvento.Items[J].RetInfEvento.TpEvento),
                      retEvento.Items[J].RetInfEvento.xEvento,
                      IntToStr(retEvento.Items[J].RetInfEvento.cStat),
                      retEvento.Items[J].RetInfEvento.xMotivo,
                      retEvento.Items[J].RetInfEvento.nProt,
                      FormatDateTimeBr(retEvento.Items[J].RetInfEvento.dhRegEvento)]);

            if retEvento.Items[J].RetInfEvento.tpEvento = teCancelamento then
            begin
              CTCancelado := True;
              FProtocolo := retEvento.Items[J].RetInfEvento.nProt;
              FDhRecbto := retEvento.Items[J].RetInfEvento.dhRegEvento;
              FPMsg := retEvento.Items[J].RetInfEvento.xMotivo;
            end;
          end;
        end;
      end;
    end;

    if (not CTCancelado) and (NaoEstaVazio(CTeRetorno.protCTe.nProt)) then
    begin
      FProtocolo := CTeRetorno.protCTe.nProt;
      FDhRecbto := CTeRetorno.protCTe.dhRecbto;
      FPMsg := CTeRetorno.protCTe.xMotivo;
    end;

    with TACBrCTe(FPDFeOwner) do
    begin
      Result := cStatProcessado(CTeRetorno.CStat) or
                cStatCancelado(CTeRetorno.CStat);
    end;

    if Result then
    begin
      for i := 0 to TACBrCTe(FPDFeOwner).Conhecimentos.Count - 1 do
      begin
        with TACBrCTe(FPDFeOwner).Conhecimentos.Items[i] do
        begin
          // Se verdadeiro significa que o componente esta carregado com todos os
          // dados do CT-e
          if (OnlyNumber(FCTeChave) = NumID) then
          begin
            Atualiza := (NaoEstaVazio(CTeRetorno.XMLprotCTe));

            if Atualiza and
               TACBrCTe(FPDFeOwner).cStatCancelado(CTeRetorno.CStat) then
              Atualiza := False;

//            if (CTeRetorno.CStat in [101, 151, 155]) then
//              Atualiza := False;

            if (CTeRetorno.cUF = 51) and (CTeRetorno.CStat = 101) then
              Atualiza := True;

            if (FPConfiguracoesCTe.Geral.ValidarDigest) and
               (CTeRetorno.protCTe.digVal <> '') and (CTe.signature.DigestValue <> '') and
               (UpperCase(CTe.signature.DigestValue) <> UpperCase(CTeRetorno.protCTe.digVal)) then
            begin
              raise EACBrCTeException.Create('DigestValue do documento ' +
                  NumID + ' n�o confere.');
            end;

            // Atualiza o Status da CTe interna //
            CTe.procCTe.cStat := CTeRetorno.cStat;

            if Atualiza then
            begin
              CTe.procCTe.Id := CTeRetorno.protCTe.Id;
              CTe.procCTe.tpAmb := CTeRetorno.tpAmb;
              CTe.procCTe.verAplic := CTeRetorno.verAplic;
              CTe.procCTe.chCTe := CTeRetorno.chCTe;
              CTe.procCTe.dhRecbto := FDhRecbto;
              CTe.procCTe.nProt := FProtocolo;
              CTe.procCTe.digVal := CTeRetorno.protCTe.digVal;
              CTe.procCTe.cStat := CTeRetorno.cStat;
              CTe.procCTe.xMotivo := CTeRetorno.xMotivo;

//              NomeXML := '-cte.xml';

              AProcCTe := TProcCTe.Create;
              try
                AProcCTe.XML_CTe := RemoverDeclaracaoXML(XMLOriginal);
//                AProcCTe.XML_CTe := StringReplace(XMLAssinado,
//                                           '<' + ENCODING_UTF8 + '>', '',
//                                           [rfReplaceAll]);
                AProcCTe.XML_Prot := CTeRetorno.XMLprotCTe;
                AProcCTe.Versao := FPVersaoServico;
                AProcCTe.GerarXML;

                XMLOriginal := AProcCTe.Gerador.ArquivoFormatoXML;

                FRetCTeDFe := '';
                aEventos := '';

                if (NaoEstaVazio(SeparaDados(FPRetWS, 'procEventoCTe'))) then
                begin
                  Inicio := Pos('<procEventoCTe', FPRetWS);
                  Fim    := Pos('</retConsSitCTe', FPRetWS) -1;

                  aEventos := Copy(FPRetWS, Inicio, Fim - Inicio + 1);

                  FRetCTeDFe := // '<' + ENCODING_UTF8 + '>' +
                                '<CTeDFe>' +
                                 '<procCTe versao="' + FVersao + '">' +
                                   SeparaDados(XMLOriginal, 'cteProc') +
                                 '</procCTe>' +
                                 '<procEventoCTe versao="' + FVersao + '">' +
                                   aEventos +
                                 '</procEventoCTe>' +
                                '</CTeDFe>';

                end;
              finally
                AProcCTe.Free;
              end;

              SalvarXML := Result and
                       FPConfiguracoesCTe.Arquivos.Salvar and
                       ((not FPConfiguracoesCTe.Arquivos.SalvarApenasCTeProcessados) or
                         Processado);

              if SalvarXML then
              begin
                if FPConfiguracoesCTe.Arquivos.EmissaoPathCTe then
                  dhEmissao := CTe.Ide.dhEmi
                else
                  dhEmissao := Now;

                sPathCTe := PathWithDelim(FPConfiguracoesCTe.Arquivos.GetPathCTe(dhEmissao, CTe.Emit.CNPJ));

                if (FRetCTeDFe <> '') {and FPConfiguracoesCTe.Geral.Salvar} then
                  FPDFeOwner.Gravar( FCTeChave + '-CTeDFe.xml', FRetCTeDFe, sPathCTe);

                // Salva o XML do CT-e assinado e protocolado
                NomeXMLSalvo := '';
                if NaoEstaVazio(NomeArq) and FileExists(NomeArq) then
                begin
                  FPDFeOwner.Gravar( NomeArq, XMLOriginal );  // Atualiza o XML carregado
                  NomeXMLSalvo := NomeArq;
                end;

                // Salva na pasta baseado nas configura��es do PathCTe
                if (NomeXMLSalvo <> CalcularNomeArquivoCompleto()) then
                  GravarXML;

                // Salva o XML de eventos retornados ao consultar um CT-e
                while aEvento <> '' do
                begin
                  Inicio := Pos('<procEventoCTe', aEventos);
                  Fim    := Pos('</procEventoCTe', aEventos) -1;

                  aEvento := Copy(aEventos, Inicio, Fim - Inicio + 1);

                  aEventos := Copy(aEventos, Fim + 16, Length(aEventos));

                  aProcEvento := '<procEventoCTe versao="' + FVersao + '" xmlns="' + ACBRCTE_NAMESPACE + '">' +
                                   SeparaDados(aEvento, 'procEventoCTe') +
                                 '</procEventoCTe>';

                  Inicio := Pos('Id=', aProcEvento) + 6;
                  Fim    := Inicio + 51;

                  aIDEvento := Copy(aProcEvento, Inicio, Fim);

                  if (aProcEvento <> '') then
                    FPDFeOwner.Gravar( aIDEvento + '-procEventoCTe.xml', aProcEvento, sPathCTe);
                end;

                (*
                // Salva o XML do CT-e assinado e protocolado
                if NaoEstaVazio(NomeArq) and FileExists(NomeArq) then
                  FPDFeOwner.Gravar( NomeArq, XMLOriginal );  // Atualiza o XML carregado

                // Salva o XML do CT-e assinado, protocolado e com os eventos
                if FRetCTeDFe <> '' then
                  FPDFeOwner.Gravar(FCTeChave + '-CTeDFe.xml',
                                    FRetCTeDFe,
                                    PathWithDelim(FPConfiguracoesCTe.Arquivos.GetPathCTe(Data)));

                GravarXML; // Salva na pasta baseado nas configura��es do PathCTe
                *)
              end;
            end;

            break;
          end;
        end;
      end;
    end;
  finally
    CTeRetorno.Free;
  end;
end;

function TCTeConsulta.GerarMsgLog: String;
begin
  Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                           'Identificador: %s ' + LineBreak +
                           'Ambiente: %s ' + LineBreak +
                           'Vers�o Aplicativo: %s ' + LineBreak +
                           'Status C�digo: %s ' + LineBreak +
                           'Status Descri��o: %s ' + LineBreak +
                           'UF: %s ' + LineBreak +
                           'Chave Acesso: %s ' + LineBreak +
                           'Recebimento: %s ' + LineBreak +
                           'Protocolo: %s ' + LineBreak +
                           'Digest Value: %s ' + LineBreak),
                   [Fversao, FCTeChave, TpAmbToStr(FTpAmb), FverAplic,
                    IntToStr(FcStat), FXMotivo, CodigoParaUF(FcUF), FCTeChave,
                    FormatDateTimeBr(FDhRecbto), FProtocolo, FprotCTe.digVal]);
end;

function TCTeConsulta.GerarPrefixoArquivo: String;
begin
  Result := Trim(FCTeChave);
end;

{ TCTeInutilizacao }

procedure TCTeInutilizacao.Clear;
begin
  inherited Clear;

  FPStatus := stCTeInutilizacao;
  FPLayout := LayCTeInutilizacao;
  FPArqEnv := 'ped-inu';
  FPArqResp := 'inu';

  FverAplic := '';
  FcStat := 0;
  FxMotivo := '';
  Fversao := '';
  FdhRecbto := 0;
  FXML_ProcInutCTe := '';

  if Assigned(FPConfiguracoesCTe) then
  begin
    FtpAmb := FPConfiguracoesCTe.WebServices.Ambiente;
    FcUF := FPConfiguracoesCTe.WebServices.UFCodigo;
  end
end;

procedure TCTeInutilizacao.SetJustificativa(AValue: String);
var
  TrimValue: String;
begin
  TrimValue := Trim(AValue);

  if EstaVazio(TrimValue) then
    GerarException(ACBrStr('Informar uma Justificativa para Inutiliza��o de ' +
      'numera��o do Conhecimento Eletronico'));

  if Length(TrimValue) < 15 then
    GerarException(ACBrStr('A Justificativa para Inutiliza��o de numera��o do ' +
      'Conhecimento Eletronico deve ter no minimo 15 caracteres'));

  FJustificativa := TrimValue;
end;

function TCTeInutilizacao.GerarPathPorCNPJ(): String;
var
  CNPJ: String;
begin
  if FPConfiguracoesCTe.Arquivos.SepararPorCNPJ then
    CNPJ := FCNPJ
  else
    CNPJ := '';

  Result := FPConfiguracoesCTe.Arquivos.GetPathInu(Now, CNPJ);
end;

procedure TCTeInutilizacao.DefinirURL;
var
  ok: Boolean;
  VerServ: Double;
  Modelo: String;
begin
  FPVersaoServico := '';
  FPURL  := '';

  Modelo := ModeloCTeToPrefixo( StrToModeloCTe(ok, IntToStr(FModelo) ));
  if not ok then
    raise EACBrCTeException.Create( 'Modelo Inv�lido: '+IntToStr(FModelo) );

  VerServ := VersaoCTeToDbl(FPConfiguracoesCTe.Geral.VersaoDF);

  TACBrCTe(FPDFeOwner).LerServicoDeParams(
    Modelo,
    FPConfiguracoesCTe.WebServices.UF,
    FPConfiguracoesCTe.WebServices.Ambiente,
    LayOutToServico(FPLayout),
    VerServ,
    FPURL
  );

  FPVersaoServico := FloatToString(VerServ, '.', '0.00');
end;

procedure TCTeInutilizacao.DefinirServicoEAction;
begin
  FPServico    := GetUrlWsd + 'CteInutilizacao';
  FPSoapAction := FPServico + '/cteInutilizacaoCT';
end;

procedure TCTeInutilizacao.DefinirDadosMsg;
var
  InutCTe: TinutCTe;
begin
  InutCTe := TinutCTe.Create;
  try
    InutCTe.tpAmb := FPConfiguracoesCTe.WebServices.Ambiente;
    InutCTe.cUF := FPConfiguracoesCTe.WebServices.UFCodigo;
    InutCTe.ano := FAno;
    InutCTe.CNPJ := FCNPJ;
    InutCTe.modelo := FModelo;
    InutCTe.serie := FSerie;
    InutCTe.nCTIni := FNumeroInicial;
    InutCTe.nCTFin := FNumeroFinal;
    InutCTe.xJust := FJustificativa;
    InutCTe.Versao := FPVersaoServico;

    AjustarOpcoes( InutCTe.Gerador.Opcoes );

    InutCTe.GerarXML;

    AssinarXML( NativeStringToUTF8( InutCTe.Gerador.ArquivoFormatoXML ),
                'inutCTe', 'infInut', 'Falha ao assinar Inutiliza��o de numera��o.');

    FID := InutCTe.ID;
  finally
    InutCTe.Free;
  end;
end;

procedure TCTeInutilizacao.SalvarEnvio;
var
  aPath: String;
begin
  inherited SalvarEnvio;

  if FPConfiguracoesCTe.Geral.Salvar then
  begin
    aPath := GerarPathPorCNPJ;
    FPDFeOwner.Gravar(GerarPrefixoArquivo + '-' + ArqEnv + '.xml', FPDadosMsg, aPath);
  end;
end;

procedure TCTeInutilizacao.SalvarResposta;
var
  aPath: String;
begin
  inherited SalvarResposta;

  if FPConfiguracoesCTe.Geral.Salvar then
  begin
    aPath := GerarPathPorCNPJ;
    FPDFeOwner.Gravar(GerarPrefixoArquivo + '-' + ArqResp + '.xml', FPRetWS, aPath);
  end;
end;

function TCTeInutilizacao.TratarResposta: Boolean;
var
  CTeRetorno: TRetInutCTe;
begin
  CTeRetorno := TRetInutCTe.Create;
  try
    FPRetWS := SeparaDados(FPRetornoWS, 'cteInutilizacaoCTResult');

    CTeRetorno.Leitor.Arquivo := ParseText(FPRetWS);
    CTeRetorno.LerXml;

    Fversao := CTeRetorno.versao;
    FTpAmb := CTeRetorno.TpAmb;
    FverAplic := CTeRetorno.verAplic;
    FcStat := CTeRetorno.cStat;
    FxMotivo := CTeRetorno.xMotivo;
    FcUF := CTeRetorno.cUF;
    FdhRecbto := CTeRetorno.dhRecbto;
    Fprotocolo := CTeRetorno.nProt;
    FPMsg := CTeRetorno.XMotivo;

    Result := (CTeRetorno.cStat = 102);

    //gerar arquivo proc de inutilizacao
    if ((CTeRetorno.cStat = 102) or (CTeRetorno.cStat = 682)) then
    begin
      FXML_ProcInutCTe := '<' + ENCODING_UTF8 + '>' +
                          '<ProcInutCTe versao="' + FPVersaoServico +
                              '" xmlns="' + ACBRCTE_NAMESPACE + '">' +
                            FPDadosMsg +
                            FPRetWS +
                          '</ProcInutCTe>';

      FNomeArquivo := PathWithDelim(GerarPathPorCNPJ) + GerarPrefixoArquivo + '-procInutCTe.xml';
      if FPConfiguracoesCTe.Arquivos.Salvar then
        FPDFeOwner.Gravar(GerarPrefixoArquivo + '-procInutCTe.xml',
          FXML_ProcInutCTe, GerarPathPorCNPJ);
    end;
  finally
    CTeRetorno.Free;
  end;
end;

function TCTeInutilizacao.GerarMsgLog: String;
begin
  Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                           'Ambiente: %s ' + LineBreak +
                           'Vers�o Aplicativo: %s ' + LineBreak +
                           'Status C�digo: %s ' + LineBreak +
                           'Status Descri��o: %s ' + LineBreak +
                           'UF: %s ' + LineBreak +
                           'Recebimento: %s ' + LineBreak),
                   [Fversao, TpAmbToStr(FTpAmb), FverAplic, IntToStr(FcStat),
                    FxMotivo, CodigoParaUF(FcUF),
                    IfThen(FdhRecbto = 0, '', FormatDateTimeBr(FdhRecbto))]);
end;

function TCTeInutilizacao.GerarPrefixoArquivo: String;
begin
  Result := Trim(OnlyNumber(FID));
end;

{ TCTeConsultaCadastro }

constructor TCTeConsultaCadastro.Create(AOwner: TACBrDFe);
begin
  inherited Create(AOwner);
end;

destructor TCTeConsultaCadastro.Destroy;
begin
  FRetConsCad.Free;

  inherited Destroy;
end;

procedure TCTeConsultaCadastro.FinalizarServico;
begin
  inherited FinalizarServico;

  FPBodyElement := FOldBodyElement;
end;

procedure TCTeConsultaCadastro.Clear;
begin
  inherited Clear;

  FPStatus := stCTeCadastro;
  FPLayout := LayCTeCadastro;
  FPArqEnv := 'ped-cad';
  FPArqResp := 'cad';

  FverAplic := '';
  FcStat := 0;
  FxMotivo := '';
  Fversao := '';
  FdhCons := 0;

  if Assigned(FPConfiguracoesCTe) then
    FcUF := FPConfiguracoesCTe.WebServices.UFCodigo;

  if Assigned(FRetConsCad) then
    FRetConsCad.Free;

  FRetConsCad := TRetConsCad.Create;
end;

procedure TCTeConsultaCadastro.SetCNPJ(const Value: String);
begin
  if NaoEstaVazio(Value) then
  begin
    FIE := '';
    FCPF := '';
  end;

  FCNPJ := Value;
end;

procedure TCTeConsultaCadastro.SetCPF(const Value: String);
begin
  if NaoEstaVazio(Value) then
  begin
    FIE := '';
    FCNPJ := '';
  end;

  FCPF := Value;
end;

procedure TCTeConsultaCadastro.SetIE(const Value: String);
begin
  if NaoEstaVazio(Value) then
  begin
    FCNPJ := '';
    FCPF := '';
  end;

  FIE := Value;
end;

procedure TCTeConsultaCadastro.DefinirServicoEAction;
begin
  FPServico := 'http://www.portalfiscal.inf.br/nfe/wsdl/CadConsultaCadastro2';
  FPSoapAction := FPServico;
end;

procedure TCTeConsultaCadastro.DefinirURL;
var
  Versao: Double;
begin
  FPVersaoServico := '';
  FPURL := '';
  Versao := VersaoCTeToDbl(FPConfiguracoesCTe.Geral.VersaoDF);

  if EstaVazio(FUF) then
    FUF := FPConfiguracoesCTe.WebServices.UF;

  TACBrCTe(FPDFeOwner).LerServicoDeParams(
    TACBrCTe(FPDFeOwner).GetNomeModeloDFe,
    FUF,
    FPConfiguracoesCTe.WebServices.Ambiente,
    LayOutToServico(FPLayout),
    Versao,
    FPURL
  );

  FPVersaoServico := FloatToString(Versao, '.', '0.00');
end;

procedure TCTeConsultaCadastro.DefinirDadosMsg;
var
  ConCadCTe: TConsCad;
begin
  ConCadCTe := TConsCad.Create;
  try
    ConCadCTe.UF := FUF;
    ConCadCTe.IE := FIE;
    ConCadCTe.CNPJ := FCNPJ;
    ConCadCTe.CPF := FCPF;
    ConCadCTe.Versao := FPVersaoServico;

    AjustarOpcoes( ConCadCTe.Gerador.Opcoes );

    ConCadCTe.GerarXML;

    FPDadosMsg := ConCadCTe.Gerador.ArquivoFormatoXML;
  finally
    ConCadCTe.Free;
  end;
end;

procedure TCTeConsultaCadastro.DefinirEnvelopeSoap;
var
  Texto: AnsiString;
begin
  Texto := '<' + ENCODING_UTF8 + '>';
  Texto := Texto + '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' +
                                   ' xmlns:xsd="http://www.w3.org/2001/XMLSchema"' +
                                   ' xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">';
  Texto := Texto +   '<soap12:Header>';
  Texto := Texto +     '<nfeCabecMsg xmlns="' + FPServico + '">';
  Texto := Texto +       GerarUFSoap;
  Texto := Texto +       GerarVersaoDadosSoap;
  Texto := Texto +     '</nfeCabecMsg>';
  Texto := Texto +   '</soap12:Header>';
  Texto := Texto +   '<soap12:Body>';
  Texto := Texto +     '<nfeDadosMsg xmlns="' + FPServico + '">';
  Texto := Texto +       FPDadosMsg;
  Texto := Texto +     '</nfeDadosMsg>';
  Texto := Texto +   '</soap12:Body>';
  Texto := Texto + '</soap12:Envelope>';

  FPEnvelopeSoap := Texto;
end;

function TCTeConsultaCadastro.TratarResposta: Boolean;
begin
  FPRetWS := SeparaDados(FPRetornoWS, 'consultaCadastro2Result');

  FRetConsCad.Leitor.Arquivo := ParseText(FPRetWS);
  FRetConsCad.LerXml;

  Fversao := FRetConsCad.versao;
  FverAplic := FRetConsCad.verAplic;
  FcStat := FRetConsCad.cStat;
  FxMotivo := FRetConsCad.xMotivo;
  FdhCons := FRetConsCad.dhCons;
  FcUF := FRetConsCad.cUF;
  FPMsg := FRetConsCad.XMotivo;

  Result := (FRetConsCad.cStat in [111, 112]);
end;

function TCTeConsultaCadastro.GerarMsgLog: String;
begin
  Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                           'Vers�o Aplicativo: %s ' + LineBreak +
                           'Status C�digo: %s ' + LineBreak +
                           'Status Descri��o: %s ' + LineBreak +
                           'UF: %s ' + LineBreak +
                           'Consulta: %s ' + sLineBreak),
                   [FRetConsCad.versao, FRetConsCad.verAplic,
                   IntToStr(FRetConsCad.cStat), FRetConsCad.xMotivo,
                   CodigoParaUF(FRetConsCad.cUF),
                   FormatDateTimeBr(FRetConsCad.dhCons)]);
end;

function TCTeConsultaCadastro.GerarUFSoap: String;
begin
  Result := '<cUF>' + IntToStr(UFparaCodigo(FUF)) + '</cUF>';
end;

procedure TCTeConsultaCadastro.InicializarServico;
begin
  inherited InicializarServico;

  FOldBodyElement := FPBodyElement;

  if (FPConfiguracoesCTe.Geral.VersaoDF >= ve300) and
    ((UpperCase(FUF) = 'RS') or (Pos('svrs.rs.gov.br', FPURL) > 0)) then
  begin
    FPBodyElement := 'consultaCadastro';
  end;
end;

{ TCTeEnvEvento }

constructor TCTeEnvEvento.Create(AOwner: TACBrDFe; AEvento: TEventoCTe);
begin
  inherited Create(AOwner);

  FEvento := AEvento;
end;

destructor TCTeEnvEvento.Destroy;
begin
  if Assigned(FEventoRetorno) then
    FEventoRetorno.Free;

  inherited;
end;

procedure TCTeEnvEvento.Clear;
begin
  inherited Clear;

  FPStatus := stCTeEvento;
  FPLayout := LayCTeEvento;
  FPArqEnv := 'ped-eve';
  FPArqResp := 'eve';

  FcStat   := 0;
  FxMotivo := '';
  FCNPJ := '';

  if Assigned(FPConfiguracoesCTe) then
    FtpAmb := FPConfiguracoesCTe.WebServices.Ambiente;

  if Assigned(FEventoRetorno) then
    FEventoRetorno.Free;

  FEventoRetorno := TRetEventoCTe.Create;
end;

function TCTeEnvEvento.GerarPathEvento(const ACNPJ: String): String;
begin
  with FEvento.Evento.Items[0].Infevento do
  begin
    Result := FPConfiguracoesCTe.Arquivos.GetPathEvento(tpEvento, ACNPJ);
  end;
end;

procedure TCTeEnvEvento.DefinirURL;
var
  UF, Modelo: String;
  VerServ: Double;
  Ok: Boolean;
begin
  VerServ := VersaoCTeToDbl(FPConfiguracoesCTe.Geral.VersaoDF);
  FCNPJ   := FEvento.Evento.Items[0].InfEvento.CNPJ;
  FTpAmb  := FEvento.Evento.Items[0].InfEvento.tpAmb;
  Modelo  := ModeloCTeToPrefixo( StrToModeloCTe(ok, ExtrairModeloChaveAcesso(FEvento.Evento.Items[0].InfEvento.chCTe) ));

  case FPConfiguracoesCTe.Geral.FormaEmissao of
    teSVCRS: UF := 'SVC-RS';
    teSVCSP: UF := 'SVC-SP';
  else
    UF := CUFtoUF(ExtrairUFChaveAcesso(FEvento.Evento.Items[0].InfEvento.chCTe));
  end;

  { Verifica��o necess�ria pois somente os eventos de CCe, Cancelamento,
    Multimodal, Presta��o em Desacordo e GTV ser�o tratados pela SEFAZ do estado
    os outros eventos como manifesta��o do destinat�rio ser�o tratados diretamente pela RFB }

  if (FEvento.Evento.Items[0].InfEvento.tpEvento in [teCCe, teCancelamento,
      teMultiModal, tePrestDesacordo, teGTV]) then
    FPLayout := LayCTeEvento
  else
    FPLayout := LayCTeEventoAN;

  FPURL := '';

  TACBrCTe(FPDFeOwner).LerServicoDeParams(
    Modelo,
    UF,
    FTpAmb,
    LayOutToServico(FPLayout),
    VerServ,
    FPURL
  );

  FPVersaoServico := FloatToString(VerServ, '.', '0.00');
end;

procedure TCTeEnvEvento.DefinirServicoEAction;
begin
  FPServico    := GetUrlWsd + 'CteRecepcaoEvento';
  FPSoapAction := FPServico + '/cteRecepcaoEvento';
end;

procedure TCTeEnvEvento.DefinirDadosMsg;
var
  EventoCTe: TEventoCTe;
  I, J, K, F: Integer;
  Evento, Eventos, EventosAssinados, AXMLEvento: AnsiString;
//  FErroValidacao: String;
  EventoEhValido: Boolean;
  SchemaEventoCTe: TSchemaCTe;
begin
  EventoCTe := TEventoCTe.Create;
  try
    EventoCTe.idLote := FidLote;
    SchemaEventoCTe := schErro;

    for I := 0 to FEvento.Evento.Count - 1 do
    begin
      with EventoCTe.Evento.Add do
      begin
        infEvento.tpAmb := FTpAmb;
        infEvento.CNPJ := FEvento.Evento[I].InfEvento.CNPJ;
        infEvento.cOrgao := FEvento.Evento[I].InfEvento.cOrgao;
        infEvento.chCTe := FEvento.Evento[I].InfEvento.chCTe;
        infEvento.dhEvento := FEvento.Evento[I].InfEvento.dhEvento;
        infEvento.tpEvento := FEvento.Evento[I].InfEvento.tpEvento;
        infEvento.nSeqEvento := FEvento.Evento[I].InfEvento.nSeqEvento;
        infEvento.versaoEvento := FEvento.Evento[I].InfEvento.versaoEvento;

        case InfEvento.tpEvento of
          teCCe:
          begin
            SchemaEventoCTe := schevCCeCTe;
            infEvento.detEvento.xCondUso := FEvento.Evento[I].InfEvento.detEvento.xCondUso;
            infEvento.detEvento.xCondUso := FEvento.Evento[i].InfEvento.detEvento.xCondUso;

            for j := 0 to FEvento.Evento[i].InfEvento.detEvento.infCorrecao.Count - 1 do
             begin
               with EventoCTe.Evento[i].InfEvento.detEvento.infCorrecao.Add do
                begin
                 grupoAlterado   := FEvento.Evento[i].InfEvento.detEvento.infCorrecao[j].grupoAlterado;
                 campoAlterado   := FEvento.Evento[i].InfEvento.detEvento.infCorrecao[j].campoAlterado;
                 valorAlterado   := FEvento.Evento[i].InfEvento.detEvento.infCorrecao[j].valorAlterado;
                 nroItemAlterado := FEvento.Evento[i].InfEvento.detEvento.infCorrecao[j].nroItemAlterado;
                end;
             end;
          end;

          teCancelamento:
          begin
            SchemaEventoCTe := schevCancCTe;
            infEvento.detEvento.nProt := FEvento.Evento[I].InfEvento.detEvento.nProt;
            infEvento.detEvento.xJust := FEvento.Evento[I].InfEvento.detEvento.xJust;
          end;

          teMultiModal:
          begin
            SchemaEventoCTe := schevRegMultimodal;
            infEvento.detEvento.xRegistro := FEvento.Evento[i].InfEvento.detEvento.xRegistro;
            infEvento.detEvento.nDoc      := FEvento.Evento[i].InfEvento.detEvento.nDoc;
          end;

          teEPEC:
          begin
            SchemaEventoCTe := schevEPECCTe;
            infEvento.detEvento.xJust   := FEvento.Evento[i].InfEvento.detEvento.xJust;
            infEvento.detEvento.vICMS   := FEvento.Evento[i].InfEvento.detEvento.vICMS;
            infEvento.detEvento.vTPrest := FEvento.Evento[i].InfEvento.detEvento.vTPrest;
            infEvento.detEvento.vCarga  := FEvento.Evento[i].InfEvento.detEvento.vCarga;
            infEvento.detEvento.toma    := FEvento.Evento[i].InfEvento.detEvento.toma;
            infEvento.detEvento.UF      := FEvento.Evento[i].InfEvento.detEvento.UF;
            infEvento.detEvento.CNPJCPF := FEvento.Evento[i].InfEvento.detEvento.CNPJCPF;
            infEvento.detEvento.IE      := FEvento.Evento[i].InfEvento.detEvento.IE;
            infEvento.detEvento.modal   := FEvento.Evento[i].InfEvento.detEvento.modal;
            infEvento.detEvento.UFIni   := FEvento.Evento[i].InfEvento.detEvento.UFIni;
            infEvento.detEvento.UFFim   := FEvento.Evento[i].InfEvento.detEvento.UFFim;
            infEvento.detEvento.tpCTe   := FEvento.Evento[i].InfEvento.detEvento.tpCTe;
            infEvento.detEvento.dhEmi   := FEvento.Evento[i].InfEvento.detEvento.dhEmi;
          end;

          tePrestDesacordo:
          begin
            SchemaEventoCTe := schevPrestDesacordo;
            infEvento.detEvento.xOBS := FEvento.Evento[i].InfEvento.detEvento.xOBS;
          end;

          teGTV:
          begin
            SchemaEventoCTe := schevGTV;
            for j := 0 to FEvento.Evento[i].InfEvento.detEvento.infGTV.Count - 1 do
            begin
              with EventoCTe.Evento[i].InfEvento.detEvento.infGTV.Add do
              begin
                nDoc     := FEvento.Evento[i].InfEvento.detEvento.infGTV[j].nDoc;
                id       := FEvento.Evento[i].InfEvento.detEvento.infGTV[j].id;
                serie    := FEvento.Evento[i].InfEvento.detEvento.infGTV[j].serie;
                subserie := FEvento.Evento[i].InfEvento.detEvento.infGTV[j].subserie;
                dEmi     := FEvento.Evento[i].InfEvento.detEvento.infGTV[j].dEmi;
                nDV      := FEvento.Evento[i].InfEvento.detEvento.infGTV[j].nDV;
                qCarga   := FEvento.Evento[i].InfEvento.detEvento.infGTV[j].qCarga;

                for k := 0 to FEvento.Evento[i].InfEvento.detEvento.infGTV.Items[j].infEspecie.Count - 1 do
                begin
                  with EventoCTe.Evento[i].InfEvento.detEvento.infGTV.Items[j].infEspecie.Add do
                  begin
                    tpEspecie := FEvento.Evento[i].InfEvento.detEvento.infGTV[j].infEspecie[k].tpEspecie;
                    vEspecie  := FEvento.Evento[i].InfEvento.detEvento.infGTV[j].infEspecie[k].vEspecie;
                  end;
                end;

                rem.CNPJCPF := FEvento.Evento[i].InfEvento.detEvento.infGTV[j].rem.CNPJCPF;
                rem.IE      := FEvento.Evento[i].InfEvento.detEvento.infGTV[j].rem.IE;
                rem.UF      := FEvento.Evento[i].InfEvento.detEvento.infGTV[j].rem.UF;
                rem.xNome   := FEvento.Evento[i].InfEvento.detEvento.infGTV[j].rem.xNome;

                dest.CNPJCPF := FEvento.Evento[i].InfEvento.detEvento.infGTV[j].dest.CNPJCPF;
                dest.IE      := FEvento.Evento[i].InfEvento.detEvento.infGTV[j].dest.IE;
                dest.UF      := FEvento.Evento[i].InfEvento.detEvento.infGTV[j].dest.UF;
                dest.xNome   := FEvento.Evento[i].InfEvento.detEvento.infGTV[j].dest.xNome;

                placa := FEvento.Evento[i].InfEvento.detEvento.infGTV[j].placa;
                UF    := FEvento.Evento[i].InfEvento.detEvento.infGTV[j].UF;
                RNTRC := FEvento.Evento[i].InfEvento.detEvento.infGTV[j].RNTRC;
              end;
            end;
          end;
        end;
      end;
    end;

    EventoCTe.Versao := FPVersaoServico;

    AjustarOpcoes( EventoCTe.Gerador.Opcoes );
//    EventoCTe.Gerador.Opcoes.RetirarAcentos := False;  // N�o funciona sem acentos

    EventoCTe.GerarXML;

    Eventos := NativeStringToUTF8( EventoCTe.Gerador.ArquivoFormatoXML );
    EventosAssinados := '';

    // Realiza a assinatura para cada evento
    while Eventos <> '' do
    begin
      F := Pos('</eventoCTe>', Eventos);

      if F > 0 then
      begin
        Evento := Copy(Eventos, 1, F + 11);
        Eventos := Copy(Eventos, F + 12, length(Eventos));

        AssinarXML(Evento, 'eventoCTe', 'infEvento', 'Falha ao assinar o Envio de Evento ');
        EventosAssinados := EventosAssinados + FPDadosMsg;
      end
      else
        Break;
    end;

    // Separa o XML especifico do Evento para ser Validado.
    AXMLEvento := '<' + ENCODING_UTF8 + '>' +
                  SeparaDados(FPDadosMsg, 'detEvento');

    with TACBrCTe(FPDFeOwner) do
    begin
      EventoEhValido := SSL.Validar(FPDadosMsg,
                                    GerarNomeArqSchema(FPLayout,
                                                       StringToFloatDef(FPVersaoServico, 0)),
                                    FPMsg) and
                        SSL.Validar(AXMLEvento,
                                    GerarNomeArqSchemaEvento(SchemaEventoCTe,
                                                             StringToFloatDef(FPVersaoServico, 0)),
                                    FPMsg);
    end;
    if not EventoEhValido then
    begin
      //FErroValidacao := ACBrStr('Falha na valida��o dos dados do Evento: ') +
      //  FPMsg;

//      raise EACBrCTeException.CreateDef(FErroValidacao);
    end;
    for I := 0 to FEvento.Evento.Count - 1 do
      FEvento.Evento[I].InfEvento.id := EventoCTe.Evento[I].InfEvento.id;
  finally
    EventoCTe.Free;
  end;
end;

procedure TCTeEnvEvento.DefinirEnvelopeSoap;
var
  Texto: AnsiString;
begin
  // UF = 51 = MT n�o esta aceitando SOAP 1.2
  if FPConfiguracoes.WebServices.UFCodigo <> 51 then
  begin
    Texto := '<' + ENCODING_UTF8 + '>';
    Texto := Texto + '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' +
                                     ' xmlns:xsd="http://www.w3.org/2001/XMLSchema"' +
                                     ' xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">';
    Texto := Texto +   '<soap12:Header>';
    Texto := Texto +     '<cteCabecMsg xmlns="' + FPServico + '">';
    Texto := Texto +       GerarUFSoap;
    Texto := Texto +       GerarVersaoDadosSoap;
    Texto := Texto +     '</cteCabecMsg>';
    Texto := Texto +   '</soap12:Header>';
    Texto := Texto +   '<soap12:Body>';
    Texto := Texto +     '<cteDadosMsg xmlns="' + FPServico + '">';
    Texto := Texto +       FPDadosMsg;
    Texto := Texto +     '</cteDadosMsg>';
    Texto := Texto +   '</soap12:Body>';
    Texto := Texto + '</soap12:Envelope>';
  end
  else begin
    Texto := '<' + ENCODING_UTF8 + '>';
    Texto := Texto + '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' +
                                   ' xmlns:xsd="http://www.w3.org/2001/XMLSchema"' +
                                   ' xmlns:soap="http://www.w3.org/2003/05/soap-envelope">';
    Texto := Texto +   '<soap:Header>';
    Texto := Texto +     '<cteCabecMsg xmlns="' + FPServico + '">';
    Texto := Texto +       GerarUFSoap;
    Texto := Texto +       GerarVersaoDadosSoap;
    Texto := Texto +     '</cteCabecMsg>';
    Texto := Texto +   '</soap:Header>';
    Texto := Texto +   '<soap:Body>';
    Texto := Texto +     '<cteDadosMsg xmlns="' + FPServico + '">';
    Texto := Texto +       FPDadosMsg;
    Texto := Texto +     '</cteDadosMsg>';
    Texto := Texto +   '</soap:Body>';
    Texto := Texto + '</soap:Envelope>';
  end;

  FPEnvelopeSoap := Texto;
end;

function TCTeEnvEvento.TratarResposta: Boolean;
var
  Leitor: TLeitor;
  I, J: Integer;
  NomeArq, PathArq, VersaoEvento, Texto: String;
begin
  FEvento.idLote := idLote;

  FPRetWS := SeparaDados(FPRetornoWS, 'cteRecepcaoEventoResult');

  EventoRetorno.Leitor.Arquivo := ParseText(FPRetWS);
  EventoRetorno.LerXml;

  FcStat := EventoRetorno.cStat;
  FxMotivo := EventoRetorno.xMotivo;
  FPMsg := EventoRetorno.xMotivo;
  FTpAmb := EventoRetorno.tpAmb;

  Result := (FcStat in [134, 135, 136]);

  //gerar arquivo proc de evento
  if Result then
  begin
    Leitor := TLeitor.Create;
    try
      for I := 0 to FEvento.Evento.Count - 1 do
      begin
        for J := 0 to EventoRetorno.retEvento.Count - 1 do
        begin
          if FEvento.Evento.Items[I].InfEvento.chCTe =
            EventoRetorno.retEvento.Items[J].RetInfEvento.chCTe then
          begin
            FEvento.Evento.Items[I].RetInfEvento.tpAmb :=
              EventoRetorno.retEvento.Items[J].RetInfEvento.tpAmb;
            FEvento.Evento.Items[I].RetInfEvento.nProt :=
              EventoRetorno.retEvento.Items[J].RetInfEvento.nProt;
            FEvento.Evento.Items[I].RetInfEvento.dhRegEvento :=
              EventoRetorno.retEvento.Items[J].RetInfEvento.dhRegEvento;
            FEvento.Evento.Items[I].RetInfEvento.cStat :=
              EventoRetorno.retEvento.Items[J].RetInfEvento.cStat;
            FEvento.Evento.Items[I].RetInfEvento.xMotivo :=
              EventoRetorno.retEvento.Items[J].RetInfEvento.xMotivo;
            FEvento.Evento.Items[i].RetInfEvento.chCTe :=
              EventoRetorno.retEvento.Items[j].RetInfEvento.chCTe;

            VersaoEvento := TACBrCTe(FPDFeOwner).LerVersaoDeParams(LayCTeEvento);

            Leitor.Arquivo := FPDadosMsg;
            Texto := '<procEventoCTe versao="' + VersaoEvento + '" xmlns="' + ACBRCTE_NAMESPACE + '">' +
                      '<eventoCTe versao="' + VersaoEvento + '">' +
                       Leitor.rExtrai(1, 'infEvento', '', I + 1) +
                       '<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">' +
                        Leitor.rExtrai(1, 'SignedInfo', '', I + 1) +
                        Leitor.rExtrai(1, 'SignatureValue', '', I + 1) +
                        Leitor.rExtrai(1, 'KeyInfo', '', I + 1) +
                       '</Signature>' +
                      '</eventoCTe>';

            Leitor.Arquivo := FPRetWS;
            Texto := Texto +
                       '<retEventoCTe versao="' + VersaoEvento + '">' +
                        Leitor.rExtrai(1, 'infEvento', '', J + 1) +
                       '</retEventoCTe>' +
                      '</procEventoCTe>';

            if FPConfiguracoesCTe.Arquivos.Salvar then
            begin
              NomeArq := OnlyNumber(FEvento.Evento.Items[I].InfEvento.Id) + '-procEventoCTe.xml';
              PathArq := PathWithDelim(GerarPathEvento(FEvento.Evento.Items[I].InfEvento.CNPJ));

              FPDFeOwner.Gravar(NomeArq, Texto, PathArq);
              FEventoRetorno.retEvento.Items[J].RetInfEvento.NomeArquivo := PathArq + NomeArq;
              FEvento.Evento.Items[I].RetInfEvento.NomeArquivo := PathArq + NomeArq;
            end;

            Texto := ParseText(Texto);
            FEventoRetorno.retEvento.Items[J].RetInfEvento.XML := Texto;
            FEvento.Evento.Items[I].RetInfEvento.XML := Texto;

            break;
          end;
        end;
      end;
    finally
      Leitor.Free;
    end;
  end;
end;

procedure TCTeEnvEvento.SalvarEnvio;
begin
//  inherited SalvarEnvio;

  if ArqEnv = '' then
    exit;

  if FPConfiguracoesCTe.Geral.Salvar then
    FPDFeOwner.Gravar(GerarPrefixoArquivo + '-' + ArqEnv + '.xml',
      FPDadosMsg, GerarPathEvento(FCNPJ));

  if FPConfiguracoesCTe.WebServices.Salvar then
    FPDFeOwner.Gravar(GerarPrefixoArquivo + '-' + ArqEnv + '-soap.xml',
      FPEnvelopeSoap, GerarPathEvento(FCNPJ));
end;

procedure TCTeEnvEvento.SalvarResposta;
begin
//  inherited SalvarResposta;

  if ArqResp = '' then
    exit;

  if FPConfiguracoesCTe.Geral.Salvar then
    FPDFeOwner.Gravar(GerarPrefixoArquivo + '-' + ArqResp + '.xml',
      FPRetWS, GerarPathEvento(FCNPJ));

  if FPConfiguracoesCTe.WebServices.Salvar then
    FPDFeOwner.Gravar(GerarPrefixoArquivo + '-' + ArqResp + '-soap.xml',
      FPRetornoWS, GerarPathEvento(FCNPJ));
end;

function TCTeEnvEvento.GerarMsgLog: String;
var
  aMsg: String;
begin
  aMsg := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                         'Ambiente: %s ' + LineBreak +
                         'Vers�o Aplicativo: %s ' + LineBreak +
                         'Status C�digo: %s ' + LineBreak +
                         'Status Descri��o: %s ' + LineBreak),
                 [FEventoRetorno.versao, TpAmbToStr(FEventoRetorno.tpAmb),
                  FEventoRetorno.verAplic, IntToStr(FEventoRetorno.cStat),
                  FEventoRetorno.xMotivo]);

  if FEventoRetorno.retEvento.Count > 0 then
    aMsg := aMsg + Format(ACBrStr('Recebimento: %s ' + LineBreak),
       [IfThen(FEventoRetorno.retEvento.Items[0].RetInfEvento.dhRegEvento = 0, '',
               FormatDateTimeBr(FEventoRetorno.retEvento.Items[0].RetInfEvento.dhRegEvento))]);

  Result := aMsg;
end;

function TCTeEnvEvento.GerarPrefixoArquivo: String;
begin
//  Result := IntToStr(FEvento.idLote);
  Result := IntToStr(FidLote);
end;

{ TDistribuicaoDFe }

constructor TDistribuicaoDFe.Create(AOwner: TACBrDFe);
begin
  inherited Create(AOwner);
end;

destructor TDistribuicaoDFe.Destroy;
begin
  FretDistDFeInt.Free;
  FlistaArqs.Free;

  inherited;
end;

procedure TDistribuicaoDFe.Clear;
begin
  inherited Clear;

  FPStatus        := stCTeDistDFeInt;
  FPLayout        := LayCTeDistDFeInt;
  FPArqEnv        := 'con-dist-dfe';
  FPArqResp       := 'dist-dfe';
  FPBodyElement   := 'cteDistDFeInteresse';
  FPHeaderElement := '';

  if Assigned(FretDistDFeInt) then
    FretDistDFeInt.Free;

  FretDistDFeInt := TRetDistDFeInt.Create;

  if Assigned(FlistaArqs) then
    FlistaArqs.Free;

  FlistaArqs := TStringList.Create;
end;

procedure TDistribuicaoDFe.DefinirURL;
var
  UF : String;
  Versao: Double;
begin
  { Esse m�todo � tratado diretamente pela RFB }

  UF := 'AN';

  Versao := 0;
  FPVersaoServico := '';
  FPURL := '';
  Versao := VersaoCTeToDbl(FPConfiguracoesCTe.Geral.VersaoDF);

  TACBrCTe(FPDFeOwner).LerServicoDeParams(
    TACBrCTe(FPDFeOwner).GetNomeModeloDFe,
    UF ,
    FPConfiguracoesCTe.WebServices.Ambiente,
    LayOutToServico(FPLayout),
    Versao,
    FPURL);

  FPVersaoServico := FloatToString(Versao, '.', '0.00');
end;

procedure TDistribuicaoDFe.DefinirServicoEAction;
begin
  FPServico := GetUrlWsd + 'CTeDistribuicaoDFe';
  FPSoapAction := FPServico + '/cteDistDFeInteresse';
end;

procedure TDistribuicaoDFe.DefinirDadosMsg;
var
  DistDFeInt: TDistDFeInt;
begin
  DistDFeInt := TDistDFeInt.Create;
  try
    DistDFeInt.TpAmb := FPConfiguracoesCTe.WebServices.Ambiente;
    DistDFeInt.cUFAutor := FcUFAutor;
    DistDFeInt.CNPJCPF := FCNPJCPF;
    DistDFeInt.ultNSU := FultNSU;
    DistDFeInt.NSU := FNSU;
    DistDFeInt.chCTe := trim(FchCTe);
    DistDFeInt.Versao := FPVersaoServico;

    AjustarOpcoes( DistDFeInt.Gerador.Opcoes );

    DistDFeInt.GerarXML;

    FPDadosMsg := DistDFeInt.Gerador.ArquivoFormatoXML;
  finally
    DistDFeInt.Free;
  end;
end;

function TDistribuicaoDFe.TratarResposta: Boolean;
var
  I: Integer;
  AXML: String;
begin
  FPRetWS := SeparaDados(FPRetornoWS, 'cteDistDFeInteresseResult');

  // Processando em UTF8, para poder gravar arquivo corretamente //
  FretDistDFeInt.Leitor.Arquivo := FPRetWS;
  FretDistDFeInt.LerXml;

  for I := 0 to FretDistDFeInt.docZip.Count - 1 do
  begin
    AXML := FretDistDFeInt.docZip.Items[I].XML;
    FNomeArq := '';
    if (AXML <> '') then
    begin
      case FretDistDFeInt.docZip.Items[I].schema of
        (*
        schresCTe:
          FNomeArq := FretDistDFeInt.docZip.Items[I].resCTe.chCTe + '-resCTe.xml';

        schresEvento:
          FNomeArq := OnlyNumber(TpEventoToStr(FretDistDFeInt.docZip.Items[I].resEvento.tpEvento) +
                     FretDistDFeInt.docZip.Items[I].resEvento.chCTe +
                     Format('%.2d', [FretDistDFeInt.docZip.Items[I].resEvento.nSeqEvento])) +
                     '-resEventoCTe.xml';
        *)
        schprocCTe,
        schprocCTeOS:
          FNomeArq := FretDistDFeInt.docZip.Items[I].resCTe.chCTe + '-cte.xml';

        schprocEventoCTe:
          FNomeArq := OnlyNumber(FretDistDFeInt.docZip.Items[I].procEvento.Id) +
                     '-procEventoCTe.xml';
      end;

      if NaoEstaVazio(NomeArq) then
        FlistaArqs.Add( FNomeArq );

      if (FPConfiguracoesCTe.Arquivos.Salvar) and NaoEstaVazio(FNomeArq) then
      begin
        if (FretDistDFeInt.docZip.Items[I].schema in [schprocEventoCTe]) then // salvar evento
          FPDFeOwner.Gravar(FNomeArq, AXML, GerarPathDistribuicao(FretDistDFeInt.docZip.Items[I]));

        if (FretDistDFeInt.docZip.Items[I].schema in [schprocCTe, schprocCTeOS]) then
          FPDFeOwner.Gravar(FNomeArq, AXML, GerarPathDistribuicao(FretDistDFeInt.docZip.Items[I]));
      end;
    end;
  end;

  { Processsa novamente, chamando ParseTXT, para converter de UTF8 para a String
    nativa e Decodificar caracteres HTML Entity }
  FretDistDFeInt.Free;   // Limpando a lista
  FretDistDFeInt := TRetDistDFeInt.Create;

  FretDistDFeInt.Leitor.Arquivo := ParseText(FPRetWS);
  FretDistDFeInt.LerXml;

  FPMsg := FretDistDFeInt.xMotivo;
  Result := (FretDistDFeInt.CStat = 137) or (FretDistDFeInt.CStat = 138);
end;

function TDistribuicaoDFe.GerarMsgLog: String;
begin
  Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                           'Ambiente: %s ' + LineBreak +
                           'Vers�o Aplicativo: %s ' + LineBreak +
                           'Status C�digo: %s ' + LineBreak +
                           'Status Descri��o: %s ' + LineBreak +
                           'Resposta: %s ' + LineBreak +
                           '�ltimo NSU: %s ' + LineBreak +
                           'M�ximo NSU: %s ' + LineBreak),
                   [FretDistDFeInt.versao, TpAmbToStr(FretDistDFeInt.tpAmb),
                    FretDistDFeInt.verAplic, IntToStr(FretDistDFeInt.cStat),
                    FretDistDFeInt.xMotivo,
                    IfThen(FretDistDFeInt.dhResp = 0, '',
                           FormatDateTimeBr(RetDistDFeInt.dhResp)),
                    FretDistDFeInt.ultNSU, FretDistDFeInt.maxNSU]);
end;

function TDistribuicaoDFe.GerarMsgErro(E: Exception): String;
begin
  Result := ACBrStr('WebService Distribui��o de DFe:' + LineBreak +
                    '- Inativo ou Inoperante tente novamente.');
end;

function TDistribuicaoDFe.GerarPathDistribuicao(
  AItem: TdocZipCollectionItem): String;
var
  Data: TDateTime;
begin
  if FPConfiguracoesCTe.Arquivos.EmissaoPathCTe then
  begin
    Data := AItem.resCTe.dhEmi;
    if Data = 0 then
      Data := AItem.procEvento.dhEvento;
  end
  else
    Data := Now;

  case AItem.schema of
    schprocEventoCTe:
      Result := FPConfiguracoesCTe.Arquivos.GetPathEvento(AItem.procEvento.tpEvento,
                                                          AItem.procEvento.CNPJ,
                                                          Data);

    schprocCTe,
    schprocCTeOS:
      Result := FPConfiguracoesCTe.Arquivos.GetPathDownload(AItem.resCTe.xNome,
                                                        AItem.resCTe.CNPJCPF,
                                                        Data);
  end;
end;

{ TCTeEnvioWebService }

constructor TCTeEnvioWebService.Create(AOwner: TACBrDFe);
begin
  inherited Create(AOwner);

  FPStatus := stCTeEnvioWebService;
end;

destructor TCTeEnvioWebService.Destroy;
begin
  inherited Destroy;
end;

procedure TCTeEnvioWebService.Clear;
begin
  inherited Clear;

  FVersao := '';
end;

function TCTeEnvioWebService.Executar: Boolean;
begin
  Result := inherited Executar;
end;

procedure TCTeEnvioWebService.DefinirURL;
begin
  FPURL := FPURLEnvio;
end;

procedure TCTeEnvioWebService.DefinirServicoEAction;
begin
  FPServico := FPSoapAction;
end;

procedure TCTeEnvioWebService.DefinirDadosMsg;
var
  LeitorXML: TLeitor;
begin
  LeitorXML := TLeitor.Create;
  try
    LeitorXML.Arquivo := FXMLEnvio;
    LeitorXML.Grupo := FXMLEnvio;
    FVersao := LeitorXML.rAtributo('versao')
  finally
    LeitorXML.Free;
  end;

  FPDadosMsg := FXMLEnvio;
end;

function TCTeEnvioWebService.TratarResposta: Boolean;
begin
  FPRetWS := SeparaDados(FPRetornoWS, 'soap:Body');
  Result := True;
end;

function TCTeEnvioWebService.GerarMsgErro(E: Exception): String;
begin
  Result := ACBrStr('WebService: '+FPServico + LineBreak +
                    '- Inativo ou Inoperante tente novamente.');
end;

function TCTeEnvioWebService.GerarVersaoDadosSoap: String;
begin
  Result := '<versaoDados>' + FVersao + '</versaoDados>';
end;

{ TWebServices }

constructor TWebServices.Create(AOwner: TACBrDFe);
begin
  FACBrCTe := TACBrCTe(AOwner);

  FStatusServico := TCTeStatusServico.Create(FACBrCTe);
  FEnviar := TCTeRecepcao.Create(FACBrCTe, TACBrCTe(FACBrCTe).Conhecimentos);
  FRetorno := TCTeRetRecepcao.Create(FACBrCTe, TACBrCTe(FACBrCTe).Conhecimentos);
  FRecibo := TCTeRecibo.Create(FACBrCTe, TACBrCTe(FACBrCTe).Conhecimentos);
  FConsulta := TCTeConsulta.Create(FACBrCTe, TACBrCTe(FACBrCTe).Conhecimentos);
  FInutilizacao := TCTeInutilizacao.Create(FACBrCTe);
  FConsultaCadastro := TCTeConsultaCadastro.Create(FACBrCTe);
  FEnvEvento := TCTeEnvEvento.Create(FACBrCTe, TACBrCTe(FACBrCTe).EventoCTe);
  FDistribuicaoDFe := TDistribuicaoDFe.Create(FACBrCTe);
  FEnvioWebService := TCTeEnvioWebService.Create(FACBrCTe);
end;

destructor TWebServices.Destroy;
begin
  FStatusServico.Free;
  FEnviar.Free;
  FRetorno.Free;
  FRecibo.Free;
  FConsulta.Free;
  FInutilizacao.Free;
  FConsultaCadastro.Free;
  FEnvEvento.Free;
  FDistribuicaoDFe.Free;
  FEnvioWebService.Free;

  inherited Destroy;
end;

function TWebServices.Envia(ALote: Integer): Boolean;
begin
  Result := Envia(IntToStr(ALote));
end;

function TWebServices.Envia(ALote: String): Boolean;
begin
  FEnviar.Clear;
  FRetorno.Clear;

  FEnviar.Lote := ALote;

  if not Enviar.Executar then
    Enviar.GerarException( Enviar.Msg );

  FRetorno.Recibo := FEnviar.Recibo;

  if not FRetorno.Executar then
    FRetorno.GerarException( FRetorno.Msg );

  Result := True;
end;

function TWebServices.EnviaOS(ALote: Integer): Boolean;
begin
  Result := EnviaOS(IntToStr(ALote));
end;

function TWebServices.EnviaOS(ALote: String): Boolean;
begin
  FEnviar.Clear;
  FRetorno.Clear;

  FEnviar.Lote := ALote;

  if not Enviar.Executar then
    Enviar.GerarException( Enviar.Msg );

  Result := True;
end;

procedure TWebServices.Inutiliza(CNPJ, AJustificativa: String;
  Ano, Modelo, Serie, NumeroInicial, NumeroFinal: Integer);
begin
  CNPJ := OnlyNumber(CNPJ);

  if not ValidarCNPJ(CNPJ) then
    raise EACBrCTeException.Create('CNPJ: ' + CNPJ + ', inv�lido.');

  FInutilizacao.CNPJ := CNPJ;
  FInutilizacao.Modelo := Modelo;
  FInutilizacao.Serie := Serie;
  FInutilizacao.Ano := Ano;
  FInutilizacao.NumeroInicial := NumeroInicial;
  FInutilizacao.NumeroFinal := NumeroFinal;
  FInutilizacao.Justificativa := AJustificativa;

  if not FInutilizacao.Executar then
    FInutilizacao.GerarException( FInutilizacao.Msg );
end;

end.
