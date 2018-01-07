#Yahoo! Box Downloader
require 'mechanize'
require 'nokogiri'
require 'kconv'
require 'scanf'
require 'date'
require 'uri'
require 'json'
require 'erb'
require 'net/http'
require 'open-uri'
require 'logger'
include ERB::Util

filenum_of_page = 100 #一度に読み込むファイル数 20,50,100のどれか

cookie_jar_yaml_path = 'yahoo.yaml' #ログイン情報のクッキーを保存したファイル

sid = "****"
topuniqid = "****"
crumb = "****"
appid = "****"

puts "sid = #{sid}"
puts "uniqid = #{topuniqid}"
puts "crumb = #{crumb}"
puts "appid = #{appid}"

agent = Mechanize.new
agent.user_agent_alias = 'Windows IE 7'
cookie = Mechanize::Cookie.new :domain => '.yahoo.co.jp', :name => "_n", :value => ""***********",", :path => '/', :expires => (Date.today + 1).to_s
agent.cookie_jar << cookie

cookie = Mechanize::Cookie.new :domain => '.yahoo.co.jp', :name => "B", :value => "***********", :path => '/', :expires => (Date.today + 1).to_s
agent.cookie_jar << cookie

cookie = Mechanize::Cookie.new :domain => '.yahoo.co.jp', :name => "F", :value => "***********", :path => '/', :expires => (Date.today + 1).to_s
agent.cookie_jar << cookie

cookie = Mechanize::Cookie.new :domain => '.yahoo.co.jp', :name => "JV", :value => "***********", :path => '/', :expires => (Date.today + 1).to_s
agent.cookie_jar << cookie

cookie = Mechanize::Cookie.new :domain => '.yahoo.co.jp', :name => "sB", :value => "***********", :path => '/', :expires => (Date.today + 1).to_s
agent.cookie_jar << cookie

cookie = Mechanize::Cookie.new :domain => '.yahoo.co.jp', :name => "SSL", :value => "***********", :path => '/', :expires => (Date.today + 1).to_s
agent.cookie_jar << cookie

cookie = Mechanize::Cookie.new :domain => '.yahoo.co.jp', :name => "T", :value => "***********", :path => '/', :expires => (Date.today + 1).to_s
agent.cookie_jar << cookie

cookie = Mechanize::Cookie.new :domain => '.yahoo.co.jp', :name => "Y", :value => "***********", :path => '/', :expires => (Date.today + 1).to_s
agent.cookie_jar << cookie

cookie = Mechanize::Cookie.new :domain => '.yahoo.co.jp', :name => "YLS", :value => "***********", :path => '/', :expires => (Date.today + 1).to_s
agent.cookie_jar << cookie

#ここから巡回してファイルをダウンロード	
folderList = Array.new
folderList.push(topuniqid)
#folderListが空になるまで巡回する
while folderList.size != 0 do
	#folderListから一つ取り出す
	nowuniqid = folderList.pop
	#そのフォルダ内のファイルのリストが書かれたJSONを取得する
	urlstr = "https://box.yahoo.co.jp/api/v1/filelist/" + sid + "/" + nowuniqid + "?_=" + DateTime.now.strftime('%Q').to_s + "&"
	urlstr << "results=#{filenum_of_page}&start=1&output=json&sort=%2Bname&filetype=both&meta=1&thumbnail=1&tree=1&sharemembercount=1&ownerinfo=1&boxcrumb="
	urlstr << url_encode(crumb)

	begin
		agent.get(urlstr)
		jsonstr = JSON.parse(agent.page.body.to_s)
		# 複数ページが存在する場合はまず全ページたどってファイル情報を入手
		filenum = jsonstr['ObjectList']['TotalResultsAvailable'].to_s
		unless jsonstr['ObjectList']['Object'] == nil
			jsonstr['ObjectList']['Object'].each do |object|
				type = object['Type'].to_s
				name = object['Name'].to_s
				uniqid = object['UniqId'].to_s
				dlurl = object['Url'].to_s
				path = "." + object['Path'].to_s #パスの先頭にドットをつけないとうまく相対パスにならない
				#ファイルかフォルダかで処理を分岐
				if(type == 'file') then
					dlurl << "?appid=#{appid}&error_redirect=1&done=https%3A%2F%2Fbox.yahoo.co.jp%2Ferror%2Fdownload_error&boxcrumb="
					dlurl << url_encode(crumb)
					#dlurlからリダイレクトされたURLを取得 これがダウンロードリンク
					agent.get(dlurl)
					redirect_link = agent.page.uri.to_s
					#ファイルを保存
					#File.write(path, Net::HTTP.get(URI.parse(redirect_link)))
					open(redirect_link) do |file|
						open(path, "w+b") do |out|
							out.write(file.read)
						end
					end
					puts "Download #{path}"
				elsif(type == 'dir') then
					#folderListに追加してあとで巡回
					folderList.push(uniqid)
					Dir.mkdir(path)
				end
			end
		end

	rescue Exception => e
		puts e.message #=>divided by 0
		puts e.class #=>ZeroDivisionError
	end
end
