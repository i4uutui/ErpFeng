let fontLoaded = false;
let fontModule = null;
let loadPromise = null;

// 预加载字体文件
export const preloadFont = () => {
  if (loadPromise) return loadPromise; // 防止重复加载

  // 动态导入字体文件（异步加载，不阻塞主线程）
  loadPromise = import("@/utils/font/sourcehan-normal").then(module => {
      fontLoaded = true;
      fontModule = module;
      // console.log("字体文件预加载完成");
      return module;
    }).catch(err => {
      // console.error("字体文件预加载失败：", err);
      loadPromise = null; // 失败后允许重试
      throw err;
    });

  return loadPromise;
};

// 获取已加载的字体模块（供打印时使用）
export const getFontModule = () => {
  if (!fontLoaded) {
    // 如果未加载完成，返回正在加载的Promise
    return loadPromise || preloadFont();
  }
  return Promise.resolve(fontModule);
};