module.exports = {
  /*
   * GSA Panel protocol: http or https
   * Only needed for the deploy function
   */
  gsaProtocol: 'https',
  
  /*
   * GSA Panel host
   * Only needed for the deploy function
   */
  gsaHost: '10.0.16.65',

  /*
   * GSA Panel port
   * Only needed for the deploy function
   */
  gsaPanelPort: '8443',

  /*
   * GSA Panel login (username)
   * Only needed for the deploy function
   */
  gsaLogin: 'admin',

  /*
   * GSA Panel password
   * Only needed for the deploy function
   */
  gsaPass: 'gsa123',

  /*
   * JS files path
   */
  jsPath: './assets/js',
 
  /*
   * JS files output path (where to go after gulp's js task)
   */
  jsBuildPath: './assets/build/js',

  /*
   * CSS files path
   */
  cssPath: './assets/css',

  /*
   * CSS files output path
   */
  cssBuildPath:     './assets/build/css',

  /*
   * Generated files path (template and partials)
   * This path is used when you do a hulq smash. Generated files go to this path
   */
  generatedPath:          './generated',
  generatedPartialsPath:  './generated/partials',

  /*
   * Workspace path (template and partials)
   * This is where you are going to work
   */
  xsltPath:         './workspace',
  xsltPartialsPath: './workspace/partials',

  /*
   * Output path
   * Where the final generated xslt will go after ./hulq recover
   */
  xsltBuildPath:    './build'

};
