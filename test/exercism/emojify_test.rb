require './test/test_helper.rb'

class EmojifyTest < Minitest::Test
  def test_convert
   assert_equal(Emojify.convert(":gun:"), '<img alt="gun" height="20" src="../img/emoji/gun.png" style="vertical-align:middle" width="20" />')
  end
end
