const qrcode = require('qrcode');
const qiniu = require('qiniu');
const { getUploadToken, deleteFile, config, domain } = require('../config/qinniu');
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

/**
 * 七牛云空间单文件删除
 * @param {string} key - 文件名（包含路径，如"qrcodes/xxx.png"）
 */
const removeQiniuFile = async (key) => {
  try {
    if (!key) {
      throw new Error('文件key不能为空');
    }
    await deleteFile(key);
    return { success: true, message: '文件删除成功' };
  } catch (error) {
    console.error('七牛云文件删除失败:', error);
    throw new Error(`文件删除失败：${error.message}`);
  }
};

/**
 * 七牛云空间批量文件删除
 * @param {string} keys - 文件名数组（包含路径，如["qrcodes/xxx.png"]）
 */
const batchRemoveQiniuFiles = async (keys) => {
  try {
    // 参数校验
    if (!Array.isArray(keys)) throw new Error('文件key列表必须是数组格式');
    if (keys.length === 0) throw new Error('文件key列表不能为空');
    // 去重（避免重复删除无效key）
    const uniqueKeys = [...new Set(keys)];
    if (uniqueKeys.length > 1000) throw new Error('单次批量删除最多支持1000个文件');

    // 调用批量删除核心函数
    const result = await batchDeleteFiles(uniqueKeys);
    return {
      success: true,
      message: `批量删除完成：总计${result.total}个文件，成功${result.successCount}个，失败${result.failCount}个`,
      data: result // 包含成功/失败的key详情
    };
  } catch (error) {
    console.error('七牛云批量文件删除失败:', error);
    throw new Error(`批量删除失败：${error.message}`);
  }
};

module.exports = {
  generateAndUploadQrcode,
  removeQiniuFile,
  batchRemoveQiniuFiles
};
