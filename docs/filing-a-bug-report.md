# Writing an Actionable Bug Report

We're a work in progress.  You reporting bugs in a clear and actionable format is a big help.  Thanks!!

When writing a bug, please include:

1. the steps you took to get to the defect (number the steps using a little markdown, as shown below).
-  what you *expected* to happen after the last step.
-  what *actually* happened after the last step.
- information about your particular situation:
  * if it's happening while you're using the CLI, include the **redacted** output of `exercism debug`.
    * "redacted" meaning remove your API key from the output before including in the issue.
  - if its' happening on the website, include your OS and browser versions.

## Example

    1. I recently completed the Hello World for Java. 
    -  I submitted the file (I got the success message).
    -  I went to the link provided by the CLI.
       * **Expected:** to see my submission, 
       * **Actual:** I got a 404.

    Here's my "exercism debug":
    ```
    **** Debug Information ****
    Exercism CLI Version: 2.3.0
    Exercism CLI Latest Release: 2.3.0
    OS/Architecture: darwin/amd64
    Build OS/Architecture /
    Home Dir: /Users/jtigger
    Config file: /Users/jtigger/.exercism.json
    API Key: *******
    Exercises Directory: /Users/jtigger/workspace/exercism/exercises
    Testing API endpoints reachability
      * API: http://exercism.io [connected] 350.644953ms
      * GitHub API: https://api.github.com/ [connected] 386.82533ms
      * XAPI: http://x.exercism.io [connected] 796.511395ms
    ```

which formats to:

-

1. I recently completed the Hello World for Java. 
-  I submitted the file (I got the success message).
-  I went to the link provided by the CLI.
   * **Expected:** to see my submission, 
   * **Actual:** I got a 404.

Here's my "exercism debug":
```
**** Debug Information ****
Exercism CLI Version: 2.3.0
Exercism CLI Latest Release: 2.3.0
OS/Architecture: darwin/amd64
Build OS/Architecture /
Home Dir: /Users/jtigger
Config file: /Users/jtigger/.exercism.json
API Key: *******
Exercises Directory: /Users/jtigger/workspace/exercism/exercises
Testing API endpoints reachability
  * API: http://exercism.io [connected] 350.644953ms
  * GitHub API: https://api.github.com/ [connected] 386.82533ms
  * XAPI: http://x.exercism.io [connected] 796.511395ms
```
   
-

