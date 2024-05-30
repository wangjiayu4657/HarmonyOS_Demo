import preferences from '@ohos.data.preferences';

//本地缓存
class StorageUtil {
  prefMap:Map<string,preferences.Preferences> = new Map()

  //获取preference
  async initPreference(context, name:string) {
    try {
      let pref = await preferences.getPreferences(context,name)
      this.prefMap.set(name, pref)
      console.log('testPreference',`加载Preference[${name}]成功`)
    } catch (err) {
      console.log('testPreference',`加载Preference[${name}]失败`,JSON.stringify(err))
    }
  }

  //写入数据
  async putPreference(name:string, key:string, value:preferences.ValueType) {
    if(this.isInitPreference(name)) {
      try {
        //获取Preferences实例
        let pref = this.prefMap.get(name)
        //写入数据
        await pref.put(key, value)
        //将当前Preferences实例的数据异步存储到用户首选项的持久化文件中
        await pref.flush()
        console.log('testPreference', `保存Preference[${name}.${key} = ${value}]成功`)
      } catch(err) {
        console.log('testPreference', `保存Preference[${name}.${key} = ${value}]失败`, JSON.stringify(err))
      }
    }
  }

  //读取数据
  async getPreference(name:string, key:string, defaultValue:preferences.ValueType) {
    if(this.isInitPreference(name)) {
      try {
        let pref = this.prefMap.get(name)
        let value = await pref.get(key,defaultValue)
        console.log('testPreference', `读取Preference[${name}.${key} = ${value}]成功`)
        return value
      } catch(err) {
        console.log('testPreference', `读取Preference[${name}.${key}]失败`, JSON.stringify(err))
      }
    }
  }

  //删除数据
  async deletePreference(name:string, key:string) {
    if(this.isInitPreference(name)) {
      try {
        let pref = this.prefMap.get(name)
        pref.delete(key)
        console.log('testPreference', `删除Preference[${name}.${key}}]成功`)
      } catch(err) {
        console.log('testPreference', `删除Preference[${name}.${key}}]失败`, JSON.stringify(err))
      }
    }
  }

  //清空所有数据
  async clearPreference(name:string, key:string) {
    if(this.isInitPreference(name)) {
      try {
        let pref = this.prefMap.get(name)
        await pref.clear()
        console.log('testPreference', `清空所有数据Preference[${name}.${key}]成功`)
      } catch (err) {
        console.log('testPreference', `清空所有数据Preference[${name}.${key}]失败`, JSON.stringify(err))
      }
    }
  }

  //判断是否初始化Preference实例
  isInitPreference(name:string):boolean {
    if(!this.prefMap.has(name)) {
      console.log('testPreference', `Preferences[${name}]尚未初始化！`)
      return false
    }

    console.log('testPreference', `Preferences[${name}]初始化成功！`)
    return true
  }
}

const storageUtil = new StorageUtil();
export default storageUtil as StorageUtil;
