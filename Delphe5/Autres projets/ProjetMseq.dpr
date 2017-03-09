program ProjetMseq;

uses
  Forms,
  classmseq in 'objmseq\classmseq.pas',
  Unit1 in 'objmseq\Unit1.pas' {Form1},
  Unit2 in 'objmseq\Unit2.pas' {Dialogue};



begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDialogue, Dialogue);
  Application.Run;
end.
