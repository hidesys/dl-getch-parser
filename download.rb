require 'mechanize'

agent = Mechanize.new
base_url = 'https://dl.getchu.com/gcoslh/'

# 1. 指定されたURLにアクセス
page = agent.get(base_url)

# 2. テキストが「はい」のリンクを見つけてクリック
yes_link = page.links.find { |link| link.text.strip == 'はい' }
page = yes_link.click if yes_link

# 3. actionが /search/search_list.php のformを見つけて設定し、送信
form = page.forms.find { |f| f.action == '/search/search_list.php' }
form['search_category_id'] = '49' if form
page = form.submit if form

# 4. 最初のページの内容を0.htmlとして保存
File.write("htmls/0.html", page.body.force_encoding('EUC-JP').encode('UTF-8', undef: :replace, replace: '?'))

# 5以降. 「次」のリンクをたどりながらページを保存
100.times do |index|
  p index
  next_link = page.links.find { |link| link.text.strip == '次' }
  break unless next_link # 「次」がなければ終了

  page = next_link.click
  File.write("htmls/#{index + 1}.html", page.body.force_encoding('EUC-JP').encode('UTF-8', undef: :replace, replace: '?'))
  sleep 1
end
