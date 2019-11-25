unit Account;

interface

uses
  globalUnit, enterData, dateutils, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.Math, StrUtils, Vcl.Imaging.pngimage;

type
  Tform_acc = class(TForm)
    lbl_introCaption: TLabel;
    btn_signIn: TButton;
    shp_rect1: TShape;
    btn_createAccount: TButton;
    edt_caWeight: TEdit;
    edt_caHeight: TEdit;
    edt_caPassword: TEdit;
    edt_caUsername: TEdit;
    lbl_caUsername: TLabel;
    lbl_caPassword: TLabel;
    lbl_caHeight: TLabel;
    lbl_metres: TLabel;
    lbl_kg: TLabel;
    lbl_caWeight: TLabel;
    shp_rect2: TShape;
    lbl_siUsername: TLabel;
    lbl_siPassword: TLabel;
    edt_siPassword: TEdit;
    edt_siUsername: TEdit;
    img_logo: TImage;
    lb_gettingStarted: TLabel;
    edt_signIn: TLabel;
    lbl_caHeightError: TLabel;
    lbl_caError: TLabel;
    lbl_caPasswordError: TLabel;
    lbl_caUsernameError: TLabel;
    lbl_caWeightError: TLabel;
    memoCaUsername: TMemo;
    img_qu: TImage;
    lbl_siError: TLabel;
    procedure btn_createAccountClick(Sender: TObject);
    function validateCreateAccount(Username, Password, Height, Weight:TObject; var aUsername, aPassword: string; aHeight, aWeight: real):boolean;
    procedure btn_signInClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure img_quMouseEnter(Sender: TObject);
    procedure img_quMouseLeave(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form_acc: Tform_acc;

implementation

{$R *.dfm}

uses databases, dashboard;

procedure enterDataInitialisation;
var currentTime, midday, midnight, evening :TDateTime;
begin
currentTime:= now; //system clock time
midday:= encodeTime(12,00,00,00); //setting midday to 12pm
midnight:= encodeTime(00,00,00,00); //setting midnight to 0am
evening:= encodeTime(18,00,00,00);  //setting evening to 6pm
if ((compareTime(currentTime, midnight)= 1) AND (compareTime(currentTime, midday)= -1)) OR (compareTime(currentTime, midnight)= 0)  then //between midnight and midday
  form_enterData.lbl_greeting.Caption:= 'Good Morning ' + currentUser; //good morning
if(compareTime(currentTime, midday)= 1) AND (compareTime(currentTime, evening)= -1) OR (compareTime(currentTime, midday)= 0) then //between midday and 6pm
  form_enterData.lbl_greeting.Caption:= 'Good Afternoon ' + currentUser;  //good afternoon
if (compareTime(currentTime, evening)= 1) OR (compareTime(currentTime, evening)= 0) then //between 6pm and midnight
  form_enterData.lbl_greeting.Caption:= 'Good Evening ' + currentUser;     //good evening
form_enterData.lbl_displayBmi.Caption:= (floattostr(roundto(currentBMI,-1))); //displaying currentBMI to 1 dp

end;

//determines next form to show
procedure nextPage;
var findFile: string;
begin
findFile:=FileSearch('sleepProgress.txt', currentDir); //checking for the sleep file in the user's directory
if findFile = '' then //if file not found
  begin
  Form_enterData.Show; //if no factor files have been created, details have not yet been entered, so show the 'enterData' page
  end
else  //file found
  begin
  factorBMI:= getFactorBMI; //initialising factorBMI
  form_dashboard.show; //show dashboard
  dashboardInitialisation;  //initialising dashboard
  end;
end;

//on clicking sign in
procedure Tform_acc.btn_signInClick(Sender: TObject);
var aUsername, aPassword: string; // user's inputs
    isError, isFound: boolean; //flags
    f, path: string; //to hold file pathnames
    existingUser, existingPassword:string; //usernames read from file
begin
isError:=FALSE;//initialising isError
lbl_siError.Caption:= ''; //removing any previous error messages

aUsername:= edt_siUsername.Text; //assigning the username and password variables
aPassword:= edt_siPassword.Text;

if (aUsername = '') OR (aPassword = '') then //if fields are blank
    begin
    lbl_siError.Caption:= 'Fields can not be left blank'; //error messsage
    isError:= TRUE; //changing state of flag
    end;

if (isError= FALSE) then //only proceeds if all fields no fields are blank
    begin
    f:= getcurrentdir; //gets the current directory
    path :=(leftstr(f,length(f)-11)); // gets the pathname of userDetails
    assignfile(intUserDetails, path+'userDetails.dat');//creating an internal version of userDetails
    reset(intUserDetails);  //Opening a read-only version of the internal file
    isFound := FALSE; //initialising flag, indicating whether the username is found on userDetails
    WHILE (not eof(intUserDetails)) AND (isFound= FALSE) do
      begin
      readln(intUserDetails, existingUser);//assigning each username to variable existingUser
      if aUsername = existingUser then //if the username read is the same as the inputted username
          begin
          isFound :=TRUE; //changing state of flag
          readln(intUserDetails, existingPassword); //reads the corresponding password
          if existingPassword = aPassword then //if the password is found
              begin
              currentUser := aUsername; //intialising global variable currentUser
              end
          else
              begin
              isError:=TRUE; //changing state of flag
              lbl_siError.Caption:= 'Incorrect password'; //error message
              end;
          end
      else
      readln(intUserDetails); //skipping past the password
      end;

    closefile(intUserdetails);  //close file
    if (isFound= FALSE) then //checking state of flag isFound
      begin
      lbl_siError.Caption:= 'No existing user'; //error message
      isError:= TRUE;  //change flag state
      end;
    end;

if (isError= FALSE) then //if no errors
    begin
    //initialising global variables
    currentDir:= getCurrentDir +'\' + currentUser; //the user's folder pathname
    currentBMI:= getBMI; //getting the user's BMI from file

    Form_acc.Hide; //hiding the current form
    nextpage; //procedure determines the next form to be viewed
    end;

enterDataInitialisation; //intialise enterData form
end;

//on creating the form
procedure Tform_acc.FormCreate(Sender: TObject);
begin
memoCaUsername.Visible:=false; //hide the username memo
memoCaUsername.Text:= 'Username should be between 6 and 15 characters' + //memo caption
                        ' and not contain characters /,? or \'  ;
edt_siPassword.PasswordChar:= '*'; //blanking password characters
end;

//hovering over question bubble
procedure Tform_acc.img_quMouseEnter(Sender: TObject);
begin
memoCaUsername.Visible:=true; //memo is visible
end;

//moving mouse off question bubble
procedure Tform_acc.img_quMouseLeave(Sender: TObject);
begin
memoCaUsername.Visible:=false; //memo is invisible
end;

//validating create account inputs
function Tform_acc.validateCreateAccount(Username, Password, Height, Weight:TObject; var aUsername, aPassword: string; aHeight, aWeight: real):boolean;
var isError: boolean;
    f, path: string;
    existingUser: string;
    i: integer;
begin
isError:= FALSE; //initialising isError, the variable to be returned

if (length(aUsername) <6) OR (length(aUsername) > 15)  then // Checking the length of the password
  begin
  lbl_caUsernameError.Caption:=  'Username must be between 6 and 15 characters'; //error message
  isError:=TRUE; //changing flag state
  end;

for I := 1 to length(aUsername) do //move through each character of the username to check for ?,/ or \
  if (aUsername[i] = '?') OR (aUsername[i] = '/') OR (aUsername[i] ='\') then
      begin
        isError:= TRUE; //setting flag as true
        lbl_caUsernameError.Caption:= 'Username should not have ?, / or \';  //error message
      end;

f:= getcurrentdir; //getting the current directory
path :=(leftstr(f,length(f)-11)); //using the current directory to get the path of the folder with the userDetails file
assignfile(intUserDetails, path+'userDetails.dat');//creating an internal version of userDetails
reset(intUserDetails);  //Opening the internal file
WHILE (not eof(intUserDetails)) AND (isError = FALSE) do //continuing until the end of file or if an error has occurred
  begin
  readln(intUserDetails, existingUser);//assigning each username to variable existingUser
  if existingUser = aUsername then //checking for another user with the same username
      begin
        isError := TRUE; //setting the error flag as true
        lbl_caWeightError.Caption:= 'User already exists'; //outputting error message
      end;
  readln(intUserDetails); //I am skipping a line: every second line is a username.
  end;
closefile(intUserdetails); //close file

if (length(aPassword) <6) OR (length(aPassword) > 15)  then // Checking the length of the password
  begin
  lbl_caPasswordError.Caption:=  'Password must be between 6 and 15 characters';//error message
  lbl_caPasswordError.Color:=clRed; // Outputting an error message in red
  isError:=TRUE;
  end;

if (aHeight < 0.5) OR (aHeight > 3) then  //checking range of height
  begin
  lbl_caHeightError.Caption:= 'Height is invalid'; //error message
  isError := TRUE;
  end;

if (aWeight < 30) OR (aWeight > 200) then  //checking weight range
  begin
  lbl_caWeightError.Caption:= 'Weight is invalid'; //error message
  isError := TRUE;
  end;

result:= isError; //returns whether an error has occurred

end;

//on clicking create account
procedure Tform_acc.btn_createAccountClick(Sender: TObject);
var
isError, isInitialError: boolean; {initial error checks for the correct data
type and ensures critical fields are not left blank}

aUsername, aPassword: string;
aHeight, aWeight: double;

isHeightFloat, isWeightFloat: boolean;

f, path: string;
bmiProgress:textfile;

begin
lbl_caUsernameError.Caption:= ''; //hiding any previous error messages
lbl_caPasswordError.Caption:= '';
lbl_caHeightError.Caption:= '';
lbl_caWeightError.Caption:= '';
lbl_caError.Caption:='';

isInitialError:= FALSE; //initialising isInitialError
isError:= FALSE; //initialising isError
aUsername:= edt_caUsername.Text;
aPassword:= edt_caPassword.Text; //Assigning inputs to variables
//I am not assigning the variable aHeight or aWeight until confirming the data type

//initial validation to ensure inputs are of correct data type before main validation
  //Checking if fields have been left blank
if (aUsername = '') OR (aPassword = '') OR (edt_caHeight.Text = '') OR (edt_caWeight.Text = '') then
    begin
    lbl_caError.Caption:= 'Fields can not be left blank'; //outputting an error message
    isInitialError:=TRUE; //changing state of the flag
    end
else
    begin
    isHeightFloat:= TryStrtoFloat(edt_caHeight.Text, aHeight);//If height is of type float, it is assigned to aHeight
    if (isHeightFloat=FALSE) then
        begin
        lbl_caHeightError.Caption:= 'Height should be a number'; //ouputting an error message
        isInitialError:= TRUE; //changing state of the flag
        end;
    isWeightFloat:= TryStrtoFloat(edt_caWeight.Text, aWeight);//If weight is of type float, it is assigned to aWeight
    if (isWeightFloat=FALSE) then
        begin
        lbl_caWeightError.Caption:= 'Weight should be a number';  //ouputting an error message
        isInitialError:= TRUE;  //changing state of the flag
        end;
    end;
if isInitialError = FALSE then  //if no initial errors
    begin
    //call validation subroutine
    isError := validateCreateAccount(lbl_caUsernameError, lbl_caPasswordError, lbl_caHeightError, lbl_caWeightError, aUsername, aPassword, aHeight, aWeight);
    end;
if (isError = FALSE) AND (isInitialError = FALSE) then   //If no error
    begin
    currentBMI:= (aWeight/aHeight)/aHeight; //calculate bmi
    currentUser:= aUsername; //assign global variable currentUser

    //adding them to file userDetails
    f:= getcurrentdir; //getting current directory
    path :=(leftstr(f,length(f)-11)); //getting filepath for userDetails
    assignfile(intUserDetails, path+'userDetails.dat');//creating an internal version of userDetails
    Append(intUserDetails);  //Opening version of the internal file where I can append to the bottom
      writeln(intUserDetails, aUsername); //writing in username
      writeln(intUserDetails, aPassword); //writing in password
    closefile(intUserdetails);

    CreateDir(currentUser); //CreateDir is a built in function
    currentDir:= getCurrentDir +'\' + currentUser; //getting the directory of the current user's folder

    Showmessage('Your account has been created '+currentUser); //an alert box

    AssignFile(bmiProgress, currentDir+'\bmiProgress.txt'); //creating an internal and external version of bmiProgress
      Rewrite(bmiProgress); //Opening an internal version of bmiProgress where I can Write into it
      Writeln(bmiProgress);
      Writeln(bmiProgress, datetostr(date)); //writing the date in bmiProgress
      Writeln(bmiProgress, currentBMI:2:4); //writing the users bmi into bmiProgress
    Closefile(bmiProgress);

    enterDataInitialisation; //initialise enterData form
    form_acc.Hide; //shows the current form
    form_enterData.Show; //shows the enter data form
    end;

end;



end.
