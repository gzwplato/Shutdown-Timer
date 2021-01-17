unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  Unix, LCLType, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonStart: TButton;
    LabelHoursCount: TLabel;
    LabelMinutes: TLabel;
    LabelHours: TLabel;
    LabelMinutesCount: TLabel;
    Timer1: TTimer;
    TrackBarMinutes: TTrackBar;
    TrackBarHours: TTrackBar;
    procedure ButtonStartClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrackBarHoursChange(Sender: TObject);
    procedure TrackBarMinutesChange(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  tHours, tMinutes, tSeconds: Integer;
  bActivated: Boolean;

implementation

{$R *.lfm}

{ TForm1 }

procedure Shutdown();
begin
  fpSystem('/sbin/shutdown -P now');
end;

procedure UpdateFormCaption();
begin
  if tSeconds = 0 then Form1.Caption:= '0 s - Shutdown Timer';
  if tSeconds < 60 then Form1.Caption:= IntToStr(tSeconds)+' s - Shutdown Timer';
  if (tSeconds >= 60) and (tSeconds < 3600) then Form1.Caption:=IntToStr(Trunc(tSeconds/60))+' m '+IntToStr(tSeconds - Trunc(tSeconds/60)*60)+' s'+' - Shutdown Timer';
  if (tSeconds >= 3600) then Form1.Caption:=IntToStr(Trunc(tSeconds/3600))+' h '+IntToStr(Trunc(tSeconds/60)-Trunc(tSeconds/3600)*60)+' m '+IntToStr(tSeconds - Trunc(tSeconds/60)*60)+' s'+' - Shutdown Timer';
end;

procedure UpdateTimeTotal();
begin
  tSeconds:= tHours*3600 + tMinutes*60;
  UpdateFormCaption();
end;

procedure TForm1.TrackBarHoursChange(Sender: TObject);
begin
  if bActivated = False then
  begin
  tHours := TrackBarHours.Position;
  tMinutes := TrackBarMinutes.Position;
  LabelHoursCount.Caption := IntToStr(TrackBarHours.Position);
  UpdateTimeTotal();
  if tSeconds = 0 then ButtonStart.Enabled:=False else ButtonStart.Enabled:=true;
  end;
end;

procedure TForm1.TrackBarMinutesChange(Sender: TObject);
begin
  if bActivated = False then
  begin
  tHours := TrackBarHours.Position;
  tMinutes := TrackBarMinutes.Position;
  LabelMinutesCount.Caption := IntToStr(TrackBarMinutes.Position);
  UpdateTimeTotal();
  if tSeconds = 0 then ButtonStart.Enabled:=False else ButtonStart.Enabled:=true;
  end;
end;

procedure TForm1.ButtonStartClick(Sender: TObject);
begin
  if bActivated = False then
  begin
  ButtonStart.Caption := 'Stop';
  bActivated := True;
  Timer1.Enabled := True;
  TrackBarHours.Enabled := False;
  TrackBarMinutes.Enabled := False;
  LabelHours.Enabled := False;
  LabelHoursCount.Enabled := False;
  LabelMinutes.Enabled := False;
  LabelMinutesCount.Enabled := False;
  end
  else
  begin
  ButtonStart.Caption := 'Start';
  bActivated := False;
  Timer1.Enabled := False;

  TrackBarHours.Enabled := True;
  TrackBarMinutes.Enabled := True;
  LabelHours.Enabled := True;
  LabelHoursCount.Enabled := True;
  LabelMinutes.Enabled := True;
  LabelMinutesCount.Enabled := True;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if tSeconds > 1 then
  begin
  tSeconds := tSeconds - 1;
  UpdateFormCaption();
  TrackBarHours.Position:= Trunc(tSeconds/3600);
  TrackBarMinutes.Position:= Trunc(tSeconds/60)-Trunc(tSeconds/3600)*60;
  LabelHoursCount.Caption:= IntToStr(Trunc(tSeconds/3600));
  LabelMinutesCount.Caption:= IntToStr(Trunc(tSeconds/60)-Trunc(tSeconds/3600)*60);
  end;
  if tSeconds = 1 then
  begin
  Timer1.Enabled := False;
  Shutdown();
  end;
end;




end.

