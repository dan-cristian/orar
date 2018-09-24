unit p;

interface

uses Dialogs,SysUtils,Classes,Menus,Graphics,StdCtrls,Forms,Controls,
     Registry,Windows;

const
     border=140;
     maxchar=30;maxCharGrup=20;
     maxMat=100;maxclas=100;maxprof=100;
     maxzile=7;maxore=12;maxMprofi=5;
     maxMclas=50;//maxclas;
     maxMgrup=10;maxMmat=5;
     maxCond=10;crlf=#13+#10;tab=#9;
     zileN:array[1..maxzile]of string[20]=('Luni','Marti','Miercuri','Joi','Vineri','Sambata','Duminica');
     izileN:array[1..7]of char=('L','M','M','J','V','S','D');
     veri2=100;veri1=2;
     dataFile='..\orr\orar.dat';iniFile='..\orr\orar.ini';
     rezR=0;rez_R=1;
     FirstTime:boolean=True;
     Mes_Ok=0;Mes_YN=1;Mes_YNC=2;Mes_Poz=3;Mes_OC=4;
     Mes_Yes=mrYes;Mes_No=mrNo;Mes_Cancel=mrCancel;

type
  sirTip=string[maxchar];
  psirTip=^sirTip;
  pIntTip=^integer;
  pByteTip=^byte;
  Tsec=set of (mat,clas,prof,sala);
  TmatR=array[1..maxclas,1..maxzile,1..maxore]of pIntTip;
  TprofR=array[1..maxclas,1..maxzile,1..maxore]of pIntTip;

var
  nrmat,nrclas,nrprof,nrMprofi,nrMgrup,nrMclas,nrMmat,nrclasSel:integer;
  matN:array[1..maxmat]of psirTip;
  clasN:array[1..maxclas]of psirTip;
  profN:array[1..maxprof]of psirTip;
  matI:array[1..maxclas,1..maxmat]of pIntTip;
  Mmat:array[1..maxclas*maxmat,1..maxMmat]of pIntTip;//1-mat,2-tip,3-Mgrup,4-Mclas,5-orapun
  profI:array[1..maxclas,1..maxmat]of pIntTip;
  Mprofi:array[1..maxclas*(maxmat+1),0..maxMprofi]of pIntTip;
  clasI:array[1..maxclas,1..2]of pIntTip;//1-index,2-ora start
  Mclas:array[1..maxclas*maxmat,0..maxMclas]of pIntTip;
  Mgrup:array[1..maxclas*maxmat,0..maxMgrup]of pSirTip;
  oreI:array[1..maxclas,1..maxmat]of pIntTip;
  matNr:array[1..maxclas]of pIntTip;
  pref:array[1..maxprof,1..maxzile,1..maxore]of pIntTip;
  oremat:array[1..maxmat,1..2]of PIntTip;{nr ore mat pe zi}
  sali:array[1..maxmat]of pIntTip;
  dif:array[1..maxclas,1..maxore]of pIntTip;
  matR:TmatR;
  profR:TprofR;
  oreZi:array[1..maxclas,1..maxzile]of pIntTip;
  cond:array[1..maxCond,1..2]of pIntTip;//1-cond 2-prioritate

  _matR:TmatR;
  _profR:TprofR;
  _restOre:array[1..maxclas,1..maxmat]of pIntTip;
  _matI:array[1..maxclas,1..maxmat]of pIntTip;
  _profI:array[1..maxclas,1..maxmat]of pIntTip;
  _oreI:array[1..maxclas,1..maxmat]of pIntTip;

  errClas,errZi,errOra:integer;
  nrCond,nrZile,oraStart,WinNrDef,winPos,lungOra:integer;
  caracterizare:string;
  WorkRez:byte;oreAll:longint;
  DoOreZi,isModified:boolean;

  errList0:TListBox;


function OraMin(nrmin:integer):string;
function OraMinNext(Hstart,index:integer):string;
function LungOraMin(Target:TCanvas;Hstart:integer):integer;
function NrCharOraMin(Hstart:integer):integer;
function umple(s:string;nr:integer):string;
function maxim(n1,n2:integer):integer;
function delBlank(s:AnsiString):AnsiString;
function mat2prof(indclas,mat:integer):integer;
function mat2ind(indclas,mat:integer):integer ;
function _mat2ind(indclas,mat:integer):integer ;
procedure ElibInt(var pInt:pIntTip);
procedure ElibSir(var pSir:pSirTip);
procedure AlocInt(var pInt:pIntTip);
procedure initInt(var pInt:pIntTip;value:integer);
procedure initSir(var pSir:pSirTip;value:sirTip);
function ReturnSir(var pSir:pSirTip;nonAlocVal:SirTip):SirTip;
function  egalInt(var pInt:PintTip;value:integer):boolean;
function mesaj(s:string;opt:integer):word;
function minim(i,j:integer):integer;
procedure exchange(var i,j:integer);
function truncStr(s:string;max:integer):string;
function getError(cod:integer):string;
procedure MakeOreZi(numarZile:integer);
function TotalOreClas(clasa:integer):integer;
function GetProf(prof,index:integer):string;
function GetMat(mat,opt,indClas:integer):string;
function GetMatI(mat:integer):integer;
function GetClas(indClas,mat,indprof,opt:integer):string;
function getZileOre(index,options:integer):integer;
function GetOreProf(prof:integer):integer;
function GetRez(index,zi,ora,princ,sec,opt:integer):ansistring;
procedure AddMenu(meniu:integer;Titlu:string;nume:string;eveniment:TNotifyEvent);
procedure SetCheck(meniu:integer;nume:string);
procedure removeItem(meniu:integer;nume:string);
procedure DisplayRez(indClas:integer;s:string);
procedure PutEroare(IndClas,zi,ora,IndMat,tip:integer);
function  Initiale(s:string):string;
procedure Process(indmat:integer);
procedure defilare(s:string;capt:TForm);
function Hey:boolean;
function param(s:string;ind:integer):integer;
function paramS(s:string;ind:integer):string;

implementation

uses mainU2,workU2,resultU2,errU2;

{-----------------------------------------------------}
function OraMin(nrmin:integer):string;
var i:integer;
begin
i:=nrmin-trunc(nrmin/60)*60;Result:=inttostr(trunc(nrmin/60));
if i<>0 then Result:=Result+','+inttostr(i);
end;
{-----------------------------------------------------}
function OraMinNext(Hstart,index:integer):string;
begin
Result:=oraMin(HStart+(-1+index)*lungOra)+'-'+oraMin(HStart+(-1+index+1)*lungOra)+' ';
end;
{-----------------------------------------------------}
function LungOraMin(Target:TCanvas;Hstart:integer):integer;
var i:integer;
begin
Result:=0;for i:=1 to maxore do Result:=maxim(Result,Target.TextWidth(OraMinNext(Hstart,i)));
end;
{-----------------------------------------------------}
function NrCharOraMin(Hstart:integer):integer;
var i:integer;
begin
Result:=0;
for i:=1 to maxore do Result:=maxim(Result,Length(OraMinNext(Hstart,i)));
end;
{-----------------------------------------------------}
function umple(s:string;nr:integer):string;
var i:integer;
begin result:='';for i:=1 to nr do result:=result+s;end;
{---------------------------------------------------------}
function maxim(n1,n2:integer):integer;
begin if n1>=n2 then result:=n1 else result:=n2;end;
{---------------------------------------------------------}
procedure exchange(var i,j:integer);
var k:integer;begin k:=i;i:=j;j:=k;end;
{---------------------------------------------------------}
function delBlank(s:AnsiString):AnsiString;
begin
while Pos(' ', S)>0 do delete(S,Pos(' ', S),1);result:=s;
end;
{---------------------------------------------------------}
function mat2prof(indclas,mat:integer):integer;
var i:integer;
begin
mat2prof:=0;
for i:=1 to matNr[indclas]^ do if matI[indClas,i]^=mat then
    begin mat2prof:=profI[indClas,i]^;exit;end;
end;
{---------------------------------------------------------}
function mat2ind(indclas,mat:integer):integer ;
var i:integer;
begin
mat2ind:=0;
for i:=1 to matNr[indclas]^ do if matI[indClas,i]^=mat then
    begin mat2ind:=i;exit;end;
end;
{-----------------------------------------------------}
function _mat2ind(indclas,mat:integer):integer ;
var i:integer;
begin
_mat2ind:=0;for i:=1 to matNr[indclas]^ do if _matI[indClas,i]^=mat then
                begin _mat2ind:=i;exit;end;
end;
{---------------------------------------------------------}
procedure ElibInt(var pInt:pIntTip);
begin
if pInt<>nil then begin dispose(pInt);pInt:=nil;end;
end;
{---------------------------------------------------------}
procedure ElibSir(var pSir:pSirTip);
begin
if pSir<>nil then begin dispose(pSir);pSir:=nil;end;
end;
{---------------------------------------------------------}
procedure AlocInt(var pInt:pIntTip);
begin
if pInt=nil then begin new(pInt);exit;end;
end;
{---------------------------------------------------------}
procedure initInt(var pInt:pIntTip;Value:integer);
begin
AlocInt(pInt);pInt^:=Value;
end;
{---------------------------------------------------------}
procedure initSir(var pSir:pSirTip;value:sirTip);
begin
if pSir=nil then new(pSir);pSir^:=value;
end;
{---------------------------------------------------------}
function egalInt(var pInt:PintTip;value:integer):boolean;
begin
if pInt<>nil then Result:=(pInt^=value) else Result:=false;
end;
{---------------------------------------------------------}
function ReturnSir(var pSir:pSirTip;nonAlocVal:SirTip):SirTip;
begin
if pSir<>nil then Result:=pSir^ else Result:=nonAlocVal;
end;
{---------------------------------------------------------}
function ReturnInt(var pInt:pIntTip;nonAlocVal:integer):Integer;
begin
if pInt<>nil then Result:=pInt^ else Result:=nonAlocVal;
end;
{---------------------------------------------------------}
function mesaj(s:string;opt:integer):word;
begin
Result:=mrOK;
case opt of
Mes_Ok:  MessageDlg(s,mtinformation,[mbOk],0);
Mes_Poz: MessageDlgPos(s,mtinformation,[mbOk],0,0,0);
Mes_YN:  Result:=MessageDlg(s,mtinformation,[mbYes,mbNo],0);
Mes_YNC: Result:=MessageDlg(s,mtinformation,[mbYes,mbNo,mbCancel],0);
Mes_OC: Result:=MessageDlg(s,mtinformation,[mbOk,mbCancel],0);
end;
end;
{---------------------------------------------------------}
function minim(i,j:integer):integer;
begin
if i<=j then minim:=i else minim:=j;
end;
{-----------------------------------------------------}
function truncStr(s:string;max:integer):string;
begin
if length(s)>max then delete(s,max,length(s)-max);Result:=s;
end;
{-----------------------------------------------------}
function getError(cod:integer):string;
var s,prof,mat:string;
begin
s:='Eroare necunoscuta';
case abs(cod) of
0: s:='No error';
1: s:='Profesor ocupat';
2: s:='Depasire numar de ore pe zi';
3: s:='Nu au loc toate materiile consecutive in aceasta zi';
4: s:='Nu pot pune materiile consecutiv';
5: s:='Materia trebuie sa fie consecutiva';
6: s:='Exista inca o materie in ziua precedenta';
7: s:='Exista inca o materie in ziua urmatoare';
8: s:='Sala ocupata';
9: s:='Preferinta profesor';
10:s:='Profesor ocupat';
11:s:='Profesor ocupat';
12:s:='Profesor ocupat';
13:s:='Loc ocupat';
14:s:='Orele consecutive nu incap';
15:s:='Grad de dificultate al materiei prea mare';
16:s:='Grad de dificultate al materiei prea mic';
end;{case}
if (not(cod in [14]))and(cod>0)then begin
   mat:=getmat(_matR[errClas,errZi,errOra]^,0,0);
   prof:=Getprof(_profR[errClas,errZi,errOra]^,0);
   if not(cod in[15,16])then s:= s+crlf+'conflict cu clasa '+clasN[clasI[errClas,1]^]^+', '+zileN[errZi]
    +', ora '+inttostr(errOra);
   if cod in [1,2,6..8,10..12] then s:=s+crlf+'materia '+mat+', profesor '+prof;
   end;
Result:=s;
end;
{-----------------------------------------------------}
procedure PutEroare(IndClas,zi,ora,IndMat,tip:integer);
var mat,clas,s:ansistring;
function sp(lg:integer;s:ansistring):ansistring;
begin if length(s)>lg then delete(s,lg,length(s)-lg);
Result:=s+umple(' ',lg-length(s));end;
begin
if errFRM=nil then begin
   Application.CreateForm(TerrFRM,errFRM);
   addMenu(winPos,'Nerezolvari','errWin',mainFRM.errMn.OnClick);end;
if indClas+indMat+tip=0 then begin errFRM.errList.Items.Clear;exit;end;
mat:=getMat(indMat,1,indClas);clas:=clasN[clasI[indClas,1]^]^;
s:=sp(15,mat)+' '+sp(15,clas);
if tip<>-1 then s:=s+sp(10,zileN[zi])+' '+sp(7,'ora '+inttostr(ora))+' '+getError(-tip)
   else s:=s+'Nu pot pune materia';
errList0.items.add(s);errFRM.errList.Items.add(s);
end;
{-----------------------------------------------------}
procedure MakeOreZi(numarZile:integer);
var i,j,totalore:integer;
    rest,cat:integer;
begin
oreAll:=0;
for i:=1 to nrClasSel do begin initInt(clasI[i,2],oraStart);
    totalore:=totaloreClas(i);oreAll:=oreAll+totalore;
    cat:=totalore div numarZile;rest:=totalore mod NumarZile;
    for j:=1 to maxzile do
        if j<=numarzile then initInt(oreZi[i,j],cat)else initInt(oreZi[i,j],0);
    for j:=1 to rest do inc(oreZi[i,j]^);
    end;
DoOreZi:=true;
end;
{---------------------------------------------------------}
function TotalOreClas(clasa:integer):integer;
var i,total:integer;
begin
total:=0;for i:=1 to matNr[clasa]^ do total:=total+oreI[clasa,i]^;
TotalOreClas:=total;
end;
{-------------------------------------------------------------}
function GetProf(prof,index:integer):string;
var k:integer;s:string;
begin result:='';
if prof<0 then for k:=1 to Mprofi[-prof,0]^ do begin
   if (index<=0)or(k=index)then begin
      if index<0 then s:='/'+Mgrup[-index,k]^ else s:='';
      result:=result+profN[Mprofi[-prof,k]^]^+s;
      end;
   if (index<>0)and(k=index)then exit;
   if (index<=0) then result:=result+'. ';end
else if (prof>0)and(index in [0,1])then result:=profN[prof]^;
end;
{-----------------------------------------------------}
function GetOreProf(prof:integer):integer;
var i,j,k,prof1:integer;
begin
Result:=0;
for i:=1 to nrclasSel do for j:=1 to matNr[i]^ do
    begin prof1:=profI[i,j]^;
    if prof=prof1 then Result:=Result+oreI[i,j]^;
    if prof1<0 then for k:=1 to MProfi[-prof1,0]^ do
       if Mprofi[-prof1,k]^=prof then Result:=Result+oreI[i,j]^;
    end;
end;
{-----------------------------------------------------}
function GetMat(mat,opt,indClas:integer):string;
var rmat{,grp}:integer;
begin
Result:='';if opt=1 then mat:=_matI[indClas,mat]^;
if mat<0 then rmat:=Mmat[-mat,1]^ else rmat:=mat;
if mat<>0 then Result:=matN[rmat]^;
end;

function GetMatI(mat:integer):integer;
begin
if mat<0 then Result:=Mmat[-mat,1]^ else Result:=mat;
end;
{-----------------------------------------------------}
function getZileOre(index,options:integer):integer;//chiar si getprof
var i,j,k,start,endu:integer;s:string;
begin
start:=1;endu:=nrclassel;Result:=0;
if (index<>0)and(options<>5)then begin start:=index;endu:=index;end;
if options in [1,2,5,6] then
for i:=start to endu do for j:=1 to maxzile do
    if options=6 then Result:=maxim(Result,OreZi[i,j]^)else
       for k:=1 to maxore do
       if matR[i,j,k]^<>0 then case options of
          1:Result:=maxim(Result,j);
          2:Result:=maxim(Result,k);
          5:if j=index then Result:=maxim(Result,k);
          end;
if options in [3,4] then begin
   s:=getProf(index,0);
   for i:=1 to nrclassel do for j:=1 to maxzile do for k:=1 to maxore do
       begin
       for start:=1 to maxMprofi do begin
           if s=getProf(profR[i,j,k]^,start)then begin
              case options of
                   3:Result:=maxim(Result,k);
                   4:Result:=maxim(Result,j);end;
                   break;end;
   end;end;end;
end;
{-----------------------------------------------------}
function GetClas(indClas,mat,indprof,opt:integer):string;
var cls,grp,i:integer;
begin
Result:=clasN[clasI[indClas,1]^]^;
if (mat<0)and(Mmat[-mat,2]^=3) then begin
   cls:=Mmat[-mat,4]^;grp:=Mmat[-mat,3]^;
   if indProf>0 then Result:=Mgrup[grp,indProf]^+'/'else result:='';
   for i:=1 to Mclas[cls,0]^ do begin Result:=Result+clasN[Mclas[cls,i]^]^;
       if i<>Mclas[cls,0]^ then Result:=Result+'/';end;
   end;
end;
{-----------------------------------------------------}
function GetRez(index,zi,ora,princ,sec,opt:integer):ansistring;
procedure mat_prof(indClas,z,o:integer;var mat,profu:integer);
begin mat:=0;profu:=0;
case opt of
RezR: begin mat:=matR[indclas,z,o]^;profu:=profR[indclas,z,o]^;end;
Rez_R:begin mat:=_matR[indclas,z,o]^;profu:=_profR[indclas,z,o]^;end;
end;end;
{=====}
function indMprofi(var indClas,mat,profu:integer):integer;
var i,j,tag:integer;s0,s1:ansistring;
begin
s0:=GetProf(index,0);j:=0;tag:=0;
for i:=1 to nrclassel do begin
    mat_prof(i,zi,ora,mat,profu);indClas:=i;
    for j:=1 to maxMprofi do begin s1:=GetProf(profu,j);
        if s1=s0 then begin tag:=1;break;end;
        if s1='' then break;end;
    if tag=1 then break;end;
if tag=0 then Result:=-1 else Result:=j;
end;
{=====}
function Clas:ansistring;
var mat,profu,grp:integer;
begin Result:='@@@';
mat_prof(index,zi,ora,mat,profu);
if (mat<0)and(Mmat[-mat,2]^=3)then grp:=Mmat[-mat,3]^ else grp:=0;
case sec of
0:Result:=GetMat(mat,0,0);
1:Result:=GetProf(profu,-grp);
3:Result:=inttostr(mat);
end;end;
{=====}
function Prof:ansistring;
var indclas,j,mat,prof:integer;
begin
Result:='';mat:=0;
j:=indMprofi(indClas,mat,prof);if j=-1 then exit;
case sec of
0:Result:=GetMat(mat,0,j);
2:Result:=GetClas(indClas,mat,j,0);
end;end;
{=====}
function Zile:ansistring;
var indClas,mat,profu,nr:integer;
begin nr:=0;Result:='';mat:=0;profu:=0;
for indClas:=1 to nrclasSel do begin
    mat_prof(indclas,zi,ora,mat,profu);
    if mat<>0 then inc(nr);
    if nr=index then break;end;
if nr<>index then exit;
case sec of
0:Result:=GetMat(mat,0,0);
1:Result:=GetProf(profu,0);
2:Result:=GetClas(indClas,mat,-1,0);
end;
end;
{=====}
begin Result:='!!!';
case princ of
0:Result:=Clas;
1:Result:=Prof;
2:Result:=Zile;
end;//case
end;
{-----------------------------------------------------}
procedure SetCheck(meniu:integer;nume:string);
var i,meniu1:integer;
begin
meniu1:=0;
with mainFRM do begin
    for i:=0 to MainMenu.Items[meniu].Count-1 do begin
    MainMenu.Items[meniu].Items[i].checked:=false;
    if MainMenu.Items[meniu].Items[i].name=nume then meniu1:=i;end;
MainMenu.Items[meniu].Items[meniu1].checked:=true;
end;
end;
{-----------------------------------------------------}
procedure RemoveItem(meniu:integer;nume:string);
var i,meniu1,total:integer;
begin
with mainFRM do begin
meniu1:=0;total:=MainMenu.Items[meniu].Count;
if total=WinNrDef+1 then winMn.visible:=false;
for i:=0 to total-1 do
    if MainMenu.Items[meniu].Items[i].name=nume then meniu1:=i;
if meniu1=0 then exit;
MainMenu.Items[meniu].Delete(meniu1);
if total>WinNrDef then begin
   if meniu1+1=total then i:=-1 else i:=0;
   MainMenu.Items[meniu].items[meniu1+i].checked:=true;
   MainMenu.Items[meniu].items[meniu1+i].click;
   end;
end;
end;
{-----------------------------------------------------}
procedure AddMenu(meniu:integer;Titlu:string;nume:string;eveniment:TNotifyEvent);
var i,j:integer;{c:char;}
begin
with mainFRM do begin
i:=mainMenu.Items[meniu].count-1;
if i+1=WinNrDef then winMn.visible:=true;
for j:=0 to i do MainMenu.Items[meniu].Items[j].checked:=false;
MainMenu.Items[meniu].Add(NewItem(titlu,0,true,true,eveniment,0,nume));
end;
end;
{-----------------------------------------------------}
procedure DisplayRez(indClas:integer;s:ansistring);
var i,j:integer;
begin
if rezFRM=nil then exit;
if not rezfrm.pasCheck.Checked then exit;
for i:=1 to maxzile do for j:=1 to maxore do
    rezFRM.orarGrid.cells[i,j]:=getMat(_matR[indClas,i,j]^,0,0);
rezFRM.orargrid.cells[1,0]:=clasN[clasI[indclas,1]^]^;
Application.ProcessMessages;
if s<>'' then begin
   for i:=1 to matNr[indclas]^ do
   s:=s+crlf+inttostr(_restore[indclas,i]^)+'   '+getMat(_matI[indclas,i]^,0,0);
   mesaj(s,Mes_Poz);end;
end;
{-----------------------------------------------------}
function Initiale(s:ansistring):string;
var i,j:integer;
begin j:=1;
for i:=1 to length(s) do
if s[i]=' ' then j:=1 else if j=1 then begin
    Result:=Result+s[i]+'.';j:=0;end;
end;
{-----------------------------------------------------}
procedure Process(indmat:integer);
begin mainFRM.caption:=inttostr(indmat);
Application.ProcessMessages;end;
{-----------------------------------------------------}
procedure defilare(s:string;capt:TForm);
var i,j:integer;
begin
exit;
if capt<>nil then capt.Caption:='';
for i:=0 to length(s)-1 do begin
    if capt<>nil then capt.Caption:=s[length(s)-i]+capt.Caption;
    for j:=1 to 100000 do;
    {Application.ProcessMessages;}
    end;
end;
{-----------------------------------------------------}
function Hey:boolean;
var reg:TRegistry;bool:boolean;s:string;nr:integer;
    data:TDateTime;an0,an,luna0,luna,zi0,zi:word;
begin
if (paramcount=1)and(paramstr(1)='cd')then begin result:=true;exit;end;
Result:=false;
reg:=TRegistry.Create;
try with reg do begin
RootKey:=HKEY_LOCAL_MACHINE;
bool:=openKey('\SOFTWARE\Microsoft\Windows\explorer\Tips',false);
if not bool then exit;
s:='Welcome to Microsoft Windows 95, the best operating system in this world';
if valueExists('15')and valueExists('16')and valueExists('17')
   and(ReadString('15')=s)then else begin
   DeleteValue('15');DeleteValue('16');DeleteValue('17');
   mesaj('Copiere ilegala'+crlf+'Pentru detalii contactati producatorul',0);
   mainfrm.aboutMn.onClick(nil);exit;end;
if ReadInteger('17')=1977 then begin Result:=true;exit;end;
data:=ReadDateTime('16');
decodedate(data,an0,luna0,zi0);decodedate(Date,an,luna,zi);
if (an>an0)or(luna>luna0)or(zi>zi0)then begin
   DeleteValue('15');DeleteValue('16');DeleteValue('17');
   mesaj('Perioada de test a programului a expirat',0);
   mainfrm.aboutMn.onClick(nil);exit;end;
if FirstTime then begin
   FirstTime:=false;nr:=ReadInteger('17');
   WriteInteger('17',nr-1);
   if nr<5 then mesaj('Mai puteti rula programul de '+inttostr(nr)+' ori',0);
   if nr-1<0 then begin
      DeleteValue('15');DeleteValue('16');DeleteValue('17');
      mesaj('Nu mai aveti dreptul sa rulati programul',0);exit;end;
   end;
Result:=true;
end;
finally reg.CloseKey;end;
end;
{-----------------------------------------------------}
function param(s:string;ind:integer):integer;
var i,k:integer;s1:string;
begin
s1:=paramS(s,ind);val(s1,i,k);
if k<>0 then Result:=-1977 else Result:=i;
end;
{-----------------------------------------------------}
function paramS(s:string;ind:integer):string;
var i,k:integer;par:array [1..10]of string;
begin i:=0;s:=s+' ';
while (s<>'')or(i<ind) do begin
      k:=Pos(',',s);if k=0 then k:=Pos('=',s);if k=0 then k:=Pos(':',s);
      if k=0 then k:=length(s);
      inc(i);par[i]:=copy(s,1,k-1);delete(s,1,k);
      end;
Result:=par[ind];
end;


end.
