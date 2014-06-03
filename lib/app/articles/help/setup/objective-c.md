## Installing Objective-C

Ensure that you have the latest Xcode installed through the Mac App Store.

## Running Tests

Exercism will only download a test file. You will need to manually create the header and the source file associated with the exercise. You will need to generate an Xcode Project file with the test file, the header file (.h) and the source file (.m).

### Creating the project in Xcode

* Start Xcode create a new project.
* Select OSX-->Application and then Command Line Tool.
* Click Next and give it a project name using the ExerciseName is advised.
* Select Foundation at the bottom from the drop down menu.
* Click Next until the wizard is finished.
* Now that the project is created click on Editor-->Add Target.
* Select OSX-->Other and select Cocoa Unit Testing Bundle.
* Ensure it's of type XCTest and that the project and target match then click finish.
* Open the new file which will be named `ExerciseName_Tests.m` in a folder called ExerciseName Tests and replace the contents with the test file you got from exercism.
* Create a new file with the correct name for the exercise.
* Click on your project in the left hand pane.
* Select Build Phases on the right.
* Ensure that `XCTest.framework` exists under Link Binary With Libraries.
* Add your `.m` files to the compile sources list.
* Then use CMD-U to run the tests when you're ready.

Tests will be run through Xcode.

### A Test Runner

An alternative to manually generating the project file is to use a test runner utility, written in ruby, that will create a project file for you with the test file, header file and source file.

```bash
$ gem install objc
$ brew install xctool
```

Run the tests with:

```bash
$ objc ExerciseName
```

The objc utility uses the exercise name to find the test file, `ExerciseNameTest.m`, the header file, `ExerciseName.h` and source file `ExerciseNameTest.m`. The files are inserted into a temporary Xcode Project and then `xctool` is used to run the tests for the project.

While `objc` makes it so you never have to launch Xcode to complete these exercises, the error messages and feedback through the command-line are not as clear as through the Xcode user interface.
