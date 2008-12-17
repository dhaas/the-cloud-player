require 'rubygems'
require 'hpricot'
##This is just a simple utility that tries to convert all the relative
## uris in the doc to a different relative path.  Works on css & html
## at the moment
## css: converts anything it finds in url($1) to url($url_prefix + $1)
## html: converts anything with src attr starting with "/" to $url_prefix + src
## html: converts anything with href attr starting with "/" to $url_prefix + href

$path_glob = ARGV[0]
$url_prefix = ARGV[1]

def fix_css(file_name)
  f = open(file_name).read
  f.gsub!(/url\((.*?)\)/) do |url|
    rel_path = $1
    if rel_path.start_with?("/") && !rel_path.start_with?($url_prefix)
      puts "    [css]url=" + $url_prefix + rel_path
      "url(#{$url_prefix}#{rel_path})"
    else
      url
    end
  end
  open(file_name,"w").write(f)
end

def fix_js(file_name)

end

def fix_html(file_name)
  f = Hpricot(open(file_name))
  (f/"*[@src]").each do |script|
    if script["src"].start_with?("/") && ! script["src"].start_with?($url_prefix)
      script["src"] = $url_prefix  + script["src"] 
      puts "    [html]src=" + script["src"]
    end
  end
  (f/"*[@href]").each do |script|
    if script["href"].start_with?("/") && ! script["href"].start_with?($url_prefix)
      script["href"] = $url_prefix + script["href"]
      puts "    [html]href=" + script["href"]
    end
  end
  open(file_name, "w").write(f)
end

Dir.glob($path_glob) do |file_name|
  puts "[debug]processing: #{file_name}"
  if file_name[/css$/]
    puts "  [debug]fixing: #{file_name}"
    fix_css(file_name)
  elsif file_name[/(html|htm)$/]
    puts "  [debug]fixing: #{file_name}"
    fix_html(file_name)
  elsif file_name[/js$/]
    puts "  [debug]fixing: #{file_name}"
    fix_js(file_name)
  end
    
end


