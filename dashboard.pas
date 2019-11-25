unit dashboard;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, globalUnit, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.jpeg, sleepTrack, sleepPlan, waterPlan, exercPlan, happiPlan, system.math, Vcl.Imaging.pngimage;

type
  Tform_dashboard = class(TForm)
    img_background: TImage;
    lbl_bmi: TLabel;
    shp_displayBmi: TShape;
    lbl_displayBmi: TLabel;
    lbl_greeting: TLabel;
    lbl_sleep: TLabel;
    lbl_water: TLabel;
    lbl_exercise: TLabel;
    lbl_happiness: TLabel;
    btn_sleepTrack: TButton;
    btn_waterTrack: TButton;
    btn_exercTrack: TButton;
    btn_happiTrack: TButton;
    btn_sleepPlan: TButton;
    btn_waterPlan: TButton;
    btn_exercPlan: TButton;
    btn_happiPlan: TButton;
    lbl_bmiTrack: TLabel;
    Label1: TLabel;
    lbl_sleepCreated: TLabel;
    lbl_waterCreated: TLabel;
    lbl_exercCreated: TLabel;
    lbl_happiCreated: TLabel;
    img_sleep: TImage;
    img_water: TImage;
    img_exerc: TImage;
    img_happi: TImage;
    procedure btn_sleepPlanClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure img_happiMouseEnter(Sender: TObject);
    procedure img_happiMouseLeave(Sender: TObject);
    procedure img_sleepMouseEnter(Sender: TObject);
    procedure img_sleepMouseLeave(Sender: TObject);
    procedure img_waterMouseEnter(Sender: TObject);
    procedure img_waterMouseLeave(Sender: TObject);
    procedure img_exercMouseEnter(Sender: TObject);
    procedure img_exercMouseLeave(Sender: TObject);
    procedure btn_waterPlanClick(Sender: TObject);
    procedure btn_exercPlanClick(Sender: TObject);
    procedure btn_happiPlanClick(Sender: TObject);
    procedure btn_sleepTrackClick(Sender: TObject);
    procedure btn_waterTrackClick(Sender: TObject);
    procedure btn_exercTrackClick(Sender: TObject);
    procedure btn_happiTrackClick(Sender: TObject);
    procedure lbl_bmiTrackClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form_dashboard: Tform_dashboard;

implementation

{$R *.dfm}

uses exercTrack, happiTrack, waterTrack, bmiTrack;

//click exercise plan
procedure Tform_dashboard.btn_exercPlanClick(Sender: TObject);
begin
form_dashboard.Hide; //hide the dashboard
form_exercPlan.Show; //show form_exercPlan
form_exercPlan.lbl_displayBmi.Caption:= floattostr(roundto(getBMI,-1)); //display BMI on form_exercPlan
end;

//click exercise Track
procedure Tform_dashboard.btn_exercTrackClick(Sender: TObject);
begin
if (isPlan('exercProgress') = TRUE) then //if a plan has been created
  begin
  form_dashboard.Hide; //hide the dashboard
  form_exercTrack.show; //show exercise tracking form
  form_exercTrack.lbl_displaygoal.Caption:= getGoal('exerc') +' hours'; //output goal using function getGoal
  end
else messagedlg('You must first create a health plan.', mtInformation, [mbCancel], 0); //error alert
end;
//click happiness plan
procedure Tform_dashboard.btn_happiPlanClick(Sender: TObject);
begin
form_dashboard.Hide; //hide the dashboard
form_happiPlan.Show; //show form_happiPlan
form_happiPlan.lbl_displayBmi.Caption:= floattostr(roundto(getBMI,-1)); //display BMI on form_happiPlan
end;
//click happiness track
procedure Tform_dashboard.btn_happiTrackClick(Sender: TObject);
begin
if (isPlan('happiProgress') = TRUE) then //if a plan has been created
  begin
  form_dashboard.Hide; //hide the dashboard
  form_happiTrack.show; //show happiness tracking form
  form_happiTrack.lbl_displaygoal.Caption:= 'Rating: ' +getGoal('happi'); //output goal using function getGoal
  end
else messagedlg('You must first create a health plan.', mtInformation, [mbCancel], 0); //error alert
end;
//click sleep plan
procedure Tform_dashboard.btn_sleepPlanClick(Sender: TObject);
begin
form_dashboard.Hide; //hide the dashboard
form_sleepPlan.Show; //show form_sleepPlan
form_sleepPlan.lbl_displayBmi.Caption:= floattostr(roundto(getBMI,-1)); //display BMI on form_sleepPlan
end;
//click sleep track
procedure Tform_dashboard.btn_sleepTrackClick(Sender: TObject);
begin
if (isPlan('sleepProgress') = TRUE) then //if a plan has been created
  begin
  form_dashboard.Hide; //hide the dashboard
  form_sleepTrack.show; //show sleep tracking form
  form_sleepTrack.lbl_displaygoal.Caption:= getGoal('sleep') +' hours'; //output goal using function getGoal
  end
else
  messagedlg('You must first create a health plan.', mtInformation, [mbCancel], 0);
end;
//click water plan
procedure Tform_dashboard.btn_waterPlanClick(Sender: TObject);
begin
form_dashboard.Hide; //hide the dashboard
form_waterPlan.Show; //show form_waterPlan
form_waterPlan.lbl_displayBmi.Caption:= floattostr(roundto(getBMI,-1)); //display BMI on form_waterPlan
end;
//click water track
procedure Tform_dashboard.btn_waterTrackClick(Sender: TObject);
begin
if (isPlan('waterProgress') = TRUE) then //if a plan has been created
  begin
  form_dashboard.Hide; //hide the dashboard
  form_waterTrack.show; //show water tracking form
  form_waterTrack.lbl_displaygoal.Caption:= getGoal('water') +' glasses'; //output goal using function getGoal
  end
else messagedlg('You must first create a health plan.', mtInformation, [mbCancel], 0);//error alert
end;

procedure Tform_dashboard.FormCreate(Sender: TObject);
begin
//hiding green messages for when plans have been created
lbl_sleepCreated.Visible:=FALSE;
lbl_waterCreated.Visible:=FALSE;
lbl_happiCreated.Visible:=FALSE;
lbl_exercCreated.Visible:=FALSE;
//hiding labels under icons
lbl_sleep.visible:=false;
lbl_water.visible:=false;
lbl_happiness.visible:=false;
lbl_exercise.visible:=false;
end;

procedure Tform_dashboard.img_sleepMouseEnter(Sender: TObject); //hovering over icon
begin
lbl_sleep.Visible:=TRUE; //label is visible
end;
procedure Tform_dashboard.img_sleepMouseLeave(Sender: TObject); //hovering off icon
begin
lbl_sleep.Visible:=FALSE; //label is invisible
end;
procedure Tform_dashboard.img_exercMouseEnter(Sender: TObject); //hovering over icon
begin
lbl_exercise.Visible:=TRUE;  //label is visible
end;
procedure Tform_dashboard.img_exercMouseLeave(Sender: TObject); //hovering off icon
begin
lbl_exercise.Visible:=FALSE; //label is invisible
end;
procedure Tform_dashboard.img_happiMouseEnter(Sender: TObject); //hovering over icon
begin
lbl_happiness.Visible:=TRUE; //label is visible
end;
procedure Tform_dashboard.img_happiMouseLeave(Sender: TObject); //hovering off icon
begin
lbl_happiness.Visible:=FALSE; //label is invisible
end;
procedure Tform_dashboard.img_waterMouseEnter(Sender: TObject); //hovering over icon
begin
lbl_water.Visible:=TRUE; //label is visible
end;
procedure Tform_dashboard.img_waterMouseLeave(Sender: TObject); //hovering off icon
begin
lbl_water.Visible:=FALSE; //label is invisible
end;
//click BMI track
procedure Tform_dashboard.lbl_bmiTrackClick(Sender: TObject);
begin
form_bmiTrack.lbl_displayBMI.Caption:= floattostr(roundto(getBMI,-1)); //output BMI using getBMI
form_bmiTrack.show; //show track page
form_dashboard.Hide; //hide dashboard
end;

end.
