*[Portuguese Version](LEIAME.md)*

# README #

HULQ - Simple framework for XSLT development

## Prerequisites ##

Before you start, make sure you have these things installed:

1. [nodejs](https://nodejs.org/)
2. [npm](https://www.npmjs.com/)
3. [gulp](http://gulpjs.com/) (sudo npm install gulp -g)
4. [phantomjs](http://phantomjs.org/) (for deployment only)

## Installation / Use ##

```
$ sudo npm install hulq -g #it needs to be available globally
$ hulq begin your_template.xslt
$ cd your_project
```

Now it is your turn: You can edit the xslt files (**workspace/your_template.xslt** and **workspace/partials/*.xslt**)

## HulQ Commands ##

  1. begin
  2. smash
  3. prepare
  4. recover
  5. deploy
  6. watch
  7. lookup
  8. destroy
  9. help

You can see their description by using **hulq help**

## The Gulpfile ##

You can change this file to configure how your output will be generated.
The gulp-xslttemplate documentation is available [here](tasks/README.md)


```
replaces: {
  jsmin: {
    filename: "app.js",
    path: jsBuildPath,
  },  
  cssmin: {
    filename: "app.css",
    path: cssBuildPath,
  }
} 
```

Create the brand new xslt file with everything together:

```
$ hulq recover # OR
$ hulq watch # to watch the files and recover when edited
```

## Contributing ##

HulQ contribution system uses GitHub to manage the pull-requests. So, basically, to contribute, you'll create a [fork](https://help.github.com/articles/fork-a-repo/), commit your changes and submit a pull-request based on a issue created by any GitHub user. These are more detailed steps:

1. [Fork](https://help.github.com/articles/fork-a-repo/) the project and set-up the repository.
2. Create a new branch to work on: **git checkout -b new_branch**
3. Work on the code and commit your changes. **WARNING: You must commit your files with LF line endings. [Read more here](https://help.github.com/articles/dealing-with-line-endings/)** 
4. After making sure your code is fully tested, you can push your commit(s) to the remote repo: **git push origin new_branch**
5. Now you must create a [pull-request](https://help.github.com/articles/creating-a-pull-request) with a good, specific title and a good description containing **the issue number** a small piece of documentation explaining what you did.
6. The code contributors will review the changes now, keep in mind that it is very common to receive code change requests, so, try to follow them or discuss the importance of the requested change to make sure that everything is done the best possible way.

## Licensing ##

Copyright 2015 HulQ Framework

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
