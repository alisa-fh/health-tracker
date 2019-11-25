unit waterTrack;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.WinXCalendars, Vcl.StdCtrls,
  Vcl.Grids, Vcl.ExtCtrls, Vcl.Imaging.pngimage, system.Math,globalUnit, waterEnterDaily;

type
  Tform_waterTrack = class(TForm)
    lbl_goal: TLabel;
    lbl_displaygoal: TLabel;
    shp_displayGoal: TShape;
    lbl_showdata: TLabel;
    lbl_showOneDay: TLabel;
    lbl_viewManyError: TLabel;
    img_qu: TImage;
    Panel1: TPanel;
    img_icon: TImage;
    lbl_waterTracker: TLabel;
    lbl_back: TLabel;
    cbo_selectView: TComboBox;
    cbo_days: TComboBox;
    stg_viewMany: TStringGrid;
    stg_viewOne: TStringGrid;
    mmo_help: TMemo;
    cdr_selectDate: TCalendarView;
    lbl_viewOneError: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cbo_selectViewChange(Sender: TObject);
    procedure cdr_selectDateChange(Sender: TObject);
    procedure cbo_daysChange(Sender: TObject);
    procedure img_quMouseEnter(Sender: TObject);
    procedure img_quMouseLeave(Sender: TObject);
    procedure lbl_backClick(Sender: TObject);
    procedure lbl_backMouseEnter(Sender: TObject);
    procedure lbl_backMouseLeave(Sender: TObject);
  private
  public
  end;

var
  form_waterTrack: Tform_waterTrack;

implementation

{$R *.dfm}

uses dashboard, sleepTrack;
//on changing number of days combo box
procedure Tform_waterTrack.cbo_daysChange(Sender: TObject);
var path, aDate, aValue: string;
    numdays, I, fileLength, row:integer;
    waterData: TStringList;
    recordsDisplayed: double;
begin
lbl_viewManyError.Hide;//hide error messages
lbl_viewOneError.Hide;
for I := 0 to 1 do
  stg_viewMany.Cols[I].Clear; //clearing contents of stringgrid
numDays:= cbo_days.ItemIndex +1; //number of days requested. +1 because indexing begins at 0
path:= currentDir + '\' + 'waterProgress.txt'; //waterProgress filepath
waterData:=TStringList.Create; //creating a stringList to hold all the data in waterProgress
  waterData.LoadFromFile(path); //loading the waterProgress data into stringList waterData
  fileLength:= waterData.Count; //number of records
  if (((fileLength)-1)/2)>= numDays then  //if the user has the requested number of entries
    begin
    i:= (fileLength+1)- numdays*2;  //pointer on the first record
    row:= 0; //initialising first row
    while I < fileLength do  //loop for each entry
     begin
     aDate:=waterData[I-1]; //assigning aDate from waterData
     stg_viewMany.Cells[0,row]:=aDate; //output date on stringgrid
     i:= i +1;
     aValue:= waterData[I-1]; //assigning aValue from waterData
     stg_viewMany.Cells[1,row]:= (aValue + ' glasses');  //output value on stringgrid
     i:=i+1;
     row:=row+1; //next stringgrid row
     end;
    waterData.Free;//free stringlist
    end
 else //if user doesn't have requested number of entries
    begin
    lbl_viewManyError.Show; //show the error label
    recordsDisplayed:= 0.5*(fileLength-1); //the number of records recorded
    lbl_viewManyError.Caption:= 'You do not yet have '+inttostr(numdays)+' entries recorded.'+#13#10+' The last '+floattostr(recordsDisplayed) + ' values have been displayed' ; //the error message
    I:= 1; //initialising pointer to the first date
    row:= 0; //initialising string grid row
    WHILE I< fileLength-1 do //iteration for each record, until end of string list
      begin
      aDate:=waterData[I]; //assigning the date from string list
      stg_viewMany.Cells[0, row]:= aDate; //displaying the date
      I:= I + 1; //increment array pointer
      aValue:= waterData[I]; //assigning the value
      stg_viewMany.Cells[1, row]:= aValue; //displaying the value
      I:= I +1;
      row:= row+1; //next string grid row
      end;
    waterData.Free; //free waterData stringlist
    end;
end;
//on changing 'view' combo box:
procedure Tform_waterTrack.cbo_selectViewChange(Sender: TObject);
begin
if cbo_selectView.ItemIndex= 0 then  //if on option 'enter today's data'
  begin
  form_waterTrack.Hide; //hide the current form
  form_waterEnterDaily.show; //show the data entry form
  form_waterEnterDaily.lbl_displaygoal.Caption:= getGoal('water') + ' glasses'; //display goal
  form_waterEnterDaily.lbl_date.Caption:= ' Todays date is ' + datetostr(date); //display date
  form_waterEnterDaily.lbl_displaybmi.caption:= floattostr(roundto(getBMI,-1)); //display BMI
  if isTodayRecorded('water') = TRUE then  //if data has been recorded today
    begin
    form_waterEnterDaily.edt_input.ReadOnly:=TRUE; //make edit box read only
    form_waterEnterDaily.edt_input.Text:= 'Todays data has been recorded';  //display message
    form_waterEnterDaily.edt_input.Font.Style:=[fsBold]; //change font to bold
    form_waterEnterDaily.btn_submit.Hide; //hide the submit button
    end;
  end;
end;
//on selecting calendar date:
procedure Tform_waterTrack.cdr_selectDateChange(Sender: TObject);
var waterData: TStringList;
    path: string;
    fileLength, index:integer;
begin
stg_viewOne.Rows[0].Clear; //clearing previous data from the grid
lbl_viewManyError.Hide; //hiding previous error messages
lbl_viewOneError.Hide;  //hiding previous error messages
path:= currentDir + '\' + 'waterProgress.txt'; //waterProgress filepath
waterData:=TStringList.Create; //creating a stringList to hold all the data in waterProgress
  waterData.LoadFromFile(path); //loading the waterProgress data into stringList waterData
  fileLength:= waterData.Count; //number of records
  index:= searchDate(waterData, cdr_selectDate.Date, 1, (fileLength-1)); //calling searchDate, returning the date's index
  if (index = -1) then  //date not found
    begin
    lbl_viewOneError.Show; //show error message
    lbl_viewOneError.Caption:= 'There is no data recorded for '+ #13#10+ datetostr(cdr_selectDate.Date)+'.'; //error message
    end
  else //if date is found
    begin
     stg_viewOne.Cells[0,0]:= datetostr(cdr_selectDate.Date); //outputting date on grid
     stg_viewOne.Cells[1,0]:= waterData[index+1] + ' glasses'; //outputting the date's data
    end;
waterData.Free; //free waterData stringlist
end;
//on creating the form:
procedure Tform_waterTrack.FormCreate(Sender: TObject);
begin
cbo_days.ItemHeight:= 0;  //setting default index
lbl_viewManyError.Hide; //hiding the error messages
lbl_viewOneError.Hide;
mmo_help.Hide; //hide help memo
end;
//on hovering over question bubble:
procedure Tform_waterTrack.img_quMouseEnter(Sender: TObject);
begin
mmo_help.show; //show help memo
mmo_help.Text:= 'Select a date from the calendar'; //text on help memo
end;
//on hovering off question bubble:
procedure Tform_waterTrack.img_quMouseLeave(Sender: TObject);
begin
mmo_help.hide; //hide help memo
end;
//on clicking 'back to dashboard':
procedure Tform_waterTrack.lbl_backClick(Sender: TObject);
begin
form_dashboard.show; //show dashboard
form_sleepTrack.Hide;//hide current form
end;
//on hovering over 'back to dashboard':
procedure Tform_waterTrack.lbl_backMouseEnter(Sender: TObject);
begin
lbl_back.Font.Style:=[fsBold, fsUnderline]; //style bold and underlined
end;
//on hovering off 'back to dashboard':
procedure Tform_waterTrack.lbl_backMouseLeave(Sender: TObject);
begin
lbl_back.Font.Style:=[fsUnderline]; //style underlined
end;

end.
