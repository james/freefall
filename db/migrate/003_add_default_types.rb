class AddDefaultTypes < ActiveRecord::Migration
  class Type < ActiveRecord::Base
  end
  def self.up
		Type.create!(:name => 'note')
		Type.create!(:name => 'status')
		Type.create!(:name => 'link')
		Type.create!(:name => 'article')
		Type.create!(:name => 'tune')
		Type.create!(:name => 'picture')
		Type.create!(:name => 'video')
		Type.create!(:name => 'file')
		Type.create!(:name => 'code')
  end

  def self.down
		Type.find_by_name('note').destroy
		Type.find_by_name('status').destroy
		Type.find_by_name('link').destroy
		Type.find_by_name('article').destroy
		Type.find_by_name('tune').destroy
		Type.find_by_name('picture').destroy
		Type.find_by_name('video').destroy
		Type.find_by_name('file').destroy
		Type.find_by_name('code').destroy
  end
end
