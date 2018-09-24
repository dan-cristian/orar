unit r;

interface
uses p;

const
     maxpoz=100;maxpoz2=2;
     Poz_Free=0;Poz_NoFree=1;Poz_NoMesaj=2;//putPoz
     Poz_Del=1;Poz_NoDel=0;                //memPoz
     Poz_Empty=0;Poz_Fill=1;Poz_After=2;Poz_Fix=3;Poz_Multi=4;//delPoz
     Ver_Mes=0;Ver_NoMes=1;Ver_List=2;

type
Trez=class(TObject)
  tryDepth,MaxAloc,LastAloc:integer;
  consec,beforeDepth:integer;
  private
    Poz:array[1..maxpoz,1..maxpoz2]of pIntTip;
    procedure Pun(indClas,indMat,zi,ora,opt:integer);
    function  MemPoz(indClas,zi,ora,how:integer):integer;
    function  PutPoz(indClas,zi,ora,how,index:integer):integer;
    procedure FreePoz(index:integer);
    procedure Limits(indClas,zi,ora:integer;var i1,i2:integer);
  public
    function  DelPoz(indClas,zi,ora,how:integer):integer;
    function  blankPoz(indClas,zi,ora:integer):boolean;
    function  tryPutFix(indClas,indMat,zi,ora,opt,nuIndMat,nuZi,nuOra,nuOra1,lung,depth:integer):integer;
    function  trybeforePutFix(indClas,indMat,zi,ora,opt:integer):integer;
    function  Put(indClas,indMat,zi,ora,opt,nr:integer;Can:boolean):integer;
    function  AllPut(indClas,indMat,opt,nuZi,nuOra,nuOra1:integer):integer;
    function  tryPut(indClas,indMat,opt,nuZi,nuOra,nuOra1:integer):integer;
    function  trybeforePut(indClas,indMat,opt:integer):integer;
    function  forcePut(indClas,indMat,zi,ora,opt:integer):integer;
    function  move(indClas,zi1,ora1,zi2,ora2,opt:integer;canMove:boolean):integer;
    function  switch(indClas,zi1,ora1,zi2,ora2,opt:integer;canSwitch:boolean):integer;
    function  verifica(indClas,option:integer):integer;
    function  PutAllMat(indClas,opt:integer):integer;
    function  makeOrar:integer;
    procedure InitVar;
    function  canPut(indClas,indMat,zi,ora:integer):integer;
    constructor Create;
    procedure FreeTemp;
  end;

TnoMove=set of 0..255;
const noMove=[9,15,16];

var
   Rez:Trez;

implementation

uses workU2,resultU2,sysutils,forms,dialogs;

{-----------------------------------------------------}
constructor Trez.create;
begin
inherited Create;
tryDepth:=1;
beforeDepth:=500;
end;
{-----------------------------------------------------}
procedure Trez.Limits(indClas,zi,ora:integer;var i1,i2:integer);
var mat,i:integer;
begin
mat:=_matR[indClas,zi,ora]^;
if (mat=0)or(oremat[getMatI(mat),1]^=1)or(consec=0)then begin i1:=ora;i2:=ora;exit;end;
for i:=ora downto 1 do if _matR[indClas,zi,i]^<>mat then break;
i1:=i+1;//ajustare
for i:=ora to OreZi[indclas,zi]^ do if _matR[indClas,zi,i]^<>mat then break;
i2:=i-1;
end;
{-----------------------------------------------------}
function TRez.blankPoz(indClas,zi,ora:integer):boolean;
begin
Result:=False;
    if (_matR[indClas,zi,ora]^*_profR[indClas,zi,ora]^<>0) then exit;
    if (_matR[indClas,zi,ora]^+_profR[indClas,zi,ora]^<>0)then begin
       mesaj('incorect, doar mat sau prof e liber',Mes_OK);exit;end;
Result:=True;
end;
{-----------------------------------------------------}
procedure Trez.Pun(indClas,indMat,zi,ora,opt:integer);
var i,j:integer;
begin
i:=_matI[indClas,indMat]^;j:=_profI[indClas,indMat]^;
_matR[indClas,zi,ora]^:=i;_profR[indClas,zi,ora]^:=j;
dec(_restOre[indClas,indMat]^);
if _restOre[indClas,indMat]^<0 then
   mesaj('ore ramase < 0 la '+GetMat(indMat,1,indClas),Mes_OK);
end;
{-----------------------------------------------------}
procedure Trez.FreePoz(index:integer);
var i:integer;
begin if index=0 then begin mesaj('index la poz=0',Mes_OK);exit;end;
for i:=1 to maxpoz2 do ElibInt(Poz[index,i]);
end;
{-----------------------------------------------------}
function Trez.MemPoz(indClas,zi,ora,how:integer):integer;
var i,indMat:integer;
begin
indMat:=_mat2ind(indClas,_matR[indClas,zi,ora]^);
if indMat=0 then begin
   if not blankPoz(indClas,zi,ora)then mesaj('indMat=0 dar mat sau prof<>0',Mes_OK);
   Result:=0;exit;end;
for i:=1 to maxpoz do if Poz[i,1]=nil then begin
    initInt(Poz[i,1],_matR[indClas,zi,ora]^);
    if how=Poz_Del then initInt(Poz[i,2],delPoz(indClas,zi,ora,Poz_Fill))
       else initInt(Poz[i,2],0);
    MaxAloc:=maxim(MaxAloc,i);LastAloc:=i;
    Result:=i;exit;end;
Result:=-1;mesaj('nu mai pot aloca la MemPoz',0);
end;
{-----------------------------------------------------}
function Trez.PutPoz(indClas,zi,ora,how,index:integer):integer;
var indMat:integer;
function Pune(_ora:integer):integer;
begin
if not blankPoz(indClas,zi,_ora)then mesaj('se acopera ceva cu PutPoz',Mes_OK);
indMat:=_mat2ind(indClas,Poz[index,1]^);
Result:=Put(indClas,indMat,zi,_ora,-1,Poz[index,2]^,True);
if indMat=0 then mesaj('indMat=0 dar index<>0',0);
end;
begin
Result:=-1;if index=0 then mesaj('index la poz=0',Mes_OK);
if Poz[index,1]<>nil then begin Result:=Pune(ora);
   if (Result<>0)and(how<>Poz_NoMesaj)then mesaj('nu pot restaura',0);
   if (how=Poz_Free)or(how=Poz_NoMesaj)then FreePoz(index);exit;end;
mesaj('la PutPoz am nil',0);
end;
{-----------------------------------------------------}
function Trez.DelPoz(indClas,zi,ora,how:integer):integer;
var indMat,mat,i1,i2,i:integer;
procedure sterg(_ora:integer);
var indClas0,indMat0,cls,j,dest:integer;
begin
if {(how=Poz_Multi)and}(mat<0)and(Mmat[-mat,2]^=3)then begin
   cls:=Mmat[-mat,4]^;
   for j:=1 to Mclas[cls,0]^ do begin indClas0:=Mclas[cls,j]^;
       dest:=_matR[indClas0,zi,_ora]^;indMat0:=_mat2ind(indClas0,mat);
       if (dest<0)and(Mmat[-dest,1]^in[MMat[-mat,1]^,0])then begin
          case how of Poz_Fill,Poz_Fix,Poz_After,Poz_Multi:inc(_restOre[indClas0,indMat0]^);
               end;//case
          _matR[indClas0,zi,_ora]^:=0;_profR[indClas0,zi,_ora]^:=0;
          displayrez(indclas,' ');
          end;
       end;
end
else begin case how of
    Poz_Fill,Poz_Fix,Poz_After:inc(_restOre[indClas,indMat]^);
    end;//case
    _matR[indClas,zi,_ora]^:=0;_profR[indClas,zi,_ora]^:=0;
    displayrez(indclas,' ');end;
end;

begin Result:=0;
mat:=_matR[indClas,zi,ora]^;indMat:=_mat2ind(indClas,mat);
if indMat=0 then begin mesaj('Sterg gol',Mes_OK);exit;end;
if (oremat[getMatI(mat),1]^=1)or(consec=0)then Sterg(ora) else begin
   Limits(indClas,zi,ora,i1,i2);
   case how of
   Poz_After:         i1:=ora;
   Poz_Fix,Poz_Multi: begin i1:=ora;i2:=ora;end;
   end;//case
   for i:=i1 to i2 do begin Sterg(i);inc(Result);end;end;
end;
{--------------------------------------------------------------------}
function TRez.Put(indClas,indMat,zi,ora,opt,nr:integer;Can:boolean):integer;
var i,j,mat,sauPus,nrPus:integer;
function Pune(_ora:integer):integer;
var k,indClas0,indMat0,cls,grp,More:integer;
function putFirst:integer;
begin
Result:=canPut(indClas,indMat,zi,_ora);
if Result=0 then begin inc(sauPus);Pun(indClas,indMat,zi,_ora,opt);DisplayRez(indClas,' ');end;
end;
begin Result:=-1;nrPus:=1;
if mat<0 then begin
   case Mmat[-mat,2]^ of
   3: begin cls:=MMat[-mat,4]^;
      nrPus:=Mclas[cls,0]^;
      for k:=1 to nrPus do begin
       indClas0:=Mclas[cls,k]^;indMat0:=_mat2ind(indClas0,mat);
       Result:=canPut(indClas0,indMat0,zi,_ora);
       if Result=0 then begin Pun(indClas0,indMat0,zi,_ora,opt);
          inc(sauPus);DisplayRez(indClas0,' ');end
          else if Result<>0 then break;
       end;
       exit;end;
   2: begin
      //grp:=MMat[-mat,3]^;
      _ora:=Mmat[-mat,5]^;if _ora=-1 then _ora:=OreZi[indClas,zi]^+1;
      if consec=0 then More:=1 else More:=oreMat[getMatI(mat),1]^;
      for k:=_ora to maxore-More+1 do
          if blankPoz(indclas,zi,k)then begin _ora:=k;break;end;
      end;
   end;//case
   end;
Result:=putFirst;
end;
begin Result:=-1;sauPus:=0;
if indMat=0 then begin mesaj('pun nimic la Put',Mes_OK);exit;end;
mat:=_matI[indClas,indMat]^;
if (oremat[getMatI(mat),1]^=1)or(consec=0)then begin Result:=Pune(ora);
   if ((Result<>0)or(not Can))and(saupus>0)then delPoz(indClas,zi,ora,Poz_Fix);
   end else begin
   if nr=0 then nr:=minim(oremat[getMatI(mat),1]^,_restore[indClas,indMat]^);
   if ora+nr-1>OreZi[indClas,zi]^ then begin Result:=14;exit;end;
   for i:=1 to nr do begin Result:=Pune(ora+i-1);if Result<>0 then break;end;
   if (Result<>0)or(not Can)then for j:=1 to i-1 do//ajustare
      if (not blankPoz(indClas,zi,ora+j-1))and(sauPus/nrPus>=j-1) then
         delPoz(indClas,zi,ora+j-1,Poz_Fix);
   end;
end;
{-----------------------------------------------------}
function TRez.AllPut(indClas,indMat,opt,nuZi,nuOra,nuOra1:integer):integer;
var zi,ora:integer;
begin
Result:=0;if indMat=0 then begin mesaj('pun nimic la AllPut',Mes_OK);Result:=-1;exit;end;
{for zi:=1 to maxzile do for ora:=1 to OreZi[indClas,zi]^ do
    if (zi<>nuZi)or(ora<nuOra)or(ora>nuOra+nuOra1-1)then
    if Put(indClas,indMat,zi,ora,opt,0,True)=0 then exit;
}
for ora:=1 to maxore do for zi:=1 to maxzile do
    if ora<=OreZi[indClas,zi]^ then
      if (zi<>nuZi)or(ora<nuOra)or(ora>nuOra+nuOra1-1)then
         if Put(indClas,indMat,zi,ora,opt,0,True)=0 then exit;
Result:=-1;
end;
{-----------------------------------------------------}
function TRez.tryPutFix(indClas,indMat,zi,ora,opt,
         nuIndMat,nuZi,nuOra,nuOra1,lung,depth:integer):integer;
var zi1,ora1,tmp:integer;
    i:integer;m:array[0..maxore-1,1..5]of integer;
begin
Result:=Put(indClas,indMat,zi,ora,opt,0,True);
if (Result=0)or(depth=0)then exit;
for i:=0 to maxore-1 do for tmp:=1 to 5 do m[i,tmp]:=-1;
if not blankPoz(indClas,zi,ora)then begin
   try
   for i:=0 to lung-1 do
       if not blankPoz(indClas,zi,ora+i)then begin tmp:=0;
          Limits(indClas,zi,ora+i,m[i,2],tmp);
          m[i,3]:=_mat2ind(indClas,_matR[indClas,zi,m[i,2]]^);
          if nuIndMat=m[i,3] then exit;//sa nu inverseze aceleasi materii
          if indMat=m[i,3] then exit;
          m[i,1]:=memPoz(indClas,zi,m[i,2],Poz_del);
          if m[i,1]<1 then begin mesaj('nu mai am memorie, trebe freePoz',Mes_OK);exit;end;
          tmp:=-1977;
          end;
   finally if tmp<>-1977 then
          for i:=0 to lung-1 do if m[i,1]<>-1 then //blankPoz(indClas,zi,m[i,2]+i) then
              putPoz(indClas,zi,m[i,2],Poz_Free,m[i,1]);
          end;
   Result:=Put(indClas,indMat,zi,ora,opt,0,True);
   if Result=0 then begin
      for i:=0 to lung-1 do begin
          if m[i,3]=-1 then begin Result:=0;break;end;
          tmp:=minim(oremat[getMatI(_matI[indClas,m[i,3]]^),1]^,_restore[indClas,m[i,3]]^);
          for zi1:=1 to maxzile do begin
              for ora1:=1 to OreZi[indClas,zi1]^ do
                  if (zi1<>zi)or(ora1<ora)or(ora1>ora+lung-1)then begin
                     Result:=tryPutFix(indClas,m[i,3],zi1,ora1,opt,nuIndMat,nuZi,nuOra,nuOra1,tmp,depth-1);
                     if Result=0 then begin m[i,4]:=zi1;m[i,5]:=ora1;break;end;
                     Result:=-1;
                     end;
              if Result=0 then break;
              end;
          if Result<>0 then break;
          end;
      if Result=0 then begin for i:=0 to lung-1 do if m[i,1]<>-1 then freePoz(m[i,1]);
                             exit;end;
      for i:=0 to lung-1 do if not blankPoz(indClas,zi,ora+i)then
          delPoz(indClas,zi,ora+i,Poz_Fill);
      for i:=0 to lung-1 do if m[i,4]<>-1 then
          delPoz(indClas,m[i,4],m[i,5],Poz_Fill);
      end;
   for i:=0 to lung-1 do if m[i,1]<>-1 then
       putPoz(indClas,zi,m[i,2],Poz_Free,m[i,1]);
   end;
end;
{-----------------------------------------------------}
function TRez.tryPut(indClas,indMat,opt,nuZi,nuOra,nuOra1:integer):integer;
var zi,ora,lung:integer;                   //0   ,0 cand nu am restrictie
begin
Result:=AllPut(indClas,indMat,opt,nuZi,nuOra,nuOra1);if Result=0 then exit;
//if indclas=11 then rezfrm.pascheck.checked:=true;
if indMat=0 then begin mesaj('pun nimic la tryPut',Mes_OK);exit;end;
lung:=minim(oremat[getMatI(_matI[indClas,indMat]^),1]^,_restore[indClas,indMat]^);
if consec=0 then lung:=1;
{for zi:=1 to maxzile do for ora:=1 to OreZi[indClas,zi]^ do
    if (zi<>nuZi)or(ora<nuOra)or(ora>nuOra+nuOra1-1)then begin
    Result:=tryPutFix(indClas,indMat,zi,ora,opt,indMat,nuZi,nuOra,nuOra1,lung,rez.tryDepth);
    if Result=0 then exit;
    end;}
for ora:=1 to maxore do for zi:=1 to maxzile do
    if ora<=OreZi[indClas,zi]^ then
       if (zi<>nuZi)or(ora<nuOra)or(ora>nuOra+nuOra1-1)then begin
          Result:=tryPutFix(indClas,indMat,zi,ora,opt,indMat,nuZi,nuOra,nuOra1,lung,rez.tryDepth);
          if Result=0 then exit;
          end;
end;
{-----------------------------------------------------}
function TRez.trybeforePutFix(indClas,indMat,zi,ora,opt:integer):integer;
var mem,indmat1,nuOra1,_errClas,_errZi,_errOra,i1,i2,count:integer;
    lClas,lZi,lOra:integer;
begin
lClas:=-1;lZi:=-1;lOra:=-1;
if not blankPoz(indClas,zi,ora) then begin Result:=-1;
   indmat1:=_mat2ind(indClas,_matR[indClas,zi,ora]^);
   if indmat=indmat1 then exit;Limits(indClas,zi,ora,i1,i2);
   mem:=rez.memPoz(indClas,zi,i1,Poz_del);if mem<1 then exit;
   //Result:=tryBeforePutFix(indClas,indMat1,zi,ora,opt);
   Result:=tryPut(indClas,indMat1,opt,zi,ora,1);// imbunatateste !
   if Result<>0 then begin PutPoz(indClas,zi,i1,Poz_Free,mem);exit;end;
   freePoz(mem);end;
count:=0;
repeat
Result:=Put(indClas,indMat,zi,ora,opt,0,True);
if (Result=0)or(Result in noMove)or(Result=14)then exit;
inc(count);if count>beforeDepth then exit;
if Result<0 then mesaj('result<0',Mes_OK);
_errClas:=errClas;_errZi:=errZi;_errOra:=errOra;
if (lClas=_errClas)and(lZi=_errZi)and(lOra=_errOra)then exit;
lClas:=_errClas;lZi:=_errZi;lOra:=_errOra;
indMat1:=_mat2ind(_errClas,_matR[_errClas,_errZi,_errOra]^);
if indMat1=0 then mesaj('la before am indmat=0',0);
Limits(_errClas,_errZi,_errOra,i1,i2);
mem:=rez.memPoz(_errClas,_errZi,i1,Poz_Del);if mem<1 then exit;
nuOra1:=minim(oremat[getMatI(_matI[indClas,indMat]^),1]^,_restore[indClas,indMat]^);
if consec=0 then nuOra1:=1;
Result:=tryPut(_errClas,indMat1,opt,_errZi,_errOra,nuOra1);//se poate imbunatati !!
if Result<>0 then begin putPoz(_errClas,_errZi,i1,Poz_Free,mem);exit;end;
FreePoz(mem);
until False;
end;
{-----------------------------------------------------}
function TRez.trybeforePut(indClas,indMat,opt:integer):integer;
var zi,ora:integer;
begin
Result:=-1;
{for zi:=1 to maxzile do for ora:=1 to OreZi[indClas,zi]^ do
    if _mat2ind(indClas,_matR[indclas,zi,ora]^)<>indmat then begin
    Result:=trybeforePutFix(indClas,indMat,zi,ora,opt);
    if Result=0 then exit;
    end;}
for ora:=1 to maxore do for zi:=1 to maxzile do
    if ora<=OreZi[indClas,zi]^ then
       if _mat2ind(indClas,_matR[indclas,zi,ora]^)<>indmat then begin
       Result:=trybeforePutFix(indClas,indMat,zi,ora,opt);
       if Result=0 then exit;
       end;
end;
{-----------------------------------------------------}
function TREz.forcePut(indClas,indMat,zi,ora,opt:integer):integer;
begin
result:=-1;
end;
{------------------------------------------------------------}
function TRez.move(indClas,zi1,ora1,zi2,ora2,opt:integer;canMove:boolean):integer;
var indmat1,mem1,i1,i2:integer;
begin Result:=-1;
if blankPoz(indClas,zi1,ora1)then mesaj('move blank',Mes_OK);
if not blankPoz(indClas,zi2,ora2)then begin mesaj('destination not blank',0);exit;end;
indMat1:=_mat2ind(indclas,_matR[indclas,zi1,ora1]^);
Limits(indClas,zi1,ora1,i1,i2);
mem1:=memPoz(indClas,zi1,i1,Poz_Del);if mem1<1 then exit;
Result:=Put(indClas,indmat1,zi2,ora2,opt,i2-i1+1,True);
if Result=0 then begin
   if canMove then begin freePoz(mem1);exit;end;
   delPoz(indClas,zi2,ora2,Poz_Fill);
   end;
putPoz(indClas,zi1,i1,Poz_Free,mem1);
end;
{------------------------------------------------------------}
function TRez.switch(indClas,zi1,ora1,zi2,ora2,opt:integer;CanSwitch:boolean):integer;
var mem1,mem2,indmat1,indmat2,i1,i2,j1,j2:integer;
begin
Result:=-1;if (zi1=zi2)and(ora1=ora2)then exit;
if blankPoz(indClas,zi2,ora2)then begin
   Result:=move(indclas,zi1,ora1,zi2,ora2,opt,CanSwitch);
   exit;end
else begin
     indmat1:=_mat2ind(indclas,_matR[indclas,zi1,ora1]^);
     indmat2:=_mat2ind(indclas,_matR[indclas,zi2,ora2]^);
     //if (indmat1=indmat2)and(zi1<>zi2)then exit;
     Limits(indClas,zi1,ora1,i1,i2);Limits(indClas,zi2,ora2,j1,j2);
     mem1:=memPoz(indClas,zi1,i1,Poz_Del);if mem1=-1{<1} then exit;
     mem2:=memPoz(indClas,zi2,j1,Poz_Del);if mem2=-1 then begin mesaj('ioi, poz ne-free',Mes_OK);exit;end;
                                               //if zero si consec atunci ok
     if mem1<>0 then Result:=Put(indClas,indmat1,zi2,ora2,opt,0,True);
     if (mem1=0)or (Result=0) then begin
        if mem2<>0 then Result:=Put(indClas,indMat2,zi1,ora1,opt,0,True);
        if (Result=0)or(mem2=0) then begin
           if canSwitch then begin Result:=0;if mem1<>0 then freePoz(mem1);
                             if mem2<>0 then freePoz(mem2);exit;end;
           if mem2<>0 then delPoz(indClas,zi1,ora1,Poz_Fill);
           end;
        {}if mem1<>0 then {}delPoz(indClas,zi2,ora2,Poz_Fill);
        end;
     if mem1<>0 then putPoz(indClas,zi1,i1,Poz_Free,mem1);
     if mem2<>0 then putPoz(indClas,zi2,j1,Poz_Free,mem2);
     end;
end;
{-----------------------------------------------------}
function Trez.verifica(indClas,option:integer):integer;
var s1,s2,mat,indMat,i,j,k,m,mem,i1,i2:integer;mes:word;
begin Result:=0;
if indClas=0 then begin s1:=1;s2:=nrclassel;end else begin s1:=indClas;s2:=s1;end;
if _restore[1,1]=nil then begin workFRM.InitTemp;
   if workrez=0 then for i:=1 to nrclasSel do for j:=1 to maxzile do
   for k:=1 to maxore do begin
   InitInt(_matR[i,j,k],matR[i,j,k]^);InitInt(_profR[i,j,k],profR[i,j,k]^);
   if matR[i,j,k]^<>0 then dec(_restOre[i,mat2ind(i,matR[i,j,k]^)]^);
   end;end;
if option=Ver_List then begin PutEroare(0,0,0,0,0);//sterge lista
   for i:=s1 to s2 do for j:=1 to matNr[i]^ do
       if _restore[i,j]^<>0 then PutEroare(i,0,0,j,-1);
   end;
for i:=s1 to s2 do for j:=1 to maxzile do for k:=1 to oreZi[i,j]^ do
if not blankPoz(i,j,k)then begin
mat:=_matR[i,j,k]^;indMat:=_mat2ind(i,mat);
Limits(i,j,k,i1,i2);mem:=MemPoz(i,j,i1,Poz_Del);
Result:=PutPoz(i,j,i1,Poz_NoMesaj,mem);
if Result<>0 then begin mes:=999;
   for m:=i1 to i2 do if blankPoz(i,j,m)then Pun(i,indmat,j,m,-1);
   case option of
        Ver_Mes: mes:=mesaj('Materia '+getmat(mat,0,0)+' nu respecta conditiile. Doriti sa o sterg ?',Mes_OC);
        Ver_NoMes:exit;
        Ver_List:PutEroare(i,j,k,indMat,Result);end;
   case mes of
   1: begin if not blankPoz(i,j,i1)then DelPoz(i,j,i1,Poz_Fill)
               else mesaj('Am pus cu Pun si acum e gol',Mes_OK);
            DisplayRez(i,'');;end;
   2: begin
           mesaj('Nu puteti edita orarul daca materiile nu respecta conditiile',Mes_OK);
           with rezFRM do if (rezFRM<>nil)and(editCheck.Checked)then begin
                editCheck.checked:=false;end;
           FreePoz(mem);exit;
           end;
   end;end;
end;
end;

function TRez.PutAllMat(indClas,opt:integer):integer;
var indMat:integer;
begin
Result:=0;
for indMat:=1 to MatNr[indclas]^ do begin
    while (_restore[indClas,indMat]^>0) do
    if (AllPut(indClas,indMat,-1,0,0,1)<>0)
    and(tryPut(indClas,indMat,-1,0,0,1)<>0)
    and(trybeforePut(indClas,indMat,-1)<>0)
    then break;
    end;
end;
{-----------------------------------------------------}
function TRez.makeOrar:integer;
var indClas,cond7,i:integer;
begin
InitVar;Result:=0;cond7:=cond[7,1]^;
for i:=1 to 2 do begin
for indClas:=1 to NrClasSel do rez.PutAllMat(indClas,-1);
if cond7=0 then break else cond[7,1]^:=0;
end;
cond[7,1]^:=cond7;Verifica(0,Ver_List);
end;
{-----------------------------------------------------}
procedure Trez.InitVar;
var i,j:integer;
begin
for i:=1 to maxpoz do for j:=1 to maxpoz2 do ElibInt(Poz[i,j]);
if cond[3,1]<>nil then consec:=cond[3,1]^;
MaxAloc:=0;LastAloc:=0;
end;
{-----------------------------------------------------}
procedure TRez.FreeTemp;
var m,n,z:integer;
begin
for m:=1 to maxclas do begin
    for n:=1 to maxmat do begin ElibInt(_RestOre[m,n]);
        ElibInt(_matI[m,n]);ElibInt(_profI[m,n]);
        ElibInt(_oreI[m,n]);end;
    for n:=1 to maxzile do for z:=1 to maxore do begin
        ElibInt(_matR[m,n,z]);ElibInt(_profR[m,n,z]);end;
    end;
end;
{-----------------------------------------------------}
function TRez.canPut(indClas,indMat,zi,ora:integer):integer;
var mat,mat0,tipMat,prof,nrore,i,j,k:integer;
begin
mat:=_matI[indclas,indMat]^;prof:=_profI[indclas,indMat]^;
nrore:=_oreI[indclas,indMat]^;if mat<0 then tipMat:=MMat[-mat,2]^ else TipMat:=0;
//loc liber
if not BlankPoz(indClas,zi,ora)then
   begin Result:=13;errClas:=indClas;errZi:=zi;errOra:=ora;exit;end;
//profesori
if cond[5,1]^=1 then
for i:=1 to NrClasSel do begin
    errClas:=i;errZi:=zi;errOra:=ora;mat0:=_matR[i,zi,ora]^;
    if _profR[i,zi,ora]^<>0 then if _profR[i,zi,ora]^=prof then
       if (mat<>mat0)or(tipMat<>3)then begin Result:=1;exit;end;
    if _profR[i,zi,ora]^<0 then
       for k:=1 to Mprofi[-_profR[i,zi,ora]^,0]^ do
           if Mprofi[-_profR[i,zi,ora]^,k]^=prof then
              if (mat<>mat0)or(tipMat<>3)then begin Result:=10;exit;end;
    if prof<0 then for j:=1 to Mprofi[-prof,0]^ do begin
       if Mprofi[-prof,j]^=_profR[i,zi,ora]^ then
          if (mat<>mat0)or(tipMat<>3)then begin Result:=11;exit;end;
       if _profR[i,zi,ora]^<0 then
          for k:=1 to Mprofi[-_profR[i,zi,ora]^,0]^ do
              if Mprofi[-_profR[i,zi,ora]^,k]^=Mprofi[-prof,j]^ then
                 if (mat<>mat0)or(tipMat<>3)then begin Result:=12;exit;end;
       end;
    end;
//ore pe zi
j:=0;
if cond[6,1]^=1 then for i:=1 to {OreZi[indClas,zi]^}maxore do begin
    if _matR[indClas,zi,i]^=mat then inc(j);
    errClas:=indClas;errZi:=zi;errOra:=i;
    if oremat[getMatI(mat),1]=nil then begin
       if j>0 then begin Result:=2;exit;end;end
    else if j=oremat[getMatI(mat),1]^ then begin Result:=2;exit;end;
    end;
{ore consecutive cu mai mult de 1 ora}
//nu trebuie
//2 ore pe sapt
if cond[1,1]^=1 then if (nrore=2)and(oremat[getMatI(mat),1]^=1)then
   begin  {verifica inainte daca nu mai e una}
   errClas:=indClas;errZi:=zi-1;
   if zi>1 then for i:=1 to {oreZi[indClas,zi-1]^}maxore do
   if _matR[indClas,zi-1,i]^=mat then begin errOra:=i;Result:=6;exit;end;
   errZi:=zi+1;{verifica dupa}
   if zi<maxzile then for i:=1 to {oreZi[indClas,zi+1]^}maxore do
   if _matR[indClas,zi+1,i]^=mat then begin errOra:=i;Result:=7;exit;end;
   end;
//sali
j:=0;
if cond[2,1]^=1 then
for i:=1 to nrClasSel do begin
    errClas:=i;errZi:=zi;errOra:=ora;
    if _matR[i,zi,ora]^=mat then inc(j);
    if j=sali[getMatI(mat)]^ then begin Result:=8;exit;end;end;
//preferinte
if cond[4,1]^=1 then
if pref[prof,zi,ora]<>nil then
   if pref[prof,zi,ora]^=1 then
      begin Result:=9;exit;end;
//grad dificultate
if cond[7,1]^=1 then begin
   if oremat[getMatI(mat),2]<>nil then i:=oremat[getMatI(mat),2]^ else i:=1;
   if dif[indClas,ora]<>nil then begin
      j:=dif[indClas,ora]^mod maxclas;
      k:=dif[indClas,ora]^div maxclas;end
      else begin j:=maxore;k:=1;end;//atentie
   if (i>j)then begin result:=15;exit;end;
   if (i<k)then begin result:=16;exit;end;
   end;
Result:=0;
end;

end.
