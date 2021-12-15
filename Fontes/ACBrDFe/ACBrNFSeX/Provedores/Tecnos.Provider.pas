{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
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

{$I ACBr.inc}

unit Tecnos.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml, ACBrNFSeXProviderABRASFv2,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeXWebserviceTecnos201 = class(TACBrNFSeXWebserviceSoap11)
  public
    function Recepcionar(ACabecalho, AMSG: String): string; override;
    function RecepcionarSincrono(ACabecalho, AMSG: String): string; override;
//    function GerarNFSe(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorFaixa(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSeServicoPrestado(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSeServicoTomado(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;

  end;

  TACBrNFSeProviderTecnos201 = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    function DefinirIDLote(const ID: string): string; override;

    procedure AssinarConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse); override;
    procedure AssinarConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse); override;

    procedure ProcessarMensagemErros(const RootNode: TACBrXmlNode;
                                     const Response: TNFSeWebserviceResponse;
                                     AListTag: string = 'ListaMensagemRetorno';
                                     AMessageTag: string = 'MensagemRetorno'); override;
  end;

implementation

uses
  DateUtils,
  ACBrUtil, ACBrDFeException, ACBrNFSeX, ACBrNFSeXConfiguracoes,
  ACBrNFSeXNotasFiscais, Tecnos.GravarXml, Tecnos.LerXml;

{ TACBrNFSeProviderTecnos201 }

procedure TACBrNFSeProviderTecnos201.AssinarConsultaLoteRps(
  Response: TNFSeConsultaLoteRpsResponse);
var
  xXml: string;
  i: Integer;
  Emitente: TEmitenteConfNFSe;
begin
  xXml := Response.XmlEnvio;
  i := Pos('<InscricaoMunicipal>', xXml) -1;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  xXml := Copy(xXml, 1, i) +
          '<RazaoSocial>' + Emitente.RazSocial + '</RazaoSocial>' +
          Copy(xXml, i +1, length(xXml));

  Response.XmlEnvio := xXml;

  inherited AssinarConsultaLoteRps(Response);
end;

procedure TACBrNFSeProviderTecnos201.AssinarConsultaNFSeporRps(
  Response: TNFSeConsultaNFSeporRpsResponse);
var
  xXml: string;
  i: Integer;
  Emitente: TEmitenteConfNFSe;
begin
  xXml := Response.XmlEnvio;
  i := Pos('<InscricaoMunicipal>', xXml) -1;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  xXml := Copy(xXml, 1, i) +
          '<RazaoSocial>' + Emitente.RazSocial + '</RazaoSocial>' +
          Copy(xXml, i +1, length(xXml));

  Response.XmlEnvio := xXml;

  inherited AssinarConsultaNFSeporRps(Response);
end;

procedure TACBrNFSeProviderTecnos201.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    CancPreencherMotivo := True;
    ConsultaPorFaixaPreencherNumNfseFinal := True;
  end;

  with ConfigAssinar do
  begin
    Rps := True;
    RpsGerarNFSe := True;
    CancelarNFSe := True;
  end;

  with ConfigWebServices do
  begin
    VersaoDados := '20.01';
    VersaoAtrib := '20.01';
  end;

  with ConfigMsgDados do
  begin
    with XmlRps do
    begin
      InfElemento := 'InfDeclaracaoPrestacaoServico';
      DocElemento := 'tcDeclaracaoPrestacaoServico';
    end;

    with LoteRps do
    begin
      InfElemento := 'InfDeclaracaoPrestacaoServico';
      DocElemento := 'tcDeclaracaoPrestacaoServico';
    end;

    DadosCabecalho := GetCabecalho('http://www.nfse-tecnos.com.br');
  end;

  with ConfigSchemas do
  begin
    ConsultarLote := 'ConsultarLoteRpsEnvio.xsd';
    ConsultarNFSeRps := 'ConsultarNfseRpsEnvio.xsd';
    ConsultarNFSePorFaixa := 'ConsultarNfseFaixaEnvio.xsd';
    ConsultarNFSeServicoPrestado := 'ConsultarNfseServicoPrestadoEnvio.xsd';
    CancelarNFSe := 'CancelarNfseEnvio.xsd';
    GerarNFSe := 'GeracaoNFSe.xsd';
    RecepcionarSincrono := 'EnviarLoteRpsSincronoEnvio.xsd';
    SubstituirNFSe := 'SubstituicaoNFSe.xsd';
  end;
end;

function TACBrNFSeProviderTecnos201.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Tecnos201.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderTecnos201.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Tecnos201.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderTecnos201.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceTecnos201.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

function TACBrNFSeProviderTecnos201.DefinirIDLote(const ID: string): string;
var
  Cnpj: string;
begin
  Cnpj := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente.CNPJ;

  Result := ' ' + ConfigGeral.Identificador + '="1' + // Tipo de opera��o, no caso envio
            IntToStr(YearOf(Date)) + // ano do lote enviado no formato AAAA
            OnlyNumber(Cnpj) +
            Poem_Zeros(OnlyNumber(ID), 16) + '"';
end;

procedure TACBrNFSeProviderTecnos201.ProcessarMensagemErros(
  const RootNode: TACBrXmlNode; const Response: TNFSeWebserviceResponse;
  AListTag, AMessageTag: string);
var
  I: Integer;
  ANode: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  AErro: TNFSeEventoCollectionItem;
  AAlerta: TNFSeEventoCollectionItem;
  Codigo, Mensagem: string;
begin
  ANode := RootNode.Childrens.FindAnyNs(AListTag);

  if (ANode = nil) then
    ANode := RootNode.Childrens.FindAnyNs('ListaMensagemRetornoLote');

  if (ANode = nil) then
    ANode := RootNode.Childrens.FindAnyNs('MensagemRetorno');

  if Assigned(ANode) then
  begin
    ANodeArray := ANode.Childrens.FindAllAnyNs(AMessageTag);

    if Assigned(ANodeArray) then
    begin
      for I := Low(ANodeArray) to High(ANodeArray) do
      begin
        Codigo := ProcessarConteudoXml(ANodeArray[I].Childrens.FindAnyNs('Codigo'), tcStr);
        Mensagem := ProcessarConteudoXml(ANodeArray[I].Childrens.FindAnyNs('Mensagem'), tcStr);

        if (Codigo <> 'A0000') and (Mensagem <> '') then
        begin
          AErro := Response.Erros.New;
          AErro.Codigo := Codigo;
          AErro.Descricao := Mensagem;
          AErro.Correcao := ProcessarConteudoXml(ANodeArray[I].Childrens.FindAnyNs('Correcao'), tcStr);
        end;
      end;
    end
    else
    begin
      Codigo := ProcessarConteudoXml(ANodeArray[I].Childrens.FindAnyNs('Codigo'), tcStr);
      Mensagem := ProcessarConteudoXml(ANode.Childrens.FindAnyNs('Mensagem'), tcStr);

      if (Codigo <> 'A0000') and (Mensagem <> '') then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Codigo;
        AErro.Descricao := Mensagem;
        AErro.Correcao := ProcessarConteudoXml(ANode.Childrens.FindAnyNs('Correcao'), tcStr);
      end;
    end;
  end;

  ANode := RootNode.Childrens.FindAnyNs('ListaMensagemAlertaRetorno');

  if Assigned(ANode) then
  begin
    ANodeArray := ANode.Childrens.FindAllAnyNs(AMessageTag);

    if Assigned(ANodeArray) then
    begin
      for I := Low(ANodeArray) to High(ANodeArray) do
      begin
        Mensagem := ProcessarConteudoXml(ANodeArray[I].Childrens.FindAnyNs('Mensagem'), tcStr);

        if Mensagem <> '' then
        begin
          AAlerta := Response.Erros.New;
          AAlerta.Codigo := ProcessarConteudoXml(ANodeArray[I].Childrens.FindAnyNs('Codigo'), tcStr);
          AAlerta.Descricao := Mensagem;
          AAlerta.Correcao := ProcessarConteudoXml(ANodeArray[I].Childrens.FindAnyNs('Correcao'), tcStr);
        end;
      end;
    end
    else
    begin
      Mensagem := ProcessarConteudoXml(ANode.Childrens.FindAnyNs('Mensagem'), tcStr);

      if Mensagem <> '' then
      begin
        AAlerta := Response.Erros.New;
        AAlerta.Codigo := ProcessarConteudoXml(ANode.Childrens.FindAnyNs('Codigo'), tcStr);
        AAlerta.Descricao := Mensagem;
        AAlerta.Correcao := ProcessarConteudoXml(ANode.Childrens.FindAnyNs('Correcao'), tcStr);
      end;
    end;
  end;
end;

{ TACBrNFSeXWebserviceTecnos201 }

function TACBrNFSeXWebserviceTecnos201.Recepcionar(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<mRecepcaoLoteRPS xmlns="http://tempuri.org/">';
  Request := Request + '<remessa>' + XmlToStr(AMSG) + '</remessa>';
  Request := Request + '</mRecepcaoLoteRPS>';

  Result := Executar('http://tempuri.org/mRecepcaoLoteRPS', Request,
                     ['mRecepcaoLoteRPSResult', 'RecepcaoLoteRPSResposta'],
                     []);
end;

function TACBrNFSeXWebserviceTecnos201.RecepcionarSincrono(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<mEnvioLoteRPSSincrono xmlns="http://tempuri.org/">';
  Request := Request + '<remessa>' + XmlToStr(AMSG) + '</remessa>';
  Request := Request + '</mEnvioLoteRPSSincrono>';

  Result := Executar('http://tempuri.org/mEnvioLoteRPSSincrono', Request,
                     ['mEnvioLoteRPSSincronoResult', 'EnviarLoteRpsSincronoResposta'],
                     []);
end;

{
function TACBrNFSeXWebserviceTecnos201.GerarNFSe(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<mGerarNfse xmlns="http://tempuri.org/">';
  Request := Request + '<remessa>' + XmlToStr(AMSG) + '</remessa>';
  Request := Request + '</mGerarNfse>';

  Result := Executar('http://tempuri.org/mGerarNfse', Request,
                     ['mGerarNfseResult', 'GerarNfseResposta'],
                     []);
end;
}
function TACBrNFSeXWebserviceTecnos201.ConsultarLote(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<mConsultaLoteRPS xmlns="http://tempuri.org/">';
  Request := Request + '<remessa>' + XmlToStr(AMSG) + '</remessa>';
  Request := Request + '</mConsultaLoteRPS>';

  Result := Executar('http://tempuri.org/mConsultaLoteRPS', Request,
                     ['mConsultaLoteRPSResult', 'ConsultarLoteRpsResposta'],
                     []);
end;

function TACBrNFSeXWebserviceTecnos201.ConsultarNFSePorFaixa(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<mConsultaNFSePorFaixa xmlns="http://tempuri.org/">';
  Request := Request + '<remessa>' + XmlToStr(AMSG) + '</remessa>';
  Request := Request + '</mConsultaNFSePorFaixa>';

  Result := Executar('http://tempuri.org/mConsultaNFSePorFaixa', Request,
                     ['mConsultaNFSePorFaixaResult', 'ConsultarNfseFaixaResposta'],
                     []);
end;

function TACBrNFSeXWebserviceTecnos201.ConsultarNFSePorRps(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<mConsultaNFSePorRPS xmlns="http://tempuri.org/">';
  Request := Request + '<remessa>' + XmlToStr(AMSG) + '</remessa>';
  Request := Request + '</mConsultaNFSePorRPS>';

  Result := Executar('http://tempuri.org/mConsultaNFSePorRPS', Request,
                     ['mConsultaNFSePorRPSResult', 'ConsultarNfseRpsResposta'],
                     []);
end;

function TACBrNFSeXWebserviceTecnos201.ConsultarNFSeServicoPrestado(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<mConsultaNFSeServicosPrestados xmlns="http://tempuri.org/">';
  Request := Request + '<remessa>' + XmlToStr(AMSG) + '</remessa>';
  Request := Request + '</mConsultaNFSeServicosPrestados>';

  Result := Executar('http://tempuri.org/mConsultaNFSeServicosPrestados', Request,
                     ['mConsultaNFSeServicoPrestadosResult', 'ConsultarNfseServicoPrestadosResposta'],
                     []);
end;

function TACBrNFSeXWebserviceTecnos201.ConsultarNFSeServicoTomado(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<mConsultaNFSeServicosTomadosIntermediados xmlns="http://tempuri.org/">';
  Request := Request + '<remessa>' + XmlToStr(AMSG) + '</remessa>';
  Request := Request + '</mConsultaNFSeServicosTomadosIntermediados>';

  Result := Executar('http://tempuri.org/mConsultaNFSeServicosTomadosIntermediados', Request,
                     ['mConsultaNFSeServicosTomadosIntermediadosResult', 'ConsultaNFSeServicosTomadosIntermediadosResposta'],
                     []);
end;

function TACBrNFSeXWebserviceTecnos201.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<mCancelamentoNFSe xmlns="http://tempuri.org/">';
  Request := Request + '<remessa>' + XmlToStr(AMSG) + '</remessa>';
  Request := Request + '</mCancelamentoNFSe>';

  Result := Executar('http://tempuri.org/mCancelamentoNFSe', Request,
                     ['mCancelamentoNFSeResult', 'CancelarNfseResposta'],
                     []);
end;

end.
