var webpack = require("webpack");

module.exports = {
  context: __dirname,
  entry: './app/main.js',
  output: {
    path: '../lib/app/public/js',
    filename: 'bundle.js'
  },
  module: {
    loaders: [{
      test: /\.html$/,
      loader: 'raw',
      exclude: ['./node_modules/', './bower_components/']
    }, {
      test: /\.sass$/,
      loader: 'style!css!sass?indentedSyntax',
      exclude: ['./node_modules/', './bower_components/']
    }]
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
    ),
    new webpack.DefinePlugin({
      getEnv: function() {
        return 'test'
      }
    })
  ]
};
