const qiniu = require('qiniu');
const BaseConfig = require('./BaseConfig')

// 七牛云配置
const accessKey = BaseConfig.accessKey;
const secretKey = BaseConfig.secretKey;
const bucket = BaseConfig.bucket;
const domain = BaseConfig.domain;

// 初始化七牛云客户端
const mac = new qiniu.auth.digest.Mac(accessKey, secretKey);
const config = new qiniu.conf.Config();
// 根据你的存储区域选择对应的机房
config.zone = qiniu.zone.Zone_z0; // 华南区域

// 初始化BucketManager用于文件删除
const bucketManager = new qiniu.rs.BucketManager(mac, config);

// 上传凭证生成函数
const getUploadToken = (key) => {
  const options = {
    scope: `${bucket}:${key}`,
    expires: 3600 // 凭证有效期1小时
  };
  const putPolicy = new qiniu.rs.PutPolicy(options);
  return putPolicy.uploadToken(mac);
};
// 删除七牛云单文件
const deleteFile = (key) => {
  return new Promise((resolve, reject) => {
    bucketManager.delete(bucket, key, (err, respBody, respInfo) => {
      if (err) {
        return reject(err);
      }
      if (respInfo.statusCode === 200) {
        resolve(true); // 删除成功
      } else {
        reject(new Error(`删除失败: ${JSON.stringify(respBody)}`));
      }
    });
  });
};
// 批量删除七牛云文件
const batchDeleteFiles = (keys) => {
  return new Promise((resolve, reject) => {
    // 校验参数：keys 必须是数组且非空
    if (!Array.isArray(keys) || keys.length === 0) {
      return reject(new Error('文件key列表不能为空（必须是数组）'));
    }

    // 七牛云限制单次批量删除最多1000个文件
    if (keys.length > 1000) {
      return reject(new Error('单次批量删除最多支持1000个文件，请拆分后重试'));
    }

    // 构造批量删除指令：每个key对应一个删除操作
    const deleteOps = keys.map(key => {
      return qiniu.rs.deleteOp(bucket, key); // 七牛云批量删除指令构造器
    });

    // 调用七牛云批量API执行删除
    bucketManager.batch(deleteOps, (err, respBody, respInfo) => {
      if (err) {
        return reject(new Error(`批量删除请求失败: ${err.message}`));
      }

      // 处理响应结果（七牛云会返回每个文件的删除状态）
      if (respInfo.statusCode === 200) {
        // 成功响应格式：[{ code: 200, data: {} }, ...]
        const successKeys = [];
        const failKeys = [];

        respBody.forEach((item, index) => {
          const key = keys[index];
          if (item.code === 200) successKeys.push(key);
          else failKeys.push({ key, error: item.data.error });
        });

        resolve({
          success: true,
          total: keys.length,
          successCount: successKeys.length,
          failCount: failKeys.length,
          successKeys,
          failKeys
        });
      } else {
        // 整体请求失败（如权限不足、bucket不存在等）
        reject(new Error(`批量删除失败: 状态码${respInfo.statusCode}，原因：${JSON.stringify(respBody)}`));
      }
    });
  });
};

module.exports = {
  getUploadToken,
  deleteFile,
  batchDeleteFiles,
  config,
  domain
};
