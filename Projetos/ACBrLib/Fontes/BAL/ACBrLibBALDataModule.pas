﻿{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }

{ Direitos Autorais Reservados (c) 2018 Daniel Simoes de Almeida               }

{ Colaboradores nesse arquivo: Italo Jurisato Junior                           }

{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }

{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }

{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }

{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/gpl-license.php                           }

{ Daniel Simões de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{        Rua Cel.Aureliano de Camargo, 973 - Tatuí - SP - 18270-170            }

{******************************************************************************}

unit ACBrLibBALDataModule;

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, ACBrLibConfig, syncobjs, ACBrBAL;

type

  { TLibBALDM }

  TLibBALDM = class(TDataModule)
    ACBrBAL1: TACBrBAL;

    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FLock: TCriticalSection;

  public
    procedure AplicarConfiguracoes;
    procedure GravarLog(AMsg: String; NivelLog: TNivelLog; Traduzir: Boolean = False);
    procedure Travar;
    procedure Destravar;
  end;

implementation

uses
  ACBrUtil,
  ACBrLibBALConfig, ACBrLibComum, ACBrLibBALClass;

{$R *.lfm}

{ TLibBALDM }

procedure TLibBALDM.DataModuleCreate(Sender: TObject);
begin
  FLock := TCriticalSection.Create;
end;

procedure TLibBALDM.DataModuleDestroy(Sender: TObject);
begin
  FLock.Destroy;
end;

procedure TLibBALDM.AplicarConfiguracoes;
var
  pLibConfig: TLibBALConfig;
begin
  pLibConfig := TLibBALConfig(TACBrLibBAL(pLib).Config);

  with ACBrBAL1 do
  begin
    ArqLog    := pLibConfig.BALConfig.ArqLog;
    Porta     := pLibConfig.BALConfig.Porta;
    Modelo    := pLibConfig.BALConfig.Modelo;
    Intervalo := pLibConfig.BALConfig.Intervalo;
    PosIni    := pLibConfig.BALConfig.PosIni;
    PosFim    := pLibConfig.BALConfig.PosFim;

    MonitorarBalanca := pLibConfig.BALConfig.MonitorarBalanca;
    pLibConfig.DeviceConfig.Apply(Device);
  end;
end;

procedure TLibBALDM.GravarLog(AMsg: String; NivelLog: TNivelLog;
  Traduzir: Boolean);
begin
  if Assigned(pLib) then
    pLib.GravarLog(AMsg, NivelLog, Traduzir);
end;

procedure TLibBALDM.Travar;
begin
  GravarLog('Travar', logParanoico);
  FLock.Acquire;
end;

procedure TLibBALDM.Destravar;
begin
  GravarLog('Destravar', logParanoico);
  FLock.Release;
end;

end.

