# README #

HULQ - Framework para desenvolvimento XSLT

## Como fazer? ##

Clone o repositório

```
#!bash

$ git clone git@bitbucket.org:code_just/hulq.git
```

Copie seu arquivo xslt para a pasta resources

```
#!bash

$ mv PATH/PARA/SEU/arquivo.xslt resources/
```
Quebre seu arquivo o XSLT em partes:

```
#!bash

$ ./hulq smash
```
Mova seu seus arquivos gerados para a pasta de trabalho

```
#!bash

$ mv generated/* xslt/
```
Altere o arquivo gulpfile.js para contemplar todas as suas partials criadas (na pasta **partials** dentro de **xslt** como no exemplo:

```
#!javascript

      replaces: {
        jsmin: {
          filename: "app.js",
          path: jsBuildPath,
        },  
        cssmin: {
          filename: "app.css",
          path: cssBuildPath,
        },  
        advanced_search: {
          type: "xslt",
          path: xsltPartialsPath
        },  
      } 
```

*(Para mais informações sobre o build, consulte a documentação do plugin **gulp-xslttemplate**)*

Reconstruir o XSLT com as alterações feitas nas partials:
```
#!bash

$ ./hulq build
```
