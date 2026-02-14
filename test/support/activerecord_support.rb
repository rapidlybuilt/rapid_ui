if ENV["BUNDLE_GEMFILE"]&.include?("gemfiles/activerecord")
  require "active_record"

  ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

  ActiveRecord::Schema.define do
    suppress_messages do
      create_table :blog_posts, force: true do |t|
        t.string :title
        t.string :author_name
        t.string :body
      end
    end
  end

  class BlogPost < ActiveRecord::Base
    scope :search, ->(query) {
      return all if query.blank?
      pattern = "%#{sanitize_sql_like(query)}%"
      where("title LIKE :p OR author_name LIKE :p OR body LIKE :p", p: pattern)
    }
  end
end
