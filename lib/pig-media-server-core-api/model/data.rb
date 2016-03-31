#coding:utf-8
require 'fileutils'
require 'digest/md5'
require 'pig-media-server-core-api/model/migrate'

$config = $config || Pit.get("Pig Media Server")

class AppData
  def self.find key
    key = Digest::MD5.hexdigest(key)
    parse(Groonga['Datas'][key].body)
  rescue
    nil
  end

  def self.set key, value
    g_key = Digest::MD5.hexdigest(key)
    Groonga['Datas'].add g_key
    Groonga['Datas'][g_key].body = value.to_json
    Groonga['Datas'][g_key].original_key = key
  end

  def self.all
    Groonga['Datas'].select.to_a.map{|x|
      {key: x.original_key, value: parse(x.body)}
    }
  end

  def self.parse val
    case val
    when 'true'
      true
    when 'false'
      false
    else
      JSON.parse val
    end

  rescue
    if val.class == String
      val.gsub(/^"|"$/, '')
    else
      val
    end
  end
end

