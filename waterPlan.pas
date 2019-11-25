unit waterPlan;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, globalUnit, enterData, system.math;

type
  Tform_waterPlan = class(TForm)
    lbl_slide: TLabel;
    pnl_water: TPanel;
    lbl_waterGoal: TLabel;
    lbl_bmi: TLabel;
    lbl_displayBmi: TLabel;
    shp_displayBmi: TShape;
    img_icon: TImage;
    lbl_back: TLabel;
    mmo_desc: TMemo;
    tbr_glasses: TTrackBar;
    mmo_trackbar: TMemo;
    mmo_etb: TMemo;
    btn_save: TButton;
    procedure lbl_backClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_saveClick(Sender: TObject);
    procedure lbl_backMouseEnter(Sender: TObject);
    procedure lbl_backMouseLeave(Sender: TObject);
    procedure tbr_glassesChange(Sender: TObject);
  private
  public
  end;

var
  form_waterPlan: Tform_waterPlan;

implementation
{$R *.dfm}
uses dashboard;
//on clicking save:
procedure Tform_waterPlan.btn_saveClick(Sender: TObject);
begin
saveGoal('water', tbr_glasses.Position); //parameters: factor, trackbar value
form_waterPlan.Hide; //hides the current form
dashboardInitialisation; //reinitialises the dashboard
form_dashboard.Show; //shows dashboard
end;
//on creating the form:
procedure Tform_waterPlan.FormCreate(Sender: TObject);
begin
mmo_desc.Text:='Water flushes out toxins, relieves fatigue and promotes weight loss by '+
                'increasing your metabolism. It is recommended that you drink 8 glasses of water '+
                'per day';  //description
mmo_trackbar.text:= inttostr(tbr_glasses.Position) +' glasses per day'; //outputs value on the trackbar

mmo_desc.ReadOnly:= TRUE; //making the description box read only
mmo_etb.ReadOnly:= TRUE; //making the ETB box read only
mmo_trackbar.ReadOnly:= TRUE; //making the trackbar box read only

mmo_etb.Text:='Effect on BMI will be displayed here'; //displays effect on BMI
end;
//on clicking 'back to dashboard':
procedure Tform_waterPlan.lbl_backClick(Sender: TObject);
begin
form_dashboard.show;//show dashboard
form_waterPlan.Hide; //hide current form
end;
//on hovering over 'back to dashboard':
procedure Tform_waterPlan.lbl_backMouseEnter(Sender: TObject);
begin
lbl_back.Font.Style:=[fsBold, fsUnderline];//style bold and underlined
end;
//on hovering off 'back to dashboard':
procedure Tform_waterPlan.lbl_backMouseLeave(Sender: TObject);
begin
lbl_back.Font.Style:=[fsUnderline]; //style underlined
end;
//on changing trackbar value:
procedure Tform_waterPlan.tbr_glassesChange(Sender: TObject);
var
difference:double;
begin
mmo_trackbar.Text:= inttostr(tbr_glasses.Position) + #13#10 +' glasses per day'; //outputs value on the trackbar
difference:= roundto(changeETB('water', tbr_glasses.Position),-3); //returns the difference in BMI using the factor and trackbar position as parameters
if difference < 0 then //if negative
  mmo_etb.Text:= 'By sticking to this regime, your BMI could increase by ' + floattostr(roundto(difference*-1, -3))
else if difference > 0 then  //if positive
  mmo_etb.Text:= 'By sticking to this regime, your BMI could decrease by ' + floattostr(roundto(difference,-3))
else //if difference = 0
  mmo_etb.Text:= 'By sticking to this regime, your BMI is predicted to remain unchanged';
end;

end.
