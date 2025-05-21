# work_ui

A new Flutter project.
Working:
This is a simple app where users can log in and manage their credit and debit transactions.
Data is stored locally using SQFlite,Users can add, edit, and delete transactions.The app separates transactions into Credit and Debit tabs for easy viewing.

EXPLANATION:-
In this app, there are mainly five folders:
models – Contains transaction.dart, which defines the transaction model.
pages – Includes home.dart, login.dart, and splash.dart, which handle the main screens of the app.
services – Contains database_services.dart, which manages database operations using SQFlite.
utils – Includes validator.dart, which is used for form validations.
widgets – Contains reusable UI components like login_button.dart, text_field.dart, transaction_dialog.dart, and transaction_list.dart.
And finally the main function called main.dart.

1.main.dart:
it is the entry point of the application. before the app start i have initilized a funtion called WidgetsFlutterBinding.ensureInitialized(); and it is used to make sure that the flutter engin and widget system are fully inililized befor you run any code that depend on them. it is typically use it before runapp() and befor calling asynchronous code in main()
like loading shared preferences,fire base inilization etc.
Inside the material_App there is a path to the splash screen.

2.splash.dart:
inside the splash screen there is a initstate() whiich is used to run the state when we start the app and inside the initstate() there is a custom build function called \_navigate();-
It start with two second delay using Future.delayed to simulate a splash screen duration.Then it uses sharedpreferences to check if the users email and password are already saved locally. if both email and password the user is automatically navigated to homepage().if no save email and password the app navigates to the loginpage. and inside the scaffold there is a image.

3.login.dart:
in login page there are two controller which is used to controll the data.and also there is a form key which is used to uniquely identify the form and allow vslidation of user input.and there is boolean variable called \_hidetext which is used to control the visibility of the password.if it is true the password is hidden else it is visible.
\_saveLogin():
this function is used to store the users email and passwor locally using sharedpreferences.if the user is loged in they dont have to login again thats the main puropse of this function.the function takes emaik and password as parameters and saved them as key value pairs in local storage.
\_togglepassword();
this function is used to toggle the visibility of the password field in the login from.it uses the set state to update the hidetext boolean variable.
\_handlelogin():
this function is triggered when the user submits the login form.it check the form input is valid using \_formkey. retrives and trim the email and password entered by the user.save the email and password to local storage using sharedpreferences through the savelogin function.if the login details are valid it navigate the user to homepage ,replacing the current screen to prevent returning to the login screen on bacl press.

And there a scaffold inside that there is the ui of the app and the textform field and buttons are custom.

customTextdield():
it is a reusable input field used throughout the app to simpify form creation it contains,
a controller to handle the text entered
a hinttext to show placeholder text indide the field
an icon to display at the begining of the input field
an suffixicon used to show or hide the password.
an validator to validate user input
Loginbutton():
And there is a login button for handling login.

4.home.dart();
It is the home page that contains all the data and also contains a floating action button and tab bars. When we click the floating action button, a dialog box appears with the data containing debit and credit, also money and remark, and also a submit button. When we submit the button, the data will be visible on the home screen, and also there is an option for deleting and editing the data.
There is an empty list to store the transaction.
logout();
this function is used to logout from the screen and it clear all the datas of the current user.

\_loadTransactions():
used to load the data that is alredy stored in the data base.
And there is a scaffold inside that there is the ui of home page.
5.database_services();
This class handles all database operations using sqflite package. it manages how transaction are stored retrived,updated and deleted from database.

addTransaction():used to add new transaction.
getalltransaction():used to retrive all stored transaction.
deleteTransaction():used to delet the datas.
updateTransaction():used to updae the current data.

validatir():
it is used to check the email and passowrd is valid.
