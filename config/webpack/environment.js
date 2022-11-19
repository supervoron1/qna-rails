const { environment } = require('@rails/webpacker')

module.exports = environment

environment.loaders.append('expose', {
    test: require.resolve('cash-dom'),
    loader: 'expose-loader',
    options: {
        exposes: '$'
    }
});