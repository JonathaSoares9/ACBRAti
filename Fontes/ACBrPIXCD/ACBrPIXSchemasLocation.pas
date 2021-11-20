{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2021 Daniel Simoes de Almeida               }
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

unit ACBrPIXSchemasLocation;

interface

uses
  Classes, SysUtils,
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   JsonDataObjects_ACBr,
  {$Else}
   Jsons,
  {$EndIf}
  ACBrPIXBase;

type

  { TACBrPIXLocationBase }

  TACBrPIXLocationBase = class(TACBrPIXSchema)
  private
    fcriacao: TDateTime;
    fid: String;
    flocation: String;
    ftipoCob: TACBrPIXTipoCobranca;
    ftxId: String;
  protected
    property id: String read fid write fid;
    property txId: String read ftxId write ftxId;
    property location: String read flocation;
    property tipoCob: TACBrPIXTipoCobranca read ftipoCob write ftipoCob;
    property criacao: TDateTime read fcriacao;

  public
    constructor Create;
    procedure Clear; override;
    procedure Assign(Source: TACBrPIXLocationBase);

    procedure WriteToJSon(AJSon: TJsonObject); override;
    procedure ReadFromJSon(AJSon: TJsonObject); override;
  end;

  { TACBrPIXLocationCompleta }

  TACBrPIXLocationCompleta = class(TACBrPIXLocationBase)
  public
    property id;
    property txId;
    property location;
    property tipoCob;
    property criacao;
  end;

  { TACBrPIXLocationCobSolicitada }

  TACBrPIXLocationCobSolicitada = class(TACBrPIXLocationBase)
  public
    property location;
  end;

implementation

uses
  ACBrUtil;

{ TACBrPIXLocationBase }

constructor TACBrPIXLocationBase.Create;
begin
  inherited;
  Clear;
end;

procedure TACBrPIXLocationBase.Clear;
begin
  fcriacao := 0;
  fid := '';
  flocation := '';
  ftipoCob := tcoNenhuma;
  ftxId := '';
end;

procedure TACBrPIXLocationBase.Assign(Source: TACBrPIXLocationBase);
begin
  fcriacao := Source.criacao;
  fid := Source.id;
  flocation := Source.location;
  ftipoCob := Source.tipoCob;
  ftxId := Source.txId;
end;

procedure TACBrPIXLocationBase.WriteToJSon(AJSon: TJsonObject);
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   AJSon := AJSon.O['loc'];
   if (fid <> '') then
     AJSon.S['id'] := fid;
   if (ftxId <> '') then
     AJSon.S['txId'] := ftxId;
   if (flocation <> '') then
     AJSon.S['location'] := flocation;
   if (ftipoCob <> tcoNenhuma) then
     AJSon.S['tipoCob'] := PIXTipoCobrancaToString(ftipoCob);
   if (fcriacao <> 0) then
     AJSon.S['criacao'] := DateTimeToIso8601(fcriacao);
  {$Else}
   AJSon := AJSon['loc'].AsObject;
   if (fid <> '') then
     AJSon['id'].AsString := fid;
   if (ftxId <> '') then
     AJSon['txId'].AsString := ftxId;
   if (flocation <> '') then
     AJSon['location'].AsString := flocation;
   if (ftipoCob <> tcoNenhuma) then
     AJSon['tipoCob'].AsString := PIXTipoCobrancaToString(ftipoCob);
   if (fcriacao <> 0) then
     AJSon['criacao'].AsString := DateTimeToIso8601(fcriacao);
  {$EndIf}
end;

procedure TACBrPIXLocationBase.ReadFromJSon(AJSon: TJsonObject);
var
  s: String;
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   fid := AJSon.S['id'];
   ftxId := AJSon.S['txId'];
   flocation := AJSon.S['location'];
   ftipoCob := StringToPIXTipoCobranca(AJSon.S['tipoCob']);
   s := AJSon.S['criacao'];
   if (s <> '') then
     fcriacao := Iso8601ToDateTime(s);
  {$Else}
   fid := AJSon['id'].AsString;
   ftxId := AJSon['txId'].AsString;
   flocation := AJSon['location'].AsString;
   ftipoCob := StringToPIXTipoCobranca(AJSon['tipoCob'].AsString);
   s := AJSon['criacao'].AsString;
   if (s <> '') then
     fcriacao := Iso8601ToDateTime(s);
  {$EndIf}
end;

end.

