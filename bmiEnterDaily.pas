unit bmiEnterDaily;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage, globalUnit, system.Math,
  Vcl.ExtCtrls;

type
  Tform_bmiEnterDaily = class(TForm)
    lbl_date: TLabel;
    lbl_bmi: TLabel;
    lbl_displayBMI: TLabel;
    shp_displayBMI: TShape;
    lbl_height: TLabel;
    lbl_metres: TLabel;
    Panel1: TPanel;
    img_icon: TImage;
    lbl_sleepTracker: TLabel;
    lbl_back: TLabel;
    cbo_selectView: TComboBox;
    edt_weight: TEdit;
    btn_submit: TButton;
    mmo_comment: TMemo;
    edt_height: TEdit;
    lbl_weight: TLabel;
    lbl_kg: TLabel;
    edt_message: TEdit;
    procedure btn_submitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbo_selectViewChange(Sender: TObject);
    procedure lbl_backClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form_bmiEnterDaily: Tform_bmiEnterDaily;

implementation

{$R *.dfm}

uses bmiTrack, dashboard;

//validating user inputs
function validateWeightHeight(inpWeight, inpHeight:string):boolean;
var
weight, height:double;
isError: boolean;
begin
isError:= false;  //set error flags as false
if (inpWeight='') OR (inpHeight = '') then //if fields are blank
  begin
  messageDlg('Fields must not be left blank', mtError, [mbCancel], 0); //error alert
  isError := TRUE; //change state of flag
  end;
if isError= FALSE then  //if fields are not blank
  if TryStrToFloat(inpWeight, weight) = TRUE AND TryStrToFloat(inpHeight, height)=TRUE then //are inputs numerical
    begin
    if (weight <30) OR (weight > 200) OR (height<0.5) OR (height > 3) then //within acceptable ranges?
      begin
      isError:= TRUE; //change state of flag
      messageDlg('Please enter sensible values', mtError, [mbCancel], 0); //error alert
      end;
    end
  else
    begin
    isError:= TRUE; //change state of flag
    messageDlg('Please enter numerical values', mtError, [mbCancel], 0);  //error alert
    end;
result:= isError; //returning isError
end;

procedure Tform_bmiEnterDaily.btn_submitClick(Sender: TObject);
var index: integer;
    isError: boolean;
    dailyBMI: double;
    weight, height: double;
begin
  isError:= validateWeightHeight(edt_weight.Text, edt_height.Text); //validating inputs, returning TRUE for error, FALSE for none
  if isError = FALSE then //if no errors
    begin
    weight:= strtofloat(edt_weight.Text); //assigning input to weight
    height:= strtofloat(edt_height.Text); //assigning input to height
    dailyBMI:= (weight/height)/height; //calculating bmi
    mmo_comment.Show;  //show the comment
    index:= trunc(random*5); //generating a random number between 0 and 4
      case index of //motivating comments chosen at random
      0: mmo_comment.Text:= 'Keep going, '+currentUser+ '! Your body will thank you for it.';
      1: mmo_comment.Text:= 'It will take time and determination, '+currentUser+', but you will achieve your goal.';
      2: mmo_comment.Text:= 'You�re already halfway there to a new, healthier and happier you, ' + currentUser+'.';
      3: mmo_comment.Text:= 'A Sore today is a strong tomorrow, '+currentUser+'.';
      4: mmo_comment.Text:= 'A little progress each day adds up to big results, '+currentUser+'.';
      end;
    saveData('BMI', floattostr(roundto(dailyBMI,-2))); //saving the users bmi in the progress file
    edt_weight.ReadOnly:= TRUE;  //making input boxes read only
    edt_height.ReadOnly:= TRUE;
    btn_submit.Hide; //hiding submit button
    end;
end;

procedure Tform_bmiEnterDaily.cbo_selectViewChange(Sender: TObject);
begin
if cbo_selectView.itemIndex = 1 then  //if clicking Show Previous Data from combobox
  begin
  form_bmiTrack.show; //show tracking form
  form_bmiEnterDaily.Hide; //hide data entry form
  end;
end;
//on creating the form
procedure Tform_bmiEnterDaily.FormCreate(Sender: TObject);
begin
edt_message.Hide; //hide 'Data has been entered' message
mmo_comment.Hide; //hide encouraging comment
mmo_comment.ReadOnly; //make encouraging comment read only
end;
//clicking back to dashboard
procedure Tform_bmiEnterDaily.lbl_backClick(Sender: TObject);
begin
form_bmiEnterDaily.Hide; //hide current form
form_dashboard.show; //show dashboard
form_dashboard.lbl_displayBMI.Caption:= floattostr(roundto(getBMI,-1));//show bmi
end;
end.
