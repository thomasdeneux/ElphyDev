unit ExeOpt1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  stmDef, StdCtrls, editcont ;

type
  TExecuteOptions = class(TForm)
    GroupBox1: TGroupBox;
    CBtrack1: TCheckBox;
    Bcancel: TButton;
    bOK: TButton;
    CBrecVideo: TCheckBox;
    ESgene: TeditString;
    Label1: TLabel;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure execution;
  end;

var
  ExecuteOptions: TExecuteOptions;

implementation

{$R *.DFM}
procedure TExecuteOptions.execution;
begin
  CBtrack1.checked:=ReplayTrack1;
  CBrecVideo.checked:=FrecVideo;
  ESgene.setString(VideoStGene,70);

  if showModal=mrOK then
    begin
      updateAllVar(self);
      ReplayTrack1:=CBtrack1.checked;
      FrecVideo:=CBrecVideo.checked;
      cntVideo:=0;
    end;
end;

end.
