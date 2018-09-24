unit errU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TerrF = class(TForm)
    errP: TPanel;
    butP: TPanel;
    errLst: TListBox;
    refreshB: TButton;
    closeB: TButton;
    Panel1: TPanel;
    secCmb: TComboBox;
    aniCmb: TComboBox;
    grupeCmb: TComboBox;
    allChk: TCheckBox;
    procedure closeBClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure refreshBClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure secCmbChange(Sender: TObject);
    procedure aniCmbChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function ErrOre(isec,ian,igrup,igr:integer):string;
    function ErrPut(isec,ian,igrup:integer):string;
    procedure AllSecErr;
    procedure SelSecErr;
  end;

var
  errF: TerrF;

implementation
uses mainU,orrclass;
{$R *.DFM}

const

   sep='--------------------';

procedure TerrF.closeBClick(Sender: TObject);
begin
errF.Release;errF:=nil;
end;

procedure TerrF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
closeBClick(nil);
end;

function TerrF.ErrOre;
var s:string;
begin
with Orar.Grups do
   with Sec[isec][ian][igrup][igr] do
   begin
      Result:='';
      if OraRest>0 then
      begin
         s:='Sectia '+Sec.Items[isec].Val;
      	s:=s+', anul '+Sec[isec].Items[ian].Val;
         s:=s+', grupa '+Sec[isec][ian].Items[igrup].Val;
         s:=s+', materia '+Mats.Items.ByCod(CMat).Val;
         s:=s+' mai are '+inttostr(OraRest)+' h de pus.';
         Result:=s;
      end;
   end;
end;

procedure TerrF.refreshBClick(Sender: TObject);
begin
errLst.Clear;
if allChk.Checked then
   AllSecErr
else
   SelSecErr;
end;

procedure TerrF.AllSecErr;
var isec,ian,igrup,igr:integer;var s:string;
begin
with Orar.Grups do
for isec:=1 to Sec.Count do
   for ian:=1 to Sec[isec].Count do
	   for igrup:=1 to Sec[isec][ian].Count do
      begin
         for igr:=1 to Sec[isec][ian][igrup].Count do
         begin
            s:=ErrOre(isec,ian,igrup,igr);
            if s<>'' then errLst.Items.Add(s);
         end;
         errLst.Items.Add(sep);
      end;
errLst.Items.Add(sep);
with Orar.Grups do
for isec:=1 to Sec.Count do
   for ian:=1 to Sec[isec].Count do
	   for igrup:=1 to Sec[isec][ian].Count do
         ErrPut(isec,ian,igrup);
end;

procedure TerrF.SelSecErr;
var isec,ian,igrup,igr:integer;s:string;
begin
isec:=secCmb.ItemIndex+1;
if isec=0 then exit;
ian:=aniCmb.ItemIndex+1;
igrup:=grupeCmb.ItemIndex+1;
for igr:=1 to Orar.Grups.Sec[isec][ian][igrup].Count do
   begin
      s:=ErrOre(isec,ian,igrup,igr);
      if s<>'' then errLst.Items.Add(s);
   end;
errLst.Items.Add(sep);
ErrPut(isec,ian,igrup);
end;

procedure TerrF.FormCreate(Sender: TObject);
begin
with Orar.Grups do
begin
   if Sec.Count>0 then
      Sec.Items.ToStrings(@secCmb.Items)
   else exit;
   secCmb.ItemIndex:=0;
   Sec[1].Items.ToStrings(@aniCmb.Items);
   aniCmb.ItemIndex:=0;
   Sec[1][1].Items.ToStrings(@grupeCmb.Items);
   grupeCmb.ItemIndex:=0;
end;
end;

procedure TerrF.secCmbChange(Sender: TObject);
begin
aniCmb.Clear;
Orar.Grups.Sec[secCmb.ItemIndex+1].Items.ToStrings(@aniCmb.Items);
aniCmb.ItemIndex:=0;
aniCmbChange(nil);
end;

procedure TerrF.aniCmbChange(Sender: TObject);
begin
grupeCmb.Clear;
Orar.Grups.Sec[SecCmb.Itemindex+1][AniCmb.ItemIndex+1].Items.ToStrings(@grupeCmb.Items);
grupeCmb.ItemIndex:=0;
end;

function TerrF.ErrPut;
var zi,ora:integer;_Grp:TGrp;err:integer;
    sect,an,gr:TCod;s:string;oraCons:integer;
begin
_Grp:=TGrp.Create;
try
with Orar.Grups do
begin
   sect:=sec.Items.IndexToCod(isec);
   an:=sec[isec].Items.IndexToCod(ian);
   gr:=sec[isec][ian].Items.IndexToCod(igrup);
   with Sec[isec][ian][igrup] do
   begin
      for zi:=1 to max_zile do
         for ora:=1 to max_ore do
         begin
         if Rez.Exist(zi,ora) then
         begin
            _Grp.Assign(Rez[zi,ora]);
            oraCons:=Del(sect,an,gr,zi,ora,0);
            err:=Put(sect,an,gr,zi,oraCons,_Grp);
            if err<>0 then
            begin
               s:='Sectia '+Sec.Items[isec].Val;
      	      s:=s+', anul '+Sec[isec].Items[ian].Val;
               s:=s+', grupa '+Sec[isec][ian].Items[igrup].Val;
               s:=s+', materia '+Mats.Items.ByCod(_Grp.CMat).Val;
               s:=s+': '+ReturnErr(err);
               errLst.Items.Add(s);
            end;
         end;
         end;
   end;
end;
finally
   _Grp.Destroy;
end;
end;

end.
