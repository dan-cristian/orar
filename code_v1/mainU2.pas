unit mainU2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, StdCtrls, Buttons, ToolWin, ComCtrls;

type
  TmainFRM = class(TForm)
    MainMenu: TMainMenu;
    FileMn: TMenuItem;
    newMn: TMenuItem;
    OpenMn: TMenuItem;
    SaveMn: TMenuItem;
    ExitMn: TMenuItem;
    OpenDlg: TOpenDialog;
    SaveDlg: TSaveDialog;
    dateMn: TMenuItem;
    GeneralMn: TMenuItem;
    ClaseMn: TMenuItem;
    OptionsMn: TMenuItem;
    RezMn: TMenuItem;
    makeMn: TMenuItem;
    winMn: TMenuItem;
    helpMn: TMenuItem;
    ContMn: TMenuItem;
    AboutMn: TMenuItem;
    N2: TMenuItem;
    IndexMn: TMenuItem;
    TileMn: TMenuItem;
    CascadeMn: TMenuItem;
    VerticalMn: TMenuItem;
    HorizontalMn: TMenuItem;
    ViewMn: TMenuItem;
    SpeedbarMn: TMenuItem;
    ImageList: TImageList;
    N4: TMenuItem;
    prefMn: TMenuItem;
    fontsMn: TMenuItem;
    FontDlg: TFontDialog;
    AnimMn: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    tipMn: TMenuItem;
    N1: TMenuItem;
    ArrangeMn: TMenuItem;
    EditImages: TImageList;
    errMn: TMenuItem;
    N3: TMenuItem;
    openTipMn: TMenuItem;
    saveTipMn: TMenuItem;
    N7: TMenuItem;
    TutMn: TMenuItem;
    Tool: TToolBar;
    newbut: TToolButton;
    saveBut: TToolButton;
    openBut: TToolButton;
    ToolButton3: TToolButton;
    genBut: TToolButton;
    selBut: TToolButton;
    rezBut: TToolButton;
    workBut: TToolButton;
    optBut: TToolButton;
    tipBut: TToolButton;
    ToolButton1: TToolButton;
    procedure OpenMnClick(Sender: TObject);
    procedure SaveMnClick(Sender: TObject);
    procedure ExitMnClick(Sender: TObject);
    procedure newMnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GeneralMnClick(Sender: TObject);
    procedure ClaseMnClick(Sender: TObject);
    procedure RezMnClick(Sender: TObject);
    procedure saveF;
    procedure openF;
    procedure makeMnClick(Sender: TObject);
    procedure CascadeMnClick(Sender: TObject);
    procedure VerticalMnClick(Sender: TObject);
    procedure HorizontalMnClick(Sender: TObject);
    procedure SpeedbarMnClick(Sender: TObject);
    procedure AboutMnClick(Sender: TObject);
    procedure prefMnClick(Sender: TObject);
    procedure fontsMnClick(Sender: TObject);
    procedure tipMnClick(Sender: TObject);
    procedure RefreshForms(Senderu: string);
    procedure ArrangeMnClick(Sender: TObject);
    procedure SetEditTool(visi:boolean);
    procedure Redirect(Sender: TObject);
    procedure errMnClick(Sender: TObject);
    procedure ContMnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure sizeComboKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure openTipMnClick(Sender: TObject);
    procedure saveTipMnClick(Sender: TObject);
    procedure TutMnClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  mainFRM:TmainFRM;

implementation

uses dataU2,selectU2,resultU2,prefU2,
     workU2,tipU2,errU2,fis,p,r;

{$R *.DFM}

{-----------------------------------------------------}
procedure resetvar;
begin
nrmat:=0;nrprof:=0;nrMprofi:=0;nrclas:=0;nrClasSel:=0;
caracterizare:='Orar scolar';IsModified:=false;
nrzile:=5;oraStart:=8*60;DoOreZi:=false;workRez:=255;
lungOra:=60;
end;
{-----------------------------------------------------}
procedure TmainFRM.FormCreate(Sender: TObject);
var i:integer;
begin
SetEditTool(false);resetvar;
rez:=Trez.Create;rez.InitVar;
nrCond:=8;//ATENTIE, trebuie actualizata
errList0:=TListBox.Create(self);errList0.Visible:=false;
errList0.Parent:=mainFRM;
width:=Screen.Width-50;height:=Screen.Height-80;
for i:=0 to MainMenu.Items.Count-1 do
    if MainMenu.Items[i].Caption='&Windows' then WinPos:=i;
WinNrDef:=MainMenu.Items[WinPos].Count;
if veri2+veri1<5 then aboutMn.OnClick(self);
end;
{-----------------------------------------------------}
procedure TmainFRM.OpenMnClick(Sender: TObject);
var canOpen:boolean;
begin
FormCloseQuery(self,canOpen);if not canOpen then exit;
OpenDlg.Filter:='Orar files ( *.orr )|*.orr|All files ( *.* )|*.*';
OpenDlg.Title:='Incarcare orar';
OpenDlg.FilterIndex:=1;
if openDlg.Execute then begin openF;RefreshForms('fileFRM');
   isModified:=false;end;
end;
{-----------------------------------------------------}
procedure TmainFRM.SaveMnClick(Sender: TObject);
begin
if nrprof*nrclas*nrmat=0 then begin
   messageDlg('Nu ati introdus datele !',mtwarning,[mbOk],0);
   exit;end;
SaveDlg.Filter:='Orar files ( *.orr )|*.orr|All files ( *.* )|*.*';
Savedlg.Title:='Salvare orar';
savedlg.filename:=opendlg.filename;
SaveDlg.FilterIndex:=1;
if savedlg.execute then begin
   if fileExists(savedlg.filename) then
      if Mesaj('Exista un fisier cu acest nume! Continuam ?',Mes_YN)=mrNo then exit;
   saveF;isMOdified:=false;end;
end;
{-----------------------------------------------------}
procedure TmainFRM.ExitMnClick(Sender: TObject);
begin
close;
end;
{-----------------------------------------------------}
procedure TmainFRM.newMnClick(Sender: TObject);
begin
if nrmat*nrprof*nrclas<>0 then begin
   if mesaj('Datele introduse se vor sterge! Continuam ?',Mes_OC)=mrCancel then exit;end;
resetvar;
if fileExists(dataFile)then begin
   Filelaunch('OpenDlg',dataFile,0);nrclassel:=0;workrez:=255;end
else fileFreeVar;
RefreshForms('fileFRM');
end;
{-----------------------------------------------------}
procedure TmainFRM.GeneralMnClick(Sender: TObject);
begin
if dataFRM<>nil then begin
   setCheck(winPos,'dataWin');dataFRM.show;exit;end;
addMenu(winPos,'Generale','dataWin',generalMn.OnClick);
Application.CreateForm(TdataFRM, dataFRM);
dataFRM.OnResize(mainFRM);
end;
{-----------------------------------------------------}
procedure TmainFRM.ClaseMnClick(Sender: TObject);
begin
if selectFRM<>nil then begin
   setCheck(winPos,'selectWin');selectFRM.show;exit;end;
if nrprof*nrclas*nrmat=0 then begin
   mesaj('Nu ati introdus datele generale',0);exit;end;
addMenu(winPos,'Clase','selectWin',claseMn.OnClick);
Application.CreateForm(TselectFRM, selectFRM);
selectFRM.OnResize(mainFRM);
end;
{-----------------------------------------------------}
procedure TmainFRM.prefMnClick(Sender: TObject);
begin
if prefFRM<>nil then begin
   setCheck(winPos,'prefWin');
   prefFRM.windowState:=wsNormal;prefFRM.show;exit;end;
if nrprof*nrclas*nrmat=0 then begin
   mesaj('Nu ati introdus datele generale',0);exit;end;
addMenu(winPos,'Optiuni','prefWin',prefMn.OnClick);
Application.CreateForm(TprefFRM, prefFRM);
end;
{-----------------------------------------------------}
procedure TmainFRM.RezMnClick(Sender: TObject);
begin
if nrclas>veri1+veri2 then exit;
if rezFRM<>nil then begin setCheck(winPos,'rezWin');rezFRM.show;exit;end;
if nrClasSel=0 then begin mesaj('Nu ati introdus datele pe clase',Mes_OK);exit;end;
addMenu(winPos,'Rezultate','rezWin',rezMn.OnClick);
Application.CreateForm(TrezFRM, rezFRM);
rezFRM.OnResize(mainFRM);
end;
{-----------------------------------------------------}
procedure TmainFRM.errMnClick(Sender: TObject);
begin
if errFRM<>nil then begin setCheck(winPos,'errWin');errFRM.show;exit;
   end else begin
   Application.CreateForm(TerrFRM,errFRM);
   addMenu(winPos,'Nerezolvari','errWin',errMn.OnClick);end;
end;
{-----------------------------------------------------}
procedure TmainFRM.saveF;
begin
if nrmat*nrprof*nrclas=0 then begin
   mesaj('Nu ati introdus datele generale',0);exit;end;
fileLaunch('SaveDlg',SaveDlg.FileName,0);
end;
{-----------------------------------------------------}
procedure TmainFRM.OpenF;
begin
fileLaunch('OpenDlg',OpenDlg.FileName,0);
end;
{-----------------------------------------------------}
procedure TmainFRM.makeMnClick(Sender: TObject);
begin
if nrclas>veri1+veri2 then exit;
if workFRM<>nil then begin setCheck(winPos,'workWin');
   workFRM.windowState:=wsNormal;workFRM.show;exit;end;
if nrClasSel=0 then begin mesaj('Nu ati introdus datele pe clase',Mes_OK);exit;end;
addMenu(winPos,'Creare orar','workWin',makeMn.OnClick);
Application.CreateForm(TworkFRM, workFRM);
end;
{-----------------------------------------------------}
procedure TmainFRM.CascadeMnClick(Sender: TObject);
begin Cascade;end;
procedure TmainFRM.ArrangeMnClick(Sender: TObject);
begin ArrangeIcons;end;
procedure TmainFRM.VerticalMnClick(Sender: TObject);
begin TileMode:=tbVertical;tile;end;
procedure TmainFRM.HorizontalMnClick(Sender: TObject);
begin TileMode:=tbHorizontal;tile;end;
{-----------------------------------------------------}
procedure TmainFRM.SpeedbarMnClick(Sender: TObject);
begin
if speedbarMn.checked then
begin tool.visible:=false;speedbarMn.checked:=false;end
else begin tool.visible:=true;speedbarMn.Checked:=true;end;
end;
{-----------------------------------------------------}
procedure TmainFRM.AboutMnClick(Sender: TObject);
var s:string;
begin
s:='Program realizat de CRISTIAN DAN'+crlf+'   e-mail: cdan@econ.ubbcluj.ro';
if veri1+veri2<5 then begin s:=s+crlf+crlf+
   'Versiune demonstrativa, maxim'+inttostr(veri2+veri1)+' clase';end;
s:=s+crlf+'Pentru detalii contactati-ma prin e-mail'+crlf;
s:=s+'sau la telefon 060/650387';
mesaj(s,0);
end;
{-----------------------------------------------------}
procedure TmainFRM.fontsMnClick(Sender: TObject);
begin
fontDlg.execute;
if dataFrm<>nil then dataFrm.modiFont;
if selectFrm<>nil then selectFrm.modiFont;
if rezFrm<>nil then rezFrm.modiFont;
if prefFrm<>nil then prefFrm.modiFont;
if errFrm<>nil then errFrm.modiFont;
if tipFrm<>nil then tipFrm.modiFont;
end;
{-----------------------------------------------------}
procedure TmainFRM.tipMnClick(Sender: TObject);
begin
if tipFRM<>nil then begin setCheck(winPos,'tipWin');
   tipFRM.windowState:=wsNormal;tipFRM.show;exit;end;
addMenu(winPos,'Tiparire','tipWin',tipMn.OnClick);
Application.CreateForm(TtipFRM,tipFRM);
SetEditTool(true);
end;
{-----------------------------------------------------}
procedure TmainFRM.SetEditTool(visi:boolean);
begin
//editTool.Visible:=visi;
end;
{-----------------------------------------------------}
procedure TmainFRM.Redirect(Sender: TObject);
begin
with tipFRM do begin
case TControl(Sender).Tag of
1:boldMn.OnClick(sender);
2:italicMn.OnClick(sender);
3:underMn.OnClick(sender);
4,5,6:tipFRM.AlignButtonClick(Sender);
7:bulletsMn.OnClick(sender);
8,9,10:FontsChange(sender);
end;
end;
end;
{-----------------------------------------------------}
procedure TmainFRM.sizeComboKeyPress(Sender: TObject; var Key: Char);
begin if key=#13 then Redirect(sender);end;
{-----------------------------------------------------}
procedure TmainFRM.ContMnClick(Sender: TObject);
begin
Application.HelpCommand(HELP_CONTENTS, 0);
end;
{-----------------------------------------------------}
procedure TmainFRM.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
CanClose:=True;
if isModified then if mesaj('Orarul a fost modificat.'+
    ' Doriti sa continuati fara sa-l salvati ?',Mes_YN)=mrNo
    then CanClose:=False;
end;
{-----------------------------------------------------}
procedure TMainFRM.RefreshForms(Senderu: string);
begin
isModified:=true;
if Senderu='fileFRM' then begin
   if dataFRM<>nil then dataFRM.FormCreate(mainFRM);
   if selectFRM<>nil then selectFRM.FormCreate(mainFRM);
   if tipFRM<>nil then tipFRM.FormCreate(mainFRM);
   end;
if Senderu='dataFRM' then begin
   if selectFRM<>nil then selectFRM.FormCreate(mainFRM)
   end;
if Senderu='prefFRM' then begin
   if rezFRM<>nil then begin if rezFrm.isedit=1 then rez.Verifica(0,Ver_Mes);
      rezFRM.lastPrinc:=2;rezFRM.PutFixed;exit;end;//daca editeaza sa nu piarda datele
   end
else if(Senderu<>'workFRM')and(prefFRM<>nil)then prefFRM.FormCreate(mainFRM);
if rezFRM<>nil then rezFRM.FormCreate(mainFRM);
end;

procedure TmainFRM.FormActivate(Sender: TObject);
begin
if not Hey then Application.Terminate;
defilare(mainFRM.Caption,mainFRM);
end;

procedure TmainFRM.openTipMnClick(Sender: TObject);
begin
OpenDlg.Filter:='RichText files (*.rtf)|*.rtf|Text Files (*.txt)|*.txt|All files ( *.* )|*.*';
OpenDlg.Title:='Salvare rezultat';
OpenDlg.FilterIndex:=1;
if OpenDlg.Execute then begin
   if OpenDlg.FilterIndex=1 then tipFrm.rich.PlainText:=false
      else tipFRM.rich.PlainText:=true;
   tipFRM.rich.lines.LoadFromFile(OpenDlg.FileName);
   end;
end;

procedure TmainFRM.saveTipMnClick(Sender: TObject);
begin
SaveDlg.Filter:='RichText files (*.rtf)|*.rtf|Text Files (*.txt)|*.txt|All files ( *.* )|*.*';
SaveDlg.Title:='Incarcare rezultat';
SaveDlg.FilterIndex:=1;
if SaveDlg.Execute then begin
   if SaveDlg.FilterIndex=1 then tipFRM.rich.PlainText:=false
      else tipFRM.rich.PlainText:=true;
   tipFRM.rich.lines.SaveToFile(SaveDlg.FileName);
   end;
end;

procedure TmainFRM.TutMnClick(Sender: TObject);
var mes:twmKey;
begin
mes.KeyData:=13;
mainfrm.dokeypress(mes);
end;

procedure TmainFRM.FormKeyPress(Sender: TObject; var Key: Char);
begin
if key=#13 then;
end;







end.
