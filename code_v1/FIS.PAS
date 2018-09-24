unit fis;

interface

procedure openFile(name:string;options:integer);
procedure saveFile(name:string;options:integer);
procedure FileLaunch(Senderu:string;Name:string;options:integer);
procedure FileFreeVar;

implementation

uses SysUtils,Dialogs,p,mainU2;

var
  _nrmat,_nrclas,_nrprof:integer;
  _matN:array[1..maxmat]of psirTip;
  _clasN:array[1..maxclas]of psirTip;
  _profN:array[1..maxprof]of psirTip;
  _matI:array[1..maxclas,1..maxmat]of pIntTip;
  _profI:array[1..maxclas,1..maxmat]of pIntTip;
  _clasI:array[1..maxclas,1..2]of pIntTip;
  _oreI:array[1..maxclas,1..maxmat]of pIntTip;
  _matNr:array[1..maxclas]of pIntTip;
  _pref:array[1..maxprof,1..maxzile,1..maxore]of pIntTip;
  _matR:array[1..maxclas,1..maxzile,1..maxore]of pIntTip;
  _profR:array[1..maxclas,1..maxzile,1..maxore]of pIntTip;
  _oremat:array[1..maxmat,1..2]of pIntTip;{nr ore consec mat}
  _dif:array[1..maxclas,1..maxore]of pIntTip;
  _sali:array[1..maxmat]of pIntTip;
  _cond:array[1..maxCond,1..2]of pIntTip;
  _oreZi:array[1..maxclas,1..maxzile]of pIntTip;
  _Mprofi:array[1..maxclas*maxmat,0..maxMprofi]of pIntTip;
  _Mgrup:array[1..maxclas*maxmat,0..maxMgrup]of pSirTip;
  _Mclas:array[1..maxclas*maxmat,0..maxMclas]of pIntTip;
  _Mmat:array[1..maxclas*maxmat,1..maxMmat]of pIntTip;

  _nrMprofi,_nrMclas,_nrMgrup,_nrMmat:integer;
  _workRez,_nrClasSel:integer;

{-----------------------------------------------------}
procedure FileFreeVar;
var m,n,z:integer;
begin
for m:=1 to maxmat do begin
    for n:=1 to 2 do ElibInt(oremat[m,n]);
    ElibSir(matN[m]);ElibInt(sali[m]);end;
for m:=1 to maxclas do begin ElibSir(clasN[m]);
    for n:=1 to maxore do ElibInt(dif[m,n]);
    ElibInt(clasI[m,1]);ElibInt(clasI[m,2]);ElibInt(matNr[m]);
    for n:=1 to maxzile do begin ElibInt(oreZi[m,n]);
        for z:=1 to maxore do begin
            ElibInt(matR[m,n,z]);ElibInt(profR[m,n,z]);end;
        end;
    for n:=1 to maxmat do begin
        ElibInt(matI[m,n]);ElibInt(profI[m,n]);ElibInt(oreI[m,n]);end;
    end;
for m:=1 to maxprof do begin ElibSir(profN[m]);
    for n:=1 to maxzile do for z:=1 to maxore do ElibInt(pref[m,n,z]);
    end;
for m:=1 to maxcond do begin ElibInt(cond[m,1]);ElibInt(cond[m,2]);end;
for m:=1 to maxmat*maxclas do for n:=0 to maxMprofi do ElibInt(Mprofi[m,n]);
end;
{-----------------------------------------------------}
procedure FreeTemp;
var m,n,z:integer;
begin
for m:=1 to maxmat do begin
    ElibInt(_oremat[m,1]);ElibInt(_oremat[m,2]);
    ElibSir(_matN[m]);ElibInt(_sali[m]);end;
for m:=1 to maxclas do begin ElibSir(_clasN[m]);ElibInt(_matNr[m]);
    for n:=1 to maxore do ElibInt(_dif[m,n]);
    ElibInt(_clasI[m,1]);ElibInt(_clasI[m,2]);
    for n:=1 to maxzile do begin ElibInt(_oreZi[m,n]);
        for z:=1 to maxore do begin
            ElibInt(_matR[m,n,z]);ElibInt(_profR[m,n,z]);end;
            end;
    for n:=1 to maxmat do begin
        ElibInt(_matI[m,n]);ElibInt(_profI[m,n]);ElibInt(_oreI[m,n]);end;
    end;
for m:=1 to maxprof do begin ElibSir(_profN[m]);
    for n:=1 to maxzile do for z:=1 to maxore do ElibInt(_pref[m,n,z]);
    end;
for m:=1 to maxcond do begin ElibInt(_cond[m,1]);ElibInt(_cond[m,2]);end;
for m:=1 to maxmat*maxclas do for n:=0 to maxMprofi do Elibint(_Mprofi[m,n]);
end;
{-----------------------------------------------------}
procedure saveFile;
var i,j,k:integer;s:string;
    f:textfile;
procedure endu;
begin writeln(f,'[END]');writeln(f);end;
begin
assignfile(f,name);
rewrite(f);
writeln(f,'CD');
writeln(f,'[GENERALE]');
writeln(f,'caracterizare='+caracterizare);
writeln(f,'ora start=',oraStart);
writeln(f,'numar zile=',nrzile);
writeln(f,'rezultate=',workRez);
with mainfrm.fontdlg.font do begin
     writeln(f,'fname=',name);
     writeln(f,'fsize=',size);
     writeln(f,'fcharset=',charset);
     writeln(f,'fcolor=',color);
//     writeln(f,'fstyle=',style);
     end;
Endu;
writeln(f,'[CLASE]');
for i:=1 to nrclas do writeln(f,clasN[i]^);Endu;
writeln(f,'[MATERII]');
for i:=1 to nrmat do writeln(f,matN[i]^);Endu;
writeln(f,'[PROFESORI]');
for i:=1 to nrprof do writeln(f,profN[i]^);Endu;
writeln(f,'[INDEX CLASE]');
for i:=1 to nrClasSel do writeln(f,clasI[i,1]^,',',clasI[i,2]^);Endu;
writeln(f,'[INDEX MATERII]');
for i:=1 to nrClasSel do begin writeln(f,'index clasa=',i);
    for j:=1 to matNr[i]^ do writeln(f,matI[i,j]^);
    end;Endu;
writeln(f,'[INDEX PROFESORI]');
for i:=1 to nrClasSel do begin writeln(f,'index clasa=',i);
    for j:=1 to matNr[i]^ do if profI[i,j]^>0 then writeln(f,profI[i,j]^)
        else begin write(f,profI[i,j]^);
        for k:=1 to Mprofi[abs(profI[i,j]^),0]^ do
            write(f,'=',Mprofi[abs(profI[i,j]^),k]^);
        writeln(f,'=');end;
    end;Endu;
writeln(f,'[NUMAR ORE]');
for i:=1 to nrClasSel do begin writeln(f,'index clasa=',i);
    for j:=1 to matNr[i]^ do writeln(f,oreI[i,j]^);
    end;Endu;
writeln(f,'[PREFERINTE]');
for i:=1 to nrprof do begin writeln(f,'index profesor=',i);
    for j:=1 to maxzile do for k:=1 to maxore do
        if pref[i,j,k]<>nil then if pref[i,j,k]^=1 then
           writeln(f,j,',',k);
    end;Endu;
writeln(f,'[TIP MATERII]');
for i:=1 to nrmat do begin
    writeln(f,'index materie=',i);
    if oremat[i,1]<>nil then s:=inttostr(oremat[i,1]^)else s:='1';
    if sali[i]<>nil then s:=s+','+inttostr(sali[i]^)else s:=s+',-1';
    if oremat[i,2]<>nil then s:=s+','+inttostr(oremat[i,2]^)else s:=s+',1';
    writeln(f,s);end;Endu;
writeln(f,'[CONDITII]');
for i:=1 to maxcond do begin writeln(f,'nr conditie=',i);
    if cond[i,1]<>nil then write(f,cond[i,1]^);
    if cond[i,2]<>nil then writeln(f,',',cond[i,2]^);
    end;Endu;
writeln(f,'[ORE PE ZI]');
for i:=1 to nrClasSel do begin writeln(f,'index clasa=',i);
    for j:=1 to maxzile do writeln(f,oreZi[i,j]^);
    end;Endu;
writeln(f,'[DIFICULTATE]');
for i:=1 to nrClasSel do begin writeln(f,'index clasa=',i);
    for j:=1 to maxore do if (dif[i,j]<>nil)and(dif[i,j]^<>1)then
        writeln(f,i,',',j,':',dif[i,j]^);
    end;Endu;
writeln(f,'[MPROFI]');
for i:=1 to nrMprofi do begin
    for j:=0 to Mprofi[i,0]^ do write(f,Mprofi[i,j]^,',');
    writeln(f);end;Endu;
writeln(f,'[MMAT]');
for i:=1 to nrMmat do begin write(f,maxMmat,',');
    for j:=1 to maxMmat do write(f,Mmat[i,j]^,',');
    writeln(f);end;Endu;
writeln(f,'[MGRUP]');
for i:=1 to nrMgrup do begin
    for j:=0 to strtoint(Mgrup[i,0]^) do write(f,Mgrup[i,j]^,',');
    writeln(f);end;Endu;
writeln(f,'[MCLAS]');
for i:=1 to nrMclas do begin
    for j:=0 to Mclas[i,0]^ do write(f,Mclas[i,j]^,',');
    writeln(f);end;Endu;
if workRez=0 then begin
writeln(f,'[ORAR]');
for i:=1 to nrClasSel do begin writeln(f,'index clasa=',i);
    for j:=1 to maxzile do for k:=1 to maxore do
        if matR[i,j,k]^<>0 then writeln(f,j,',',k,':',matR[i,j,k]^);
    end;Endu;
end;
closefile(f);mesaj('Orarul a fost salvat',0);
end;

procedure openFile;
var f:textfile;s:string;
    _caracterizare:string;
    _orastart,_nrzile:integer;
    m,n,z:integer;

procedure genProc;
var p:integer;s0,s1,s2:string;
begin
repeat
readln(f,s0);p:=pos('=',s0);
if p<>0 then begin s1:=copy(s0,1,p-1);
   s2:=copy(s0,p+1,length(s0)-p);
   if s1='caracterizare' then _caracterizare:=s2;
   if s1='ora start' then _orastart:=strtoint(s2);
   if s1='numar zile' then _nrzile:=strtoint(s2);
   if s1='rezultate'then _workRez:=strtoint(s2);
   with mainfrm.fontdlg.font do begin
   if s1='fname' then name:=s2;
   if s1='fsize' then size:=strtoint(s2);
   if s1='fcharset'then charset:=strtoint(s2);
//   if s1='fstyle'then style:=strtoint(s2);
   if s1='fcolor'then color:=strtoint(s2);
   end;
   end;
until s0='[END]';
end;

procedure cmpProc;
var i:integer;s1:string;
begin
i:=0;
repeat
readln(f,s1);
if s1<>'[END]' then begin inc(i);
   if s='[CLASE]' then initSir(_clasN[i],s1);
   if s='[MATERII]' then initSir(_matN[i],s1);
   if s='[PROFESORI]' then initSir(_profN[i],s1);
   end;
until s1='[END]';
if s='[CLASE]'then _nrclas:=minim(i,veri1+veri2);
if s='[MATERII]'then _nrmat:=i;
if s='[PROFESORI]'then _nrprof:=i;
end;

procedure iclasProc;
var i:integer;s1:string;
begin i:=0;
repeat
readln(f,s1);
if s1<>'[END]' then begin inc(i);initInt(_clasI[i,1],param(s1,1));
   initInt(_clasI[i,2],param(s1,2));end;
until s1='[END]';
_nrClasSel:=minim(i,veri1+veri2);
end;

procedure impoProc;
var i,j,p,t:integer;s1,s2:string;
begin
i:=0;j:=0;
repeat
readln(f,s1);p:=pos('=',s1);
if p<>0 then begin
   if (s='[INDEX PROFESORI]')and(s1[1]='-') then begin
      inc(_nrMprofi);inc(i);
      if _profI[j,i]=nil then new(_profI[j,i]);
      _profI[j,i]^:=strtoint(copy(s1,1,pos('=',s1)-1));
      delete(s1,1,pos('=',s1));t:=0;
      while pos('=',s1)>0 do
            begin
            inc(t);
            if _Mprofi[-_profI[j,i]^,t]=nil then new(_Mprofi[-_profI[j,i]^,t]);
            _Mprofi[-_profI[j,i]^,t]^:=strtoint(copy(s1,1,pos('=',s1)-1));
            delete(s1,1,pos('=',s1));
            end;
      new(_Mprofi[-_profI[j,i]^,0]);_Mprofi[-_profI[j,i]^,0]^:=t;
      end
   else begin
   if s='[INDEX MATERII]'then if j<>0 then initInt(_matNr[j],i);
   s2:=copy(s1,p+1,length(s1)-p);
   j:=strtoint(s2);i:=0;end;
   end
else if s1<>'[END]' then begin inc(i);
   if s='[INDEX MATERII]' then initInt(_matI[j,i],strtoint(s1));
   if s='[INDEX PROFESORI]' then initInt(_profI[j,i],strtoint(s1));
   if s='[NUMAR ORE]' then initInt(_oreI[j,i],strtoint(s1));
   if s='[CONDITII]' then begin initInt(_cond[j,1],param(s1,1));
      initInt(_cond[j,2],param(s1,2));end;
   if s='[ORE PE ZI]'then initInt(_oreZi[j,i],strtoint(s1));
   end;
until s1='[END]';
if s='[INDEX MATERII]'then initInt(_matNr[j],i);
end;

procedure prefProc;
var p,index,zi,ora,mat,mat2prof,i:integer;s1:string;
begin
p:=0;repeat
if p=0 then readln(f,s1);p:=pos('=',s1);
if p<>0 then begin index:=param(s1,2);
   repeat readln(f,s1);p:=Pos(',',s1);
   if p<>0 then begin
      zi:=param(s1,1);ora:=param(s1,2);
      if s='[ORAR]' then begin mat:=param(s1,3);
         initInt(_matR[index,zi,ora],mat);mat2prof:=0;
         for i:=1 to _matNr[index]^ do if _matI[index,i]^=mat then
             begin mat2prof:=_profI[index,i]^;break;end;
         initInt(_profR[index,zi,ora],mat2prof);
         end;
      if s='[PREFERINTE]' then initInt(_pref[index,zi,ora],1);
      if s='[DIFICULTATE]' then begin
         initInt(_dif[param(s1,1),param(s1,2)],param(s1,3));
         end;
      end;
   until p=0;p:=1;end;
until s1='[END]';
end;

procedure tmatProc;
var p,m,i:integer;s1:string;
begin p:=0;repeat
if p=0 then readln(f,s1);p:=pos('=',s1);
if p<>0 then begin m:=param(s1,2);
   repeat readln(f,s1);p:=pos(',',s1);
   if p<>0 then begin
      initInt(_oremat[m,1],param(s1,1));initInt(_sali[m],param(s1,2));
      i:=param(s1,3);if i>1 then initInt(_oremat[m,2],i);end;
   until p=0;p:=1;end;
until s1='[END]';
end;

procedure Mproc;
var i,j:integer;s1:ansistring;
begin
repeat
readln(f,s1);if s1='[END]'then exit;
if s='[MPROFI]'then begin inc(_nrMprofi);j:=param(s1,1);
   for i:=0 to j do InitInt(_Mprofi[_nrMprofi,i],param(s1,i+1));
   end;
if s='[MCLAS]'then begin inc(_nrMclas);j:=param(s1,1);
   for i:=0 to j do InitInt(_Mclas[_nrMclas,i],param(s1,i+1));
   end;
if s='[MMAT]'then begin inc(_nrMmat);j:=param(s1,1);
   for i:=1 to j do InitInt(_MMat[_nrMmat,i],param(s1,i+1));
   end;
if s='[MGRUP]'then begin inc(_nrMgrup);j:=param(s1,1);
   for i:=0 to j do InitSir(_Mgrup[_nrMgrup,i],paramS(s1,i+1));
   end;
until 1=2;
end;

begin
assignfile(f,name);{$i-}reset(f);{$i+}
if ioresult<>0 then begin
   MessageDlg('File not found !',mterror, [mbOk] , 0);
   freeTemp;exit;end;
readln(f,s);if s<>'CD' then begin
   MessageDlg('Wrong file format !',mterror, [mbOk] , 0);
   closefile(f);exit;end;
_caracterizare:='Default';_oraStart:=0;_Nrzile:=0;
_nrclas:=0;_nrprof:=0;_nrmat:=0;_workrez:=0;
_nrMprofi:=0;_nrMclas:=0;_nrMgrup:=0;_nrMmat:=0;
while not eof(f)do
begin
readln(f,s);
if s='[GENERALE]' then genProc;
if s='[CLASE]'then cmpProc; {ClaseMateriiProfesori}
if s='[MATERII]'then cmpProc;
if s='[PROFESORI]'then cmpProc;
if s='[INDEX CLASE]'then iclasProc;
if s='[INDEX MATERII]'then impoProc;{indexMateriiProfesoriOre}
if s='[INDEX PROFESORI]'then impoProc;
if s='[NUMAR ORE]'then impoProc;
if s='[PREFERINTE]'then prefProc;
if s='[TIP MATERII]'then tmatProc;
if s='[CONDITII]'then impoProc;
if s='[ORE PE ZI]'then impoProc;
if s='[DIFICULTATE]'then prefProc;
if (s='[MPROFI]')or(s='[MCLAS]')or(s='[MGRUP]')or(s='[MMAT]')then begin
   if s='[MPROFI]'then _nrMprofi:=0;
   Mproc;end;
if _workRez=0 then if s='[ORAR]'then prefProc;
end;{while}
closefile(f);
caracterizare:=_caracterizare;
oraStart:=_oraStart;NrZile:=_NrZile;
workRez:=_workRez;
FileFreeVar;DoOreZi:=false;
NrClasSel:=_nrClasSel;
nrclas:=_nrclas;nrprof:=_nrprof;nrmat:=_nrmat;
nrMprofi:=_nrMprofi;nrMmat:=_nrMmat;nrMgrup:=_nrMgrup;nrMclas:=_nrMclas;
for m:=1 to nrclas do initSir(clasN[m],_clasN[m]^);
for m:=1 to nrprof do initSir(profN[m],_profN[m]^);
for m:=1 to nrmat do initSir(matN[m],_matN[m]^);
for m:=1 to NrClasSel do begin
    for n:=1 to maxore do if _dif[m,n]<>nil then initInt(dif[m,n],_dif[m,n]^);
    initInt(matNr[m],_matNr[m]^);
    initInt(clasI[m,1],_clasI[m,1]^);
    initInt(clasI[m,2],_clasI[m,2]^);
    for n:=1 to matNr[m]^ do begin
        initInt(matI[m,n],_matI[m,n]^);
        initInt(profI[m,n],_profI[m,n]^);
        initInt(oreI[m,n],_oreI[m,n]^);end;
     end;
for m:=1 to nrprof do for n:=1 to maxzile do for z:=1 to maxore do
    if _pref[m,n,z]<>nil then initInt(pref[m,n,z],_pref[m,n,z]^);
for m:=1 to nrmat do begin
    if _oremat[m,1]<>nil then initInt(oremat[m,1],_oremat[m,1]^)
       else initInt(oremat[m,1],1);
    if _oremat[m,2]<>nil then initInt(oremat[m,2],_oremat[m,2]^);
    initInt(sali[m],_sali[m]^);
    end;
for m:=1 to maxcond do
    if _cond[m,1]<>nil then begin
       initInt(cond[m,1],_cond[m,1]^);
       initInt(cond[m,2],_cond[m,2]^);end;
for m:=1 to nrclas do for n:=1 to maxzile do
    if _oreZi[m,n]<>nil then begin
       initInt(oreZi[m,n],_oreZi[m,n]^);DoOreZi:=true;end
    else initInt(oreZi[m,n],0);
for m:=1 to nrclas do for n:=1 to maxzile do for z:=1 to maxore do
    begin
    if _matR[m,n,z]=nil then initInt(matR[m,n,z],0)
       else initInt(matR[m,n,z],_matR[m,n,z]^);
    if _profR[m,n,z]=nil then initInt(profR[m,n,z],0)
       else initInt(profR[m,n,z],_profR[m,n,z]^);
    end;
for m:=1 to nrMprofi do
    for n:=0 to _Mprofi[m,0]^ do initInt(Mprofi[m,n],_Mprofi[m,n]^);
for m:=1 to nrMmat do
    for n:=1 to maxMmat do initInt(Mmat[m,n],_Mmat[m,n]^);
for m:=1 to nrMclas do
    for n:=0 to _Mclas[m,0]^ do initInt(Mclas[m,n],_Mclas[m,n]^);
for m:=1 to nrMgrup do
    for n:=0 to strtoint(_Mgrup[m,0]^) do initSir(Mgrup[m,n],_Mgrup[m,n]^);
FreeTemp;
end;

procedure FileLaunch(Senderu:string ;Name:string;options:integer);
begin
if upperCase(senderu)=upperCase('OpenDlg') then openFile(name,options);
if upperCase(senderu)=upperCase('SaveDlg') then saveFile(name,options);
end;

end.
