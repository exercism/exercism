## Installing C&#35;

### Windows
There are a couple of different ways to get started using C#. The main way is to
install Visual Studio, the IDE for C# and related projects.

If you don't want to use the IDE, files can be compiled via command line using the
compiler provided by the .NET framework.

##### With Visual Studio
Install [Visual Studio Express 2013 for Windows Desktop](http://www.visualstudio.com/downloads/download-visual-studio-vs#d-express-windows-desktop).
This will include the IDE and compiler for C#.

Once installed and started, click on "Create New Project" (alternatively, you can go to File->New->New Project).

![New Project](/img/help/setup/csharp/newProject.png)

Choose what language and project type (Visual C# and Class Library). Also name your project to whatever you'd like.

![Create Project](/img/help/setup/csharp/createNewProject.png)

Once created, feel free to drag and drop the C# Exercism folders into the project.

![Drag and Drop Folders](/img/help/setup/csharp/dragDropFolders.png)

In order to compile, get the [NUnit](http://nunit.org/) assembly referenced for the unit tests. This can be done via [NuGet](http://www.nuget.org/) - a package manager for Visual Studio. The best packages is to get the base [NUnit]() and the [NUnit.Runners](https://www.nuget.org/packages/NUnit.Runners/)
package since it includes the assemblies needed and a GUI test runner.

![Nuget](/img/help/setup/csharp/nugetMenu.png)

Two options to use Nuget - the NuGet manager or through the Package Manager Console.

The manager is the easiest way to get started.

![Nuget Manager](/img/help/setup/csharp/nugetManageNunitRunner.png)

The project should now be able to compile.

##### With the command line compiler
The .cs files can also be compiled without Visual Studio. Get the latest version of
[].NET installed](http://msdn.microsoft.com/en-us/library/5a4x27ek(v=vs.110).aspx) and there will be an executable called csc.exe.

The compiler executable is usually located in the Microsoft.NET\Framework\Version folder under the Windows directory.

Refer to this [MSDN article](http://msdn.microsoft.com/en-us/library/78f4aasd.aspx) for more information on the command line compiler.

### Mac
Install [Mono Develop](http://www.mono-project.com/Mono:OSX#Installing_Mono_on_MacOS_X).

Build
```bash
dmcs Bob.cs BobTest.cs /../NUnit-2.6.3/bin/nunit.framework.dll -target:library
```

Link
```bash
monolinker -a /../NUnit-2.6.3/bin/nunit.framework.dll -a Bob.dll
```

And run the DLL
```bash
mono /../NUnit-2.6.3/bin/nunit-console.exe output/Bob.dll
```

Clean up afterwards, if needed.
```bash
rm -rf output
```

Mono does have an IDE that can be used for development instead of the above command line commands.

### Linux

[Mono Develop](http://www.mono-project.com/Mono_For_Linux_Developers) is also available for Linux.

## Running Tests
All tests have been ignored except the first one for you to work on. To continue, just remove the ```[Ignore]``` attribute on the test to start working on it.

Make sure [NUnit](http://nunit.org/?p=download) is installed, if not already installed from the setup from above.

This installation should include the NUnit-Gui executable. Run this and, after compiling, open the assembly from the Gui and you are able to run the tests.

**Note:** You may need to include the nunit-framework.dll in the same directory as the source code you're compiling if you get an error saying it can't find the ```nunit.framework.dll```.

If you installed the NUnit runner through NuGet, the runner will be located in the ```\packages\NUnit.Runners(version number)\tools``` folder where your project is.

If you installed NUnit manually the runner will be in the ```Program Files (x86)\NUnit(version number)\bin``` folder.

![NUnit Runner](/img/help/setup/csharp/nUnitRunner.png)

Once you have been able to compile the code it will create a DLL in the ```\bin\Debug``` folder of your project. In the NUnit runner, select "Open Project" and select the DLL that was created from compiling. This will load all the tests and allow you to run them.

![NUnit Runner Execute Tests](/img/help/setup/csharp/nUnitExecuteTests.png)

The NUnit runner will automatically reload the DLL if it has been updated.

## Recommended Learning Resources

Exercism provides exercises and feedback but can be difficult to jump into for those learning C# for the first time. These resources can help you get started:

* [Channel9 Series: C# Fundamentals](http://channel9.msdn.com/Series/C-Sharp-Fundamentals-Development-for-Absolute-Beginners)
* [MSDN Walkthrough: Getting Started with C#](http://msdn.microsoft.com/library/vstudio/dd492171(v=vs.120))
* [.NET Framework Development Guide](http://msdn.microsoft.com/library/vstudio/hh156542)
* [StackOverflow](http://stackoverflow.com/)
  * [C#](http://stackoverflow.com/questions/tagged/c%23)
  * [.NET](http://stackoverflow.com/questions/tagged/.net)
  * [NUnit](http://stackoverflow.com/questions/tagged/nunit)