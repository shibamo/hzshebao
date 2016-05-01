source 'https://rubygems.org'
#source 'https://ruby.taobao.org/'
#source 'https://gems.ruby-china.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  gem 'better_errors'
  gem 'binding_of_caller'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'bootstrap-sass', '~> 3.1.1'

gem 'bcrypt-ruby' , '~>3.1.2'

gem 'gon'

gem 'kaminari'
gem 'bootstrap-kaminari-views'

#自定义分页插件主题  
#执行rails g kaminari:views bootstrap 时报错 作用：Ensure net/https uses OpenSSL::SSL::VERIFY_PEER to  
#verify SSL certificatesand provides certificate bundle in case OpenSSL cannot find one  
gem 'certified' 

#管理客户与缴费单状态
gem 'workflow'

#生成支持主从表同时输入字段创建记录的表单
gem 'simple_form'

#权限检查,未与devise(目前不需要使用全功能的用户创建与验证功能),rotify(角色与资源间不是多对多的关联关系,可能会导致角色数爆炸)联合使用
gem 'cancancan'

#调试时使用pry,目前发现对中文输入字段支持会有问题
group :development do
  #gem 'pry-rails'
end

#用于生成导出的excel表
gem 'spreadsheet'

#用于连接数据库
gem 'mysql2'

#测试使用repec
group :development, :test do
  gem "rspec-rails", "~> 3.1.0"
  gem "factory_girl_rails", "~> 4.4.1"
end

group :test do
  gem "faker", "~> 1.4.3"
  gem "capybara", "~> 2.4.3"
  gem "database_cleaner", "~> 1.3.0"
  gem "launchy", "~> 2.4.2"
  gem 'selenium-webdriver', '~> 2.48', '>= 2.48.1'
end

