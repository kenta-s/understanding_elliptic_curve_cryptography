require 'minitest/autorun'
require './secp256k1'

class TestSecp256k1 < Minitest::Test
  def setup
    @secp = Secp256k1.new(
      x: 5,
      y: 5,
      a: 3,
      b: 4,
      p: 7,
    )
  end

  def test_inverse
    assert_equal 0, @secp.inverse(0)
    assert_equal 1, @secp.inverse(1)
    assert_equal 4, @secp.inverse(2)
    assert_equal 5, @secp.inverse(3)
    assert_equal 2, @secp.inverse(4)
    assert_equal 3, @secp.inverse(5)
    assert_equal 6, @secp.inverse(6)
  end

  def test_multiply
    # assert_equal [1, 6], @secp.multiply(0, 2)
    assert_equal [0, 2], @secp.multiply(1, 1)
    assert_equal [0, 2], @secp.multiply(2, 2)
    # assert_equal [1, 6], @secp.multiply(5, 2)
    # assert_equal [0, 0], @secp.multiply(6, 0)
    assert_equal [1, 1], @secp.multiply(5, 5)
    # assert_equal [0, 5], @secp.multiply(2, 5)
    # assert_equal [0, 5], @secp.multiply(1, 6)
    # assert_equal [1, 1], @secp.multiply(0, 5)
  end
end
