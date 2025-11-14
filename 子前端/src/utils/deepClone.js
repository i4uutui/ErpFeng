/**
 * 深拷贝（支持复杂结构、循环引用）
 * @param {*} obj 要拷贝的对象
 * @param {WeakMap} [hash=new WeakMap()] 用于处理循环引用
 * @returns {*} 深拷贝后的对象
 */
function deepClone(obj, hash = new WeakMap()) {
  if (obj === null || typeof obj !== 'object') return obj
  if (hash.has(obj)) return hash.get(obj)

  // 特殊对象快速处理
  const Ctor = obj.constructor
  switch (Ctor) {
    case Date: return new Date(obj)
    case RegExp: return new RegExp(obj)
  }

  // Map / Set
  if (obj instanceof Map) {
    const res = new Map()
    hash.set(obj, res)
    for (const [k, v] of obj) res.set(deepClone(k, hash), deepClone(v, hash))
    return res
  }

  if (obj instanceof Set) {
    const res = new Set()
    hash.set(obj, res)
    for (const v of obj) res.add(deepClone(v, hash))
    return res
  }

  // 普通对象 / 数组
  const res = Array.isArray(obj) ? [] : {}
  hash.set(obj, res)

  for (const key of Reflect.ownKeys(obj)) {
    res[key] = deepClone(obj[key], hash)
  }

  return res
}

export default deepClone