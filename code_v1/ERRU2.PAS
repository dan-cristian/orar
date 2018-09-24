unit errU2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TerrFRM = class(TForm)
    errList: TListBox;
    butPan: TPanel;
    closeBut: TButton;
    refreshBut: TButton;
    comboPan: TPanel;
    Combo: TComboBox;
    clasCheck: TCheckBox;
    procedure modiFont;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure closeButClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure refreshButClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  errFRM: TerrFRM;

implementation

uses mainU2,p,r;

{$R *.DFM}

procedure TerrFrm.modiFont;
var f:Tfont;
begin
f:=mainfrm.fontdlg.font;
with errlist.font do begin
size:=f.size;style:=f.style;charset:=f.charset;color:=f.color;
end;
end;

procedure TerrFRM.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
closeButClick(self);
end;

procedure TerrFRM.closeButClick(Sender: TObject);
begin
errFRM.release;errFRM:=nil;
end;

procedure TerrFRM.FormDestroy(Sender: TObject);
begin
removeItem(winPos,'errWin');
end;

procedure TerrFRM.FormCreate(Sender: TObject);
var i:integer;
begin
Top:=0;Left:=0;height:=300;width:=400;
modiFont;errList.Items:=errList0.Items;
for i:=1 to nrclas do combo.items.add(clasN[i]^);
end;

procedure TerrFRM.FormActivate(Sender: TObject);
begin
defilare(errFRM.Caption,errFRM);
end;

procedure TerrFRM.refreshButClick(Sender: TObject);
begin
if clasCheck.Checked then rez.verifica(0,Ver_List)
   else if combo.itemindex<>-1 then rez.verifica(combo.itemindex+1,Ver_List);
end;

end.
