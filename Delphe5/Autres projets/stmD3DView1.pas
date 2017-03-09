Retiré de Elphy le 24 juin 2010

unit stmD3DView1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,MMsystem, StdCtrls, Menus,
  DirectXGraphics, D3DX81mo, ExtCtrls, editcont,
  util1,Dgraphic,dibG,listG,varConf1,
  stmDef,stmObj,stmData0, stmD3Dobj,  Chooseob2,stmPG;


type
  TObject3Drecord=
    record
      ob:Tobject3D;
      x,y,z:single;
      TX,TY,TZ:single;
    end;
  PObject3Drecord=^TObject3Drecord;
  TarrayOfObject3Drecord=array[0..1] of TObject3Drecord;
  ParrayOfObject3Drecord=^TarrayOfObject3Drecord;

  TObject3DList= class(TlistG)
    constructor create;
    function getrec(n:integer):TObject3Drecord;
    property rec[n:integer]: TObject3Drecord read getRec; default;
  end;


type
  TViewer3D=class;

  TD3DViewForm = class(TForm)
    Panel1: TPanel;
    SimplePanel1: TSimplePanel;
    PaintBox1: TPaintBox;
    sbD: TscrollbarV;
    sbPhi: TscrollbarV;
    sbAlpha: TscrollbarV;
    LabelD: TLabel;
    LabelPhi: TLabel;
    LabelAlpha: TLabel;
    MainMenu1: TMainMenu;
    Addobject1: TMenuItem;
    procedure PaintBox1Paint(Sender: TObject);
    procedure sbDScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure sbPhiScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure sbAlphaScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure Addobject1Click(Sender: TObject);
  private
    { Déclarations privées }

    owner0:Tviewer3D;

    procedure setCaptions;

  public
    { Déclarations publiques }
    procedure init(owner1:Tviewer3D);
  end;




  TViewer3D=class(Tdata0)
              ListRef:ParrayOfObject3Drecord; {pour la sauvegarde}
              ListRefSize:integer;

              D3dDevice:IDIRECT3DDEVICE8;  { Le device }
              d3DDM:TD3DDISPLAYMODE;       { Current Display Mode }
              d3dpp:TD3DPRESENT_PARAMETERS;
              light:TD3Dlight8;

              D0,phi0,alpha0:float;

              objList:TObject3DList;

              constructor create;override;
              destructor destroy;override;
              procedure FreeRef;override;

              class function stmClassName:string;override;
              function initialise(st:string):boolean;override;
              procedure createForm;override;

              procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
              procedure RetablirReferences(list:Tlist);override;
              procedure processMessage(id:integer;source:typeUO;p:pointer);override;

              procedure setViewMatrix;
              procedure setProjMatrix;
              procedure Render;

              function width0:integer;
              function height0:integer;

              procedure addObject3D(ob1:Tobject3D);
              procedure addObject3Drec(const rec:Tobject3Drecord);
              procedure clear;
            end;


procedure proTviewer3D_create(stName:String;var pu:typeUO);pascal;
procedure proTviewer3D_add(var obj3D: Tobject3D;x,y,z:float;var pu:typeUO);pascal;
procedure proTviewer3D_clear(var pu:typeUO);pascal;


implementation



{$R *.dfm}

var
  D3D8:IDIRECT3D8; {L'unique interface IDIRECT3D8 }


constructor TObject3DList.create;
begin
  inherited create(sizeof(Tobject3Drecord));
end;

function TObject3DList.getrec(n:integer):TObject3Drecord;
begin
  result:=PObject3Drecord(items[n])^;
end;


procedure  TD3DViewForm.init(owner1:Tviewer3D);
begin
  owner0:=owner1;

  with owner0 do
  begin
    sbD.setParams(D0,1,10);
    sbD.dxSmall:=0.01;
    sbD.dxLarge:=0.1;

    sbPhi.setParams(phi0,-pi,pi);
    sbPhi.dxSmall:=0.01;
    sbPhi.dxLarge:=0.1;

    sbAlpha.setParams(alpha0,-pi/2,pi/2);
    sbAlpha.dxSmall:=0.01;
    sbAlpha.dxLarge:=0.1;
  end;
end;





procedure TD3DViewForm.setCaptions;
begin
  with owner0 do
  begin
    labelD.Caption:='D='+Estr(D0,3);
    labelPhi.Caption:='Phi='+Estr(Phi0,3);
    labelAlpha.Caption:='Alpha='+Estr(Alpha0,3);
  end;
end;

procedure TD3DViewForm.PaintBox1Paint(Sender: TObject);
begin
  owner0.Render;
  validateRect(SimplePanel1.handle,nil);
end;

procedure TD3DViewForm.sbDScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  owner0.d0:=x;
  owner0.render;
end;

procedure TD3DViewForm.sbPhiScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  owner0.phi0:=x;
  owner0.render;
end;

procedure TD3DViewForm.sbAlphaScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  owner0.alpha0:=x;
  owner0.render;
end;


{ TViewer3D }

constructor TViewer3D.create;
begin
  inherited;

  objList:=TObject3DList.create;

  D0:=5;
  createForm;

end;

destructor TViewer3D.destroy;
begin
  clear;

  inherited;
end;

procedure TViewer3D.FreeRef;
begin
  inherited;
  clear;
end;

class function TViewer3D.stmClassName:string;
begin
  result:='Viewer3D';
end;

procedure TViewer3D.createForm;
var
  vec:TD3Dvector;
begin
  if not assigned(D3D8) then
    D3D8:= Direct3DCreate8( D3D_SDK_VERSION );

  if not assigned(D3D8) then exit;

  form:=TD3DViewForm.Create(formStm);
  with TD3DViewForm(form) do init(self);

  D3D8.GetAdapterDisplayMode( D3DADAPTER_DEFAULT, d3ddm );

  fillchar(d3dpp, sizeof(d3dpp),0 );
  d3dpp.Windowed := TRUE;
  d3dpp.SwapEffect := D3DSWAPEFFECT_DISCARD;
  d3dpp.BackBufferFormat := {d3ddm.Format}D3DFMT_A8R8G8B8;
  d3dpp.EnableAutoDepthStencil := TRUE;
  d3dpp.AutoDepthStencilFormat := D3DFMT_D16;
  d3dpp.MultiSampleType:=D3DMULTISAMPLE_4_SAMPLES;

  if Failed( D3D8.CreateDevice( D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, TD3DViewForm(form).SimplePanel1.handle,
                        D3DCREATE_SOFTWARE_VERTEXPROCESSING+D3DCREATE_FPU_PRESERVE ,
                        d3dpp, d3dDevice ) )
     then exit;

  {Define Light 0}
  fillchar(light,sizeof(light),0);
  with light do
  begin
    _type:=D3DLIGHT_DIRECTIONAL;
    diffuse:=rgbaValue(1,1,1,0);
    vec:=D3Dvector(1,-1,0);
    D3DXVec3Normalize(light.direction,vec);
  end;
  d3dDevice.setLight(0,light);

   // Turn off culling
  d3dDevice.SetRenderState( D3DRS_CULLMODE, ord(D3DCULL_NONE) );

   // Turn on the zbuffer
  d3dDevice.SetRenderState( D3DRS_ZENABLE, 1 );



end;

procedure  TViewer3D.SetViewMatrix;
var
  matView:TD3DXMATRIX;
  Eye, At, Up : TD3DXVector3;
begin
  eye:=D3DXVECTOR3( D0*cos(alpha0)*sin(phi0), D0*sin(alpha0),-D0*cos(alpha0)*cos(phi0));
  At:=D3DXVECTOR3( 0.0, 0.0, 0.0 );
  Up:=D3DXVECTOR3( -sin(alpha0)*sin(phi0),cos(alpha0),sin(alpha0)*cos(phi0));
  D3DXMatrixLookAtLH( matView,eye,at,up);
  d3dDevice.SetTransform( D3DTS_VIEW, matView );
end;

procedure  TViewer3D.SetProjMatrix;
var
  matProj:TD3DXMATRIX;
begin
  D3DXMatrixPerspectiveFovLH( matProj, D3DX_PI/4, height0/width0, 0.1, 100.0 );
  d3dDevice.SetTransform( D3DTS_PROJECTION, matProj );
end;

procedure TViewer3D.render;
var
  i:integer;
begin
  if not assigned(d3dDevice ) then exit;

  d3dDevice.Clear( 0, nil, D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER,
                     D3DCOLOR_ARGB(255,0,0,255), 1, 0 );

  d3dDevice.BeginScene;

  SetViewMatrix;
  SetProjMatrix;

  for i:=0 to objList.count-1 do
    with objList[i] do ob.display3D(D3Ddevice,x,y,z,tx,ty,tz);

  d3dDevice.EndScene;

  d3dDevice.Present( Nil, Nil, 0, Nil );

  TD3DViewForm(form).setCaptions;
end;

function TViewer3D.height0: integer;
begin
  result:=TD3DViewForm(form).simplePanel1.Width;
end;

function TViewer3D.width0: integer;
begin
  result:=TD3DViewForm(form).simplePanel1.height;
end;

function TViewer3D.initialise(st: string): boolean;
begin
  result:=inherited initialise(st);
  if assigned(form) then form.caption:=st;
end;

procedure TViewer3D.addObject3D(ob1: Tobject3D);
var
  r: TObject3Drecord;
begin
  fillchar(r,sizeof(r),0);
  r.ob:=ob1;

  objList.Add(@r);
  refObjet(ob1);
end;


procedure TViewer3D.addObject3Drec(const rec: Tobject3Drecord);
begin
  objList.Add(@rec);
  refObjet(rec.ob);
end;

procedure TViewer3D.clear;
var
  i:integer;
  ob1:Tobject3D;
begin
  for i:=0 to objList.count-1 do
  begin
    ob1:=objList[i].ob;
    ob1.releaseDevice;
    derefObjet(typeUO(ob1));
  end;
end;

procedure TViewer3D.processMessage(id: integer; source: typeUO; p: pointer);
var
  i:integer;
  ok:boolean;
  source1:typeUO;
begin
  case id of
    UOmsg_invalidateData:
      begin
        for i:=0 to objList.count-1 do
        if (objList[i].ob=source) then
          if assigned(form) then form.invalidate;
      end;


    UOmsg_destroy:
      begin
        ok:=false;
        for i:=objList.count-1 downto 0 do
        if (objList[i].ob=source) then
          begin
            objList.delete(i);
            source1:=source;
            derefObjet(source1); {source1 est mis à nil donc, on copie source dans source1}
            ok:=true;
          end;

        if ok and assigned(form) then form.invalidate;
      end;
  end;
end;

procedure TViewer3D.RetablirReferences(list: Tlist);
var
  i,j:integer;
  p:pointer;
  nbref:integer;
  rec1:Tobject3Drecord;
begin
  nbref:=ListRefSize div sizeof(Tobject3Drecord);

  for i:=0 to list.count-1 do
    begin
      p:=typeUO(list[i]).myAd;
      for j:=0 to nbRef-1 do
      if p=listRef[j].ob then
      begin
        rec1:=listRef[j];
        rec1.ob:=list[i];
        addObject3Drec(rec1);
      end;  
    end;

  freemem(listRef);
  listRefSize:=0;
end;

procedure TViewer3D.BuildInfo(var conf: TblocConf; lecture, tout: boolean);
begin
  inherited buildInfo(conf,lecture,tout);

  conf.setvarConf('D0',D0,sizeof(D0));
  conf.setvarConf('Phi0',Phi0,sizeof(Phi0));
  conf.setvarConf('Alpha00',Alpha0,sizeof(Alpha0));

  if lecture then
    begin
      listRef:=nil;
      listRefSize:=0;
      conf.setDynConf('OBJ3D',listRef,listRefSize);
    end
  else
    begin
      conf.setvarConf('OBJ3D',objList.getPointer^ ,sizeof(Tobject3Drecord)*objList.count);
    end;

end;


procedure TD3DViewForm.Addobject1Click(Sender: TObject);
var
  ob:Tobject3D;
begin
  ob:=nil;
  if ChooseObject2.execution(Tobject3D,typeUO(ob)) then
    begin
      owner0.addObject3D(ob);
      invalidate;
    end;
end;

{**************************** Méthodes STM ************************************}
procedure proTviewer3D_create(stName:String;var pu:typeUO);
begin
  
  createPgObject(stname,pu,Tviewer3D);

end;

procedure proTviewer3D_add(var obj3D: Tobject3D;x,y,z:float;var pu:typeUO);
var
  rec:Tobject3Drecord;
begin
  verifierObjet(pu);
  verifierObjet(typeUO(obj3D));

  fillchar(rec,sizeof(rec),0);
  rec.ob:=obj3D;
  rec.x:=x;
  rec.y:=y;
  rec.z:=z;

  Tviewer3D(pu).addObject3Drec(rec);
end;

procedure proTviewer3D_clear(var pu:typeUO);
begin
  verifierObjet(pu);
  Tviewer3D(pu).clear;
end;



initialization
  registerObject(Tviewer3D,data);

end.
