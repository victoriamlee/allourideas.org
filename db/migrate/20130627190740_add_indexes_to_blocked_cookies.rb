class AddIndexesToBlockedCookies < ActiveRecord::Migration
  def self.up
    change_table :blocked_cookies do |t|
      t.index :question_id
      t.index :ip_addr
      t.index :created_at
    end
  end

  def self.down
  end
end
