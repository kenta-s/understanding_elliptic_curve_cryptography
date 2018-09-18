require 'securerandom'

# 楕円曲線関数
# y^2 = x^3 + ax + b
class Secp256k1
  attr_reader :x, :y, :p, :a, :b, :n
  def initialize(x:,y:,p:,a:,b:)
    # 基準点（ベース）となるG（x, y）座標はsecp256k1の場合以下の通りに決まっている
    
    @x = x || "79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798".to_i(16)
    # => 55066263022277343669578718895168534326250603453777594175500187360389116729240
    
    @y = y || "483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8".to_i(16)
    # => 32670510020758816978083085130507043184471273380659243275938904335757337482424
    
    
    # 剰余系の素数pも同じくsecp256k1では以下の通りになる。
    @p = p || 2 ** 256 - 2**32 - 2**9 - 2**8 - 2**7 - 2**6 - 2**4 - 1 # 注) pはRubyでは予約語なんですがまあ見逃してください
    # => 115792089237316195423570985008687907853269984665640564039457584007908834671663
    
    # Gをスカラー倍していってnG = Oとなる最小の数(位数)。これもsecp256k1だと基準点Gが固定されているので必ずこの値になる。
    @n = n || "fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141".to_i(16)
    # => 115792089237316195423570985008687907852837564279074904382605163141518161494337
    
    # 楕円曲線関数でいうところのパラメータa, bはsecp256k1の場合それぞれ0, 7になる
    @a = a || 0
    @b = b || 7
    # つまり
    # y^2 = x^3 + 7
    # となる
  end

  # 秘密鍵。1からGの位数 - 1の範囲でランダムに選ぶ。
  # 推定されないように必ず安全な乱数生成器を使う。randとか使ったらダメぜったい（理由は結城 浩さんの「暗号技術入門」読むといいです）
  def private_key
    @private_key ||= SecureRandom.random_number(n - 1)
  end

  def extended_euclid(a, b)
    return {x: 1, y: 0} if b.zero?
    prev = extended_euclid(b, a % b)
   
    {
      x: prev[:y],
      y: prev[:x] - (a / b) * prev[:y]
    }
  end
  
  def inverse(value)
    extended_euclid(p, value).dig(:y) % p
  end

  def test_exec
    puts inverse((2 * y % p))
    slope = (((3 * (x**2 % p) % p) + a) % p) * inverse((2 * y % p)) % p
    puts "slope: #{slope}"
   
    new_x, new_y = multiply(x, y)
    puts "x: #{new_x}"
    puts "y: #{new_y}"
  end

  def multiply(x, y)
    slope = (((3 * (x**2 % p) % p) + a) % p) * inverse((2 * y % p)) % p
    new_x = (slope ** 2 - x - x) % p
    new_y = (slope * (x - new_x) -y) % p
    [new_x, new_y]
  end
end


secp = Secp256k1.new(
  x: 5,
  y: 5,
  a: 3,
  b: 4,
  p: 7,
)

secp.test_exec
