# Exercism front end

This document describes the new front end of exercism.io. Both, document and
frontend are under active development.

## Tools
- **[NodeJS](https://nodejs.org/)** platform for building fast, scalable network applications
- **[npm](https://www.npmjs.com/)** package manager for NodeJS
- **[AngularJS](https://angularjs.org/)** front end JS framework
- **[webpack](http://webpack.github.io/)** module bundler
- **[Gulp](http://gulpjs.com/)** JS task runner
- **[Bower](http://bower.io/)** package management
- **[Karma](http://karma-runner.github.io/0.12/index.html)** JS test runner
- **[Jasmine](http://jasmine.github.io/)** JS test framework
- **[Protractor](https://github.com/angular/protractor)** Angular JS end-to-end test framework
- **[Underscore](http://underscorejs.org/)** JS library providing some useful functional programing helpers
- **[AngularUI Router](https://github.com/angular-ui/ui-router)** Angular JS routing framework
- **[ngAnnotate](https://github.com/olov/ng-annotate)** dependency injection system for AngularJS

Plus various smaller plugins and libraries (E.g. sass preprocessor, twitter bootstrap...)

TODO: update list

## File structure

Client application will be part of **[exercism.io](https://github.com/exercism/exercism.io)** and will
live in the same repo:

```
exercism.io/
  bin/
  client/ << here goes the client code
  config/
  db/
  ...
```

File structure of the client:

```
client/
    app/                                    // actual application code
        bower_components/                   // bower modules
            ...
        components/                         // components used accross the app
          /top_nav
            top_nav.html
            top_nav_directive.js
            top_nav_directive.spec.js
            top_nav.scss
            logo.png
            index.js                        // every module needs index.js so we can load it as one
          /comment_box
            comment_box.tmpl.html
            comment_box_directive.js
            comment_box_directive.spec.js
            comment_box.scss
            index.js
          ...
        exercises/
          exercises_list_controller.js
          exercises_list_controller.spec.js
          exercises_list.html
          exercises_list.scss
          config.js
          index.js
        submissions/
          submissions_detail_controller.js
          submissions_detail_controller.spec.js
          submissions_detail.html
          submissions_detail.scss
          submissions_new_controller.js
          submissions_new_controller.spec.js
          submissions_new.html
          submissions_new.scss
          config.js
          index.js
        ...
        main.js                              // main application file - entry point, requires all the needed modules
        index.html                          // main html file - layout (we don't actually need it now)
    e2e/                                    // end-to-end tests, split into directories by modules, one file for one feature
      submissions/
        create_submission_spec.js           // spec testing creating of new submission
        create_submission_page.js           // helper page object
        edit_submission_spec.js
        edit_submission_page.js
      helpers/                              // common functions needed in end-to-end tests
      ...
    tasks/                                   // individual Gulp tasks required, one file = one task
    node_modules/                           // installed node modules, not checked in to git
    .gitignore
    bower.json                              // Bower configuration
    gulpfile.js                             // Gulp configuration
    webpack.config.js                       // Webpack configuration
    package.json                            // npm dependencies (Gulp & Webpack)
    protractor.config.js                    // Protractor (end-to-end tests) configuration
```

## How it works

Long story short (lots of details ommited):
Client files are bundled into single js file by Webpack and together with any images moved into `./lib/app/public/js` folder,
and `./lib/app/views/layout.erb` then requires `bundle.js` file, which will load all the needed dependencies. (NOTE: Find a
way how to make webpack load only needed modules for current view).

## Development

### Prerequsities
Installed NodeJS and npm. Instructions can be found [here](http://blog.nodeknockout.com/post/65463770933/how-to-install-node-js-and-npm).

In the `./client` directory:
run commands:

1. `npm install` - install all npm dependencies
2. `bower install` - install all bower dependencies
3. `gulp` - run Gulp's default task (this will bundle all client side files into single file, copy it into `./lib/app/public/js` and start watching the files with enabled live reloading)

In the root application directory:

1. run `foreman start`

### Tasks
* `gulp` - default task, runs `gulp clean`, `gulp build` and `gulp watch`
* `gulp clean` - delete contents of `./lib/app/public` folder
* `gulp build` - bundle all the modules together and output `bundle.js` file into `./lib/app/public/js` directory
* `gulp copy` - copy `bundle.js` and images to `lib/app/public/` directory
* `gulp watch` - watch for changes in js/css/html files
* `gulp test` - run karma tests
* `gulp e2e` - run protractor end-to-end tests

### Deployment
TODO

### CI
TODO

## Best practises
TODO

### General
* Favor npm packages before bower packages, use bower package only if you cannot find npm package. [Why?](http://webpack.github.io/docs/usage-with-bower.html)

### Javascript

### Styles

## Useful resources

### AngularJS
* [AngularJS styleguide](https://github.com/johnpapa/angular-styleguide)
* [AngularJS modular demo](https://github.com/johnpapa/ng-demos/tree/master/modular)
* [Guide to componentized AngularJS](http://labs.bench.co/2015/1/21/componentized-angular)
* [Google's AngularJS app structure best practices](https://docs.google.com/document/d/1XXMvReO8-Awi1EZXAXS4PzDzdNvV6pGcuaF4Q9821Es/mobilebasic?pli=1)
* [Egghead tutorials](https://egghead.io/) (partially paid)

### Webpack
* [Webpack guide](https://github.com/petehunt/webpack-howto)
* [AngularJS bundling best practices](http://www.reddit.com/r/angularjs/comments/252z6x/what_are_best_practices_for_bundling_angularjs/)

### JavaScript
* [Google's JavaScript styleguide](http://google-styleguide.googlecode.com/svn/trunk/javascriptguide.xml)
