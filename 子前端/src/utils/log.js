import { getItem } from '@/assets/js/storage';
import request from '@/utils/request';

/**
 * 上报操作日志
 * @param {Object} logData - 日志数据
 * @param {string} logData.operationType - 操作类型（add/update/delete/query）
 * @param {string} logData.module - 操作模块（如'EmployeeInfo'）
 * @param {string} logData.desc - 操作描述
 * @param {Object} [logData.data] - 操作数据（可选）
 */
export const reportOperationLog = async (logData) => {
  try {
    // 获取当前用户信息（从全局状态或localStorage中获取）
    const userInfo = getItem('user');

    // 构造完整日志数据
    const fullLog = {
      userId: userInfo.id,
      userName: userInfo.name,
      companyId: userInfo.company_id,
      operationType: logData.operationType,
      module: logData.module,
      desc: logData.desc,
      data: logData.data ? JSON.stringify(logData.data) : null,
    };

    // 发送日志到后端
    await request.post('/api/operation_log', fullLog);
  } catch (error) {
    console.error('日志上报失败：', error);
    // 日志上报失败不影响主流程，仅记录错误
  }
};

// 简易获取IP地址（实际可通过后端接口获取更准确的IP）
const getIpAddress = async () => {
  try {
    const res = await fetch('https://api.ipify.org?format=json');
    const data = await res.json();
    return data.ip;
  } catch (error) {
    return 'unknown';
  }
};