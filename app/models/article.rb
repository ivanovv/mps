class Article < ActiveRecord::Base
  searchkick word_middle: [:content],  language: 'russian'
end
