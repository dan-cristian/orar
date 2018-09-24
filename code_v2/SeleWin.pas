unit SeleWin;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  ,StdCtrls,ExtCtrls;

type
  TSeleWin = class(TPanel)
  private
    { Private declarations }
  		dragX,dragY:integer;
      _Items:TStrings;
      _OkOnClick:TNotifyEvent;
      _CloseOnClick:TNotifyEvent;
      procedure wOkOnClick(value:TNotifyEvent);
      procedure wCloseOnClick(value:TNotifyEvent);
  protected
    { Protected declarations }
    procedure HMouseDown(Sender:TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure HMouseUp(Sender:TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure HMouseMove(Sender:TObject; Shift: TShiftState; X,
      Y: Integer);
  public
    { Public declarations }
      headP:TPanel;
      seleP:TPanel;
      seleLst:TListBox;
      okB:TButton;
      closeB:TButton;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    { Published declarations }
      property OkOnClick:TNotifyEvent
         read _OkOnClick write wOkOnClick;
      property CloseOnClick:TNotifyEvent
         read _CloseOnClick write wCloseOnClick;
      property Items:TStrings read _Items write _Items;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TSeleWin]);
end;

procedure TSeleWin.HMouseDown;
begin
dragX:=X;dragY:=Y;
inherited MouseDown	(Button,Shift,X,Y);
end;

procedure TSeleWin.HMouseUp;
var pas:integer;
begin
dragX:=-1;dragY:=-1;pas:=20;
if Top<0 then Top:=0;
if Left<0 then Left:=0;
if Left+pas>Parent.ClientWidth then Left:=Parent.ClientWidth-pas;
if Top+pas>Parent.ClientHeight then Top:=Parent.ClientHeight-pas;
inherited MouseUp(Button,Shift,X,Y);
end;

procedure TSeleWin.HMouseMove;
begin
if (dragX<0)or(dragY<0)then exit;
Left:=Left+(X-dragX);Top:=Top+(Y-dragY);refresh;
inherited MouseMove(Shift,X,Y);
end;

constructor TSeleWin.Create;
begin
inherited Create(AOwner);
BorderWidth:=1;
dragX:=-1;dragY:=-1;
headP:=TPanel.Create(Self);
headP.Parent:=Self;
with headP do begin
   Align:=alTop;
   BevelInner:=bvNone;
   BevelOuter:=bvLowered;
   Color:=clHighlight;
   Height:=20;
   OnMouseDown:=HMouseDown;
   OnMouseUp:=HMouseUp;
   OnMouseMove:=HMouseMove;
	end;
seleP:=TPanel.Create(Self);
seleP.Parent:=Self;
with seleP do begin
   Align:=alClient;
   BorderWidth:=5;
   BevelInner:=bvNone;
   BevelOuter:=bvNone;
	end;
seleLst:=TListBox.Create(Self);
seleLst.Parent:=seleP;
Items:=seleLst.Items;
with seleLst do begin
   Align:=alClient;
	end;
okB:=TButton.Create(headP);
okB.Parent:=headP;
with okB do begin
   Caption:='OK';
   Height:=15;
   Width:=45;
   Top:=3;
   Left:=5;
	end;
closeB:=TButton.Create(headP);
closeB.Parent:=headP;
with closeB do begin
   Caption:='Inchide';
   Height:=okB.Height;;
   Width:=okB.Width;
   Top:=okB.Top;
   Left:=okB.Left+okB.Width+10;
	end;
end;

destructor TSeleWin.Destroy;
begin
okB.Destroy;
closeB.Destroy;
headP.Destroy;
seleLst.Destroy;
seleP.Destroy;
inherited Destroy;
end;

procedure TSeleWin.wOkOnClick;
begin
_OkOnClick:=value;OkB.OnClick:=value;
end;

procedure TSeleWin.wCloseOnClick;
begin
_CloseOnClick:=value;CloseB.OnClick:=value;
end;

end.

