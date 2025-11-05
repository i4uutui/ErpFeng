const foowwSessionStorage = {
  // expiret 1000 = 1秒（单位：毫秒）
  set: function(key, value, expire) {
    let obj = {
      data: value,
    };
    if (expire) {
      obj.expire = expire; // 过期时间（毫秒）
      obj.time = Date.now(); // 存储时间戳
    }
    // sessionStorage 存储的值不能为对象，转为 JSON 字符串
    sessionStorage.setItem(key, JSON.stringify(obj));
  },  
  get: function(key) {
    let val = sessionStorage.getItem(key);
    if (!val) {
      return null; // 没有值时返回 null 更统一
    }
    try {
      val = JSON.parse(val);
    } catch (e) {
      // 若存储的 JSON 格式错误，直接移除该键并返回 null
      sessionStorage.removeItem(key);
      return null;
    }
    // 有过期时间且已过期时，移除键并返回 null
    if (val.expire && Date.now() - val.time > val.expire) {
      sessionStorage.removeItem(key);
      return null;
    }
    return val.data;
  },
  // 可选：添加移除方法（保持 API 完整性）
  remove: function(key) {
    sessionStorage.removeItem(key);
  },
  // 可选：添加清空方法
  clear: function() {
    sessionStorage.clear();
  }
};

// 对外暴露的方法（保持原 API 一致）
export function getItem(key) {
  return foowwSessionStorage.get(key);
}

export function setItem(key, value, expire) {
  foowwSessionStorage.set(key, value, expire);
  // 原代码返回 JSON.stringify(obj) 无意义，改为返回存储的 value（或根据需求调整）
  return value;
}

// 可选：暴露移除和清空方法
export function removeItem(key) {
  foowwSessionStorage.remove(key);
}

export function clearStorage() {
  foowwSessionStorage.clear();
}