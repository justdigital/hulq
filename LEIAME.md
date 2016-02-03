# LEIA-ME #

HULQ - Framework simples para desenvolvimento XSLT

## Pré-requisitos ##

Antes de começar, se certifique de ter os itens abaixo instalados:

1. [nodejs](https://nodejs.org/)
2. [npm](https://www.npmjs.com/)
3. [gulp](http://gulpjs.com/) (sudo npm install gulp -g)
4. [phantomjs](http://phantomjs.org/) (para deploy)

## Instalação / Uso ##

```
$ sudo npm install hulq -g #precisa estar disponível global
$ hulq begin seu_template.xslt
$ cd seu_projeto
```

Agora é com você: Edite o arquivo xslt (**workspace/seu_template.xslt** e **workspace/partials/*.xslt**)

## Comandos HulQ ##

  1. begin
  2. smash
  3. prepare
  4. recover
  5. deploy
  6. watch
  7. lookup
  8. destroy
  9. help

Você pode ver suas descrições usando **hulq help**

## O arquivo Gulpfile ##

Você pode alterar esse arquivo para configurar como seu output será gerado.
A documentação do gulp-xslttemplate está disponível [aqui](tasks/README.md)


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

Crie um novo arquivo xslt com tudo junto:

```
$ hulq recover # OU
$ hulq watch # para monitorar os arquivos e recuperá-los quando editados
```

## Contribuindo


O sistema de contribuição do HulQ usa o GitHub para gerenciar os pull-requests. Então, basicamente, para contribuir, você irá fazer um [fork](https://help.github.com/articles/fork-a-repo/), executar o commit de suas alterações e submeter um pull-request baseado na issue criada por qualquer usuário GitHub. Seguem alguns passos mais detalhados:

1. Faça um [fork](https://help.github.com/articles/fork-a-repo/) do projeto e configure o repositório.
2. Crie uma nova branch para trabalhar: **git checkout -b nova_branch**
3. Trabalhe no código e realize o commit de suas alterações. **ALERTA: Você deve realizar o commit de seus arquivos com quebra de linhas LF. [Leia mais aqui](https://help.github.com/articles/dealing-with-line-endings/)**
4. Depois de ter certeza que seu código foi totalmente testado, você pode realizar seu push no repositório remoto: **git push origin nova_branch**
5. Agora você deve criar um [pull-request](https://help.github.com/articles/creating-a-pull-request) com um título específico, uma boa descrição contendo **o número da issue** e um pedaço de documentação explicando o que você fez.
6. Os contribuidores do código irão revisar as alterações agora, tenha em mente que é muito comum receber pedido de alteração de código, então, tente acompanhá-los ou discutir a importância do pedido de alteração para ter certeza que tudo foi feito da melhor maneira possível.

## Licença ##

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
