unit procs;

interface

const
     crlf=#13+#10;
     tab=#9;
     max_strings=50;
     
function umple(s:string;nr:integer):string;
function maxim(n1,n2:integer):integer;
function minim(i,j:integer):integer;
function delBlank(s:AnsiString):AnsiString;
function paramS(s:string;ind:integer):string;
function param(s:string;ind:integer):integer;
function Initiale(s:ansistring):string;
function AdjustStr(s:string;lung:integer):string;
function OraMinNext(Hstart,index:integer):string;
function SentenceCase(s:string):string;
procedure switchInt(var i1,i2:integer);

implementation
uses SysUtils;
{-----------------------------------------------------}
function umple(s:string;nr:integer):string;
var i:integer;
begin result:='';for i:=1 to nr do result:=result+s;end;
{---------------------------------------------------------}
function maxim(n1,n2:integer):integer;
begin if n1>=n2 then result:=n1 else result:=n2;end;
{---------------------------------------------------------}
function delBlank(s:AnsiString):AnsiString;
begin
while Pos(' ', S)>0 do delete(S,Pos(' ', S),1);result:=s;
end;
{---------------------------------------------------------}
function minim(i,j:integer):integer;
begin
if i<=j then minim:=i else minim:=j;
end;
{-----------------------------------------------------}
function paramS(s:string;ind:integer):string;
var i,k:integer;par:array [1..max_strings]of string;
begin i:=0;s:=s+' ';
while (s<>'')or(i<ind) do begin
      k:=Pos(',',s);if k=0 then k:=Pos('=',s);if k=0 then k:=Pos(':',s);
      if k=0 then k:=length(s);
      inc(i);par[i]:=copy(s,1,k-1);delete(s,1,k);
      end;
Result:=par[ind];
end;
{------------------------------------------------}
function param(s:string;ind:integer):integer;
var i,k:integer;s1:string;
begin
s1:=paramS(s,ind);val(s1,i,k);
if k<>0 then Result:=-1977 else Result:=i;
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
function AdjustStr(s:string;lung:integer):string;
begin
if length(s)>lung then delete(s,lung,length(s)-lung)
   else if length(s)<lung then s:=s+umple(' ',lung-length(s));
Result:=s;
end;
{-----------------------------------------------------}
function OraMinNext(Hstart,index:integer):string;
var s1,s2:string[5];
begin
s1:=inttostr(HStart+index-1);
s2:=inttostr(HStart+index);
if HStart+index-1<10 then s1:=' '+s1;
if HStart+index<10 then s2:=' '+s2;
Result:=' '+s1+'-'+s2;
end;
{-----------------------------------------------------}
function SentenceCase(s:string):string;
var i:integer;st:string;
begin
Result:=s;if s='' then exit;
st:=s[1];st:=UpperCase(st);s[1]:=st[1];
for i:=1 to length(s)-1 do
	if s[i]=' ' then begin
   	st:=s[i+1];st:=UpperCase(st);s[i+1]:=st[1];
      end;
Result:=s;
end;

procedure switchInt;
var i:integer;
begin
   i:=i1;
   i1:=i2;
   i2:=i;
end;

end.
