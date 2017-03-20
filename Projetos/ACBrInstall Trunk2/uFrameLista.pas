﻿{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2009   Isaque Pinheiro                      }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Simões de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Praça Anita Costa, 34 - Tatuí - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 29/03/2012: Isaque Pinheiro / Régys Borges da Silveira
|*  - Criação e distribuição da Primeira Versao
*******************************************************************************}
unit uFrameLista;

interface

uses
  Generics.Collections, Generics.Defaults,

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls, ComCtrls;

type
  TPacotes = TList<TCheckBox>;

  TframePacotes = class(TFrame)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ACBr_synapse_dpk: TCheckBox;
    ACBr_Comum_dpk: TCheckBox;
    ACBr_Diversos_dpk: TCheckBox;
    ACBr_Serial_dpk: TCheckBox;
    ACBr_TCP_dpk: TCheckBox;
    ACBr_TEFD_dpk: TCheckBox;
    ACBr_Boleto_dpk: TCheckBox;
    ACBr_Sintegra_dpk: TCheckBox;
    ACBr_SPED_dpk: TCheckBox;
    ACBr_PAF_dpk: TCheckBox;
    ACBr_OpenSSL_dpk: TCheckBox;
    ACBr_PCNComum_dpk: TCheckBox;
    ACBr_NFe_dpk: TCheckBox;
    ACBr_CTe_dpk: TCheckBox;
    Label8: TLabel;
    ACBr_NFSe_dpk: TCheckBox;
    ACBr_MDFe_dpk: TCheckBox;
    ACBr_LFD_dpk: TCheckBox;
    Label9: TLabel;
    ACBr_GNRE_dpk: TCheckBox;
    ACBr_Convenio115_dpk: TCheckBox;
    ACBr_SEF2_dpk: TCheckBox;
    ACBr_SAT_dpk: TCheckBox;
    ACBr_NFeDanfeESCPOS_dpk: TCheckBox;
    ACBr_SATExtratoESCPOS_dpk: TCheckBox;
    ACBr_SPEDImportar_dpk: TCheckBox;
    ACBr_DFeComum_dpk: TCheckBox;
    ACBr_NFCeECFVirtual_dpk: TCheckBox;
    ACBr_SATECFVirtual_dpk: TCheckBox;
    ACBr_TXTComum_dpk: TCheckBox;
    btnPacotesDesmarcarTodos: TSpeedButton;
    btnPacotesMarcarTodos: TSpeedButton;
    ACBr_NFeDanfeFR_dpk: TCheckBox;
    Label5: TLabel;
    ACBr_CTeDacteFR_dpk: TCheckBox;
    Label6: TLabel;
    ACBr_NFSeDanfseFR_dpk: TCheckBox;
    Label7: TLabel;
    ACBr_BoletoFR_dpk: TCheckBox;
    ACBr_MDFeDamdfeFR_dpk: TCheckBox;
    ACBr_GNREGuiaFR_dpk: TCheckBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    ACBr_NFeDanfeRL_dpk: TCheckBox;
    ACBr_CTeDacteRL_dpk: TCheckBox;
    ACBr_NFSeDanfseRL_dpk: TCheckBox;
    ACBr_BoletoRL_dpk: TCheckBox;
    ACBr_MDFeDamdfeRL_dpk: TCheckBox;
    ACBr_SATExtratoRL_dpk: TCheckBox;
    ACBr_GNREGuiaRL_dpk: TCheckBox;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    ACBr_BlocoX_dpk: TCheckBox;
    ACBr_DeSTDA_dpk: TCheckBox;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    ACBr_Ponto_dpk: TCheckBox;
    Label25: TLabel;
    ACBr_MTER_dpk: TCheckBox;
    Label26: TLabel;
    procedure btnPacotesMarcarTodosClick(Sender: TObject);
    procedure btnPacotesDesmarcarTodosClick(Sender: TObject);
    procedure VerificarCheckboxes(Sender: TObject);
  private
    FPacotes: TPacotes;
    FUtilizarBotoesMarcar: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Pacotes: TPacotes read FPacotes write FPacotes;
  end;

implementation

uses
  StrUtils;

{$R *.dfm}

constructor TframePacotes.Create(AOwner: TComponent);
var
  I: Integer;
begin
  inherited;

  // variavel para controle do verificar checkboxes
  // utilizada para evitar estouro de pilha por conta da redundância
  // e também para que pacotes dependentes não atrapalhem a rotina
  FUtilizarBotoesMarcar := False;

  // lista de pacotes (checkboxes) disponiveis
  FPacotes := TPacotes.Create;

  // popular a lista de pacotes com os pacotes disponíveis
  // colocar todos os checkboxes disponíveis na lista
  FPacotes.Clear;
  for I := 0 to Self.ComponentCount - 1 do
  begin
    if Self.Components[I] is TCheckBox then
       FPacotes.Add(TCheckBox(Self.Components[I]));
  end;
  FPacotes.Sort(TComparer<TCheckBox>.Construct(
      function(const Dpk1, Dpk2: TCheckBox): Integer
      begin
         Result := CompareStr( FormatFloat('0000', Dpk1.TabOrder), FormatFloat('0000', Dpk2.TabOrder) );
      end));
end;

destructor TframePacotes.Destroy;
begin
  FreeAndNil(FPacotes);

  inherited;
end;

// botão para marcar todos os checkboxes
procedure TframePacotes.btnPacotesMarcarTodosClick(Sender: TObject);
var
  I: Integer;
begin
  FUtilizarBotoesMarcar := True;
  try
    for I := 0 to Self.ComponentCount -1 do
    begin
      if Self.Components[I] is TCheckBox then
      begin
        if TCheckBox(Self.Components[I]).Enabled then
          TCheckBox(Self.Components[I]).Checked := True;
      end;
    end;
  finally
    FUtilizarBotoesMarcar := False;
    VerificarCheckboxes(Sender);
  end;
end;

// botão para desmarcar todos os checkboxes
procedure TframePacotes.btnPacotesDesmarcarTodosClick(Sender: TObject);
var
  I: Integer;
begin
  FUtilizarBotoesMarcar := True;
  try
    for I := 0 to Self.ComponentCount -1 do
    begin
      if Self.Components[I] is TCheckBox then
      begin
        if TCheckBox(Self.Components[I]).Enabled then
          TCheckBox(Self.Components[I]).Checked := False;
      end;
    end;
  finally
    FUtilizarBotoesMarcar := False;
    VerificarCheckboxes(Sender);
  end;
end;

// rotina de verificação de dependência e marcação dos pacotes base
procedure TframePacotes.VerificarCheckboxes(Sender: TObject);
begin
  // pacotes base não podem ser desmarcados
  // instalação mínima do ACBr
  ACBr_synapse_dpk.Checked := True;
  ACBr_Comum_dpk.Checked := True;
  ACBr_Diversos_dpk.Checked := True;

  if not FUtilizarBotoesMarcar then
  begin
    FUtilizarBotoesMarcar := True;

    /// caso algum evento abaixo dispare novamente
    try
      // quando não for selecionado o NFe devemos desmarcar
      if not ACBr_NFe_dpk.Checked then
      begin
        ACBr_NFeDanfeFR_dpk.Checked := False;
        ACBr_NFeDanfeRL_dpk.Checked := False;
      end;

      // quando não for selecionado o CTe devemos desmarcar
      if not ACBr_CTe_dpk.Checked then
      begin
        ACBr_CTeDacteFR_dpk.Checked := False;
        ACBr_CTeDacteRL_dpk.Checked := False;
      end;

      // quando não for selecionado o NFSe devemos desmarcar
      if not ACBr_NFSe_dpk.Checked then
      begin
        ACBr_NFSeDanfseFR_dpk.Checked := False;
        ACBr_NFSeDanfseRL_dpk.Checked := False;
      end;

      // quando não for selecionado o Boleto devemos desmarcar
      if not ACBr_Boleto_dpk.Checked then
      begin
        ACBr_BoletoFR_dpk.Checked := False;
        ACBr_BoletoRL_dpk.Checked := False;
      end;

      // quando não for selecionado o MDF-e devemos desmarcar
      if not ACBr_MDFe_dpk.Checked then
      begin
        ACBr_MDFeDamdfeFR_dpk.Checked := False;
        ACBr_MDFeDamdfeRL_dpk.Checked := False;
      end;

      // quando não for selecionado o SAT devemos desmarcar
      if not ACBr_SAT_dpk.Checked then
      begin
        ACBr_SATExtratoRL_dpk.Checked := False;
      end;

      // quando não for selecionado o GNRE devemos desmarcar
      if not ACBr_GNRE_dpk.Checked then
      begin
        ACBr_GNREGuiaFR_dpk.Checked := False;
        ACBr_GNREGuiaRL_dpk.Checked := False;
      end;

      // dependencia do NFe
      if ACBr_NFeDanfeESCPOS_dpk.Checked and
        (not(ACBr_NFe_dpk.Checked) or not(ACBr_Serial_dpk.Checked)) then
      begin
        ACBr_Serial_dpk.Checked := True;
        ACBr_NFe_dpk.Checked := True;
      end;

      // dependencia do SAT
      if ACBr_SATExtratoESCPOS_dpk.Checked and
        (not(ACBr_SAT_dpk.Checked) or not(ACBr_Serial_dpk.Checked)) then
      begin
        ACBr_Serial_dpk.Checked := True;
        ACBr_SAT_dpk.Checked := True;
      end;

      if (ACBr_SATExtratoRL_dpk.Checked) and not(ACBr_SAT_dpk.Checked) then
        ACBr_SAT_dpk.Checked := True;

      if ACBr_SAT_dpk.Checked and not(ACBr_PCNComum_dpk.Checked) then
        ACBr_PCNComum_dpk.Checked := True;

      // dependencias da NFe e CTe
      if (ACBr_NFe_dpk.Checked) or (ACBr_CTe_dpk.Checked) or
        (ACBr_NFSe_dpk.Checked) or (ACBr_MDFe_dpk.Checked) then
      begin
        ACBr_PCNComum_dpk.Checked := True;
        ACBr_OpenSSL_dpk.Checked := True;
      end;

      // dependencias do ACBrTEFD
      if not(ACBr_TCP_dpk.Checked) and (ACBr_TEFD_dpk.Checked or ACBr_MTER_dpk.Checked ) then
        ACBr_TCP_dpk.Checked := True;

      // Dependencias do ACBrPaf
      if not(ACBr_SPED_dpk.Checked) and ACBr_PAF_dpk.Checked then
        ACBr_SPED_dpk.Checked := True;

    finally
      FUtilizarBotoesMarcar := False;
    end;
  end;
end;

end.

{
  Hierarquia de dependência dos Packages
  • ACBrComum → Synapse
• ACBrDiversos → ACBrComum
• PCNComum → ACBrDiversos
• ACBrOpenSSL → ACBrComum
• ACBrSerial → ACBrDiversos, ACBrOpenSSL
• ACBrTXTComum → ACBrDiversos,
• ACBrConvenio115 → ACBrTXTComum, ACBrOpenSSL
• ACBrLFD → ACBrTXTComum
• ACBrPAF → ACBrTXTComum, ACBrOpenSSL
• ACBrSEF2 → ACBrTXTComum, PCNComum
• ACBrSintegra → ACBrTXTComum
• ACBrSPED → ACBrTXTComum
• ACBrTCP → ACBrDiversos
• ACBrTEFD → ACBrComum
• ACBr_Boleto → ACBrTCP
• ACBr_BoletoFC_Fortes → ACBr_Boleto, fortes324laz
• ACBr_BoletoFC_LazReport → ACBr_Boleto, lazreportpdfexport
• ACBrDFeComum → ACBrOpenSSL, ACBrTCP, PCNComum
• ACBrNFe → ACBrDFeComum
• ACBrCTe → ACBrDFeComum
• ACBrGNRe → ACBrDFeComum
• ACBrMDFe → ACBrDFeComum
• ACBrNFSe → ACBrDFeComum
• ACBr_SAT → PCNComum
• ACBr_SAT_ECFVirtual → ACBr_SAT, ACBrSerial
• ACBr_SAT_Extrato_ESCPOS → ACBr_SAT, ACBrDFeComum, ACBrSerial
• ACBr_SAT_Extrato_Fortes → ACBr_SAT, ACBrDFeComum, fortes324laz
}
