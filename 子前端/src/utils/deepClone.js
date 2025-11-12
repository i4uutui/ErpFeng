/**
 * 深拷贝（支持复杂结构、循环引用）
 * @param {*} obj 要拷贝的对象
 * @param {WeakMap} [hash=new WeakMap()] 用于处理循环引用
 * @returns {*} 深拷贝后的对象
 */
function deepClone(obj, hash = new WeakMap()) {
  // 原始类型 或 null、undefined 直接返回
  if (obj === null || typeof obj !== 'object') return obj

  // 如果已经拷贝过（处理循环引用）
  if (hash.has(obj)) return hash.get(obj)

  // 处理特殊对象
  if (obj instanceof Date) return new Date(obj)
  if (obj instanceof RegExp) return new RegExp(obj)
  if (obj instanceof Map) {
    const result = new Map()
    hash.set(obj, result)
    obj.forEach((v, k) => {
      result.set(deepClone(k, hash), deepClone(v, hash))
    })
    return result
  }
  if (obj instanceof Set) {
    const result = new Set()
    hash.set(obj, result)
    obj.forEach(v => result.add(deepClone(v, hash)))
    return result
  }

  // 处理数组或普通对象
  const result = Array.isArray(obj) ? [] : {}
  hash.set(obj, result)

  // 遍历属性
  for (const key in obj) {
    if (obj.hasOwnProperty(key)) {
      result[key] = deepClone(obj[key], hash)
    }
  }

  // 复制 Symbol 属性
  const symbolKeys = Object.getOwnPropertySymbols(obj)
  for (const sym of symbolKeys) {
    result[sym] = deepClone(obj[sym], hash)
  }

  return result
}

export default deepClone