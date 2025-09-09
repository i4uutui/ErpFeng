const qrcode = require('qrcode');
const qiniu = require('qiniu');
const { getUploadToken, config, domain } = require('../config/qinniu');
const { v4: uuidv4 } = require('uuid');

// 生成二维码并上传到七牛云
const generateAndUploadQrcode = async (content) => {
  try {
    // 生成二维码的Buffer
    const buffer = await qrcode.toBuffer(content, {
      width: 128,
      margin: 1
    });
    
    // 生成唯一文件名
    const fileName = `qrcodes/${uuidv4()}.png`;
    
    // 获取上传凭证
    const token = getUploadToken(fileName);
    
    // 上传到七牛云
    const formUploader = new qiniu.form_up.FormUploader(config);
    const putExtra = new qiniu.form_up.PutExtra();
    
    return new Promise((resolve, reject) => {
      formUploader.putStream(
        token,
        fileName,
        bufferToStream(buffer),
        putExtra,
        (err, body, info) => {
          if (err) {
            return reject(err);
          }
          if (info.statusCode === 200) {
            // 返回完整的二维码URL
            resolve(`${domain}/${fileName}`);
          } else {
            reject(new Error(`上传失败: ${JSON.stringify(body)}`));
          }
        }
      );
    });
  } catch (error) {
    console.error('二维码生成或上传失败:', error);
    throw error;
  }
};

// 将Buffer转换为Stream
const bufferToStream = (buffer) => {
  const { Readable } = require('stream');
  const stream = new Readable();
  stream.push(buffer);
  stream.push(null);
  return stream;
};

module.exports = {
  generateAndUploadQrcode
};
