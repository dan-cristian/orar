unit mainU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus,
  OrrClass,
  ImgList, ToolWin, ComCtrls, StdCtrls, ExtCtrls, StdActns;

type
  TmainF = class(TForm)
    FontDlg: TFontDialog;
    MainMenu: TMainMenu;
    FileMn: TMenuItem;
    newMn: TMenuItem;
    OpenMn: TMenuItem;
    SaveMn: TMenuItem;
    N7: TMenuItem;
    ExitMn: TMenuItem;
    ViewMn: TMenuItem;
    SpeedbarMn: TMenuItem;
    N3: TMenuItem;
    errMn: TMenuItem;
    dateMn: TMenuItem;
    GeneralMn: TMenuItem;
    ClaseMn: TMenuItem;
    RezMn: TMenuItem;
    makeMn: TMenuItem;
    N4: TMenuItem;
    confMn: TMenuItem;
    OptionsMn: TMenuItem;
    fontsMn: TMenuItem;
    winMn: TMenuItem;
    TileMn: TMenuItem;
    VerticalMn: TMenuItem;
    HorizontalMn: TMenuItem;
    CascadeMn: TMenuItem;
    ArrangeMn: TMenuItem;
    N1: TMenuItem;
    helpMn: TMenuItem;
    ContMn: TMenuItem;
    IndexMn: TMenuItem;
    TutMn: TMenuItem;
    N2: TMenuItem;
    AboutMn: TMenuItem;
    OpenDlg: TOpenDialog;
    SaveDlg: TSaveDialog;
    menu1Img: TImageList;
    menuImg: TImageList;
    SituatiiMn: TMenuItem;
    sitOrMn: TMenuItem;
    sitMatMn: TMenuItem;
    sitProfMn: TMenuItem;
    sitSaliMn: TMenuItem;
    PrintDlg: TPrintDialog;
    PrintSetupDlg: TPrinterSetupDialog;
    sitgrupeMn: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    sitprefMn: TMenuItem;
    mainCool: TControlBar;
    mainBar: TToolBar;
    newMnSp: TToolButton;
    openMnSp: TToolButton;
    saveMnSp: TToolButton;
    ToolButton4: TToolButton;
    genMnSp: TToolButton;
    seleMnSp: TToolButton;
    rezMnSp: TToolButton;
    confMnSp: TToolButton;
    workMnSp: TToolButton;
    ToolButton7: TToolButton;
    tipMnSp: TToolButton;
    ToolButton5: TToolButton;
    tipBar: TToolBar;
    fontsCmb: TComboBox;
    ToolButton1: TToolButton;
    sizeCmb: TComboBox;
    ToolButton3: TToolButton;
    leftB: TToolButton;
    centerB: TToolButton;
    rightB: TToolButton;
    ToolButton2: TToolButton;
    boldB: TToolButton;
    italicB: TToolButton;
    underB: TToolButton;
    bulletsB: TToolButton;
    ToolButton6: TToolButton;
    nerezMn: TToolButton;
    ToolButton8: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure GeneralMnClick(Sender: TObject);
    procedure OpenMnClick(Sender: TObject);
    procedure SaveMnClick(Sender: TObject);
    procedure ClaseMnClick(Sender: TObject);
    procedure RezMnClick(Sender: TObject);
    procedure confMnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure newMnClick(Sender: TObject);
    procedure ExitMnClick(Sender: TObject);
    procedure SpeedbarMnClick(Sender: TObject);
    procedure tipMnClick(Sender: TObject);
    procedure fontsMnClick(Sender: TObject);
    procedure Process(Sender: TObject);
    procedure AboutMnClick(Sender: TObject);
    procedure errMnClick(Sender: TObject);
    procedure makeMnClick(Sender: TObject);
    procedure CascadeMnClick(Sender: TObject);
    procedure sitMatMnClick(Sender: TObject);
    procedure ContMnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  mainF: TmainF;
  Orar:TOrar;

implementation

{$R *.DFM}

uses gen, dataU, seleU, rezU, configU, tipU, procs, errU, makeU;

procedure TmainF.FormCreate(Sender: TObject);
begin
Width:=Screen.Width-50;Height:=Screen.Height-50;
Orar:=TOrar.Create;
end;

procedure TmainF.OpenMnClick(Sender: TObject);
begin
OpenDlg.Filter:='Orar files ( *.orr )|*.orr|All files ( *.* )|*.*';
OpenDlg.Title:='Incarcare orar';
OpenDlg.FilterIndex:=1;
if openDlg.Execute then begin Orar.LoadFromFile(OpenDlg.FileName);
   Caption:='Orar Scolar - '+openDlg.FileName;
   end;
end;

procedure TmainF.SaveMnClick(Sender: TObject);
begin
SaveDlg.Filter:='Orar files ( *.orr )|*.orr|All files ( *.* )|*.*';
Savedlg.Title:='Salvare orar';
savedlg.filename:=opendlg.filename;
SaveDlg.FilterIndex:=1;
if savedlg.execute then begin
   Orar.SaveToFile(SaveDlg.FileName);
   Caption:='Orar Scolar - '+SaveDlg.FileName;
   end;
end;

procedure TmainF.GeneralMnClick(Sender: TObject);
begin
if dataF=nil then Application.CreateForm(TDataF,dataF)
else dataF.Show;
end;

procedure TmainF.ClaseMnClick(Sender: TObject);
begin
if seleF=nil then Application.CreateForm(TseleF,seleF)
else seleF.Show;
end;

procedure TmainF.RezMnClick(Sender: TObject);
begin
if rezF=nil then Application.CreateForm(TrezF,rezF)
else rezF.Show;
end;

procedure TmainF.confMnClick(Sender: TObject);
begin
if configF=nil then Application.CreateForm(TconfigF,configF)
else configF.Show;
end;

procedure TmainF.tipMnClick(Sender: TObject);
begin
tipBar.Show;
if tipF=nil then Application.CreateForm(TtipF,tipF)
else tipF.Show;
end;

procedure TmainF.errMnClick(Sender: TObject);
begin
if errF=nil then Application.CreateForm(TerrF,errF)
else errF.Show;
end;

procedure TmainF.makeMnClick(Sender: TObject);
begin
if makeF=nil then Application.CreateForm(TmakeF,makeF)
else makeF.Show;
end;

procedure TmainF.sitMatMnClick(Sender: TObject);
begin
//if tipmatF=nil then Application.CreateForm(TtipmatF,tipmatF)
//else tipmatF.Show;
end;

procedure TmainF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Orar.Destroy;
end;

procedure TmainF.newMnClick(Sender: TObject);
begin
Orar.Destroy;Orar:=TOrar.Create;
end;

procedure TmainF.ExitMnClick(Sender: TObject);
begin
Close;
end;

procedure TmainF.SpeedbarMnClick(Sender: TObject);
begin
mainCool.Visible:=not(mainCool.Visible);
SpeedbarMn.Checked:=mainCool.Visible;
end;

procedure TmainF.fontsMnClick(Sender: TObject);
begin
if FontDlg.Execute then;
end;

procedure TmainF.Process(Sender: TObject);
begin
tipF.Process(Sender);
end;

procedure TmainF.AboutMnClick(Sender: TObject);
begin
MessageDlg('Program realizat de Dan CRISTIAN, '+crlf+
    'e-mail: DanCristian77@hotmail.com',mtInformation,[mbOK],0);
end;


procedure TmainF.CascadeMnClick(Sender: TObject);
begin
case TMenuItem(Sender).Tag of
	1: begin TileMode:=tbVertical;Tile;end;
   2: begin TileMode:=tbVertical;Tile;end;
   3: Cascade;
   4: ArrangeIcons;
   end;
end;


procedure TmainF.ContMnClick(Sender: TObject);
begin
   winexec('winhlp32.exe try.hlp',SW_SHOWNORMAL);
end;

end.
