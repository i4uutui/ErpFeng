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

// 上传凭证生成函数
const getUploadToken = (key) => {
  const options = {
    scope: `${bucket}:${key}`,
    expires: 3600 // 凭证有效期1小时
  };
  const putPolicy = new qiniu.rs.PutPolicy(options);
  return putPolicy.uploadToken(mac);
};

module.exports = {
  getUploadToken,
  config,
  domain
};
