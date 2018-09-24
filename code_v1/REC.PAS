unit rec;

interface
procedure RecPlay(Sender: TObject);
procedure RecKeyPress(Sender: TObject; var Key: Char);

implementation
uses windows,forms;

var
   ind:integer;
   m:array[1..10000,1..3]of integer;

procedure RecPlay(Sender: TObject);
const
     pas:integer=10;speed=100;
var
   i,but:integer;
procedure muta;
var j,x,y,xp,yp:integer;c:TPoint;
begin
GetCursorPos(c);
pas:=5;
x:=m[i,1];y:=m[i,2];
//xp:=trunc((x-c.x)/(pas*2));yp:=trunc((y-c.y)/(pas*2));
xp:=trunc((x-c.x)/pas);yp:=trunc((y-c.y)/pas);
for j:=1 to pas do begin
    //mouse_event(MOUSEEVENTF_MOVE,xp,yp,0,0);
    SetCursorPos(c.x+xp*j,c.y+yp*j);
    Application.ProcessMessages;
    sleep(speed);
    end;
SetCursorPos(x,y);
end;
begin
for i:=1 to ind-1 do begin
    muta;
    but:=0;
    case m[i,3] of
     11: but:=MOUSEEVENTF_LEFTDOWN;
     21: but:=MOUSEEVENTF_LEFTUP;
     12: but:=MOUSEEVENTF_RIGHTDOWN;
     22: but:=MOUSEEVENTF_RIGHTUP;
     end;
    if but<>0 then mouse_event(but,0,0,0,0);
    Application.ProcessMessages;
    sleep(speed);
    end;
end;

procedure RecKeyPress(Sender: TObject; var Key: Char);
var c:TPoint;
procedure a(i:integer);
begin
if i=1 then begin a(11);a(21);exit;end;
if i=2 then begin a(12);a(22);exit;end;
GetCursorPos(c);
m[ind,1]:=c.x;
m[ind,2]:=c.y;
m[ind,3]:=i;
inc(ind);
end;
begin
case key of
     '!': a(11);
     '@': a(12);
     '#': a(21);
     '$': a(22);
     '~': a(1);
     '%': a(2);
     end;
end;

begin
ind:=1;
end.
