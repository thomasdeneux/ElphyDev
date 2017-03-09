unit Defform;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs,
  editCont,
  debug0;

{ Les objets visuels ont un dialogue qui s'affiche dans l'écran de controle. Ces
dialogues doivent descendre de TgenForm.

Quand on attrappe les objets avec la souris, le dialogue est mis à jour avec
updatePosition, updateSize, updateTheta.
}

type
  TGenForm =class(Tform)
            public
              majPos:procedure of object;
              procedure updatePosition; virtual;
              procedure updateSize;     virtual;
              procedure updateTheta;    virtual;
              procedure VKreturn;       virtual;
            end;


type
  TclassGenForm=class of TgenForm;


implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TgenForm.updatePosition;
begin
end;

procedure TgenForm.updateSize;
begin
end;

procedure TgenForm.updateTheta;
begin
end;

procedure TgenForm.VKreturn;
begin
  updateAllVar(self);
  if assigned(majpos) then majpos;
end;



Initialization
AffDebug('Initialization defForm',0);
{$IFDEF FPC}
{$I Defform.lrs}
{$ENDIF}
end.
