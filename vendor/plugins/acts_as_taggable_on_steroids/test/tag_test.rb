require File.dirname(__FILE__) + '/abstract_unit'

class TagTest < Test::Unit::TestCase
  fixtures :tags, :taggings, :users, :photos, :posts
  
  def test_taggings
    assert_equal [taggings(:jonathan_sky_good), taggings(:sam_flowers_good), taggings(:sam_flower_good)], tags(:good).taggings
    assert_equal [taggings(:sam_ground_bad), taggings(:jonathan_bad_cat_bad)], tags(:bad).taggings
  end
  
  def test_to_s
    assert_equal tags(:good).name, tags(:good).to_s
  end
  
  def test_equality
    assert_equal tags(:good), tags(:good)
    assert_equal Tag.find(1), Tag.find(1)
    assert_equal Tag.new(:name => 'A'), Tag.new(:name => 'A')
    assert_not_equal Tag.new(:name => 'A'), Tag.new(:name => 'B')
  end
end
