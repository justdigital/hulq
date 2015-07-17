# README #

HULQ - Simple framework for XSLT development

## Installation / Use ##

Clone the repo

```
$ git clone git@github.com:justdigital/hulq.git
```

Move your XSLT template to the project folder

```
$ mv PATH/TO/YOUR/template.xslt resources/template.xslt
```
Break your template in many parts:

```
$ ./hulq smash
```
Move the generated files to the XSLT workspace

```
$ mv generated/* xslt/
```

Now it is your turn: You can edit the xslt files (workspace/**/*.xslt)

## The Gulpfile ##

You can change this file to configure how your output will be generated

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

TODO Create a documentation for our gulp plugin:  **gulp-xslttemplate**

Create the brand new xslt file with everything together:
```
#!bash

$ ./hulq recover
```


## Contributing ##

TODO
