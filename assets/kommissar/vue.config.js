const path = require('path')

module.exports = {
  publicPath: '/kommissar',
  outputDir: path.resolve(__dirname, '../../priv/static/kommissar'),
  chainWebpack: config => {
    config.optimization.delete('splitChunks')
  }
}
