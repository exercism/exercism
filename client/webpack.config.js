var webpack = require("webpack");

module.exports = {
  context: __dirname,
  entry: './app/main.js',
  output: {
    path: '../lib/app/public/js',
    filename: 'bundle.js'
  },
  resolve: {
    root: ['./bower_components']
  },
  plugins: [
    new webpack.ResolverPlugin(
      new webpack.ResolverPlugin.DirectoryDescriptionFilePlugin(
        'bower.json',
        ['main']
      )
    )
  ]
};
