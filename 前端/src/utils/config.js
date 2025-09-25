const public_config = {
  api: process.env.NODE_ENV === 'development' ? 'http://localhost:3000' : 'http://api.yuanfangzixun.com.cn',
}

export default public_config